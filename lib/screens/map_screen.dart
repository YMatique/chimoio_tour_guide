import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../database_helper.dart';
import '../models/tourist_spot.dart';
import '../models/restaurant.dart';
import '../models/event.dart';
import '../models/location_item.dart';
import 'dart:math' show sqrt, pow;

class MapScreen extends StatefulWidget {
  final LocationItem initialSpot;
  final List<LocationItem>? itinerary;

  MapScreen({required this.initialSpot, this.itinerary});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  LocationData? currentLocation;
  Location location = Location();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<LocationItem> allSpots = [];
  Map<String, bool> arrivedStatus = {};
  bool showAllSpots = false;
  bool routeTraced = false;
  String distance = '';
  String duration = '';

  @override
  void initState() {
    super.initState();
    if (widget.itinerary != null && widget.itinerary!.isNotEmpty) {
      _loadItinerary();
    } else {
      _loadInitialSpot();
    }
    _setupLocationTracking();
  }

  void _loadInitialSpot() {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(widget.initialSpot.name),
          position: LatLng(
            widget.initialSpot.latitude,
            widget.initialSpot.longitude,
          ),
          infoWindow: InfoWindow(
            title: widget.initialSpot.name,
            snippet:
                widget.initialSpot is TouristSpot
                    ? (widget.initialSpot as TouristSpot).description
                    : widget.initialSpot is Restaurant
                    ? (widget.initialSpot as Restaurant).cuisine
                    : (widget.initialSpot as Event).dateTime,
          ),
        ),
      );
      arrivedStatus[widget.initialSpot.name] = false;
      allSpots = [widget.initialSpot];
    });
  }

  void _loadItinerary() {
    setState(() {
      allSpots = widget.itinerary!;
      markers.addAll(
        allSpots.map(
          (spot) => Marker(
            markerId: MarkerId(spot.name),
            position: LatLng(spot.latitude, spot.longitude),
            infoWindow: InfoWindow(
              title: spot.name,
              snippet:
                  spot is TouristSpot
                      ? (spot as TouristSpot).description
                      : spot is Restaurant
                      ? (spot as Restaurant).cuisine
                      : (spot as Event).dateTime,
            ),
          ),
        ),
      );
      arrivedStatus = {for (var spot in allSpots) spot.name: false};
      _fetchItineraryRoute();
    });
  }

  Future<void> _loadAllSpots() async {
    final touristSpots = await dbHelper.getTouristSpots();
    final restaurants = await dbHelper.getRestaurants();
    final events = await dbHelper.getEvents();
    allSpots = [...touristSpots, ...restaurants, ...events];
    setState(() {
      showAllSpots = true;
      routeTraced = false;
      polylines.clear();
      distance = '';
      duration = '';
      markers.clear();
      markers.addAll(
        allSpots.map(
          (spot) => Marker(
            markerId: MarkerId(spot.name),
            position: LatLng(spot.latitude, spot.longitude),
            infoWindow: InfoWindow(
              title: spot.name,
              snippet:
                  spot is TouristSpot
                      ? (spot as TouristSpot).description
                      : spot is Restaurant
                      ? (spot as Restaurant).cuisine
                      : (spot as Event).dateTime,
            ),
          ),
        ),
      );
      arrivedStatus = {for (var spot in allSpots) spot.name: false};
      _updateUserMarker();
    });
  }

  Future<void> _setupLocationTracking() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      currentLocation = await location.getLocation();
      _updateUserMarker();

      location.onLocationChanged.listen((LocationData newLocation) {
        currentLocation = newLocation;
        _updateUserMarker();
        _checkProximity();
        if (routeTraced && !showAllSpots && widget.itinerary == null)
          _fetchRoute();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao obter localização: $e')));
    }
  }

  void _updateUserMarker() {
    setState(() {
      markers.removeWhere((m) => m.markerId.value == 'user');
      if (currentLocation != null) {
        markers.add(
          Marker(
            markerId: MarkerId('user'),
            position: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
            infoWindow: InfoWindow(title: 'Você está aqui'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
      }
    });
  }

  Future<void> _fetchRoute() async {
    if (currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Localização atual não disponível.')),
      );
      return;
    }

    final origin = '${currentLocation!.latitude},${currentLocation!.longitude}';
    final destination =
        '${widget.initialSpot.latitude},${widget.initialSpot.longitude}';
    const apiKey =
        'AIzaSyBm8VIwNwf9C_G_G9S2627gJCju1gZAIwo'; // Substitua pela sua chave real
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final points = _decodePolyline(
            data['routes'][0]['overview_polyline']['points'],
          );
          final leg = data['routes'][0]['legs'][0];
          setState(() {
            routeTraced = true;
            polylines.clear();
            polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                points: points,
                color: Colors.blue,
                width: 5,
              ),
            );
            distance = leg['distance']['text'];
            duration = leg['duration']['text'];
          });
          mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(
                  currentLocation!.latitude! < widget.initialSpot.latitude
                      ? currentLocation!.latitude!
                      : widget.initialSpot.latitude,
                  currentLocation!.longitude! < widget.initialSpot.longitude
                      ? currentLocation!.longitude!
                      : widget.initialSpot.longitude,
                ),
                northeast: LatLng(
                  currentLocation!.latitude! > widget.initialSpot.latitude
                      ? currentLocation!.latitude!
                      : widget.initialSpot.latitude,
                  currentLocation!.longitude! > widget.initialSpot.longitude
                      ? currentLocation!.longitude!
                      : widget.initialSpot.longitude,
                ),
              ),
              50,
            ),
          );
        } else if (data['status'] == 'ZERO_RESULTS') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Nenhuma rota encontrada.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro na API: ${data['status']}')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao traçar rota: $e')));
    }
  }

  Future<void> _fetchItineraryRoute() async {
    if (widget.itinerary!.length < 2) return;

    const apiKey =
        'AIzaSyBm8VIwNwf9C_G_G9S2627gJCju1gZAIwo'; // Substitua pela sua chave real
    List<LatLng> allPoints = [];
    double totalDistance = 0.0;
    int totalDuration = 0;

    for (int i = 0; i < widget.itinerary!.length - 1; i++) {
      final origin =
          '${widget.itinerary![i].latitude},${widget.itinerary![i].longitude}';
      final destination =
          '${widget.itinerary![i + 1].latitude},${widget.itinerary![i + 1].longitude}';
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'OK') {
            final points = _decodePolyline(
              data['routes'][0]['overview_polyline']['points'],
            );
            final leg = data['routes'][0]['legs'][0];
            allPoints.addAll(points);
            totalDistance += leg['distance']['value'] / 1000;
            totalDuration += (leg['duration']['value'] as int);
          }
        }
      } catch (e) {
        print('Erro ao traçar trecho do roteiro: $e');
      }
    }

    setState(() {
      routeTraced = true;
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId('itinerary_route'),
          points: allPoints,
          color: Colors.blue,
          width: 5,
        ),
      );
      distance = '${totalDistance.toStringAsFixed(1)} km';
      duration = _formatDuration(totalDuration);
    });

    LatLngBounds bounds = _calculateBounds(allPoints);
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return hours > 0 ? '$hours h $minutes min' : '$minutes min';
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _checkProximity() {
    if (currentLocation == null) return;

    for (var spot in allSpots) {
      double distance = _calculateDistance(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
        spot.latitude,
        spot.longitude,
      );
      const double threshold = 0.1;
      if (distance <= threshold && !arrivedStatus[spot.name]!) {
        arrivedStatus[spot.name] = true;
        _showArrivalMessage(spot.name);
      } else if (distance > threshold && arrivedStatus[spot.name]!) {
        arrivedStatus[spot.name] = false;
      }
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    double dx = lat2 - lat1;
    double dy = lon2 - lon1;
    return sqrt(pow(dx, 2) + pow(dy, 2)) * 111;
  }

  void _showArrivalMessage(String spotName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Você chegou a $spotName!'),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = CameraPosition(
      target: LatLng(widget.initialSpot.latitude, widget.initialSpot.longitude),
      zoom: 14.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialSpot.name),
        backgroundColor: Color(0xFF18243C),
        actions: [
          IconButton(
            icon: Icon(Icons.directions, color: Color(0xFFFF9626)),
            onPressed: widget.itinerary == null ? _fetchRoute : null,
            tooltip: 'Traçar Rota',
          ),
          IconButton(
            icon: Icon(Icons.map, color: Color(0xFFFF9626)),
            onPressed: _loadAllSpots,
            tooltip: 'Ver todos os pontos',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: markers,
            polylines: polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (routeTraced && distance.isNotEmpty && duration.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white.withOpacity(0.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Distância: $distance',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text('Tempo: $duration', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
