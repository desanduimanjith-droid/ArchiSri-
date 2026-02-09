import 'package:flutter/material.dart';
import 'iot_device_screen.dart';
import 'materials_screen.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Cream Background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==================================================
            // 1. HEADER SECTION
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFFFDD835), // Yellow Header
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 150, 5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      size: 60,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Marketplace",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "IoT devices & recommend materials",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // ==================================================
                  // 2. SEARCH BAR & CART ICON
                  // ==================================================
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search Products..",
                            prefixIcon: const Icon(
                              Icons.menu,
                              color: Colors.grey,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.3),
                        child: InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // ==================================================
                  // 3. IOT DEVICE CARD (Clickable to New Page)
                  // ==================================================
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IoTDeviceScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
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
                          // Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDD835).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
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
                          const SizedBox(height: 15),

                          // Image
                          Center(
                            child: Image.asset(
                              'assets/iot_device.png',
                              height: 160,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 160,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "ArchiSri GS Pro",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // ==================================================
                  // 4. RECOMMEND MATERIALS BUTTON (Clickable to New Page)
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MaterialsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A373),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.construction, color: Colors.black87),
                          SizedBox(width: 10),
                          Text(
                            "Recommend Materials",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
