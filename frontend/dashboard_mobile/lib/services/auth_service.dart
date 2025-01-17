import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Repositories
import 'package:dashboard_mobile/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository authRepository = AuthRepository();

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await authRepository.login(email, password);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);  

      final userData = data['user'];

      if (userData == null) {
        print("Error: Data is null.");
        return {
          'success': false,
          'message': 'User data is missing.',
        };
      }

      print("Token: ${data['token']}");
      print("Id: ${userData['id']}");

      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('token', data['token']);
      await sharedPrefs.setInt('id', userData['id']);

      return {
        'success': true,
        'token': data['token'],
        'admin': {
          'id': userData['id']
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

  // Logout
  Future<bool> logout() async {
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      String? token = sharedPrefs.getString('token');

      if (token == null || token.isEmpty) {
        print("No token for logout");
        return false;
      }

      final response = await authRepository.logout(token);

      if (response.statusCode == 200) {
        await sharedPrefs.remove('token');
        await sharedPrefs.remove('id');
        print("Logout successful.");
        return true;
      } else {
        print("Failed to logout: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error during logout: $error");
      return false;
    }
  }
}
