import 'package:flutter/material.dart';
import '../models/engineer_model.dart'; // Ensure this file has 'engineerDummyData'
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EngineerHomeScreen extends StatefulWidget {
  const EngineerHomeScreen({super.key});

  @override
  State<EngineerHomeScreen> createState() => _EngineerHomeScreenState();
}

// After ApI intergration this want to be a Stateful widget to handle the API data 
/* class _EngineerHomeScreenState extends State<EngineerHomeScreen> {
  // --- LOGIC VARIABLES ---
  final ScrollController _scrollController = ScrollController();
  List<Engineer> _engineers = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchPage(); // Fetch first 20 engineers
    
    // Listen to scrolling to load more items
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
        _fetchPage();
      }
    });
  }

  Future<void> _fetchPage() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      // Calling the service we created
      final newItems = await ApiService().fetchEngineers(page: _currentPage);
      setState(() {
        _currentPage++;
        _isLoading = false;
        if (newItems.isEmpty) {
          _hasMore = false;
        } else {
          _engineers.addAll(newItems);
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
*/

class _EngineerHomeScreenState extends State<EngineerHomeScreen> {
  late Future<List<Engineer>> _engineersFuture;
  String _searchQuery = "";
  String _selectedSpecialty = "";
  String _selectedLocation = "";

  @override
  void initState() {
    super.initState();
    // Initialize the API call once
    _engineersFuture = ApiService().fetchEngineers().catchError((_) {
      // Fallback to dummy data if API fails
      return engineerDummyData;
    });
  }

  // Filter engineers based on search and filters
  List<Engineer> _filterEngineers(List<Engineer> engineers) {
    return engineers.where((engineer) {
      final matchesSearch = _searchQuery.isEmpty ||
          engineer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          engineer.specialty
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          engineer.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesSpecialty = _selectedSpecialty.isEmpty ||
          engineer.specialty
              .toLowerCase()
              .contains(_selectedSpecialty.toLowerCase());

      final matchesLocation = _selectedLocation.isEmpty ||
          engineer.location
              .toLowerCase()
              .contains(_selectedLocation.toLowerCase());

      return matchesSearch && matchesSpecialty && matchesLocation;
    }).toList();
  }

  // Function to open the filter pop-up
  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF3F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const FilterSheet(),
    ).then((result) {
      if (result != null) {
        setState(() {
          _selectedSpecialty = result['specialty'] ?? "";
          _selectedLocation = result['location'] ?? "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // The header banner
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFCABF58), // The light green background
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDD8436), // The icon box color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.architecture, // Changed to architecture for Engineers
                    size: 90,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connect with\nEngineers",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Find verified engineering professionals",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- SEARCH BAR & FILTER BUTTON ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search engineers",
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // The Filter Icon
                GestureDetector(
                  onTap: _openFilter,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.tune, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // The engineers list count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FutureBuilder<List<Engineer>>(
                future: _engineersFuture,
                builder: (context, snapshot) {
                  final filtered = _filterEngineers(snapshot.data ?? []);
                  return Text(
                    "${filtered.length} engineers found",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Fetch engineers from API
          Expanded(
            child: FutureBuilder<List<Engineer>>(
              future: _engineersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFCABF58)));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Error: ${snapshot.error}"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _engineersFuture = ApiService().fetchEngineers().catchError((_) {
                                return engineerDummyData;
                              });
                            });
                          },
                          child: const Text("Retry"),
                        )
                      ],
                    ),
                  );
                }

                final filtered = _filterEngineers(snapshot.data ?? []);
                if (filtered.isEmpty) {
                  return const Center(child: Text("No engineers found matching your criteria."));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => EngineerCard(item: filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}

// Engineer Card Widget
class EngineerCard extends StatelessWidget {
  final Engineer item;
  const EngineerCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFFFFF3F3),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          // Pop up EngineerDetailSheet
          builder: (context) => EngineerDetailSheet(item: item),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3F3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        item.hourlyRate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFFDD8436),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: item.tags.take(2).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC5E1EB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(fontSize: 10, color: Colors.indigo),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600], size: 16),
                          Text(" ${item.rating}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16),
                          Text(" ${item.location}", style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.business_center_outlined, size: 16),
                          Text(" ${item.projects}", style: const TextStyle(fontSize: 12)),
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
}

// tag widget for the engineer details sheet
Widget _buildTag(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFC5E1EB), // Light blue from your screenshot
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.indigo.shade200),
    ),
    child: Text(
      label,
      style: const TextStyle(
          color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );
}

