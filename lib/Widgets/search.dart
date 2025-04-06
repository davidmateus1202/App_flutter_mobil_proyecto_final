import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.grey[600]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w300
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            width: 40,
            height: 35,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          border: InputBorder.none,
          hintText: 'Buscar',
          hintStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w300
          )
        ),
      ),
    );
  }
}