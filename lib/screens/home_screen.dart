import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Guia Turístico de Chimoio'),
        // backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Container(
                child: 
                  Text(
                  "O Guia \nTurístico de Chimoio",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  softWrap: true,
                ),),
                Icon(Icons.pin_drop_outlined, size: 40,)
                
              
              ],)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 20,
                      child: Text("Clique"),
                      // decoration: BoxDecoration(),
                      color: Color.fromRGBO(24, 35, 57, 1),
                    ),
                    onTap: () {
                      print("taped");
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 20,
                      height: 300,
                      child: Text("Clique"),
                    ),
                    onTap: () {
                      print("taped");
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 2 - 20,
                    height: 300,
                    child: Text("Clique"),
                    color: Color.fromRGBO(24, 35, 57, 1),
                  ),
                  onTap: () {
                    print("taped");
                  },
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 2 - 20,
                    height: 300,
                    child: Text("Clique"),
                  ),
                  onTap: () {
                    print("taped");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
