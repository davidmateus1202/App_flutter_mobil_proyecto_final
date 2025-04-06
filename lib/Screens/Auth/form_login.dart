import 'package:diapce/Theme/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../Providers/auth_provider.dart';
import '../../Widgets/button_custom.dart';
import '../../Widgets/text_form_text.dart';
import '../../Widgets/text_widget.dart';
import '../../mainScreen.dart';

// Formulario de inicio de sesion
Future<dynamic> formLogin(BuildContext context) {

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return FormLogin();
    },
  );
}

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {

  // Controladores
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  //login
  _login() async {
    setState(() {
      loading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final response = await authProvider.login(email: _emailController.text, password: _passwordController.text);

    if (response['success'] == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Mainscreen()), (_) => false);
    } else {
      if (!mounted) return;
      QuickAlert.show(
        context: context, 
        type: QuickAlertType.error,
        title: 'Error',
        text: response['message'] as String,
        confirmBtnText: 'Aceptar',
        confirmBtnColor: App.primaryColor
      );
    }
    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 100),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
              ),
              SizedBox(height: 20),
              TextWidget(text: 'Ingresa tus datos', fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              TextFormText(icon: Icon(Icons.person, color: Colors.grey[400], size: 20), controller: _emailController, obscureText: false, hintText: 'Nombre'),
              TextFormText(icon: Icon(Icons.password, color: Colors.grey[400], size: 20), controller: _passwordController, obscureText: true, hintText: 'Contraseña'),
              ButtonCustom(context: context, onPressed: () async {
                if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                  QuickAlert.show(
                    context: context, 
                    type: QuickAlertType.info,
                    title: 'Atención',
                    text: 'Por favor, rellene todos los campos',
                    confirmBtnText: 'Aceptar',
                    confirmBtnColor: App.primaryColor
                  );
                } else {
                  await _login();
                }
              }, text: 'Ingresar'),
              keyboardHeight == 0 ? SizedBox(height: 50) : SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }

}