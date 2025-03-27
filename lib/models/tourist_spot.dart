import 'location_item.dart';

class TouristSpot implements LocationItem {
  final int? id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  TouristSpot({
    this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory TouristSpot.fromMap(Map<String, dynamic> map) {
    return TouristSpot(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
