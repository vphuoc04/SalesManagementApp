// Services
import 'package:dashboard_mobile/services/api_service.dart';

class AuthRepository {
  final ApiService apiService = ApiService();

  Future<dynamic> login(String email, String password) {
    return apiService.post(
      'auth/login',
      {
        'email': email,
        'password': password,
      },
    );
  }

  Future<dynamic> logout(String token) {
    return apiService.get(
      'auth/logout',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }
}