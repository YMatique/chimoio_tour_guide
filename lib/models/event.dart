import 'location_item.dart';

class Event implements LocationItem {
  final int? id;
  final String name;
  final String dateTime;
  final String location;
  final double latitude;
  final double longitude;

  Event({
    this.id,
    required this.name,
    required this.dateTime,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateTime': dateTime,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      dateTime: map['dateTime'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
