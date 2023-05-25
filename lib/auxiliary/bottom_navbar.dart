import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key, required this.options}) : super(key: key);

  final List<Widget> options;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.options[_currentIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home),
                backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
                label: 'Tenants List',
                icon: Icon(Icons.person_pin),
                backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
                label: 'Report',
                icon: Icon(Icons.analytics_outlined),
                backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(Icons.person),
                backgroundColor: Colors.blue
            )
          ],
      )
    );
  }
}
