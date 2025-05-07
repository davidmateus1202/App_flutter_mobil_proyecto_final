import 'package:diapce/Theme/app.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    required this.subtitle,
    });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        color: App.primaryColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50)
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(text: title, fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
          TextWidget(text: subtitle, fontSize: 12, color: App.grayColor, fontWeight: FontWeight.w300),
        ],
      ),
    );
  }
}