import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/screens/student/bottom_bar_navigation.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.0,
              bottom: 16.0,
            ),
            decoration: BoxDecoration(color: const Color(0xFF899DD9)),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "User",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Espacios.',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          SpaceCard(
            color: Colors.blue,
            title: 'Laboratorio de física - A112',
            date: '18:30 Sunday, 18 December 2025',
          ),
        ],
      ),
      bottomNavigationBar: BottomBarNavigation(),

    );
  }
}



class SpaceCard extends StatelessWidget {
  const SpaceCard({
    super.key,
    required this.color,
    required this.title,
    required this.date
  });

  final Color color;
  final String title, date;

  @override
  Widget build(BuildContext) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8)
                )
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                    ),
                  ),
                  Text(
                    "Class Room",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
