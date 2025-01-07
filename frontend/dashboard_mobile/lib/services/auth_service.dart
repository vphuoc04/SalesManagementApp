import 'package:dashboard_mobile/services/api_service.dart';

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
}
