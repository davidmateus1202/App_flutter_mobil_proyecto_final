import 'package:diapce/Controllers/pathologies_controller.dart';
import 'package:diapce/Models/slab_model.dart';
import 'package:diapce/Providers/pathologies_provider.dart';
import 'package:diapce/Providers/slab_provider.dart';
import 'package:diapce/Screens/GoogleMaps/google_maps_screen.dart';
import 'package:diapce/Theme/app.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectSlabs extends StatefulWidget {
  const ProjectSlabs({super.key});

  @override
  State<ProjectSlabs> createState() => _ProjectSlabsState();
}

class _ProjectSlabsState extends State<ProjectSlabs> {

  // instancias
  final PathologiesController _pathologiesController = PathologiesController();

  _saveSlab(SlabModel slab) {
    final slabs = Provider.of<SlabProvider>(context, listen: false);
    final pathologyProvider = context.read<PathologiesProvider>();
    pathologyProvider.setDataPathologies('slab_id', slab.id);
    slabs.selectSlab(slab);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final slabs = Provider.of<SlabProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', onPressed: () => Navigator.pop(context), color: Colors.white),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 16),
          child: _buildSlab(slabs.slabs),
        ),
    );
  }

  // Widget slab
  Widget _buildSlab(List<SlabModel> slabs) {
  return ListView.builder(
    itemCount: slabs.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () { _saveSlab(slabs[index]); },
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(text: 'Placa - ${slabs[index].id}', fontSize: 16, fontWeight: FontWeight.w500),
                    TextWidget(
                      text: 'Area: ${_pathologiesController.calculedArea(long: slabs[index].long, width: slabs[index].width)} m2',
                      fontSize: 12,
                      color: Colors.grey[600]!,
                    )
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoogleMapsScreen(
                      latitude: double.tryParse(slabs[index].latitude.toString()) ?? 0.0,
                      longitude: double.tryParse(slabs[index].longitude.toString()) ?? 0.0,
                      id: slabs[index].id,
                    ),
                  ),
                ),
                child: Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: App.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Icon(Icons.map, color: Colors.white, size: 20),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

}