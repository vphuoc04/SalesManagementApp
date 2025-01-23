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

  Future<dynamic> update(int id, String name, int publish, {required String token}) {
    return apiService.put(
      'user_catalogues/$id', {
        'name': name,
        'publish': publish
      },
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
  }

  Future<dynamic> get({required String token}) {
    return apiService.get(
      'user_catalogues',
      headers: {
        'Authorization': 'Bearer $token'
      }, 
    );
  }
}