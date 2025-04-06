import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AlertSucces extends StatelessWidget {
  const AlertSucces({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          QuickAlert.show(
            context: context, 
            type: QuickAlertType.success,
            title: 'Succes',
            text: 'This is a success alert',
          );
        });
        return SizedBox.shrink();
      },
    );
  }
}