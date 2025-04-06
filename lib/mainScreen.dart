// ignore: file_names
import 'package:diapce/Screens/home.dart';
import 'package:diapce/Screens/profile.dart';
import 'package:diapce/Screens/project.dart';
import 'package:diapce/Theme/app.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: Center(
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            Home(),
            Project(),
            Profile(),
          ],
        )
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, color: App.primaryColor),
          activeIcon: Icon(Icons.home_filled, color: App.secondaryColor),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: App.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
          activeIcon: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: App.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: Icon(Icons.add, color: App.secondaryColor),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_sharp, color: App.primaryColor),
          activeIcon: Icon(Icons.person_2_sharp, color: App.secondaryColor),
          label: '',
        ),
      ],
    );
  }
}