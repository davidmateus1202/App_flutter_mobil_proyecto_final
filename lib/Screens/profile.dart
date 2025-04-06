import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';
import '../Theme/app.dart';
import '../Widgets/text_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthProvider auth = AuthProvider();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: App.grayColor,
        body: Column(
          children: [
            _header(auth),
            _body(),
          ],
        ));
  }

  Widget _header(AuthProvider auth) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 350,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5))
                ],
                color: App.primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                    text: auth.name,
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                TextWidget(
                    text: auth.email,
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ],
            ),
          ),
          Positioned(
                top: 180,
                left: MediaQuery.of(context).size.width / 2 - 65,
                child: Container(
                  width: 130,
                  height: 130,
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(100))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Image.asset('assets/images/photo.jpg')
                  ),
                )
            )
        ],
      )
    );
  }

  Widget _body() {
    return  Column(
      spacing: 25,
        children: [
          _item(
          Icon(Icons.pivot_table_chart_sharp, color: App.grayColor), 
          TextWidget(text: 'Proyectos', fontSize: 16, fontWeight: FontWeight.w500), 
          () {}
          ),
          _item(
          Icon(Icons.settings, color: App.grayColor), 
          TextWidget(text: 'Configuración', fontSize: 16, fontWeight: FontWeight.w500), 
          () {}
          ),
          _item(
          Icon(Icons.more, color: App.grayColor), 
          TextWidget(text: 'Mas', fontSize: 16, fontWeight: FontWeight.w500), 
          () {}
          ),
        ],
      );
  }

  Widget _item(Icon icon, TextWidget text, GestureTapCallback? action) {
    return GestureDetector(
      onTap: action,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          spacing: 10,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: App.secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)
                ),
              ),
              child: icon,
            ),
            text,
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: App.primaryColor)
          ],
        ),
      ),
    );

  }
}
