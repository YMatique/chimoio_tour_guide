import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/restaurant.dart';
import 'map_screen.dart';

class RestaurantsScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurantes'),
        // backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: dbHelper.getRestaurants(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final restaurants = snapshot.data!;
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return ListTile(
                leading: Icon(Icons.restaurant, color: Colors.green),
                title: Text(restaurant.name),
                subtitle: Text(restaurant.cuisine),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapScreen(initialSpot: restaurant),
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
