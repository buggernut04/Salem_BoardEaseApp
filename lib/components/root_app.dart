import 'package:flutter/material.dart';

import 'homepage.dart';
import 'payment_analysis.dart';
import 'payment_setup.dart';
import 'tenant_list.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int _currentIndex = 0;

  List<Widget> options = const[
    MyHomePage(),
    TenantList(),
    Report(),
    PaymentDetail(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: options[_currentIndex]
      ),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getFooter() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.yellowAccent,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black.withOpacity(0.8),
        onTap: (index){
          selectedTab(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              label: 'Tenants List',
              icon: Icon(Icons.person_pin),
              //backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
            label: 'Report',
            icon: Icon(Icons.analytics_outlined),
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
              label: 'Payment',
              icon: Icon(Icons.payment),
              //backgroundColor: Colors.blue
          )
        ],
    );
  }

  /*AnimatedBottomNavigationBar(
  activeColor: Colors.blue,
  splashColor: Colors.blueAccent,
  inactiveColor: Colors.black.withOpacity(0.8),
  icons: iconItems,
  activeIndex: _currentIndex,
  gapLocation: GapLocation.none,
  notchSmoothness: NotchSmoothness.smoothEdge,
  leftCornerRadius: 10,
  iconSize: 25,
  rightCornerRadius: 10,
  onTap: (index) {
  selectedTab(index);
  },*/

  selectedTab(index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
