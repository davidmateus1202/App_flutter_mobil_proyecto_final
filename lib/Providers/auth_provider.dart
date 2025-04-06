import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/auth_api.dart';

class AuthProvider extends ChangeNotifier {

  final AuthApi _authApi = AuthApi();

  //User
  String _email = '';
  String _name = '';
  String _photoUrl = '';
  bool _isLogged = false;

  //Getters
  String get email => _email;
  String get name => _name;
  String get photoUrl => _photoUrl;
  bool get isLogged => _isLogged;

  // funcions
  Future<Map<String, Object>> login({
    required String email,
    required String password
  }) async {
    
    final response = await _authApi.login(email: email, password: password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, Object> result = {};
    
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(response.body);

        // Set user data
        prefs.setString('role', jsonData['role'][0]);
        prefs.setString('token', jsonData['token']);

        _email = jsonData['user']['email'];
        _name = jsonData['user']['name'];

        result = {
          'success': true,
          'message': 'Inicio de sesion correcto'
        };
        break;
      case 422:
        result = {
          'success': false,
          'message': 'Datos incorrectos'
        };
        break;
      case 401:
        result = {
          'success': false,
          'message': 'Credenciales incorrectas'
        };
        break;
      default:
        result = {
          'success': false,
          'message': 'Error en el servidor'
        };
        break;
    }
    return result; 
  }

  Future<Map<String, Object>> validToken() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, Object> result = {};
    
    try {
      final response = await _authApi.validToken();
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);

          // Set user data
          prefs.setString('role', jsonData['role'][0]);
          prefs.setString('token', jsonData['token']);

          _email = jsonData['user']['email'];
          _name = jsonData['user']['name'];

          result = {
            'success': true,
            'message': 'Inicio de sesion correcto'
          };
      } else {
        result = {
          'success': false,
          'message': 'Error en el servidor'
        };
      }
    return result;
    } catch (e) {
      return result = {
        'success': false,
        'message': 'Error en el servidor'
      };
    }
  }
}