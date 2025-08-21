import 'package:diapce/Controllers/abscisa_controller.dart';
import 'package:diapce/Controllers/project_controller.dart';
import 'package:diapce/Providers/slab_provider.dart';
import 'package:diapce/Screens/abscisa.dart';
import 'package:diapce/Screens/Pathologies/pathologies.dart';
import 'package:diapce/Screens/EditDataProject/project_edit.dart';
import 'package:diapce/Screens/register_collaborator.dart';
import 'package:diapce/Screens/slab.dart';
import 'package:diapce/Theme/app.dart';
import 'package:diapce/Widgets/button_custom.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/loading_screen.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/project.dart';
import '../Providers/abscisa_provider.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({
    super.key,
    required this.project,
  });

  final ProjectModel project;

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  String selected = 'Información';
  bool loading = false;

  // instancia de controlador de proyecto
  final ProjectController _projectController = ProjectController();
  final AbscisaController _abscisaController = AbscisaController();

  @override
  void initState() {
    super.initState();
    _loadDetailsProject();
  }

  /// Realiza la carga inicial de los detalles del producto en la abscisa que este en estado de in_progress
  _loadDetailsProject() async {
    loading = true;
    setState(() {});
    await _projectController.getDetailProject(id: widget.project.id, context: context);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final abscisa = context.watch<AbscisaProvider>();
    final slab = context.watch<SlabProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', 
        onPressed: () => {
          abscisa.clearAbscisa(),
          slab.clearSlabs(),
          Navigator.pop(context)
        },
        showIconButton: true,
        iconButton: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCollaborator(project: widget.project,)));
          }, 
          icon: Icon(Icons.person_add_alt_1, color: Colors.black)
        ),
      ),
      body: loading
              ? LoadingScreen()
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 50),
                              TextWidget(text: widget.project.name, fontSize: 25, fontWeight: FontWeight.w500, maxLines: 2, color: Colors.black),
                              TextWidget(text: widget.project.description, fontSize: 15, fontWeight: FontWeight.w500, maxLines: 2, color: Colors.grey[400]!),
                              SizedBox(height: 50),
                              _buildControl(),
                              _buildInformation(abscisa, slab),
                            ],
                          ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: ButtonCustom(context: context, onPressed: () async {
                        if (abscisa.abscisa != null) {
                          await _abscisaController.changeStatus(abscisa_id: abscisa.abscisa!.id , status: 'finished', context: context);
                          Navigator.pop(context);
                        }
                      }, text: 'Finalizar'),
                    )
                  ],
                ),
              ),
    );
  }

  // Control for the project
  Widget _buildControl() {
    return Row(
      spacing: 15,
      children: [
        _buildControlItem(
          title: 'Información',
          icon: Icons.info,
          onPressed: () {
            selected = 'Información';
            setState(() {});
          },
          selected: selected,
        ),
        _buildControlItem(
          title: 'Detalles',
          icon: Icons.description,
          onPressed: () {
            selected = 'Detalles';
            setState(() {});
          },
          selected: selected,
        ),
      ],
    );
  }

  // Control button item
  Widget _buildControlItem({
    required String title,
    required IconData icon,
    required Function() onPressed,
    required String selected,
  }) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 5,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selected == title ? App.primaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: selected == title ? Colors.white : Colors.black, size: 16),
              ),
              TextWidget(text: title, fontSize: 12, fontWeight: FontWeight.w600, maxLines: 2, color: Colors.grey[400]!),
            ],
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: selected == title ? App.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformation(AbscisaProvider abscisa, SlabProvider slab) {
    return selected == 'Información'
        ? _buildButtonRegisterDetails(abscisa, slab)
        : Container();
  }

  Widget _buildButtonRegisterDetails(AbscisaProvider abscisa, SlabProvider slab) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonInformation(
            icon: Icons.insert_drive_file,
            title: 'Abscisa',
            description: abscisa.abscisa != null ? 'Abscisa de ${abscisa.abscisa?.numberOfAbscisas} placas' : 'Agrega una nueva abscisa',
            onPressed: () {
              abscisa.abscisa == null
                  ? Navigator.push(context, MaterialPageRoute(builder: (context) => Abscisa(project: widget.project)))
                  : null;
            },
            object: abscisa.abscisa,
          ),
          _buildButtonInformation(
            icon: Icons.inventory_2_sharp,
            title: 'Placas',
            description: slab.countSlabs > 0 ? '${slab.countSlabs} placa registrada' : 'Agrega una nueva placa',
            onPressed: () {
              abscisa.abscisa != null && slab.countSlabs < abscisa.abscisa!.numberOfAbscisas
                ? Navigator.push(context, MaterialPageRoute(builder: (context) => Slab(abscisa: abscisa.abscisa!)))
                : null;
            },
            object: slab.countSlabs == 0 ? null : slab.slabs,
          ),
          _buildButtonInformation(
            icon: Icons.add_circle_outlined,
            title: 'Patologias',
            description: 'Edita las patologias del tramo',
            onPressed: () {
              slab.countSlabs > 0
                ? Navigator.push(context, MaterialPageRoute(builder: (context) => Pathologies()))
                : null;
            },
            object: slab.countSlabs == 0 ? null : slab.slabs,
          ),
          TextWidget(
            text: 'Servicios',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          _buildListViewButton()
        ],
      ),
    );
  }

  Widget _buildButtonInformation({
    required String title,
    required String description,
    required IconData icon,
    required Function() onPressed,
    required dynamic object,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: Row(
        spacing: 15,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: object != null ? App.primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(text: title, fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
              TextWidget(text: description, fontSize: 11, fontWeight: FontWeight.w300, color: Colors.grey[400]!),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () => onPressed(),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListViewButton() {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
            _buildButtonService(
              'Editar',
              Icon(Icons.edit, color: Colors.white, size: 20), 
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectEdit(id: widget.project.id)));
              }
            ),
            _buildButtonService(
              'Estadistica',
              Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20), 
              () {
                // Implementar la acción de editar
              }
            ),
        ]
      )
    );
  }

  Widget _buildButtonService(String title, Icon icon, Function onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(25)),
              child: icon,
            ),
            TextWidget(
                text: title,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ],
        ),
            ),
      ));
  }
}
