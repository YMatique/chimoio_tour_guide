import 'package:flutter/material.dart';
import 'tourist_spot_screen.dart';
import 'restaurant_screen.dart';
import 'event_screen.dart';
import 'itinerary_screen.dart';
import 'map_screen.dart';
import 'about_screen.dart'; // Novo import
import '../models/tourist_spot.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF18243C), Color(0xFF2E3B55).withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Guia Turístico',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'de Chimoio',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFFFF9626),
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 4,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF9626), Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildCustomButton(
                        context,
                        title: 'Pontos Turísticos',
                        icon: Icons.place,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TouristSpotsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildCustomButton(
                        context,
                        title: 'Restaurantes',
                        icon: Icons.restaurant,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildCustomButton(
                        context,
                        title: 'Eventos',
                        icon: Icons.event,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EventsScreen()),
                          );
                        },
                      ),
                      _buildCustomButton(
                        context,
                        title: 'Roteiro',
                        icon: Icons.directions,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItineraryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildCustomButton(
                        context,
                        title: 'Mapa',
                        icon: Icons.map,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MapScreen(
                                    initialSpot: TouristSpot(
                                      name: 'Chimoio',
                                      description: 'Centro da cidade',
                                      latitude: -19.1167,
                                      longitude: 33.4833,
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                      _buildCustomButton(
                        context,
                        title: 'Sobre o App',
                        icon: Icons.info,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AboutScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF18243C), Color(0xFF25304A)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Color(0xFFFF9626), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0, 6),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Color(0xFFFF9626).withOpacity(0.2),
              offset: Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 60, color: Color(0xFFFF9626)),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: Color(0xFFFF9626).withOpacity(0.5),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
