import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diapce/Controllers/pathologies_controller.dart';
import 'package:diapce/Providers/pathologies_provider.dart';
import 'package:diapce/Screens/Pathologies/show_dialog_pathology.dart';
import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:diapce/Widgets/loading_screen.dart';
import 'package:diapce/Widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPathologies extends StatefulWidget {
  const SearchPathologies({super.key});

  @override
  State<SearchPathologies> createState() => _SearchPathologiesState();
}

class _SearchPathologiesState extends State<SearchPathologies> {

  // instancias
  final PathologiesController _pathologiesController = PathologiesController();
  final TextEditingController _searchController = TextEditingController();

  // variables
  List<dynamic> pathologies = [];
  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    isLoading = true;
    setState(() {});
    final response = await _pathologiesController.loadConcepts();
    if (response != null) {
        pathologies = response;
    } else {
      pathologies = [];
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pathologyProvider = context.watch<PathologiesProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', onPressed: () => Navigator.pop(context), color: Colors.white),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15,
              children: [
                TextWidget(text: 'Patologias en pavimentos', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                _buildSearch(),
                isLoading
                    ? LoadingScreen(maxHeight: 400)
                    : _buildList(pathologyProvider) 
                    
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
        controller: _searchController,
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            if (value.isNotEmpty) {
              pathologies = pathologies.where((pathology) {
                return pathology['name'].toLowerCase().contains(value.toLowerCase()) ||
                       pathology['description'].toLowerCase().contains(value.toLowerCase());
              }).toList();
            } else {
              _loadData();
            }
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Buscar patologia',
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(onPressed: () {
              _searchController.clear();
              _loadData();
            }, icon: Icon(Icons.close, color: Colors.grey)),
          ),
        ),
      )
    );
  }

  // Widget list
  Widget _buildList(PathologiesProvider pathologyProvider) {
    return pathologies.isNotEmpty
        ? Expanded(
          child: ListView.builder(
              itemCount: pathologies.length,
              itemBuilder: (context, index) {
                return _buildItem(pathologies[index], pathologyProvider);
              },
            ),
        )
        : _buildNotFound();
  }

  //Widget Item
  Widget _buildItem(dynamic pathology, PathologiesProvider pathologyProvider) {
    return GestureDetector(
      onTap: () {
        pathologyProvider.setDataPathologies('name', pathology['name']);
        Navigator.pop(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 400,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: pathology['url_image'],
                width: MediaQuery.of(context).size.width,
                height: 300,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: Colors.grey[300]),
                ),
                errorWidget: (context, url, error) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
      
            // Burbuja superior
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  dialogBuilderPathology(context, pathology['url_image']);
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.expand_rounded,
                      color: Colors.black, size: 20),
                ),
              ),
            ),
      
            // Información del texto
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    TextWidget(
                      text: pathology['name'],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      maxLines: 2,
                    ),
                    TextWidget(
                      text: pathology['description'],
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[800]!,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget not found
  Widget _buildNotFound() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 400,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.search_off, color: Colors.black, size: 30),
          ),
          TextWidget(text: 'No se encontraron resultados relacionados!', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]!, maxLines: 2,)        ],
      ),
    );
  }
}