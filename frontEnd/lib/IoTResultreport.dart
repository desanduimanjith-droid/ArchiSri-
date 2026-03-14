import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'iot_service.dart';

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

class SoilTestingScreen extends StatefulWidget {
  const SoilTestingScreen({super.key});

  @override
  State<SoilTestingScreen> createState() => _SoilTestingScreenState();
}

class _SoilTestingScreenState extends State<SoilTestingScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E1),
      body: SafeArea(
        child: StreamBuilder<DatabaseEvent>(
          stream: _firebaseService.getSensorDataStream(),
          builder: (context, snapshot) {
            Map<dynamic, dynamic> data = {};
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            }

            // Fallback to hardcoded values if data is missing
            final double moisture = (data['moisture'] ?? 73.4).toDouble();
            final String temperature =
                data['temperature']?.toString() ?? "22.9";
            final String density = data['density']?.toString() ?? "1.43";
            final String ph = data['ph']?.toString() ?? "6.8";
            final String phStatus = data['phStatus']?.toString() ?? "Neutral";
            final String conductivity =
                data['conductivity']?.toString() ?? "2.4";
            final String soilType = data['soilType']?.toString() ?? "Clay Loam";
            final String compaction =
                data['compaction']?.toString() ?? "Medium (Good)";
            final String deviceId = data['deviceId']?.toString() ?? "4521";
            final bool isOnline = data['isOnline'] ?? true;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildConnectionBar(isOnline, deviceId),
                  const SizedBox(height: 20),
                  _buildMoistureCard(moisture),
                  const SizedBox(height: 20),
                  _buildSmallCards(temperature, density),
                  const SizedBox(height: 20),
                  _buildMoistureChart(),
                  const SizedBox(height: 20),
                  _buildDetailedAnalysis(
                    ph,
                    phStatus,
                    conductivity,
                    soilType,
                    compaction,
                  ),
                  const SizedBox(height: 20),
                  _buildScanButton(),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // HEADER part
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Color(0xFFD4D977),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF64B5F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.water_drop_outlined,
              color: Colors.white,
              size: 50,
            ),
          ),
          const Column(
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

  //  CONNECTION BAR
  Widget _buildConnectionBar(bool isOnline, String deviceId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: isOnline ? Colors.green : Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  isOnline ? "Live Connection Active" : "Device Offline",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              "Device #$deviceId",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // MOISTURE CARD
  Widget _buildMoistureCard(double moisturePercent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Soil Moisture",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 70,
              lineWidth: 12,
              percent: (moisturePercent / 100).clamp(0.0, 1.0),
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.grey.shade200,
              progressColor: Colors.purple,
              center: Text(
                "${moisturePercent.toStringAsFixed(1)}%\nMoisture",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE9D8FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Optimal",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SMALL CARDS
  Widget _buildSmallCards(String temperature, String density) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _smallCard(
              icon: Icons.thermostat,
              title: "Temperature",
              value: "$temperature°C",
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _smallCard(
              icon: Icons.show_chart,
              title: "Soil Density",
              value: "$density g/cm³",
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  //  MOISTURE CHART
  Widget _buildMoistureChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "24-Hour Moisture Trend",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 20),

            /// BARS
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(18, (index) {
                  double height = (index % 3 == 0)
                      ? 110
                      : (index % 3 == 1)
                      ? 70
                      : 40;

                  return Container(
                    width: 6,
                    height: height,
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? const Color(0xFF3B82F6) // blue
                          : const Color(0xFFB4C34C), // green
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 15),

            /// TIME LABELS
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "00:00",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  "12:00",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  "23:59",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //  DETAILED ANALYSIS
  Widget _buildDetailedAnalysis(
    String ph,
    String phStatus,
    String conductivity,
    String soilType,
    String compaction,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detailed Analysis",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text("pH Level: $ph ($phStatus)"),
            const SizedBox(height: 8),
            Text("Conductivity: $conductivity mS/cm (Normal)"),
            const SizedBox(height: 8),
            Text("Soil Type: $soilType"),
            const SizedBox(height: 8),
            Text("Compaction: $compaction"),
          ],
        ),
      ),
    );
  }

  //  SCAN BUTTON
  Widget _buildScanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "SCAN AGAIN",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
