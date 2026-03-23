import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:archisri_1/utils/marketplace_rating_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class IoTMarketplace extends StatefulWidget {
  const IoTMarketplace({super.key});

  @override
  State<IoTMarketplace> createState() => _IoTMarketplaceState();
}

class _IoTMarketplaceState extends State<IoTMarketplace> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _savedPhoneNumber = '';
  String _savedAddress = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _showPersonalDetailsDialog() async {
    _phoneController.text = _savedPhoneNumber;
    _addressController.text = _savedAddress;

    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Personal Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+94xxxxxxxxx',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your address',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_phoneController.text.trim().isEmpty ||
                  _addressController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill phone and address'),
                  ),
                );
                return;
              }

              setState(() {
                _savedPhoneNumber = _phoneController.text.trim();
                _savedAddress = _addressController.text.trim();
              });

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Personal details saved')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_savedPhoneNumber.isEmpty || _savedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add Personal Details first')),
      );
      return;
    }

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
      debugPrint("Connection Error: $e");
    }
  }

  bool _isDescriptionExpanded = false;

  // Rating State
  int _totalRatingsCount = 24;
  double _averageRating = 4.5;
  int _userRating = 0;

  void _handleRating(int rating) {
    final updated = applyMarketplaceRating(
      current: MarketplaceRatingState(
        totalRatingsCount: _totalRatingsCount,
        averageRating: _averageRating,
        userRating: _userRating,
      ),
      newRating: rating,
    );

    setState(() {
      _totalRatingsCount = updated.totalRatingsCount;
      _averageRating = updated.averageRating;
      _userRating = updated.userRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: Column(
        children: [
          // Header Section
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

          const SizedBox(height: 20),

          // Product Card
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

                    // Product Image Placeholder
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade100),
                        borderRadius: BorderRadius.circular(15),

                        color: Colors.grey.shade100,
                      ),
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

                    // rating system
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            int starValue = index + 1;
                            // Fill star if it's less than user rating OR average rating
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

                    // Description Toggle
                    GestureDetector(
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

                    // Buttons
                    OutlinedButton.icon(
                      onPressed: _showPersonalDetailsDialog,
                      icon: const Icon(Icons.person_outline),
                      label: Text(
                        _savedPhoneNumber.isEmpty
                            ? 'Personal Details'
                            : 'Personal Details Saved',
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        side: const BorderSide(color: Color(0xFFBF711D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7EB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE6C98A)),
                      ),
                      child: _savedPhoneNumber.isEmpty && _savedAddress.isEmpty
                          ? const Text(
                              'Personal details are not added yet.',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Personal Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFBF711D),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Phone: $_savedPhoneNumber',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Address: $_savedAddress',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Recommendation Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recommend Materials is coming soon!'),
                  ),
                );
              },
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
