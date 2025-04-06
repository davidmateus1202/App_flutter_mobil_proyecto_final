import 'package:diapce/Services/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SlabApi {

  // funtion for create a new slab
  Future<http.Response> create({
    required int abscisaId,
    required double long,
    required double width,
    required String typeLong,
    required String typeWidth,
    required String latitude,
    required String longitude,

  }) async {
    try {
      final uri = Uri.parse('${BaseUrl.baseUrl}/slab/create');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token'
        },
        body: {
          "abscisa_id": abscisaId.toString(),
          "long": long.toString(),
          "width": width.toString(),
          "type_long": typeLong,
          "type_width": typeWidth,
          "latitude": latitude,
          "longitude": longitude,
        }
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create slab ${e.toString()}');
    }
  }

  Future<http.Response> index({
    required int abscisaId
  }) async {
    try {
      final uri = Uri.parse('${BaseUrl.baseUrl}/slab/${abscisaId}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        uri,
        headers: { 'Authorization': 'Bearer $token' },
      );

      return response;
    } catch (e) {
      throw Exception('Failed to get all slabs ${e.toString()}');
    }
  }
}