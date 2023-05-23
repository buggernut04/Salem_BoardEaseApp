import 'package:flutter/material.dart';

import 'auxiliary/splashscreen.dart';
import 'components/homepage.dart';

void main() => runApp(const BoardEaseApp());

class BoardEaseApp extends StatelessWidget {
  const BoardEaseApp({super.key });

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(), // Route for the splash screen
          '/home': (context) => const MyHomePage(), // Route for the main screen
        },
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightGreen,
        )
    );
  }
}




