import 'dart:convert';
import 'dart:io';
import 'package:diapce/Api/projects_api.dart';
import 'package:diapce/Models/abscisa_model.dart';
import 'package:diapce/Models/slab_model.dart';
import 'package:diapce/Providers/abscisa_provider.dart';
import 'package:diapce/Providers/project_provider.dart';
import 'package:diapce/Providers/slab_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

class ProjectController {

  final ProjectsApi _projectsApi = ProjectsApi();

  // logica de negocio
  index(BuildContext context) async {
    final project = Provider.of<ProjectProvider>(context, listen: false);
    await project.index();
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      return File(image.path);
    }
  }

  Future<File?> compressImageFuntion(XFile image) async {
    try {
      // leer la imagen original
      final originalFile = File(image.path);
      final imageBytes = await originalFile.readAsBytes();

      // decodificar la imagen
      final decodeImage = await img.decodeImage(imageBytes);

      if (decodeImage != null) {
        // comprimir imagen
        final resizeImage = img.copyResize(decodeImage, width: 1080);

        // codificar la imagen a 80
        final compressedImageTem = img.encodeJpg(resizeImage, quality: 80);

        // guardar imagen temporalmente
        final temDir = await getTemporaryDirectory();
        final compressImage = File('${temDir.path}/temp.jpg');

        await compressImage.writeAsBytes(compressedImageTem);
        return compressImage;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> getDetailProject({
    required int id,
    required BuildContext context
  }) async {
    try {

      //instancias de provider
      final abscisaProvider = Provider.of<AbscisaProvider>(context, listen: false);
      final slabProvider = Provider.of<SlabProvider>(context, listen: false);
      List<SlabModel> slabs = [];

      final response = await _projectsApi.getDetailProjectApi(id: id);
      if (response.statusCode == 200) {

        Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['abscisa_in_progress'] == null) {
          return;
        }

        final abscisa = AbscisaModel.fromJson(data['abscisa_in_progress']);
        abscisaProvider.saveAbscisa(abscisa);

        for (var item in data['abscisa_in_progress']['slabs']) {
          final slab = SlabModel.fromJson(item);
          slabs.add(slab);
        }

        if (slabs.isNotEmpty) {
            slabProvider.saveSlabs(slabs, slabs.length);
        }
      }

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  
}