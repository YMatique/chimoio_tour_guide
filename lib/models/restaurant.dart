import 'location_item.dart';

class Restaurant implements LocationItem {
  final int? id;
  final String name;
  final String cuisine;
  final double latitude;
  final double longitude;

  Restaurant({
    this.id,
    required this.name,
    required this.cuisine,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      cuisine: map['cuisine'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
