import 'package:flutter/material.dart';

import 'homepage.dart';
import 'payment_setup.dart';
import 'tenant_record.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int _currentIndex = 0;

  List<Widget> options = const[
    MyHomePage(),
    TenantRecord(),
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
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black.withOpacity(0.8),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index){
          selectedTab(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'HOME',
              icon: Icon(Icons.home,size: 30.0),
          ),
          BottomNavigationBarItem(
              label: 'RECORDS',
              icon: Icon(Icons.person_pin, size: 30.0),
              //backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
              label: 'PAYMENT',
              icon: Icon(Icons.payment, size: 30.0),
              //backgroundColor: Colors.blue
          )
        ],
    );
  }

  selectedTab(index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
