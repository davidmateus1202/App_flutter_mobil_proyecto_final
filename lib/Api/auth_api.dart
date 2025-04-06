import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/base_url.dart';

class AuthApi {

  // Login
  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${BaseUrl.baseUrl}/login');
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        }
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login ${e.toString()}');
    }
  }

  Future<http.Response> validToken() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('${BaseUrl.baseUrl}/refresh-token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        }

      );
      return response;
    } catch (e) {
      throw Exception('Failed to login ${e.toString()}');

    }
  }
}