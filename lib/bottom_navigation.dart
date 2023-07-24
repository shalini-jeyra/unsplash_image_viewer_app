import 'package:flutter/material.dart';
import 'package:image_viewer_app/pages/home_page/home_page.dart';

import 'pages/pages.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    CategoriesPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, 
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), 
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal), 
        backgroundColor: Colors.white, 
        elevation: 8.0, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home", 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
        ],
      ),
    );
  }
}
