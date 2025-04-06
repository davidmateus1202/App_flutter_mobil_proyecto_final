import 'dart:io';
import 'package:diapce/Controllers/geolocator_service.dart';
import 'package:diapce/Controllers/project_controller.dart';
import 'package:diapce/Providers/project_provider.dart';
import 'package:diapce/Theme/app.dart';
import 'package:diapce/Widgets/button_custom.dart';
import 'package:diapce/Widgets/header.dart';
import 'package:diapce/Widgets/text_form_text.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {

  // Controladores
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ProjectController _projectController = ProjectController();
  final GeolocatorService _geolocatorService = GeolocatorService();

  bool loading = false;
  bool loadingCreate = false;
  double lat = 0.0;
  double lon = 0.0;
  File? image;

  _pickImage() async {
    final File? image = await _projectController.pickImage();
    if (image != null) {
      setState(() {
        this.image = image;
      });
    }
  }

  _create() async {

    final compressFile = await _projectController.compressImageFuntion(XFile(image!.path));
    if (compressFile != null) {
      image = compressFile;
    }

    // instance provider
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    await projectProvider.cretae(
      // ignore: use_build_context_synchronously
      context: context,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      image: image,
      start_lat: lat, 
      start_lng: lon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              color: App.primaryColor,
            ),
            Header(title: 'Proyecto', subtitle: 'Crea un nuevo proyecto de investigacion.'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                spacing: 15,
                children: [
                  TextFormText(icon: Icon(Icons.abc), controller: _nameController, obscureText: false, hintText: 'Nombre del proyecto'),
                  TextFormText(icon: Icon(Icons.abc), controller: _descriptionController, obscureText: false, hintText: 'Descripcion del proyecto (opcional)'),
                  _buildImageButton(),
                  _buildButtonLocation(),
                  ButtonCustom(
                  context: 
                  context, 
                  onPressed: () async {
                      if (_nameController.text.isEmpty || lat == 0.0 && lon == 0.0 || image == null) {
                        QuickAlert.show(
                          context: context, 
                          type: QuickAlertType.info,
                          title: 'Error',
                          text: 'Todos los campos son obligatorios',
                          confirmBtnText: 'Aceptar',
                          confirmBtnColor: App.primaryColor
                        );
                        return;
                      } else {
                        await _create();
                        
                      }
                     }, 
                     text: 'Guardar', 
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  // Widget image button
  Widget _buildImageButton() {
    return GestureDetector(
      onTap: () async { await _pickImage(); },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: 'Imagen de proyecto', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
            TextWidget(text: 'Captura la imagen de tu proyecto', fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey[400]!),
            SizedBox(height: 10),
            image == null ? _buildButtonImage() : _buildImage(),
          ],
        )
      ),
    );
  }

  // Widget render image
  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(image!, width: MediaQuery.of(context).size.width, height: 180, fit: BoxFit.cover),
    );
  }

  // Widget de boton
  Widget _buildButtonImage() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Icon(Icons.camera_alt_rounded, color: App.primaryColor, size: 50),
        ),
      ),
    );
  }

  // Widget button location
  Widget _buildButtonLocation() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      decoration: BoxDecoration(
        color: App.grayColor,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        spacing: 5,
        children: [
          Container(
            margin: EdgeInsets.all(3),
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Icon(
                            Icons.location_on_rounded,
                            color: lat == 0.0 && lon == 0.0 ? Colors.grey[400] : App.primaryColor,
                          ),
          ),
          TextWidget(text: lat == 0.0 && lon == 0.0 ? 'Ubicacion del proyecto' : 'Ubicacion registrada', fontSize: 14, color: lat == 0.0 && lon == 0.0 ? Colors.grey[400]! : Colors.black, fontWeight: FontWeight.w500),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                loading = true;
                setState(() {});
                final position = await _geolocatorService.determinePosition();
                lat = position.latitude;
                lon = position.longitude;
                loading = false;
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: App.primaryColor,
                  borderRadius: BorderRadius.circular(50)
                ),
                alignment: Alignment.center,
                child: TextWidget(text: 'Ubicacion', fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            )
          )
        ],
      ),
    );
  }
}