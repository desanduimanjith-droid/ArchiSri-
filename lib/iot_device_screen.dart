import 'package:flutter/material.dart';

class IoTDeviceScreen extends StatelessWidget {
  const IoTDeviceScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Cream Background
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              "IoT Device Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18, // Smaller heading like Materials page
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFDD835), // Yellow Header
            elevation: 0,
            floating: false,
            pinned: false,
            foregroundColor: Colors.black, // Back button color
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // IMAGE
                  // ==================================================
                  Center(
                    child: Image.asset(
                      'assets/iot_device.png',
                      height: 250, // Larger image for details page
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ==================================================
                  // TITLE & PRICE
                  // ==================================================
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ArchiSri GS Pro",
                        style: TextStyle(
                          fontSize: 24, // Larger title
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "LKR 4500",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // ==================================================
                  // TAGS / RATING
                  // ==================================================
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDD835).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.settings,
                              size: 16,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "IoT Device",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Text(
                        " 4.8 (156 reviews)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Capable of mature soil moisture and saltiness of the soil. This smart device offers real-time monitoring and data analysis to help you make informed decisions about your construction site foundation.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ==================================================
                  // BUTTONS (Enlarged)
                  // ==================================================
                  Row(
                    children: [
                      Expanded(
                        child: _buildClickableButton(
                          "Buy Now",
                          const Color.fromARGB(255, 113, 41, 15),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildClickableButton(
                          "Add to Cart",
                          const Color.fromARGB(255, 113, 41, 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(vertical: 15), // Taller buttons
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16, // Larger font
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
