import 'package:cached_network_image/cached_network_image.dart';
import 'package:diapce/Controllers/pathologies_controller.dart';
import 'package:diapce/Widgets/button_custom.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/not_found.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PathologiesEdit extends StatefulWidget {
  const PathologiesEdit({
    super.key,
    this.pathologies
  });

  final dynamic pathologies;

  @override
  State<PathologiesEdit> createState() => _PathologiesEditState();
}

class _PathologiesEditState extends State<PathologiesEdit> {
  
  final _projectController = PathologiesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', onPressed: () { Navigator.pop(context);}),
      body: widget.pathologies.length == 0
          ? NotFound()
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  _buildListPathologies(),
                ],
              ),
            ),
    );
  }

  // lista de patologias
  Widget _buildListPathologies() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.pathologies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: TextWidget(text: widget.pathologies[index]['name'], fontSize: 15, fontWeight: FontWeight.w500, maxLines: 2)),
                    SizedBox(
                      child: Row(
                        spacing: 5,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: _projectController.formatTypeColor(widget.pathologies[index]['type_damage']),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          TextWidget(text: _projectController.formatTypeDamage(widget.pathologies[index]['type_damage']), fontSize: 15, fontWeight: FontWeight.w600, color: _projectController.formatTypeColor(widget.pathologies[index]['type_damage']),)
                        ],
                      ),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.pathologies[index]['url_image'],
                    fit: BoxFit.cover,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      TextWidget(text: 'Mas Datos', fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[600]!,),
                      _buildRowItem(widget.pathologies[index], Icons.dangerous_rounded),
                      _buildRowItem(widget.pathologies[index], Icons.health_and_safety),
                      ButtonCustom(
                        context: context,
                         onPressed: () async {}, 
                         text: 'Editar'
                        )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // row widget
  Widget _buildRowItem(dynamic pathology, IconData icon) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey[600],
          ),
          child: Icon(icon, color: Colors.white, size: 15),
        ),
        TextWidget(text: 'Longitud: ${pathology['long_damage']} ${pathology['type_long_damage']}, Ancho: ${pathology['width_damage']} ${pathology['type_width_damage']}', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600]!,),
      ],
    );
  }
}