// The details sheet that opens when tap an engineer
class EngineerDetailSheet extends StatelessWidget {
  final Engineer item;
  const EngineerDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 80, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 16),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header with "Available" status
                  Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(item.imageUrl, width: 100, height: 100, fit: BoxFit.cover)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                                  child: const Text("Available", style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(item.specialty, style: const TextStyle(color: Color(0xFFDD8436), fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.star_outline, color: Colors.black, size: 18),
                                Text(" ${item.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(width: 12),
                                const Icon(Icons.location_on_outlined, color: Colors.black, size: 18),
                                Expanded(
                                  child: Text(" ${item.location}", style: const TextStyle(fontSize: 13)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 2. TAGS SECTION
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.tags.map((tag) => _buildTag(tag)).toList(),
                  ),

                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // 3. STATS ROW
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn("Experience", item.experience),
                        _buildStatColumn("Projects", "${item.projects}"),
                        _buildStatColumn("Rate", item.hourlyRate),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // 3.5 CONTACT INFORMATION SECTION
                  const Text(
                    "Contact Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildContactCard(
                    Icons.email_outlined,
                    "Email",
                    item.email,
                    const Color(0xFFE5D7F5),
                  ),
                  const SizedBox(height: 10),
                  _buildContactCard(
                    Icons.phone_outlined,
                    "Phone",
                    item.phone,
                    const Color(0xFFF3E7D5),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // 4. UPLOAD AI-GENERATED PLAN BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9F3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Upload AI-Generated Plan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 26),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.file_upload_outlined, size: 32, color: Colors.blue),
                              SizedBox(height: 6),
                              Text("Upload Plan File", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text("PDF, DWG, or Image files", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const TextField(
                            maxLines: 3,
                            minLines: 3,
                            decoration: InputDecoration(
                              hintText: "Describe your requirements...",
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          // 5. BOTTOM BUTTON
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color(0xFFFFF3F3),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => EngineerChatSheet(item: item),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Request Review", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // Helper for Experience/Projects/Rate
  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  // Helper for Contact Cards
  Widget _buildContactCard(IconData icon, String label, String value, Color backgroundColor) {
    return GestureDetector(
      onTap: () async {
        if (label == "Email") {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: value,
          );
          try {
            await launchUrl(emailLaunchUri);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Could not open email: $e")),
            );
          }
        } else if (label == "Phone") {
          final Uri phoneLaunchUri = Uri(
            scheme: 'tel',
            path: value,
          );
          try {
            await launchUrl(phoneLaunchUri);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Could not open phone: $e")),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Engineer Chat Screen Widget
class EngineerChatSheet extends StatelessWidget {
  final Engineer item;
  const EngineerChatSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Center(
            child: Container(
              width: 80,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(item.imageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.phone_outlined, size: 24),
              const SizedBox(width: 15),
              const Icon(Icons.videocam_outlined, size: 26),
              const SizedBox(width: 10),
              const Icon(Icons.more_vert),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.grey, thickness: 0.5),
          ),

          Expanded(
            child: ListView(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E7D5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E7D5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi! I'm ${item.name}. I've received your inquiry regarding engineering services. How can I help?",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "11:49 AM",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              top: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E7D5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E7D5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send_outlined, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Filter Sheet Widget (Same logic, but can be customized for Engineers later)
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool isVerified = false;
  bool isResidential = false; 
  bool isCommercial = false; 
  bool isIndustrial = false; 
  bool isSustainable = false; 
  bool isRestoration = false; 
  
  final List<String> _districts = [
    "Colombo", "Gampaha", "Kalutara", "Kandy", "Matale", "Nuwara Eliya",
    "Galle", "Matara", "Hambantota", "Jaffna", "Kilinochchi", "Mannar",
    "Vavuniya", "Mullaitivu", "Batticaloa", "Ampara", "Trincomalee",
    "Kurunegala", "Puttalam", "Anuradhapura", "Polonnaruwa", "Badulla",
    "Moneragala", "Ratnapura", "Kegalle",
  ];
  
  String? selectedDistrict; 
  double _currentRating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Filters",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              const Text(
                "Verified Engineers Only",
                style: TextStyle(fontSize: 15),
              ),
              Checkbox(
                value: isVerified,
                activeColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    isVerified = value ?? false;
                  });
                },
              ),
            ],
          ),

          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Engineering Specialty",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Custom engineering specialties could go here (Civil, Structural, etc.)
          _buildFilterRow("Civil Engineering", isResidential, (val) => setState(() => isResidential = val!)),
          _buildFilterRow("Structural Engineering", isCommercial, (val) => setState(() => isCommercial = val!)),
          _buildFilterRow("MEP Engineering", isIndustrial, (val) => setState(() => isIndustrial = val!)),

          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Location",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select District"),
                value: selectedDistrict,
                items: _districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Minimum Rating",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _currentRating,
            min: 0,
            max: 5,
            divisions: 5,
            label: _currentRating.toString(),
            activeColor: const Color(0xFFCABF58),
            onChanged: (v) {
              setState(() {
                _currentRating = v;
              });
            },
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Get selected specialty
              String specialty = "";
              if (isResidential) specialty = "Residential";
              else if (isCommercial) specialty = "Commercial";
              else if (isIndustrial) specialty = "Industrial";
              else if (isSustainable) specialty = "Structural Engineer";
              else if (isRestoration) specialty = "Civil Engineer";

              // Pop with filter values
              Navigator.pop(context, {
                'specialty': specialty,
                'location': selectedDistrict ?? "",
                'rating': _currentRating,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "Show Results",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(String title, bool val, Function(bool?)? onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Checkbox(
          value: val,
          activeColor: Colors.black,
          visualDensity: const VisualDensity(vertical: -4),
          onChanged: onChange,
        ),
      ],
    );
  }
}