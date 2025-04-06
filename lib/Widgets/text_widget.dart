import 'package:flutter/material.dart';

// componente de texto
class TextWidget extends StatelessWidget {
  const TextWidget({
    required this.text,
    this.color = Colors.black,
    super.key,
    required this.fontSize,
    this.maxLines = 1,
    this.fontWeight = FontWeight.normal
  });

  final String text;
  final Color color;
  final double fontSize;
  final int maxLines;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: 1.0,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Poppins',
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      maxLines: maxLines
    );
  }
}