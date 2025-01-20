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

      print("Decoded Response Data: $data");

      if (data['data'] == null) {
        print("Error: 'data' is null.");
        return {
          'success': false,
          'message': 'Invalid response structure.',
        };
      }

      final token = data['data']['token'];
      final refreshToken = data['data']['refreshToken'];
      final userData = data['data']['user'];

      if (token == null || userData == null) {
        print("Error: Token or User data is missing.");
        return {
          'success': false,
          'message': 'Missing token or user data.',
        };
      }

      print("Token: $token");
      print("Refresh token: $refreshToken");
      print("User ID: ${userData['id']}");

      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('token', token);
      await sharedPrefs.setInt('id', userData['id']);

      return {
        'success': true,
        'token': token,
        'refreshToken': refreshToken,
        'user': {
          'id': userData['id']
        },
      };
    } else {
      print("Error: HTTP ${response.statusCode}");
      return {
        'success': false,
        'message': 'Unexpected error occurred.',
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

  //Refresh token
  Future<bool> refreshToken() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? oldToken = sharedPrefs.getString('token'); 
    String? refreshToken = sharedPrefs.getString('refreshToken');

    if (refreshToken == null || refreshToken.isEmpty) {
      print("No refresh token available.");
      return false;
    }

    try {
      if (oldToken != null && oldToken.isNotEmpty) {
        final blacklistResponse = await authRepository.blacklistToken(oldToken);
        if (blacklistResponse.statusCode != 200) {
          print("Failed to blacklist old token: ${blacklistResponse.body}");
          return false;
        }
        print("Old token blacklisted successfully.");
      }

      final response = await authRepository.refreshToken(refreshToken);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newToken = data['token'];
        final newRefreshToken = data['refreshToken'];

        await sharedPrefs.setString('token', newToken);
        await sharedPrefs.setString('refreshToken', newRefreshToken);

        print("Access token refreshed successfully.");
        return true;
      } else {
        print("Failed to refresh access token: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error during token refresh: $error");
      return false;
    }
  }
}