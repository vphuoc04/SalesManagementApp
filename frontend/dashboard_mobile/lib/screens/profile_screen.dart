import 'package:dashboard_mobile/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Models
import 'package:dashboard_mobile/models/user.dart';

// Services
import 'package:dashboard_mobile/services/auth_service.dart';
import 'package:dashboard_mobile/services/user_service.dart';

// Screens
import 'package:dashboard_mobile/screens/login_screen.dart';

// Widgets
import 'package:dashboard_mobile/widgets/loading_widget.dart';  

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();
  final AuthService authService = AuthService();

  User? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataById();
  }

  Future<void> fetchDataById() async {
    await Future.delayed(Duration(seconds: 2)); 
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? userId = prefs.getInt('id');

      if (token == null || token.isEmpty) {
        print("Error: Token not found in SharedPreferences!");
        setState(() {
          data = null; 
          isLoading = false;  
        });
        return;
      }

      if (userId == null) {
        print("Error: Admin ID not found in SharedPreferences!");
        setState(() {
          data = null; 
          isLoading = false;  
        });
        return;
      }

      print("Fetching data for ID: $userId with Token: $token");
      final User result = await userService.getDataById(userId);
      setState(() {
        data = result; 
        isLoading = false;  
      });
    } catch (error) {
      print("Error getting data: $error");
      setState(() {
        data = null;  
        isLoading = false;  
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: LoadingWidget(color: myColor),  
              )
            : data == null
                ? Center(
                    child: Column(
                      children: [
                        Text("No admin data available."),
                        ElevatedButton(
                          onPressed: () async {
                            bool logoutSuccess = await authService.logout();
                            if (logoutSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Logout failed. Please try again.")),
                              );
                            }
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "${data!.middleName} ${data!.firstName}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text("Email: ${data!.email}"),
                        Text("Phone: ${data!.phone}"),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            bool logoutSuccess = await authService.logout();
                            if (logoutSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Logout failed. Please try again.")),
                              );
                            }
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
