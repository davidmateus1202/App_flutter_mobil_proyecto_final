import 'package:diapce/Controllers/project_controller.dart';
import 'package:diapce/Screens/EditDataProject/pathologies_edit.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/loading_screen.dart';
import 'package:diapce/Widgets/not_found.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ProjectEdit extends StatefulWidget {
  const ProjectEdit({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<ProjectEdit> createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit> {

  // instancias
  final ProjectController _projectController = ProjectController();

  //variables
  List<dynamic> _abscisas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    _isLoading = true;
    setState(() {});
    final response = await _projectController.getAllAbscisas(id: widget.id);
    if (response != null) {
      // do something with the response
      _abscisas = response['data']['data'];
    } else {
      // handle error
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', onPressed: () { Navigator.pop(context);}),
      body: _isLoading 
        ? LoadingScreen(maxHeight: 200,)
        : _abscisas.isEmpty
          ? NotFound()
          : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              spacing: 10,
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildSearch(),
                ),
                _buildList()
              ],
            ),
          ),
    );
  }

    //widget search
  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Buscar abscisa',
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(onPressed: () {

            }, icon: Icon(Icons.close, color: Colors.grey)),
          ),
        ),
      )
    );
  }

  //  widget list to abscisas
  Widget _buildList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _abscisas.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                TextWidget(text: _abscisas[index]['name'], fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[800]!),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _projectController.formatStateColorAbscisa(_abscisas[index]['status']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextWidget(text: _projectController.formatStateAbscisa(_abscisas[index]['status']), fontSize: 9, fontWeight: FontWeight.w500, color: _projectController.formatStateColorTextAbscisa(_abscisas[index]['status'])),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: 20),
            collapsedShape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent)
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.car_repair_sharp, color: Colors.white, size: 20,),
            ),
            children: [
              _buildListSlab(_abscisas[index]['slabs_with_pathologies']),
            ],
          );
        },
      ),
    );
  }

  // Widget to slabs
  Widget _buildListSlab(List<dynamic> slabs) {
    return  ListView.builder(
        itemCount: slabs.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildButtonSlab(slabs[index]);
        },
    );
  }

  Widget _buildButtonSlab(dynamic slabs) {
    return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.map, color: Colors.black, size: 20,),
                          ),

                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.edit, color: Colors.black, size: 20,),
                          ),
                        ],
                      ),
                    ),
                    TextWidget(text: 'Placa - ${slabs['id']}', fontSize: 15, fontWeight: FontWeight.w500),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PathologiesEdit(pathologies: slabs['pathologies'],)));
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            )
          );
  }
}