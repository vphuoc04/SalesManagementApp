import 'dart:convert';
import 'package:dashboard_mobile/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await authService.login(email, password);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);  

      final adminData = data['admin'];

      if (adminData == null) {
        print("Error: Admin data is null.");
        return {
          'success': false,
          'message': 'Admin data is missing.',
        };
      }

      print("Token: ${data['token']}");
      print("Admin id: ${adminData['id']}");

      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('token', data['token']);
      await sharedPrefs.setInt('id', adminData['id']);

      return {
        'success': true,
        'token': data['token'],
        'admin': {
          'id': adminData['id']
        },
      };
    } 
    else if (response.statusCode == 422) {
      final error = json.decode(response.body);
      return {
        'success': false,
        'message': error['errors']['message'],
      };
    } 
    else {
      return {
        'success': false,
        'message': 'Unexpected error occurred',
      };
    }
  }
}
