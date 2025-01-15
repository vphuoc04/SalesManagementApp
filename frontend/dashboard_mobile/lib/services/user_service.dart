import 'dart:convert';

// Models
import 'package:dashboard_mobile/models/user.dart';

// Services
import 'package:dashboard_mobile/services/token_service.dart';

// Repositories
import 'package:dashboard_mobile/repositories/user_repository.dart';

class UserService {
  final UserRepository userRepository = UserRepository();

  Future<User> getDataById(int? id) async {
    if (id == null) {
      throw Exception('ID is null');
    }

    String? token = await TokenService.loadToken();  
    print("Token for get data: $token");
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userRepository.getDataByid(id, token: token);
      print("API Response: ${response.body}");
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
        final userData = data['data'];
        if (userData == null) {
          throw Exception('Data is null.');
        }
        return User.fromJson(userData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load admin data!');
      }
    } catch (error) {
      print("Error in user.getAdminById: $error");
      throw Exception('An error occurred while fetching admin data!');
    }
  }
}