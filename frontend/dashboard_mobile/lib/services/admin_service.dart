import 'dart:convert';

// Models
import 'package:dashboard_mobile/models/admin.dart';

// Services
import 'package:dashboard_mobile/services/token_service.dart';

// Repositories
import 'package:dashboard_mobile/repositories/admin_repository.dart';

class AdminService {
  final AdminRepository adminRepository = AdminRepository();

  Future<Admin> getAdminById(int? id) async {
    if (id == null) {
      throw Exception('Admin ID is null');
    }

    String? token = await TokenService.loadToken();  
    print("Token for get data: $token");
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await adminRepository.getAdminById(id, token: token);
      print("API Response: ${response.body}");
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
        final adminData = data['data'];
        if (adminData == null) {
          throw Exception('Admin data is null.');
        }
        return Admin.fromJson(adminData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load admin data!');
      }
    } catch (error) {
      print("Error in AdminRepository.getAdminById: $error");
      throw Exception('An error occurred while fetching admin data!');
    }
  }
}