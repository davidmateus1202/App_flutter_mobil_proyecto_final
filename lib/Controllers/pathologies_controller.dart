import 'dart:convert';
import 'dart:io';
import 'package:diapce/Api/pathologies_api.dart';
import 'package:diapce/Controllers/project_controller.dart';
import 'package:diapce/Providers/pathologies_provider.dart';
import 'package:diapce/Providers/slab_provider.dart';
import 'package:diapce/Theme/app.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class PathologiesController {

  final PathologiesApi _pathologiesApi = PathologiesApi();
  final ProjectController _projectController = ProjectController();

  analyzePathology({
    File? image,
  }) async {
    File? compressFile = await _projectController.compressImageFuntion(XFile(image!.path));
    final response = await _pathologiesApi.analyzePathology(image: compressFile);
    if (response.statusCode == 200) {
      print('Respuesta de la API:');
      final String data = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = jsonDecode(data);
      print(jsonData);
      return jsonData;
    }
  }

  /// format percentage
  formatPercentage(String value) {
    RegExp regExp = new RegExp(r"(\d+\.\d{1})");
    final match = regExp.firstMatch(value);
    if (match != null) {
      return double.parse(match.group(0)!) / 100;
    }
  }

  // title format damage
  formatTitle(PathologiesProvider pathology) {
    switch (pathology.typeDamage) {
      case 'low':
        return 'Nivel bajo';
      case 'half':
        return 'Nivel medio';
      case 'high':
        return 'Nivel alto';
      default:
        return 'Nivel de severidad';
    }
  }

  formatTypeDamage(String typeDamage) {
    switch (typeDamage) {
      case 'low':
        return 'Bajo';
      case 'half':
        return 'Medio';
      case 'high':
        return 'Alto';
      default:
        return 'Nivel de severidad';
    }
  }

  formatTypeColor(String typeDamage) {
    switch (typeDamage) {
      case 'low':
        return Colors.amber;
      case 'half':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// get all slabs by project
  calculedArea({
    required double long,
    required double width,
  }) {
    double longM = long / 100;
    double widthM = width / 100;
    return longM * widthM;
  }

  /// get all concepts by pathology
  loadConcepts() async {
    final response = await _pathologiesApi.showConcepts();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['pathologyConcepts'];
    }
    return null;
  }

  // create new pathology
  create({
    required BuildContext context,
    required SlabProvider slab,
    required TextEditingController longitudDamage,
    required TextEditingController anchoDamage,
    required TextEditingController longitudReparacion,
    required TextEditingController anchoReparacion,
  }) async {
    if (slab.slabSelected == null ||
        longitudDamage.text.isEmpty ||
        anchoDamage.text.isEmpty ||
        longitudReparacion.text.isEmpty ||
        anchoReparacion.text.isEmpty) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: 'Advertencia',
          text: 'Todos los campos son obligatorios',
          confirmBtnText: 'Aceptar',
          confirmBtnColor: App.primaryColor);
      return;
    }

    // datos para registrar la patologia
    final pathology = context.read<PathologiesProvider>();
    pathology.setDataPathologies('long_damage', longitudDamage.text);
    pathology.setDataPathologies('type_long_damage', 'cm');
    pathology.setDataPathologies('width_damage', anchoDamage.text);
    pathology.setDataPathologies('type_width_damage', 'cm');
    pathology.setDataPathologies('repair_long', longitudReparacion.text);
    pathology.setDataPathologies('type_repair_long', 'cm');
    pathology.setDataPathologies('repair_width', anchoReparacion.text);
    pathology.setDataPathologies('type_repair_width', 'cm');

    final response = await _pathologiesApi.create(pathologyProvider: pathology);

    if (response.statusCode == 201) {
      pathology.removeDataPathology();
      pathology.removeTypeDamage();
      slab.removeSlab();

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
        QuickAlert.show(
          // ignore: use_build_context_synchronously
          context: context,
          type: QuickAlertType.error,
          title: 'Error 500',
          text: 'No se pudo realizar el registro de la patologia.',
          confirmBtnText: 'Aceptar',
          confirmBtnColor: App.primaryColor);
    }
  }
}
