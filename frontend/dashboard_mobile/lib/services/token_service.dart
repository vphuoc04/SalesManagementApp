import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static String tokenKey = 'token';

  // Set token
  static Future<void> setToken(String token) async {
    final set = await SharedPreferences.getInstance();
    await set.setString(tokenKey, token);
  }

  // Load token
  static Future<String?> loadToken() async {
    final load = await SharedPreferences.getInstance();
    return load.getString(tokenKey); 
  }
}