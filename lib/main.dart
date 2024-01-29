import 'package:flutter/material.dart';
import 'package:manja_app/view/screen/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MANJA APPS',
      theme: ThemeData(
        primaryColor: const Color(0xFF87C4FF),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF87C4FF), // Warna utama
        ),
      ),
      home: const LandingPage(),
    );
  }
}
