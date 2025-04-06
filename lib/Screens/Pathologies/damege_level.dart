import 'package:diapce/Providers/pathologies_provider.dart';
import 'package:diapce/Theme/app.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<dynamic> damageLevel(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DamegeLevel();
    },
  );
}

class DamegeLevel extends StatelessWidget {
  const DamegeLevel({super.key});

  @override
  Widget build(BuildContext context) {
    final _pathologies = Provider.of<PathologiesProvider>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 15,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(50)
            ),
          ),
          SizedBox(height: 10),
          _builItem(context: context, title: 'Nivel bajo', image: 'assets/images/bajo.png', onTap: () { _pathologies.setTypeDamage('low'); _pathologies.setDataPathologies('type_damage', 'low');  Navigator.pop(context); }),
          _builItem(context: context, title: 'Nivel medio', image: 'assets/images/medio.png', onTap: () {  _pathologies.setTypeDamage('half'); _pathologies.setDataPathologies('type_damage', 'half'); Navigator.pop(context); }),
          _builItem(context: context, title: 'Nivel Alto', image: 'assets/images/alto.png', onTap: () {  _pathologies.setTypeDamage('high'); _pathologies.setDataPathologies('type_damage', 'high'); Navigator.pop(context); }),
        ],
      )
    );
  }

  Widget _builItem(
      {required BuildContext context,
      required String title,
      required String image,
      required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.translucent,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: App.grayColor),
          child: Row(
            spacing: 15,
            children: [
              Image.asset(
                image,
                width: 30,
              ),
              TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.w500),
              Spacer(),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 15),
              )
            ],
          )),
    );
  }
}