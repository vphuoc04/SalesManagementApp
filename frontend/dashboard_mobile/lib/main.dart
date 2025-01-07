import 'package:flutter/material.dart';

// Screens
import 'package:dashboard_mobile/screens/login_screen.dart';
import 'package:dashboard_mobile/screens/dashboard_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen()
      },
    );
  }
}