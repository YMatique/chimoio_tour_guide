class Transport {
  final int? id;
  final String route;
  final String description;

  Transport({this.id, required this.route, required this.description});

  Map<String, dynamic> toMap() {
    return {'id': id, 'route': route, 'description': description};
  }

  factory Transport.fromMap(Map<String, dynamic> map) {
    return Transport(
      id: map['id'],
      route: map['route'],
      description: map['description'],
    );
  }
}
