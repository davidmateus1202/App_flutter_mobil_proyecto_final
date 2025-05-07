import 'package:diapce/Screens/Auth/form_login.dart';
import 'package:flutter/material.dart';

import '../../Theme/app.dart';
import '../../Widgets/button_custom.dart';
import '../../Widgets/text_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  // Widget principal 
  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/icon.png'),
          TextWidget(text: 'Inicio de Sesion', fontSize: 25, fontWeight: FontWeight.w500),
          ButtonCustom(context: context, onPressed: () async {formLogin(context);}, text: 'Ingresar'),
          _buildButtonRegister(),
          SizedBox(height: 20),
          _buildRegister()
        ],
      ),
    );
  }

  // Widget de boton Register
  Widget _buildButtonRegister() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: App.primaryColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(text: 'Ingresa', fontSize: 12, color: App.primaryColor, fontWeight: FontWeight.w400),
        ],
      )
    );
  }

  // Widget de boton Register
  Widget _buildRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(text: '¿No tienes una cuenta? ', fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
        TextWidget(text: 'Registrate', fontSize: 12, color: App.primaryColor, fontWeight: FontWeight.w400),
      ],
    );
  }
}