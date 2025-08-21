import 'package:diapce/Models/project.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RegisterCollaborator extends StatefulWidget {
  const RegisterCollaborator({
    required this.project,
    super.key
    });

  final ProjectModel project;

  @override
  State<RegisterCollaborator> createState() => _RegisterCollaboratorState();
}

class _RegisterCollaboratorState extends State<RegisterCollaborator> {

  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', onPressed: () {Navigator.pop(context);}, color: Colors.white,),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            TextWidget(
              text: 'Registrar Colaborador',
              fontSize: 25,
              fontWeight: FontWeight.w300,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                ),
                child: RepaintBoundary(
                  key: _qrKey,
                  child: QrImageView(data: widget.project.id.toString()),
                )
              ),
              TextWidget(
                text: 'Escanea este código QR para unirte a un equipo', 
                fontSize: 15,
                fontWeight: FontWeight.w300,
                textAlign: TextAlign.center,
                color: Colors.grey[400]!,
                maxLines: 2)
          ],
        ),
      ),
    );
  }
}