import 'dart:convert';
import 'dart:io';
import 'package:diapce/Theme/app.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../Api/projects_api.dart';
import '../Models/project.dart';
import '../mainScreen.dart';

class ProjectProvider extends ChangeNotifier {

  final ProjectsApi _projectsApi = ProjectsApi();

  // variables
  List<ProjectModel> _projects = [];
  ProjectModel? _project;
  final int _currentPage = 1;
  final int _lastPage = 1;

  // getters
  List<ProjectModel> get projects => _projects;
  ProjectModel? get project => _project;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;

  // functions
  Future<void> index() async {
    try {
      _projects = await _projectsApi.index(page: _currentPage);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get projects ${e.toString()}');
    }
  }

  Future<void> cretae({
    required BuildContext context,
    required String name,
    String? description,
    File? image,
    double? start_lat,
    double? start_lng,
  }) async {
    try {
      final response = await _projectsApi.create(
        name: name,
        description: description,
        image: image,
        start_lat: start_lat,
        start_lng: start_lng
      );

      if (response.statusCode == 201) {
        final String data = await response.stream.bytesToString();
        final Map<String, dynamic> jsonData = jsonDecode(data); 
        
        final index = _projects.indexWhere((element) => element.id == jsonData['id']);
        if (index != -1) {
          _projects[index] = ProjectModel.fromJson(jsonData);
        } else {
          _projects.add(ProjectModel.fromJson(jsonData));
        }
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Mainscreen()), (route) => false);
      } else {
        QuickAlert.show(
          // ignore: use_build_context_synchronously
          context: context, 
          type: QuickAlertType.error,
          title: 'Error',
          text: response.body,
          confirmBtnText: 'Aceptar',
          confirmBtnColor: App.primaryColor
        );
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create project ${e.toString()}');
    }
  }
}