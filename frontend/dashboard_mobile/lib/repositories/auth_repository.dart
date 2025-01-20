// Services
import 'package:dashboard_mobile/services/api_service.dart';

class AuthRepository {
  final ApiService apiService = ApiService();

  // Login
  Future<dynamic> login(String email, String password) {
    return apiService.post(
      'auth/login', {
        'email': email,
        'password': password,
      },
    );
  }

  // Blacklist token
  Future<dynamic> blacklistToken(String token) {
    return apiService.post(
      'auth/blacklisted_tokens',
      {'token': token},
      extraHeaders: {
        'Authorization': 'Bearer $token'
      },
    );
  }

  // Logout
  Future<dynamic> logout(String token) {
    return apiService.get(
      'auth/logout',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Refresh token
  Future<dynamic> refreshToken(String refreshToken) {
    return apiService.post(
      'auth/refresh', {
        'refreshToken': refreshToken
      }
    );
  }
}