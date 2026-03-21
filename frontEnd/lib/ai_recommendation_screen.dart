import 'package:flutter/material.dart';

class AIRecommendationScreen extends StatelessWidget {
  final String foundationType;
  final String cementType;
  final double moisture;
  final double ec;
  final double temp;

  const AIRecommendationScreen({
    super.key,
    required this.foundationType,
    required this.cementType,
    required this.moisture,
    required this.ec,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          "AI Construction Guide",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              _buildRecommendationCard(
                title: "Recommended Foundation",
                value: foundationType,
                icon: Icons.foundation,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 15),
              _buildRecommendationCard(
                title: "Recommended Cement",
                value: cementType,
                icon: Icons.architecture,
                color: Colors.orange.shade800,
              ),
              const SizedBox(height: 30),
              _buildAIGuidanceSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.purple, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "AI Analysis Complete",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  "Based on real-time soil dynamics",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIGuidanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
             Icon(Icons.lightbulb, color: Colors.amber, size: 24),
             SizedBox(width: 10),
             Text(
              "AI Implementation Guide",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withOpacity(0.1)),
          ),
          child: Text(
            _generateAIGuide(),
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF4B5563),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  String _generateAIGuide() {
    String guide = "";

    // Foundation logic
    if (foundationType == "Piled Foundation") {
      guide += "The soil shows critical indicators of instability due to ${ec > 1000 ? "extreme salinity level ($ec)" : "saturation ($moisture%)"}. A Piled Foundation is mandatory to transfer structural loads to deeper, more stable strata, bypassing the weak surface soil.\n\n";
    } else if (foundationType == "Raft Foundation") {
      guide += "With high moisture content ($moisture%), a Raft Foundation is recommended to spread the load over the entire footprint of the structure, minimizing differential settlement and ensuring structural integrity.\n\n";
    } else if (foundationType == "Pad Foundation") {
      guide += "The current moisture level ($moisture%) is optimal for Pad Foundations. This cost-effective solution is ideal for the detected soil stability, provided columns are correctly spaced and reinforced.\n\n";
    } else {
      guide += "Excellent soil stability detected ($moisture% moisture). A Shallow Foundation is more than sufficient, allowing for significant cost savings without compromising safety.\n\n";
    }

    // Cement logic
    if (cementType.contains("SRC")) {
      guide += "Crucially, the high salinity (EC: $ec) poses a chemical threat to standard concrete. Sulfate Resisting Cement (SRC) is essential to prevent concrete degradation and internal corrosion of steel reinforcement.";
    } else if (cementType.contains("PPC")) {
      guide += "Given the elevated ground temperature ($temp°C), Portland Pozzolana Cement (PPC) is selected for its low heat of hydration, which drastically reduces the risk of thermal cracking during the curing process.";
    } else if (cementType.contains("53")) {
      guide += "OPC Grade 53 is recommended to provide high early strength, which is vital for maintaining construction speed in high-moisture conditions.";
    } else {
      guide += "Standard OPC Grade 43 is recommended. It offers a perfect balance of workability and strength for these stable environmental conditions.";
    }

    return guide;
  }
}
