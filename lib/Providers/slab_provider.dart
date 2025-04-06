import 'dart:convert';

import 'package:diapce/Api/slab_api.dart';
import 'package:diapce/Models/slab_model.dart';
import 'package:flutter/material.dart';

class SlabProvider extends ChangeNotifier {

  List<SlabModel> _slabs = [];
  int _countSlabs = 0;
  SlabModel? _slabSelected;

  List<SlabModel> get slabs => _slabs;
  int get countSlabs => _countSlabs;
  SlabModel? get slabSelected => _slabSelected;

  //instance of the slab model
  SlabApi slabApi = SlabApi();

  Future<void> create({
    required int abscisaId,
    required double long,
    required double width,
    required String latitude,
    required String longitude,
  }) async {
    final response = await slabApi.create(
      abscisaId: abscisaId, 
      long: long, width: width, 
      typeLong: 'cm', 
      typeWidth: 'cm', 
      latitude: latitude, 
      longitude: longitude
    );

    if (response.statusCode == 201) {
      _countSlabs++;
      _slabs.add(SlabModel.fromJson(jsonDecode(response.body)));
    }
    notifyListeners();
  }

  saveSlabs(List<SlabModel> slabs, int count) {
    _slabs = slabs;
    _countSlabs = count;
    notifyListeners();
  }

  clearSlabs() {
    _slabs = [];
    _countSlabs = 0;
    notifyListeners();
  }

  /// select slab
  selectSlab(SlabModel slab) {
    _slabSelected = slab;
    notifyListeners();
  }

}