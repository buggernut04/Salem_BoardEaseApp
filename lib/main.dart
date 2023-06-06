import 'package:boardease_application/auxiliary/root_app.dart';
import 'package:flutter/material.dart';


import 'auxiliary/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const BoardEaseApp());
}

class BoardEaseApp extends StatelessWidget {
  const BoardEaseApp({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(), // Route for the splash screen
          '/home': (context) => RootApp(), // Route for the main screen
        },
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightGreen,
        )
    );
  }
}




