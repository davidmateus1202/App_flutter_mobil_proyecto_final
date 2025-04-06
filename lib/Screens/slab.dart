import 'package:diapce/Models/abscisa_model.dart';
import 'package:diapce/Widgets/button_custom.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/header.dart';
import 'package:diapce/Widgets/text_form_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../Controllers/geolocator_service.dart';
import '../Providers/slab_provider.dart';
import '../Theme/app.dart';
import '../Widgets/text_widget.dart';

class Slab extends StatefulWidget {
  const Slab({
    super.key,
    required this.abscisa
    });

    final AbscisaModel abscisa;

  @override
  State<Slab> createState() => _SlabState();
}

class _SlabState extends State<Slab> {

  final TextEditingController _long = TextEditingController();
  final TextEditingController _width = TextEditingController();
  final GeolocatorService _geolocatorService = GeolocatorService();

  // variables
  double lat = 0.0;
  double lon = 0.0;
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    final slabProvider = Provider.of<SlabProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', onPressed: () => Navigator.pop(context), color: App.primaryColor,),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 15,
                children: [
                  Header(title: 'Placa', subtitle: 'Ingrese los datos de la placa'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormText(icon: Icon(Icons.numbers_rounded), controller: _long, obscureText: false, hintText: 'Longitud (cm)', keyboardType: TextInputType.number,),  
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormText(icon: Icon(Icons.numbers_rounded), controller: _width, obscureText: false, hintText: 'Ancho (cm)', keyboardType: TextInputType.number,),  
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _buildButtonLocation(), 
                  )
                ],
              ),
            ) 
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ButtonCustom(
              context: context, 
              onPressed: () async {
                await slabProvider.create(
                  abscisaId: widget.abscisa.id, 
                  long: double.parse(_long.text), 
                  width: double.parse(_width.text), 
                  latitude: lat.toString(), 
                  longitude: lon.toString()
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }, 
              text: 'Guardar',
            ),
          )
          
        ],
      ),
    );
  }

  // widget 
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
          TextWidget(text: lat == 0.0 && lon == 0.0 ? 'Ubicacion del proyecto' : 'Ubicacion registrada', fontSize: 12, color: lat == 0.0 && lon == 0.0 ? Colors.grey[400]! : Colors.black, fontWeight: FontWeight.w500),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (loading) return;
                if (_long.text.isEmpty || _width.text.isEmpty) {
                  QuickAlert.show(
                    context: context, 
                    type: QuickAlertType.info,
                    title: 'Campos vacios',
                    text: 'Por favor llene todos los campos',
                  );
                } else {
                  loading = true;
                  setState(() {});
                  final position = await _geolocatorService.determinePosition();
                  lat = position.latitude;
                  lon = position.longitude;
                  loading = false;
                  setState(() {});
                }
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