import 'package:flutter/material.dart';
import 'screens/engineer_screen.dart'; // This must match your file name

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
      // Update this line to match the class name in engineer_screen.dart
      home: const EngineerHomeScreen(), 
    );
  }
}