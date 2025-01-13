// Services
import 'package:dashboard_mobile/services/api_service.dart';

class AdminRepository {
  final ApiService apiService = ApiService();

  Future<dynamic> getAdminById(int id, {required String token}) {
    return apiService.get(
      'admin/$id',
      headers: {'Authorization': 'Bearer $token'}, 
    );
  }
}
