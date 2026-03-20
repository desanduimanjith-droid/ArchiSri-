import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class IoTMarketplace extends StatefulWidget {
  const IoTMarketplace({super.key});

  @override
  State<IoTMarketplace> createState() => _IoTMarketplaceState();
}

class _IoTMarketplaceState extends State<IoTMarketplace> {
  Future<void> _processPayment() async {
    final String serverUrl = "http://192.168.1.21:5001/create-checkout";
    try {
      final response = await http.post(Uri.parse(serverUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = Uri.parse(data['url']);

        // This opens the Stripe payment page in the browser
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }

  int _cartCount = 0;
  bool _isDescriptionExpanded = false;

  // Rating State
  int _totalRatingsCount = 24;
  double _averageRating = 4.5;
  int _userRating = 0;

  void _handleRating(int rating) {
    setState(() {
      if (_userRating == 0) {
        // First time rating
        _averageRating =
            ((_averageRating * _totalRatingsCount) + rating) /
            (_totalRatingsCount + 1);
        _totalRatingsCount++;
      } else {
        // Updating existing rating
        _averageRating =
            ((_averageRating * _totalRatingsCount) - _userRating + rating) /
            _totalRatingsCount;
      }
      _userRating = rating;
      _averageRating = _averageRating.clamp(1.0, 5.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: Column(
        children: [
          // UI Header Section for ArchiSri Marketplace
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 40,
              top: 60,
              right: 40,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFD4C55A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE68C46),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Marketplace",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "IoT devices & recommended materials",
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Cart Icon Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: [
                  // Trigger cart view overlay or navigation
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
                          minWidth: 18,
                          minHeight: 18,
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

          // UI COmponent for displaying product Card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // UI Badge for identifying IoT enabled materials
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      //Custom background styling with specific color and borders
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6C98A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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

                    // UI Placeholder for displaying Architectural Product Image
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade100),
                        borderRadius: BorderRadius.circular(15),

                        color: Colors.grey.shade100,
                      ),
                      //Loading the local image asset for architectural product
                      child: Image.asset(
                        'assets/images/iot.png',
                        fit: BoxFit.fill,
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
                          "LKR 4500",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBF711D),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Capable of mature soil moisture and saltiness.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    // Interactive product rating system using star icons and user feedback
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            int starValue = index + 1;
                            // Dynamic logic to determine star fill state based on user input or average rating
                            bool isFilled =
                                starValue <=
                                (_userRating != 0
                                    ? _userRating
                                    : _averageRating.round());
                            return GestureDetector(
                              onTap: () => _handleRating(starValue),
                              child: Icon(
                                isFilled ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 24,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${_averageRating.toStringAsFixed(1)} ($_totalRatingsCount reviews)",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Logical toggle to expland or collaps the product description view
                    GestureDetector(
                      //Update the UI state reflect description expansion state
                      onTap: () => setState(
                        () => _isDescriptionExpanded = !_isDescriptionExpanded,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "SEE DESCRIPTION",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                          "This module uses IoT sensors to monitor and analyze land conditions in real time. It detects environmental risks such as coastal corrosion and weak soil conditions.",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Market place action buttons purchasing and cart management
                    ElevatedButton(
                      onPressed: _processPayment,

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

          // Primary action button to trigger recommendation engine
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
    );
  }
}
