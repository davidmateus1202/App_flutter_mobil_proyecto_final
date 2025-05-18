import 'package:diapce/Services/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AbscisaApi {

  Future<http.Response> create({
    required String name,
    required int numberOfAbscisas,
    required int projectId,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${BaseUrl.baseUrl}/abscisa/create');
      final token = prefs.getString('token');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        },
        body: {
          "name": name,
          "number_of_abscisas": numberOfAbscisas.toString(),
          "project_id": projectId.toString(),
        }
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create abscisa ${e.toString()}');
    }
  }

  Future<http.Response> changeStatus({
    required int abscisaId,
    required String status,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${BaseUrl.baseUrl}/abscisa/change/status');
      final token = prefs.getString('token');

      final response = await http.post(
        url,
        headers: { 'Authorization': 'Bearer $token' },
        body: {
          "abscisa_id": "$abscisaId",
          "status": status,
        }
      );

      return response;

    } catch (e) {
      throw Exception('Failed to change status ${e.toString()}');
    }
  }
}