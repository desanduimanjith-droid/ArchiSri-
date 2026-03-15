import 'package:flutter/material.dart';
import 'recommendation_screen.dart';

void main() {
  runApp(const ArchiSriApp());
}

class ArchiSriApp extends StatelessWidget {
  const ArchiSriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArchiSri',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: RecommendationScreen(),
    );
  }
}
