import 'dart:io';

import 'package:diapce/Providers/pathologies_provider.dart';
import 'package:diapce/Services/base_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PathologiesApi {

  // Analyze Pathology
  Future analyzePathology({
    File? image,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('${BaseUrl.baseUrl}/model');

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    return response;
  }

  // show concepts by pathology
  Future showConcepts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('${BaseUrl.baseUrl}/pathologie/show/concept');

    try {

      final response = http.get(
        url,
        headers: { 'Authorization': 'Bearer $token' },
      );

      return response;

    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // create pathology in database
  create({
    required PathologiesProvider pathologyProvider
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse('${BaseUrl.baseUrl}/pathologie/create');

      final response = await http.post(
        url,
        body: {
          'slab_id': '${pathologyProvider.pathologies['slab_id']}',
          'name': pathologyProvider.pathologies['name'],
          'url_image': pathologyProvider.pathologies['url_image'],
          'long_damage': '${pathologyProvider.pathologies['long_damage']}',
          'type_long_damage': pathologyProvider.pathologies['type_long_damage'],
          'width_damage': '${pathologyProvider.pathologies['width_damage']}',
          'type_width_damage': pathologyProvider.pathologies['type_width_damage'],
          'repair_long': '${pathologyProvider.pathologies['repair_long']}',
          'type_repair_long': pathologyProvider.pathologies['type_repair_long'],
          'repair_width': '${pathologyProvider.pathologies['repair_width']}',
          'type_repair_width': pathologyProvider.pathologies['type_repair_width'],
          'type_damage': pathologyProvider.pathologies['type_damage']
        },
        headers: { 'Authorization': 'Bearer $token' }
      );

      return response;

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}