import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controllers/geolocator_service.dart';
import '../../Providers/auth_provider.dart';
import '../../mainScreen.dart';
import '../Auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // instance
  final GeolocatorService _geolocator = GeolocatorService();


  @override
  void initState() {
    super.initState();
     _verifyToken();
    _currentGeolocation();
  }

  _currentGeolocation() async {
    await _geolocator.determinePosition();
  }

  _verifyToken() async {
    final authProvaider = Provider.of<AuthProvider>(context, listen: false);
    final response = await authProvaider.validToken();
    if (response['success'] == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Mainscreen()), (_) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset('assets/images/icon11.png', width: 150),
        ),
      )
    );
  }
}