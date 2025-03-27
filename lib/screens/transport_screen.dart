import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/transport.dart';

class TransportScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transporte Público'),
        // backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Transport>>(
        future: dbHelper.getTransports(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final transports = snapshot.data!;
          return ListView.builder(
            itemCount: transports.length,
            itemBuilder: (context, index) {
              final transport = transports[index];
              return ListTile(
                leading: Icon(Icons.directions_bus, color: Colors.green),
                title: Text(transport.route),
                subtitle: Text(transport.description),
              );
            },
          );
        },
      ),
    );
  }
}
