import 'package:diapce/Api/projects_api.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';



class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {

  final MobileScannerController controller = MobileScannerController();
  ProjectsApi projectsApi = ProjectsApi();
  bool isScanCompleted = false;
  bool isLoading = false;

  Future registerCollaborator(String code) async {
    isLoading = true;
    setState(() {});
    final response = await projectsApi.newRegisterCollaborator(code);
    if (response.statusCode == 201) {
      isLoading = false;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Mainscreen()), (_) => false);
    } else {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register collaborator'))
      );
      isScanCompleted = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(onPressed: () {Navigator.pop(context);}, title: '',),
      body: isLoading 
        ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          ),
        )
        : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (!isScanCompleted) {
                isScanCompleted = true;
                final String code = capture.barcodes.first.rawValue ?? '';
                await registerCollaborator(code);
                print('Barcode found! $code');
              }
            },
          ),
        ),
      ),
    );
  }
}