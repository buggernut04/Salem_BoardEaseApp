import 'package:boardease_application/auxiliary/bottom_navbar.dart';
import 'package:flutter/material.dart';

import 'auxiliary/splashscreen.dart';
import 'components/homepage.dart';
import 'components/payment_analysis.dart';
import 'components/payment_setup.dart';
import 'components/tenant_list.dart';

void main() => runApp(const BoardEaseApp());

class BoardEaseApp extends StatelessWidget {
  const BoardEaseApp({super.key });

  final List<Widget> options = const[
    MyHomePage(),
    TenantList(),
    Report(),
    PaymentDetail(),
  ];

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(), // Route for the splash screen
          '/home': (context) => BottomNavBar(options: options), // Route for the main screen
        },
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightGreen,
        )
    );
  }
}




