import 'dart:io';

import 'package:diapce/Controllers/pathologies_controller.dart';
import 'package:diapce/Controllers/project_controller.dart';
import 'package:diapce/Providers/pathologies_provider.dart';
import 'package:diapce/Providers/slab_provider.dart';
import 'package:diapce/Screens/Pathologies/damege_level.dart';
import 'package:diapce/Screens/project_slabs.dart';
import 'package:diapce/Screens/Pathologies/search_pathologies.dart';
import 'package:diapce/Widgets/button_custom.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/header.dart';
import 'package:diapce/Widgets/text_form_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../Theme/app.dart';
import '../../Widgets/text_widget.dart';

class Pathologies extends StatefulWidget {
  const Pathologies({super.key});

  @override
  State<Pathologies> createState() => _PathologiesState();
}

class _PathologiesState extends State<Pathologies> {

  //instance
  final ProjectController _projectController = ProjectController();
  final PathologiesController _pathologiesController = PathologiesController();
  final TextEditingController _longitudDamage = TextEditingController();
  final TextEditingController _anchoDamage = TextEditingController();
  final TextEditingController _longitudReparacion = TextEditingController();
  final TextEditingController _anchoReparacion = TextEditingController();
  
  // variables
  File? image;
  bool isloading = false;
  Map<String, dynamic> data = {};
  double porcentaje = 0.0;

  _pickerImage() async {
    final File? image = await _projectController.pickImage();
    if (image != null) {
      setState(() {
        this.image = image;
      });
    }
  }

  _analiceImage() async {

    final pathologyProvider = context.read<PathologiesProvider>();

    try {
      if (image != null) {
        isloading = true;
        setState(() {});
        data = await _pathologiesController.analyzePathology(image: image);
        // porcentaje = _pathologiesController.formatPercentage(data['data']['confidence']);
        print(data);
        // almacenar la imagen de la patologia
        pathologyProvider.setDataPathologies('url_image', data['image']);
        pathologyProvider.setDataPathologies('name', data['data']['predicted_class']);

        isloading = false;
        setState(() {});
    }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isloading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final slab = context.watch<SlabProvider>();
    final pathologiesProvider = context.watch<PathologiesProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Patologias', onPressed: () => Navigator.pop(context), color: App.primaryColor),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Header(title: 'Patologia', subtitle: 'Registra el daño en la estructura'),
                  _buildImageButton(),
                  _buildControlItem(),
                  if (data.isNotEmpty) ... [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 10),
                      child: TextWidget(text: 'Analisis de resultados', fontSize: 16, fontWeight: FontWeight.w500, color: App.primaryColor),
                    ),
                    _buildIndicador(),
                    _buildPathologies(pathologiesProvider),
                    Divider(color: Colors.grey[300], thickness: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextWidget(text: 'Placa de estudio', fontSize: 16, fontWeight: FontWeight.w500, color: App.primaryColor),
                    ),
                    _buildRowItem(slab.slabSelected == null ? 'Agregar' : 'Placa - ${slab.slabSelected?.id}', slab.slabSelected != null ? 'Placa seleccionada' : 'Agrega una placa de estudio', () { Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectSlabs())); }, slab.slabSelected != null ? true : false),
                    Divider(color: Colors.grey[300], thickness: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextWidget(text: 'Informacion adicional', fontSize: 16, fontWeight: FontWeight.w500, color: App.primaryColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormText(icon: Icon(Icons.abc), controller: _longitudDamage, obscureText: false, hintText: 'Longitud de la patologia', keyboardType: TextInputType.number)
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormText(icon: Icon(Icons.abc), controller: _anchoDamage, obscureText: false, hintText: 'Ancho de la patologia', keyboardType: TextInputType.number)
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormText(icon: Icon(Icons.abc), controller: _longitudReparacion, obscureText: false, hintText: 'Longitud de la reparacion', keyboardType: TextInputType.number)
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormText(icon: Icon(Icons.abc), controller: _anchoReparacion, obscureText: false, hintText: 'Ancho de la reparacion', keyboardType: TextInputType.number,)
                    ),
                    Divider(color: Colors.grey[300], thickness: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextWidget(text: 'Nivel de gravedad', fontSize: 16, fontWeight: FontWeight.w500, color: App.primaryColor),
                    ),
                    _buildRowItem(_pathologiesController.formatTitle(pathologiesProvider), 'Agrega un nivel de gravedad', () { damageLevel(context); }, pathologiesProvider.typeDamage != '' ? true : false),
                  ]
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ButtonCustom(
              context: context, 
              onPressed: () async {
                _pathologiesController.create(
                  context: context,
                  slab: slab, 
                  longitudDamage: _longitudDamage, 
                  anchoDamage: _anchoDamage, 
                  longitudReparacion: _longitudReparacion, 
                  anchoReparacion: _anchoReparacion
                );
              }, 
              text: 'Guardar'
            )
          )
        ],
      ),
    );
  }

  // Toma de lectura de modelo por patologia
  Widget _buildImageButton() {
    return GestureDetector(
      onTap: () async { await _pickerImage(); },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        width: MediaQuery.of(context).size.width,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10)
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(image!, fit: BoxFit.cover),
              )
            : Center(
                child: Icon(Icons.camera_alt, size: 50, color: App.primaryColor),
              ),
      ),
    );
  }

  // Widget de botones de control
  Widget _buildControlItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(left: 20, right: 5, top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width,
      height: 55,
      decoration: BoxDecoration(
        color: App.grayColor,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           Expanded(
            child: Row(
              spacing: 15,
              children: [
                Image.asset('assets/images/ia.png', fit: BoxFit.contain, width: 30, height: 30),
                TextWidget(text: 'Analizar con IA', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[400]!),
              ],
            ) 
            ),
           GestureDetector(
            onTap: () async {
             await _analiceImage();
            },
            child: Container(
              height: 50,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: App.primaryColor,
                borderRadius: BorderRadius.circular(50)
              ),
              child: isloading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)
                    )
                  : TextWidget(text: 'Analizar', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
            ),

           )
        ],
      ),
    );
  }

  // Widget analisis de resultados
  Widget _buildIndicador() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextWidget(text: data['data']?['confidence'] ?? '', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]!),
        ),
        Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 16,
            animation: true,
            lineHeight: 15.0,
            animationDuration: 2500,
            percent: porcentaje,
            barRadius: Radius.circular(50),
            progressColor: App.primaryColor,
          ),
        ),
      ],
    );
  }

  //Row pathologies
  Widget _buildPathologies(PathologiesProvider pathologiesProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: TextWidget(text: pathologiesProvider.pathologies['name'] ?? '', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]!, maxLines: 2,)),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPathologies()));
            },
            child: Row(
              children: [
                TextWidget(text: 'Cambiar', fontSize: 14, fontWeight: FontWeight.w500, color: App.primaryColor),
                Icon(Icons.change_circle, color: App.primaryColor),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowItem(String title, String subtitle, Function onTap, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(
          spacing: 10,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected == false ? Colors.grey[200] : App.primaryColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(isSelected == false ? Icons.add : Icons.check, color: isSelected == false ? Colors.grey[400] : Colors.white),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: title, fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]!),
                TextWidget(text: subtitle, fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[400]!),
              ],
            )
          ],
        ),
      ),
    );
  }

}