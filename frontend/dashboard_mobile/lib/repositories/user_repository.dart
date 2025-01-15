// Services
import 'package:dashboard_mobile/services/api_service.dart';

class UserRepository {
  final ApiService apiService = ApiService();

  Future<dynamic> getDataByid(int id, {required String token}) {
    return apiService.get(
      'user/$id',
      headers: {'Authorization': 'Bearer $token'}, 
    );
  }
}
