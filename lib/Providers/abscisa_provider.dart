import 'dart:convert';

import 'package:diapce/Api/abscisa_api.dart';
import 'package:diapce/Models/abscisa_model.dart';
import 'package:flutter/foundation.dart';

class AbscisaProvider extends ChangeNotifier {

  AbscisaModel? _abscisa;
  AbscisaModel? get abscisa => _abscisa;

  //instance of AbscisaApi
  final AbscisaApi _abscisaApi = AbscisaApi();

  Future<void> create({
    required String name,
    required int numberOfAbscisas,
    required int projectId
  }) async {
    final response = await _abscisaApi.create(
      name: name, 
      numberOfAbscisas: numberOfAbscisas, 
      projectId: projectId
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final json = responseBody['data'];
      _abscisa = AbscisaModel.fromJson(json);
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Failed to create abscisa');
      }
    }
  }

  saveAbscisa(AbscisaModel abscisa) {
    _abscisa = abscisa;
    notifyListeners();
  }

  clearAbscisa() {
    _abscisa = null;
    notifyListeners();
  }
}