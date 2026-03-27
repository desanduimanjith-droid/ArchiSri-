import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'iot_service.dart';
import 'ai_recommendation_screen.dart';

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
  Map<String, dynamic>? _baselineData;
  Map<String, dynamic>? _lastLiveData;
  bool _dataChanged = false;

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
      // Only reset baseline if we haven't established a connection yet
      if (!_dataChanged) {
        _baselineData = null;
      }
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
      initialData: const {
        "moisture": 0.0,
        "rawMoisture": 0.0,
        "temperature": 0.0,
        "ec": 0.0,
        "soilDensity": 1.43,
        "ph": 6.8,
        "conductivity": 0.0,
      },
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData &&
            !_timedOut) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F0E1),
            appBar: AppBar(
              backgroundColor: const Color(0xFFD4D977),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text("Soil Testing",
                  style: TextStyle(color: Colors.black)),
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
              title: const Text("Soil Testing",
                  style: TextStyle(color: Colors.black)),
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

        final rawData = snapshot.data;
        if (!_dataChanged &&
            rawData != null &&
            snapshot.connectionState == ConnectionState.active) {
          if (_baselineData == null) {
            _baselineData = rawData;
          } else {
            if (rawData["moisture"] != _baselineData!["moisture"] ||
                rawData["ec"] != _baselineData!["ec"]) {
              _dataChanged = true;
            }
          }
        }

        final bool isZeroData = rawData == null ||
            (rawData["moisture"] == 0.0 && rawData["ec"] == 0.0);

        if (_dataChanged && !isZeroData) {
          _lastLiveData = rawData;
        }

        final data = _dataChanged
            ? (!isZeroData
                ? rawData
                : (_lastLiveData ??
                    rawData ??
                    {
                      "moisture": 0.0,
                      "rawMoisture": 0.0,
                      "temperature": 0.0,
                      "ec": 0.0,
                      "soilDensity": 1.43,
                      "ph": 6.8,
                      "conductivity": 0.0,
                    }))
            : {
                "moisture": 0.0,
                "rawMoisture": 0.0,
                "temperature": 0.0,
                "ec": 0.0,
                "soilDensity": 1.43,
                "ph": 6.8,
                "conductivity": 0.0,
              };

        final double moisture = (data["moisture"] as num).toDouble();
        final double rawMoisture = (data["rawMoisture"] as num).toDouble();
        final double ec = (data["ec"] as num).toDouble();
        final double temperature = ec == 0 ? 0.0 : ec - 198;
        final double ph = (data["ph"] as num).toDouble();
        final String moistureStatus = _getMoistureStatus(moisture);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F0E1),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(moisture),
                const SizedBox(height: 20),
                _buildConnectionBar(moisture, ec, temperature),
                const SizedBox(height: 20),
                _buildMoistureCard(moisture, rawMoisture, moistureStatus),
                const SizedBox(height: 20),
                _buildSmallCards(temperature, ec),
                const SizedBox(height: 20),
                _buildScanAndRecommendations(moisture, ec, temperature),
                const SizedBox(height: 20),
                _buildDetailedAnalysis(ph, ec, moisture),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  // HEADER part
  Widget _buildHeader(double moisture) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8BC34A), Color(0xFFDCE775), Color(0xFFFFF176)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(44),
          bottomRight: Radius.circular(44),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8BC34A).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(44),
          bottomRight: Radius.circular(44),
        ),
        child: Stack(
          children: [
            // Decorative Blobs for Mesh Gradient Effect
            Positioned(
              top: -30,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE9F0C0).withValues(alpha: 0.3),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Actual Content
            Padding(
              padding: EdgeInsets.fromLTRB(24, statusBarHeight + 10, 24, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.black, size: 24),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF64B5F6).withValues(alpha: 0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.water_drop_outlined,
                          color: Colors.white,
                          size: 55,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Soil Testing",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.waves_rounded,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 5),
                              Text(
                                "LIVE: ${moisture.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  CONNECTION BAR
  Widget _buildConnectionBar(double moisture, double ec, double temp) {
    final bool isNotConnected = moisture == 0 && ec == 0 && temp == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isNotConnected ? Colors.red.shade100 : Colors.green.shade100,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.circle,
                        color: (isNotConnected ? Colors.red : Colors.green)
                            .withValues(alpha: 0.2),
                        size: 16),
                    Icon(Icons.circle,
                        color: isNotConnected ? Colors.red : Colors.green,
                        size: 10),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isNotConnected
                          ? "IOT NOT CONNECTED"
                          : "LIVE CONNECTION ACTIVE",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: isNotConnected ? Colors.red : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Updated: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "IoT Device",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MOISTURE CARD
  Widget _buildMoistureCard(
      double moisture, double rawMoisture, String moistureStatus) {
    final double percentValue = (moisture / 100).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Soil Moisture",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.water_drop, color: Colors.blue, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 25),
            CircularPercentIndicator(
              radius: 80,
              lineWidth: 16,
              percent: percentValue,
              animation: true,
              animationDuration: 1200,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.grey.shade100,
              progressColor: Colors.purple,
              center: _isScanning
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${moisture.toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Raw: ${rawMoisture.toInt()}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE9D8FD), Color(0xFFD6BCFA)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                moistureStatus.toUpperCase(),
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1.2,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          left: BorderSide(color: color.withValues(alpha: 0.5), width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: color.withValues(alpha: 0.7),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }


  //  DETAILED ANALYSIS
  Widget _buildDetailedAnalysis(double ph, double ec, double moisture) {
    String condStatus = (ec < 200)
        ? "Low"
        : (ec < 800)
            ? "Normal"
            : "High (Saline)";
    String soilType = (moisture > 70)
        ? "Marshy / Saturated"
        : (moisture > 35)
            ? "Clay Loam"
            : "Sandy / Granular";
    String compaction = (moisture > 60)
        ? "Soft / Low"
        : (moisture > 30)
            ? "Medium (Optimal)"
            : "Hard / Compacted";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined,
                    color: Colors.blueGrey, size: 20),
                const SizedBox(width: 10),
                const Text(
                  "Soil Professional Analysis",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            _analysisRow(
                "pH Level",
                "${ph.toStringAsFixed(2)} (${ph < 6.5 ? "Slightly Acidic" : (ph < 7.5 ? "Neutral" : "Alkaline")})",
                Icons.science_outlined),
            _analysisRow(
                "Conductivity",
                "${ec.toStringAsFixed(1)} µS/cm ($condStatus)",
                Icons.electric_bolt_outlined),
            _analysisRow("Soil Type", soilType, Icons.terrain_outlined),
            _analysisRow("Compaction", compaction, Icons.compress_outlined),
          ],
        ),
      ),
    );
  }

  Widget _analysisRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String _getFoundationType(double moisture, double ec) {
    if (moisture > 70 || ec > 1000) return "Piled Foundation";
    if (moisture > 50) return "Raft Foundation";
    if (moisture > 30) return "Pad Foundation";
    return "Shallow Foundation";
  }

  String _getCementType(double moisture, double ec, double temp) {
    if (ec > 800) return "SRC (Salt Resisting)";
    if (temp > 35) return "PPC (Heat Resisting)";
    if (moisture > 60) return "OPC 53";
    return "OPC 43";
  }

  //  SCAN BUTTON AND RECOMMENDATIONS
  Widget _buildScanAndRecommendations(double moisture, double ec, double temp) {
    final String foundation = _getFoundationType(moisture, ec);
    final String cement = _getCementType(moisture, ec, temp);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Scan Button on the left
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _isScanning ? null : _scanAgain,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: _isScanning
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.purple,
                          ),
                        )
                      : const Icon(Icons.refresh_rounded,
                          size: 30, color: Colors.purple),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // AI Recommendations Button on the right
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 4,
              shadowColor: const Color(0xFFD81B60).withValues(alpha: 0.4),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AIRecommendationScreen(
                        foundationType: foundation,
                        cementType: cement,
                        moisture: moisture,
                        ec: ec,
                        temp: temp,
                      ),
                    ),
                  );
                },
                child: Ink(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E24AA), Color(0xFFD81B60)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      SizedBox(width: 12),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "AI RECOMMENDATION",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
