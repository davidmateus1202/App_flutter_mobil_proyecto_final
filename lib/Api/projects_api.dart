import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/project.dart';
import '../Services/base_url.dart';

class ProjectsApi {
  
  // Get Projects
  Future index({
    required int page
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${BaseUrl.baseUrl}/project/?page=$page');
      final token = prefs.getString('token');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        }
      );
      
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];

      return data.map((item) => ProjectModel.fromJson(item)).toList();

    } catch (e) {
      throw Exception('Failed to get projects ${e.toString()}');
    }
  }

  // Create Project
  Future create({
    required String name,
    String? description,
    File? image,
    // ignore: non_constant_identifier_names
    double? start_lat,
    // ignore: non_constant_identifier_names
    double? start_lng,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${BaseUrl.baseUrl}/project/create');
      final token = prefs.getString('token');

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;
      request.fields['description'] = description ?? '';
      request.fields['start_lat'] = start_lat.toString();
      request.fields['start_lng'] = start_lng.toString();
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send();
      return response;

    } catch (e) {
      throw Exception('Failed to create project ${e.toString()}');
    }
  }

  /// realiza la peticion a lservidor de tipo post para validar la persistencia del dato
  /// obtiene la abscisa que esta en estado de estudio
  Future getDetailProjectApi({
    required int id
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${BaseUrl.baseUrl}/project/show/detail');
      final token = prefs.getString('token');

      // peticion
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        },
        body: {
          'project_id': id.toString()
        }
      );

      return response;

    } catch (e) {
      throw Exception('Failed to get detail project ${e.toString()}');
    }
  }


}