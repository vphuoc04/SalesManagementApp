import 'package:dashboard_mobile/services/api_service.dart';

class UserCataloguesRepository {
  final ApiService apiService = ApiService();

  Future<dynamic> add(String name, int publish, {required String token}) {
    return apiService.post(
      'user_catalogues', {
        'name': name,
        'publish': publish
      }, 
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
  }
}