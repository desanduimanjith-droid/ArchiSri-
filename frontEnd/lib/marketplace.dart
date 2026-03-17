import 'package:flutter/material.dart';

class IoTMarketplace extends StatefulWidget {
  @override
  _IoTMarketplaceState createState() => _IoTMarketplaceState();
}

class _IoTMarketplaceState extends State<IoTMarketplace> {
  int _cartCount = 0;
  bool _isDescriptionExpanded = false;
  double _avgRating = 4.8;
  int _totalReviews = 156;
  int _userRating = 0;

  void _handleRating(int rating) {
    setState(() {
      // Calculate new average for demo purposes
      _avgRating =
          ((_avgRating * _totalReviews) + rating) / (_totalReviews + 1);
      _totalReviews++;
      _userRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6C4), // Match the beige background
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom Header ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFD4C35E),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE68A45),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.shopping_cart, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Marketplace",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "IoT devices &\nrecommend materials",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- Cart Icon with Badge (Search Bar Removed) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, size: 30),
                      onPressed: () => print("Cart clicked"),
                    ),
                    if (_cartCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$_cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // --- Product Card ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IoT Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C98A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.settings, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "IoT Device",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Product Image PlaceHolder
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.shade100),
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/iot.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Title and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ArchiSri GS Pro",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Price: LKR 4500",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Text(
                        "Capable of mature soil moisture and saltiness.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      // --- Interactive Star Rating ---
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () => _handleRating(index + 1),
                                child: Icon(
                                  index <
                                          (_userRating > 0
                                              ? _userRating
                                              : _avgRating.round())
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${_avgRating.toStringAsFixed(1)} ($_totalReviews)",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // --- See Description Toggle ---
                      GestureDetector(
                        onTap: () => setState(
                          () =>
                              _isDescriptionExpanded = !_isDescriptionExpanded,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              "SEE DESCRIPTION",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              _isDescriptionExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.blue,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      if (_isDescriptionExpanded)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: const Text(
                            "This module uses Internet of Things (IoT) sensors to monitor and analyze land conditions in real time."
                            " It integrates multiple sensors, including soil moisture sensors, electrical conductivity (EC) sensors for measuring soil salinity, and sensors to track pore pressure and moisture levels. "
                            "By collecting and analyzing this data, the system can detect potential environmental risks such as coastal corrosion, landslide-prone areas, and weak soil conditions."
                            " This helps in early warning, better land management, and informed decision-making for construction and agriculture.",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black54,
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),
                      // --- Buttons ---
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBF711D),
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => setState(() => _cartCount++),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD48F4E),
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Bottom Recommendation Bar ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.build, color: Colors.black87),
                label: const Text(
                  "Recommend Materials",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4C35E),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
