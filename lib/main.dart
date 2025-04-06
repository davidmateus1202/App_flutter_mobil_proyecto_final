import 'package:diapce/Providers/abscisa_provider.dart';
import 'package:diapce/Providers/auth_provider.dart';
import 'package:diapce/Providers/pathologies_provider.dart';
import 'package:diapce/Providers/slab_provider.dart';
import 'package:diapce/Screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/project_provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ChangeNotifierProvider(create: (_) => AbscisaProvider()),
      ChangeNotifierProvider(create: (_) => SlabProvider()),
      ChangeNotifierProvider(create: (_) => PathologiesProvider()),
      
    ], child: const MyApp(),)
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}