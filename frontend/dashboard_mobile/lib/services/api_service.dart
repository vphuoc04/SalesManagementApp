import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseApi = 'http://10.0.2.2:8080/api/v1';
  static String? token;
  
  Uri urls(String endpoint) {
    return Uri.parse('$baseApi/$endpoint');
  }

  // Post method
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? extraHeaders,
  }) async {
    final Uri url = urls(endpoint);

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        if (extraHeaders != null) ...extraHeaders, 
      },
      body: json.encode(body),
    );
  }

  // Get method
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers, 
  }) async {
    final Uri url = urls(endpoint);

    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        if (headers != null) ...headers, 
      },
    );
  }
}
