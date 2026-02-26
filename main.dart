import 'package:flutter/material.dart';

void main() {
  runApp(const ArchisriIoTReportApp());
}

class ArchisriIoTReportApp extends StatelessWidget {
  const ArchisriIoTReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SoilTestingScreen(),
    );
  }
}

class SoilTestingScreen extends StatelessWidget {
  const SoilTestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The overall app background color (light beige)
      backgroundColor: const Color(0xFFF5F0E1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              // We will add the next components here!
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Color(0xFFD4D977), // The greenish-yellow top background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Blue App Icon Container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF64B5F6),
              borderRadius: BorderRadius.circular(20),
            ),
            // Using a standard material icon for now as a placeholder
            child: const Icon(
              Icons.water_drop_outlined,
              color: Colors.white,
              size: 50,
            ),
          ),

          // Header Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Soil Testing",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Live IoT Sensor Data",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
