import 'package:flutter/material.dart';
import '../models/engineer_model.dart'; // Ensure this file has 'engineerDummyData'
import '../services/api_service.dart';
import '../services/whatsapp_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class EngineerHomeScreen extends StatefulWidget {
  const EngineerHomeScreen({super.key});

  @override
  State<EngineerHomeScreen> createState() => _EngineerHomeScreenState();
}


class _EngineerHomeScreenState extends State<EngineerHomeScreen> {
  late Future<List<Engineer>> _engineersFuture;
  String _searchQuery = "";
  List<String> _selectedSpecialties = [];
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

        final matchesSpecialty = _selectedSpecialties.isEmpty ||
          _selectedSpecialties.any((specialty) => engineer.specialty
            .toLowerCase()
            .contains(specialty.toLowerCase()));

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
          final specialties = result['specialties'];
          _selectedSpecialties = specialties is List<String> ? specialties : [];
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
class EngineerDetailSheet extends StatefulWidget {
  final Engineer item;
  const EngineerDetailSheet({super.key, required this.item});

  @override
  State<EngineerDetailSheet> createState() => _EngineerDetailSheetState();
}

class _EngineerDetailSheetState extends State<EngineerDetailSheet> {
  Future<void> _connectWhatsApp() async {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);

    final success = await WhatsAppHelper.contactEngineer(
      engineerName: widget.item.name,
      engineerPhone: widget.item.phone,
      projectDetails: 'Hi, I found your profile on Engineer Connect and would like to discuss a project.',
    );

    if (!success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp. Please make sure WhatsApp is installed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 80, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 16),
            
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Header with "Available" status
                Row(
                  children: [
                      ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(widget.item.imageUrl, width: 100, height: 100, fit: BoxFit.cover)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(widget.item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                            Text(widget.item.specialty, style: const TextStyle(color: Color(0xFFDD8436), fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.star_outline, color: Colors.black, size: 18),
                                Text(" ${widget.item.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(width: 12),
                                const Icon(Icons.location_on_outlined, color: Colors.black, size: 18),
                                Expanded(
                                  child: Text(" ${widget.item.location}", style: const TextStyle(fontSize: 13)),
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
                    children: widget.item.tags.map((tag) => _buildTag(tag)).toList(),
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
                        _buildStatColumn("Experience", widget.item.experience),
                        _buildStatColumn("Projects", "${widget.item.projects}"),
                        _buildStatColumn("Rate", widget.item.hourlyRate),
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
                    widget.item.email,
                    const Color(0xFFE5D7F5),
                     context,
                  ),
                  const SizedBox(height: 10),
                  _buildContactCard(
                    Icons.phone_outlined,
                    "Phone",
                    widget.item.phone,
                    const Color(0xFFF3E7D5),
                     context,
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // 4. TIP NOTICE
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF4DA6FF).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF1E88E5), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You can attach your plan files and add project details directly in the WhatsApp chat.',
                            style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
              ],
            ),

            const SizedBox(height: 4),

            // 5. BOTTOM BUTTON
            ElevatedButton.icon(
              onPressed: _connectWhatsApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), // WhatsApp green
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: Image.asset(
                'assets/whatsapp_icon.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.chat, color: Colors.white),
              ),
              label: const Text(
                "Connect via WhatsApp",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
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
  Widget _buildContactCard(
    IconData icon,
    String label,
    String value,
    Color backgroundColor,
    BuildContext context,
  ) {
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

// Filter Sheet Widget (Same logic, but can be customized for Engineers later)
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool isVerified = false;
  bool isCivil = false;
  bool isStructural = false;
  bool isElectrical = false;
  bool isMechanical = false;
  bool isEnvironmental = false;
  
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
          _buildFilterRow(
            "Civil Engineer",
            isCivil,
            (val) => setState(() => isCivil = val ?? false),
          ),
          _buildFilterRow(
            "Structural Engineer",
            isStructural,
            (val) => setState(() => isStructural = val ?? false),
          ),
          _buildFilterRow(
            "Electrical Engineer",
            isElectrical,
            (val) => setState(() => isElectrical = val ?? false),
          ),
          _buildFilterRow(
            "Mechanical Engineer",
            isMechanical,
            (val) => setState(() => isMechanical = val ?? false),
          ),
          _buildFilterRow(
            "Environmental Engineer",
            isEnvironmental,
            (val) => setState(() => isEnvironmental = val ?? false),
          ),

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
              final List<String> specialties = [];
              if (isCivil) specialties.add("Civil Engineer");
              if (isStructural) specialties.add("Structural Engineer");
              if (isElectrical) specialties.add("Electrical Engineer");
              if (isMechanical) specialties.add("Mechanical Engineer");
              if (isEnvironmental) specialties.add("Environmental Engineer");

              // Pop with filter values
              Navigator.pop(context, {
                'specialties': specialties,
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