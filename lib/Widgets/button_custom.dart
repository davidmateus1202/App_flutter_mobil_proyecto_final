import 'package:diapce/Theme/app.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ButtonCustom extends StatefulWidget {
  const ButtonCustom({
    required this.context,
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    });

    final Future Function() onPressed;
    final String text;
    final double? width;
    final BuildContext context;

  @override
  State<ButtonCustom> createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = widget.width ?? MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        loading = true;
        setState(() {});
        await widget.onPressed();
        loading = false;
        setState(() {});
      },
      child: Container(
        width: buttonWidth,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: App.primaryColor,
          borderRadius: BorderRadius.circular(50)
        ),
        child: loading ? SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: Colors.white)) : TextWidget(text: widget.text, fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}