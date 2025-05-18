import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({
    super.key,
    this.maxHeight = 200,
    });
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - maxHeight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/notFound.png', width: 100,),
          TextWidget(text: 'No se encontraron resultados!', fontSize: 20, fontWeight: FontWeight.w500, maxLines: 2,),
          TextWidget(text: 'No hay resultados asociados a la busqueda.', fontSize: 12, fontWeight: FontWeight.w300, maxLines: 2,)
        ],
      )
    );
  }
}