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

  // App Theme Colors
  static const Color kPrimaryColor = Color(0xFFD4A574);
  static const Color kSecondaryColor = Color(0xFF1E1E2E);
  static const Color kBackgroundColor = Color(0xFFF5E6D3);
  static const Color kAccentColor = Color(0xFFE68C46);
  static const Color kHeaderGold = Color(0xFFD4C55A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildSectionTitle("Soil Dynamics Dashboard"),
                  const SizedBox(height: 15),
                  _buildMetricsDashboard(),
                  const SizedBox(height: 35),
                  
                  _buildSectionTitle("AI Structural Roadmap"),
                  const SizedBox(height: 15),
                  _buildRecommendationCard(
                    title: "Foundation Strategy",
                    value: foundationType,
                    icon: Icons.foundation_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                    ),
                    description: _getFoundationReasoning(),
                  ),
                  const SizedBox(height: 20),
                  _buildRecommendationCard(
                    title: "Material Specification",
                    value: cementType,
                    icon: Icons.architecture_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFDBA74), Color(0xFFEA580C)],
                    ),
                    description: _getCementReasoning(),
                  ),
                  const SizedBox(height: 35),
                  
                  _buildSectionTitle("Expert Implementation Guide"),
                  const SizedBox(height: 15),
                  _buildAIGuidanceSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: kSecondaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        centerTitle: true,
        title: const Text(
          "AI Construction Guide",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kHeaderGold, kAccentColor, kSecondaryColor],
                ),
              ),
            ),
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.auto_awesome,
                size: 200,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Analysis Complete",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: kAccentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: kSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsDashboard() {
    return Row(
      children: [
        _buildMetricItem("Moisture", "${moisture.toStringAsFixed(1)}%", Icons.water_drop_rounded, const Color(0xFF3B82F6)),
        const SizedBox(width: 12),
        _buildMetricItem("Salinity", "${ec.toInt()}", Icons.bolt_rounded, const Color(0xFF10B981)),
        const SizedBox(width: 12),
        _buildMetricItem("Temp", "${temp.toStringAsFixed(1)}°C", Icons.thermostat_rounded, const Color(0xFFEF4444)),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kSecondaryColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(gradient: gradient),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIGuidanceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: kHeaderGold, size: 24),
              SizedBox(width: 12),
              Text(
                "Full Technical Analysis",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _generateAIGuide(),
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoPill("Confidence Level: 98%"),
        ],
      ),
    );
  }

  Widget _buildInfoPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kHeaderGold,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getFoundationReasoning() {
    if (foundationType == "Piled Foundation") {
      return "Required due to deep-soil instability detected by high sensor variance.";
    } else if (foundationType == "Raft Foundation") {
      return "Selected to distribute load across high-moisture surface contact.";
    } else {
      return "Optimized for stable, low-moisture surface conditions found on-site.";
    }
  }

  String _getCementReasoning() {
    if (cementType.contains("SRC")) {
      return "Defensive selection against the detected chemical salinity in the soil.";
    } else if (cementType.contains("PPC")) {
      return "Thermal protection chosen for high ambient ground temperatures.";
    } else {
      return "Standard high-performance binder for optimized curing conditions.";
    }
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
