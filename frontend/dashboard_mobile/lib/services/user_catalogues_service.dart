import 'dart:convert';

// Repositories
import 'package:dashboard_mobile/repositories/user_catalogues_repository.dart';

// Services
import 'package:dashboard_mobile/services/token_service.dart';

// Models
import 'package:dashboard_mobile/models/user_catalogues.dart';

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

  Future<Map<String, dynamic>> update(int id, String name, int publish) async {
    String? token = await TokenService.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

    try {
      print("Sending update request with: id=$id, name=$name, publish=$publish");
      final response = await userCataloguesRepository.update(id, name, publish, token: token);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data update: $data");
        return data;
      } else {
        print("Update group failed with status: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Update group failed!'
        };
      }
    } catch (error) {
      print("Update group failed: $error");
      throw Exception("Error: $error");
    }
  }


  Future<List<UserCatalogues>> getAll() async {
    String? token = await TokenService.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userCataloguesRepository.get(token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> userCataloguesList = data['data'];
        return userCataloguesList
            .map((group) => UserCatalogues.fromJson(group))
            .toList();
      } else {
        throw Exception('Failed to load user catalogues');
      }
    } catch (error) {
      throw Exception('Error fetching user catalogues: $error');
    }
  }
}
