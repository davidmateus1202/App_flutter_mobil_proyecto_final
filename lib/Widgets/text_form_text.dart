import 'package:flutter/material.dart';

class TextFormText extends StatelessWidget {
  const TextFormText({
    required this.icon,
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  final Icon icon;
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(50))
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
            child: icon,
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            width: MediaQuery.of(context).size.width - 100,
            height: 55,
            child: TextFormField(
              keyboardType: keyboardType,
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none
                ),
                hintText: hintText, 
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontFamily: 'Poppins',
                )
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}