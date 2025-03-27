import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/event.dart';
import 'map_screen.dart';

class EventsScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos')),
      body: FutureBuilder<List<Event>>(
        future: dbHelper.getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: Icon(Icons.event, color: Color(0xFF18243C)),
                title: Text(event.name),
                subtitle: Text('${event.dateTime} - ${event.location}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapScreen(initialSpot: event),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
