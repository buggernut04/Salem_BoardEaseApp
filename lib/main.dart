import 'package:boardease_application/components/root_app.dart';
import 'package:flutter/material.dart';
import 'auxiliary/splashscreen.dart';
import 'notification_service/notification_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  runApp(const BoardEaseApp());
}

class BoardEaseApp extends StatelessWidget {
  const BoardEaseApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(), // Route for the splash screen
          '/home': (context) => const RootApp(), // Route for the main screen
        },
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightGreen,
        ),
    );
  }
}




