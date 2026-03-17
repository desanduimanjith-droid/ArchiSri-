import 'package:flutter/material.dart';

class MaterialsScreen extends StatelessWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              "Recommended Materials",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18, // Smaller heading
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFDD835),
            elevation: 0,
            floating: false,
            pinned: false,
            foregroundColor: Colors.black,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ==================================================
                  // BANNER
                  // ==================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6CCB2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A373),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.assignment_turned_in,
                                color: Colors.black87,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Based on Your Soil Report",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "These products are recommended for Clay Loam soil with high moisture content",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ==================================================
                  // MATERIAL CARDS
                  // ==================================================

                  // Card 1: OPC Cement
                  _buildDetailedMaterialCard(
                    title: "OPC 43 Premium Cement",
                    price: "LKR 4500",
                    description:
                        "Capable of mature soil moisture and saltiness of the soil.",
                    imagePath: 'assets/opc_cement.png',
                    tag: "IoT recommend",
                    address: "No.43 row road, Piliyandala",
                    phone: "0777345768",
                    company: "Tokyo supermix (Pvt) Ltd",
                  ),
                  const SizedBox(height: 25),

                  // Card 2: Sulfate Cement
                  _buildDetailedMaterialCard(
                    title: "Sulfate-Resistant Cement (Type V)",
                    price: "LKR 5000",
                    description:
                        "It is highly effective in marine environments and in contact with sulfate-rich soils.",
                    imagePath: 'assets/sulfate_cement.png',
                    tag: "IoT recommend",
                    address: "No.43 row road, Piliyandala",
                    phone: "0767561234",
                    company: "Tokyo supermix (Pvt) Ltd",
                  ),
                  const SizedBox(height: 25),

                  // Card 3: Raft Foundation
                  _buildDetailedMaterialCard(
                    title: "Raft Foundation",
                    price: "",
                    description:
                        "Your land soil is too weak and contains more water in soil. According to the plan house should be heavy.",
                    imagePath: 'assets/raft_foundation.png',
                    tag: "IoT recommend",
                    isViewDetails: true,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Material Card
  Widget _buildDetailedMaterialCard({
    required String title,
    required String price,
    required String description,
    required String imagePath,
    required String tag,
    String? address,
    String? phone,
    String? company,
    bool isViewDetails = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD87D4A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          isViewDetails
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE68A45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "View details",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Price: $price",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
          if (!isViewDetails) ...[
            const SizedBox(height: 10),
            const Divider(thickness: 0.5),
            const SizedBox(height: 5),
            _buildContactRow(Icons.location_on_outlined, address!),
            const SizedBox(height: 5),
            _buildContactRow(Icons.phone_in_talk_outlined, phone!),
            const SizedBox(height: 5),
            _buildContactRow(Icons.home_work_outlined, company!),
          ],
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
