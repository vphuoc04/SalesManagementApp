// Services
import 'package:dashboard_mobile/services/api_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
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

  // Logout
  Future<void> logout() async {
    SharedPreferences out = await SharedPreferences.getInstance();
    String? token = out.getString('token');
    await out.remove('token');
    print('Token has been removed: $token');
  }
}
