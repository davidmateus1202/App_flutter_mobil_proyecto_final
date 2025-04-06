import 'package:diapce/Models/project.dart';
import 'package:diapce/Providers/abscisa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Theme/app.dart';
import '../Widgets/button_custom.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/header.dart';
import '../Widgets/text_form_text.dart';

class Abscisa extends StatefulWidget {
  const Abscisa({
    required this.project,
    super.key
  });

  final ProjectModel project;

  @override
  State<Abscisa> createState() => _AbscisaState();
}

class _AbscisaState extends State<Abscisa> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final abscisa = Provider.of<AbscisaProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Ajusta el contenido al abrir el teclado
      appBar: CustomAppBar(title: 'Abscisa', onPressed: () async {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
        color: App.primaryColor,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Cierra el teclado al tocar fuera
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(title: 'Abscisa', subtitle: 'Agrega una nueva abscisa'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormText(icon: Icon(Icons.abc),controller: _nameController,obscureText: false,hintText: 'Nombre (opcional)'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormText( icon: Icon(Icons.abc), controller: _numberController, obscureText: false, hintText: 'Número de placas', keyboardType: TextInputType.number),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonCustom(
                context: context,
                onPressed: () async {
                  await abscisa.create(
                    name: _nameController.text.trim(), 
                    numberOfAbscisas: int.parse(_numberController.text.trim()), 
                    projectId: widget.project.id
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                text: 'Guardar',
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
