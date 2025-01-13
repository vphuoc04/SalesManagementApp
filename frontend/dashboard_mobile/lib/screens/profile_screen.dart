import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Models
import 'package:dashboard_mobile/models/admin.dart';

// Services
import 'package:dashboard_mobile/services/auth_service.dart';
import 'package:dashboard_mobile/services/admin_service.dart';

// Screens
import 'package:dashboard_mobile/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AdminService adminService = AdminService();
  final AuthService authService = AuthService();

  Admin? adminData;

  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  Future<void> fetchAdminData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? adminId = prefs.getInt('id');

      if (token == null || token.isEmpty) {
        print("Error: Token not found in SharedPreferences!");
        setState(() {
          adminData = null; 
        });
        return;
      }

      if (adminId == null) {
        print("Error: Admin ID not found in SharedPreferences!");
        setState(() {
          adminData = null; 
        });
        return;
      }

      print("Fetching admin data for ID: $adminId with Token: $token");
      final Admin result = await adminService.getAdminById(adminId);
      setState(() {
        adminData = result; 
      });
    } catch (error) {
      print("Error getting admin data: $error");
      setState(() {
        adminData = null;  
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: adminData == null
            ? Center(
                child: Text("No admin data available."),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "${adminData!.middleName} ${adminData!.firstName}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("Email: ${adminData!.email}"),
                    Text("Phone: ${adminData!.phone}"),
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