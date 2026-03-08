import 'package:flutter/material.dart';

class connection_Engineer extends StatelessWidget {
  const connection_Engineer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE4D0),
      appBar: AppBar(
        title: const Text(
          "Connection with Engineers",
          style: TextStyle(fontFamily: 'Serif', color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text(
          "Welcome to the Engineer Platform!",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
