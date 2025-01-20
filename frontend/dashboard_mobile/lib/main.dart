import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Services
import 'package:dashboard_mobile/services/token_service.dart';
import 'package:dashboard_mobile/services/auth_service.dart'; 

// Screens
import 'package:dashboard_mobile/screens/login_screen.dart';
import 'package:dashboard_mobile/screens/layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? token = await TokenService.loadToken();
  int? id;

  if (token != null) {
    final authService = AuthService();
    final isRefreshed = await authService.refreshToken();  

    if (!isRefreshed) {
      token = null;
    } else {
      final check = await SharedPreferences.getInstance();
      id = check.getInt('id');
      print('Admin id check: $id');
    }
  }

  runApp(MyApp(initialRoute: token == null ? '/' : '/dashboard', id: id));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final int? id; 

  const MyApp(
    {super.key, required this.initialRoute, this.id}
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => id == null ? LoginScreen() : LayoutScreen(id: id!)
      },
    );
  }
}