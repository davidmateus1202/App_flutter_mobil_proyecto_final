import 'package:flutter/material.dart';

class PathologiesProvider extends ChangeNotifier {

  String _typeDamage = '';
  String _resultPathology = '';
  Map<String, dynamic> _pathologies = {
    'slab_id': 0,
    'name': '',
    'url_image': '',
    'long_damage': 0,
    'type_long_damage': '',
    'width_damage': 0,
    'type_width_damage': '',
    'repair_long': 0,
    'type_repair_long': '',
    'repair_width': 0,
    'type_repair_width': '',
    'type_damage': '',
  };

  //getters
  String get typeDamage => _typeDamage;
  String get resultPathology => _resultPathology;
  Map<String, dynamic> get pathologies => _pathologies;

  //setters
  setTypeDamage(String typeDamage) {
    _typeDamage = typeDamage;
    notifyListeners();
  }

  removeTypeDamage() {
    _typeDamage = '';
    notifyListeners();
  }

  // setters for pathologies
  setDataPathologies(String key, dynamic value) {
    if (_pathologies.containsKey(key)) {
      _pathologies[key] = value;
      notifyListeners();
    } else {
      throw Exception('Key $key not found in pathologies map');
    }
  }

  setResultPathology(String resultPathology) {
    _resultPathology = resultPathology;
    notifyListeners();
  }

  removeDataPathology() {
    _pathologies = {
    'slab_id': 0,
    'name': '',
    'url_image': '',
    'long_damage': 0,
    'type_long_damage': '',
    'width_damage': 0,
    'type_width_damage': '',
    'repair_long': 0,
    'type_repair_long': '',
    'repair_width': 0,
    'type_repair_width': '',
    'type_damage': '',
  };

    notifyListeners();
  }

}