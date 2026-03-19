import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'iot_service.dart';

class SoilTestingScreen extends StatelessWidget {
  SoilTestingScreen({super.key});

  final IoTService service = IoTService();

  String _getMoistureStatus(double moisture) {
    if (moisture < 30) return "Dry";
    if (moisture < 70) return "Moderate";
    return "Optimal";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: service.getSensorData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F0E1),
            body: Center(
              child: Text(
                "Firebase Error: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final data =
            snapshot.data ??
            {
              "moisture": 0.0,
              "temperature": 0.0,
              "ec": 0.0,
              "soilDensity": 1.43,
              "ph": 6.8,
              "conductivity": 0.0,
            };

        final double moisture = (data["moisture"] as num).toDouble();
        final double ec = (data["ec"] as num).toDouble();
        final double soilDensity = (data["soilDensity"] as num).toDouble();
        final double ph = (data["ph"] as num).toDouble();
        final double conductivity = (data["conductivity"] as num).toDouble();

        final String moistureStatus = _getMoistureStatus(moisture);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F0E1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildConnectionBar(),
                  const SizedBox(height: 20),
                  _buildMoistureCard(moisture, moistureStatus),
                  const SizedBox(height: 20),
                  _buildSmallCards(ec, soilDensity),
                  const SizedBox(height: 20),
                  _buildMoistureChart(moisture),
                  const SizedBox(height: 20),
                  _buildDetailedAnalysis(ph, conductivity),
                  const SizedBox(height: 20),
                  _buildScanButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildConnectionBar() {
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 8),
                Text(
                  "Live Connection Active",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text("Device #4521", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMoistureCard(double moisture, String moistureStatus) {
    final double percentValue = (moisture / 100).clamp(0.0, 1.0);

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
              percent: percentValue,
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.grey.shade200,
              progressColor: Colors.purple,
              center: Text(
                "${moisture.toStringAsFixed(1)}%\nMoisture",
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
              child: Text(
                moistureStatus,
                style: const TextStyle(
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

  Widget _buildSmallCards(double ec, double soilDensity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _smallCard(
              icon: Icons.electrical_services,
              title: "EC Value",
              value: ec.toStringAsFixed(0),
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _smallCard(
              icon: Icons.show_chart,
              title: "Soil Density",
              value: "${soilDensity.toStringAsFixed(2)} g/cm³",
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

  Widget _buildMoistureChart(double moisture) {
    final values = [
      (moisture * 0.80).clamp(0, 100),
      (moisture * 0.65).clamp(0, 100),
      (moisture * 0.90).clamp(0, 100),
      (moisture * 0.70).clamp(0, 100),
      (moisture * 0.95).clamp(0, 100),
      (moisture * 0.60).clamp(0, 100),
      (moisture * 1.00).clamp(0, 100),
      (moisture * 0.75).clamp(0, 100),
    ];

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
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: values.map((value) {
                  final double height = (value / 100) * 110;
                  return Container(
                    width: 12,
                    height: height,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("00:00", style: TextStyle(fontSize: 12)),
                Text("12:00", style: TextStyle(fontSize: 12)),
                Text("23:59", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAnalysis(double ph, double conductivity) {
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
            Text("pH Level: ${ph.toStringAsFixed(1)}"),
            const SizedBox(height: 8),
            Text("Conductivity: ${conductivity.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            const Text("Soil Type: Clay Loam"),
            const SizedBox(height: 8),
            const Text("Compaction: Medium"),
          ],
        ),
      ),
    );
  }

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
            ),
          ),
        ),
      ),
    );
  }
}
