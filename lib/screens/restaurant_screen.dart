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
                leading: Icon(Icons.restaurant, color: Color(0xFF18243C)),
                title: Text(restaurant.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                subtitle: Text(restaurant.cuisine, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
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
