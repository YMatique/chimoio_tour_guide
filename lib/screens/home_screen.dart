import 'package:chimoio_tour_guide/screens/transport_screen.dart';
import 'package:flutter/material.dart';
import 'tourist_spot_screen.dart';
import 'restaurant_screen.dart';
import 'event_screen.dart';
import 'itinerary_screen.dart';
import 'about_screen.dart';

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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'de Chimoio',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFFFF9626),
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 2,
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
                        title: 'Transporte',
                        icon: Icons.directions_bus,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => TransportScreen(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("O Guia Turístico para conhecer a cidade de Chimoio", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white),)
              ],)
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
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color(0xFFFF9626), width: .75),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Color(0xFFFF9626).withOpacity(0.2),
              offset: Offset(0, -2),
              blurRadius: 2,
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
                Icon(icon, size: 54, color: Color(0xFFFF9626)),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      
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
