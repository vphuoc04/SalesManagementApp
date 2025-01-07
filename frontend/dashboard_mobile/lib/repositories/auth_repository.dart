import 'dart:convert';
import 'package:dashboard_mobile/services/auth_service.dart';

class AuthRepository {
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await authService.login(email, password);

    print("API response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);  
      return {
        'success': true,
        'token': data['token'],
        'data': data['data'],
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
