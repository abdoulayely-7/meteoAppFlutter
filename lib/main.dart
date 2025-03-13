import 'package:examen_meteo/pages/accueil.dart';
import 'package:flutter/material.dart';
import 'package:examen_meteo/pages/Bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Météo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // Écran d'accueil
        '/Bar': (context) => const HomePage(), // Écran de progression
        // Ajoutez d'autres routes pour les écrans supplémentaires ici
      },
    );
  }
}

