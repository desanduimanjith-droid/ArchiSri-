import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'iot_service.dart';

class SoilTestingScreen extends StatefulWidget {
  const SoilTestingScreen({super.key});

  @override
  State<SoilTestingScreen> createState() => _SoilTestingScreenState();
}

class _SoilTestingScreenState extends State<SoilTestingScreen> {
  final IoTService service = IoTService();
  bool _timedOut = false;
  bool _isScanning = false;
  late Stream<Map<String, dynamic>> _sensorStream;

  @override
  void initState() {
    super.initState();
    _sensorStream = service.getSensorData();
    _startTimeout();
  }

  void _startTimeout() {
    _timedOut = false;
    // Timeout after 10 seconds if no data arrives
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _timedOut = true;
        });
      }
    });
  }

  void _scanAgain() {
    setState(() {
      _isScanning = true;
      _sensorStream = service.getSensorData();
    });
    // Restart timeout timer
    _startTimeout();
    // Simulate scan duration for UX
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  String _getMoistureStatus(double moisture) {
    if (moisture < 20) return "Dry";
    if (moisture < 40) return "Low Moisture";
    if (moisture < 60) return "Moderate";
    if (moisture < 80) return "Optimal";
    return "Saturated";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _sensorStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !_timedOut) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F0E1),
            appBar: AppBar(
              backgroundColor: const Color(0xFFD4D977),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text("Soil Testing", style: TextStyle(color: Colors.black)),
              elevation: 0,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (_timedOut && !snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F0E1),
            appBar: AppBar(
              backgroundColor: const Color(0xFFD4D977),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text("Soil Testing", style: TextStyle(color: Colors.black)),
              elevation: 0,
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Could not connect to IoT sensor.\nPlease check your internet connection and Firebase setup.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        }

        final data = snapshot.data ??
            {
              "moisture": 0.0,
              "temperature": 0.0,
              "ec": 0.0,
              "soilDensity": 1.43,
              "ph": 6.8,
              "conductivity": 0.0,
            };

        final double moisture = (data["moisture"] as num).toDouble();
        final double rawMoisture = (data["rawMoisture"] as num).toDouble();
        final double ec = (data["ec"] as num).toDouble();
        // Custom calculation for temperature: ec - 198
        final double calculatedTemp = ec - 198;
        final double ph = (data["ph"] as num).toDouble();

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
                  _buildMoistureCard(moisture, rawMoisture, moistureStatus),
                  const SizedBox(height: 20),
                  _buildSmallCards(calculatedTemp, ec),
                  const SizedBox(height: 20),
                  _buildMoistureChart(),
                  const SizedBox(height: 20),
                  _buildScanAndRecommendations(moisture),
                  const SizedBox(height: 20),
                  _buildDetailedAnalysis(ph, ec),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
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
        ],
      ),
    );
  }

  //  CONNECTION BAR 
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 12),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Live Connection Active",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Last updated: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
            const Text("Device #4521", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // MOISTURE CARD 
  Widget _buildMoistureCard(double moisture, double rawMoisture, String moistureStatus) {
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
              center: _isScanning
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${moisture.toStringAsFixed(1)}%",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          "(${rawMoisture.toInt()})",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
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

  // SMALL CARDS 
  Widget _buildSmallCards(double temp, double ec) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _smallCard(
              icon: Icons.thermostat,
              title: "Temperature",
              value: "${temp.toStringAsFixed(1)}°C",
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _smallCard(
              icon: Icons.bolt,
              title: "EC Value",
              value: "${ec.toInt()} µS/cm",
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
  Widget _buildDetailedAnalysis(double ph, double ec) {
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
            Text("pH Level: ${ph.toStringAsFixed(1)} (Neutral)"),
            const SizedBox(height: 8),
            Text("Conductivity: ${ec.toStringAsFixed(1)} mS/cm (Normal)"),
            const SizedBox(height: 8),
            const Text("Soil Type: Clay Loam"),
            const SizedBox(height: 8),
            const Text("Compaction: Medium (Good)"),
          ],
        ),
      ),
    );
  }

  String _getFoundationType(double moisture) {
    if (moisture > 70) return "Raft Foundation";
    if (moisture > 50) return "Pad Foundation";
    if (moisture > 30) return "Strip Foundation";
    return "Shallow Foundation";
  }

  String _getCementType(double moisture) {
    if (moisture > 70) return "SRC / PPC";
    if (moisture > 50) return "OPC 53";
    return "OPC 43";
  }

  //  SCAN BUTTON AND RECOMMENDATIONS
  Widget _buildScanAndRecommendations(double moisture) {
    final String foundation = _getFoundationType(moisture);
    final String cement = _getCementType(moisture);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              // Scan Button on the left
              Expanded(
                flex: 2,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _isScanning ? null : _scanAgain,
                    child: _isScanning
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "SCAN AGAIN",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Recommendations on the right
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _recommendationRow(
                      label: "Foundation",
                      value: foundation,
                      icon: Icons.foundation,
                    ),
                    const SizedBox(height: 8),
                    _recommendationRow(
                      label: "Cement",
                      value: cement,
                      icon: Icons.architecture,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recommendationRow({required String label, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
