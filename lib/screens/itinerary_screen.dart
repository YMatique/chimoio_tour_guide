import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database_helper.dart';
import '../models/tourist_spot.dart';
import '../models/restaurant.dart';
import '../models/event.dart';
import '../models/location_item.dart';
import 'map_screen.dart';

class ItineraryScreen extends StatefulWidget {
  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<LocationItem> itinerary = [];
  double totalDistance = 0.0;
  int totalDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Roteiro'),
        // backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: Colors.white),
            onPressed: itinerary.isNotEmpty ? _showItineraryOnMap : null,
            tooltip: 'Ver no Mapa',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                itinerary.isEmpty
                    ? Center(child: Text('Adicione itens ao seu roteiro!'))
                    : ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex--;
                          final item = itinerary.removeAt(oldIndex);
                          itinerary.insert(newIndex, item);
                          _calculateRouteDetails();
                        });
                      },
                      children:
                          itinerary.map((item) {
                            return ListTile(
                              key: ValueKey(item),
                              leading: Icon(
                                item is TouristSpot
                                    ? Icons.place
                                    : item is Restaurant
                                    ? Icons.restaurant
                                    : Icons.event,
                                color: Color(0xFFFF9626),
                              ),
                              title: Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                              subtitle: Text(
                                item is TouristSpot
                                    ? item.description
                                    : item is Restaurant
                                    ? item.cuisine
                                    : '${(item as Event).dateTime} - ${(item as Event).location}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    itinerary.remove(item);
                                    _calculateRouteDetails();
                                  });
                                },
                              ),
                            );
                          }).toList(),
                    ),
          ),
          if (itinerary.isNotEmpty)
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.white.withOpacity(0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Distância Total: ${totalDistance.toStringAsFixed(1)} km',
                  ),
                  Text('Tempo: ${_formatDuration(totalDuration)}'),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItemToItinerary,
        backgroundColor: Color(0xFF18243C),
        elevation: 1,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addItemToItinerary() async {
    final touristSpots = await dbHelper.getTouristSpots();
    final restaurants = await dbHelper.getRestaurants();
    final events = await dbHelper.getEvents();
    final allItems = <LocationItem>[...touristSpots, ...restaurants, ...events];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: allItems.length,
          itemBuilder: (context, index) {
            final item = allItems[index];
            return ListTile(
              leading: Icon(
                item is TouristSpot
                    ? Icons.place
                    : item is Restaurant
                    ? Icons.restaurant
                    : Icons.event,
                color:Color(0xFF18243C),
              ),
              title: Text(item.name, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
              onTap: () {
                setState(() {
                  if (!itinerary.contains(item)) {
                    itinerary.add(item);
                    _calculateRouteDetails();
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _calculateRouteDetails() async {
    if (itinerary.length < 2) {
      setState(() {
        totalDistance = 0.0;
        totalDuration = 0;
      });
      return;
    }

    double distance = 0.0;
    int duration = 0;
    const apiKey =
        'AIzaSyBm8VIwNwf9C_G_G9S2627gJCju1gZAIwo'; // Substitua pela sua chave real

    for (int i = 0; i < itinerary.length - 1; i++) {
      final origin = '${itinerary[i].latitude},${itinerary[i].longitude}';
      final destination =
          '${itinerary[i + 1].latitude},${itinerary[i + 1].longitude}';
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'OK') {
            final leg = data['routes'][0]['legs'][0];
            distance += leg['distance']['value'] / 1000;
            duration += (leg['duration']['value'] as int);
          }
        }
      } catch (e) {
        print('Erro ao calcular trecho: $e');
      }
    }

    setState(() {
      totalDistance = distance;
      totalDuration = duration;
    });
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return hours > 0 ? '$hours h $minutes min' : '$minutes min';
  }

  void _showItineraryOnMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MapScreen(initialSpot: itinerary[0], itinerary: itinerary),
      ),
    );
  }
}
