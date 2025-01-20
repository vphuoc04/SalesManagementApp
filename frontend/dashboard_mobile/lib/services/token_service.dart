import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static String tokenKey = 'token';
  static String refreshTokenKey = 'refreshToken';

  // Set token
  static Future<void> setToken(String token, String refreshToken) async {
    final set = await SharedPreferences.getInstance();
    await set.setString(tokenKey, token);
    await set.setString(refreshTokenKey, refreshToken);
    print("Token saved: $token");
    print("Refresh token saved: $refreshToken");
  }

  // Load token
  static Future<String?> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("Token loaded from SharedPreferences: $token");
    return token;
  }

  // Remove token
  static Future<void> removeToken() async {
    final remove = await SharedPreferences.getInstance();
    await remove.remove(tokenKey);
  }
}