import 'package:flutter/material.dart';
import 'package:uts_recognitionapp/models/user_role.dart';
import 'package:uts_recognitionapp/screens/common/profile_screen.dart';
import 'package:uts_recognitionapp/screens/teacher/home_professor.dart';

import 'add_location_screen.dart';

class BottomBarNavigationProfessor extends StatefulWidget {
  const BottomBarNavigationProfessor({super.key});

  @override
  State<BottomBarNavigationProfessor> createState() => _BottomBarNavigationProfessor();
}

class _BottomBarNavigationProfessor extends State<BottomBarNavigationProfessor> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeProfessor()));
      } else if (index == 1) {
        _addLocation(context);
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(userRole: UserRole.teacher, customBottomNavigationBar: const BottomBarNavigationProfessor())),
        );
      }
    });
  }


  void _addLocation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddLocationScreen()),
    );

  }


  @override
  Widget build(BuildContext context) {


    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined, color: Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, color: Colors.grey),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
