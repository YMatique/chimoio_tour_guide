import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/tourist_spot.dart';
import 'map_screen.dart';

class TouristSpotsScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pontos Turísticos'),
        // backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<TouristSpot>>(
        future: dbHelper.getTouristSpots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final spots = snapshot.data!;
          return ListView.builder(
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return ListTile(
                leading: Icon(Icons.place, color: Color(0xFF18243C)),
                title: Text(spot.name),
                subtitle: Text(spot.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapScreen(initialSpot: spot),
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
