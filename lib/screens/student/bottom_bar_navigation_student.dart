import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/models/user_role.dart';
import 'package:uts_recognitionapp/screens/common/profile_screen.dart';

import 'home_student.dart';

class BottomBarNavigationStudent extends StatefulWidget {
  const BottomBarNavigationStudent({super.key});

  @override
  State<BottomBarNavigationStudent> createState() =>
      _BottomBarNavigationStudent();
}

class _BottomBarNavigationStudent extends State<BottomBarNavigationStudent> {
  int _selectedIndex = 0;

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (contex) => const StudentHomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => const ProfileScreen(
                customBottomNavigationBar: BottomBarNavigationStudent(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],

      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFF899DD9),
      onTap: _onTappedItem,
    );
  }
}
