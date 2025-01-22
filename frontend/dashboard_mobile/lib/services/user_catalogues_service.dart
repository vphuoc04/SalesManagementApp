import 'dart:convert';

// Repositories
import 'package:dashboard_mobile/repositories/user_catalogues_repository.dart';

// Services
import 'package:dashboard_mobile/services/token_service.dart';

class UserCataloguesService {
  final UserCataloguesRepository userCataloguesRepository = UserCataloguesRepository();

  Future<Map<String, dynamic>> add(String name, int publish) async {
    String? token = await TokenService.loadToken();

    if(token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userCataloguesRepository.add(name, publish, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data add: $data");
        return data; 
      }

      print("Add group failed with status: ${response.body}");
      return {
        'success': false,
        'message': 'Add group failed!'
      };
    } catch (error) {
      print("Add group failed: $error");
      throw Exception("Error: $error");
    }
  }
}
