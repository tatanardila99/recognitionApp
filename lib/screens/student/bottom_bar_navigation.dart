import 'package:flutter/material.dart';

class BottomBarNavigation extends StatefulWidget {
  const BottomBarNavigation({super.key});

  @override
  State<BottomBarNavigation> createState() => _BottomBarNavigation();
}

class _BottomBarNavigation extends State<BottomBarNavigation> {

  int _selectedIndex = 0;

  final List<String> screenOptions = [
    "/student/dashboard",
    "/student/profile",
  ];

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacementNamed(screenOptions[index]);
    print("index =  ${_selectedIndex}");
  }

  @override
  Widget build(BuildContext context) {


    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      //type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFF899DD9),
      onTap: _onTappedItem,
    );
  }
}
