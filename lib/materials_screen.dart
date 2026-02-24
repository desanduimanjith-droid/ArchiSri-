import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'widgets/material_card.dart';

class MaterialsScreen extends StatelessWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
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
            backgroundColor: AppColors.primaryYellow,
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
                      color: AppColors.lightBrown,
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
                            color: AppColors.mediumBrown,
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
                  MaterialCard(
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
                  MaterialCard(
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
                  MaterialCard(
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
}
