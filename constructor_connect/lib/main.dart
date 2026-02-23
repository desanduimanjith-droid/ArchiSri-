import 'package:flutter/material.dart';
import 'screens/constructor_screen.dart';

void main() => runApp(const ArchieSriApp());

class ArchieSriApp extends StatelessWidget {
  const ArchieSriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4EBD7), // Default cream color for bg
        fontFamily: 'Roboto', // Default text font
      ),
      home: const HomeScreen(),
    );
  }
}
