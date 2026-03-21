import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/whatsapp_helper.dart';
import '../../shared/rating_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class EngineerHomeScreen extends StatefulWidget {
  const EngineerHomeScreen({super.key});

  @override
  State<EngineerHomeScreen> createState() => _EngineerHomeScreenState();
}

class _EngineerHomeScreenState extends State<EngineerHomeScreen> {
  String _searchQuery = "";
  List<String> _selectedSpecialties = [];
  String _selectedLocation = "";

  // Filter engineers based on search and filters
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filterEngineers(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> engineers,
  ) {
    return engineers.where((engineer) {
      final data = engineer.data();
      final name = _engineerName(data).toLowerCase();
      final specialty = _engineerSpecialty(data).toLowerCase();
      final company = _engineerCompany(data).toLowerCase();
      final email = _engineerEmail(data).toLowerCase();
      final registration = _engineerRegistration(data).toLowerCase();
      final location = _engineerLocation(data).toLowerCase();

      final matchesSearch =
          _searchQuery.isEmpty ||
          name.contains(_searchQuery.toLowerCase()) ||
          specialty.contains(_searchQuery.toLowerCase()) ||
          company.contains(_searchQuery.toLowerCase()) ||
          email.contains(_searchQuery.toLowerCase()) ||
          registration.contains(_searchQuery.toLowerCase());

      final matchesSpecialty =
          _selectedSpecialties.isEmpty ||
          _selectedSpecialties.any(
            (selected) => specialty.contains(selected.toLowerCase()),
          );

      final matchesLocation =
          _selectedLocation.isEmpty ||
          location.contains(_selectedLocation.toLowerCase());

      // ALWAYS require the engineer to be verified to show up in the public feed
      final matchesVerified = _engineerIsVerified(data);

      return matchesSearch &&
          matchesSpecialty &&
          matchesLocation &&
          matchesVerified;
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
      backgroundColor: const Color(0xFFF5E6D3),
      body: Column(
        children: [
          // Header Section
          Stack(
            children: [
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

                      child: Icon(
                        Icons.engineering,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Connect with enginners",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Find verified engineering professionals",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white70,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 70,
                
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          // Search bar and filter button
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
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('engineers')
                    .snapshots(),
                builder: (context, snapshot) {
                  final filtered = _filterEngineers(snapshot.data?.docs ?? []);
                  return Text(
                    "${filtered.length} engineers found",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Fetch engineers from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('engineers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCABF58)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Error: ${snapshot.error}"),
                        ),
                        const Text(
                          "Please check Firebase connection and engineer documents.",
                        ),
                      ],
                    ),
                  );
                }

                final filtered = _filterEngineers(snapshot.data?.docs ?? []);
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text("No engineers found matching your criteria."),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      return EngineerCard(item: doc.data(), docId: doc.id);
                    },
                );
              },
            ),
          ),
        ],
      ),
      // bottom nav removed
    );
  }
}

// Engineer Card Widget
class EngineerCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final String docId;
  const EngineerCard({super.key, required this.item, required this.docId});

  @override
  Widget build(BuildContext context) {
    final tags = _engineerTags(item);
    final imageUrl = _engineerImageUrl(item);

    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFFFFF3F3),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          // Pop up EngineerDetailSheet
          builder: (context) => EngineerDetailSheet(item: item),
        );

        if (result == true) {
          final phone = _engineerPhone(item);
          final success = await WhatsAppHelper.contactEngineer(
            engineerName: _engineerName(item),
            engineerPhone: phone,
            projectDetails:
                'Hi, I found your profile on Engineer Connect and would like to discuss a project.',
          );

          if (!context.mounted) return;

          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Could not open WhatsApp. Please make sure WhatsApp is installed.',
                ),
              ),
            );
          } else {
            showRatingBottomSheet(
              context: context,
              name: _engineerName(item),
              imageUrl: imageUrl,
              currentRating: _engineerRating(item).toString(),
              docId: docId,
              collectionName: 'engineers',
            );
          }
        }
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
            imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildAvatar(item, size: 80),
                    ),
                  )
                : _buildAvatar(item, size: 80),
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
                          _engineerName(item),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        _engineerRate(item),
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
                    _engineerDescription(item),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tags
                          .take(2)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC5E1EB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600], size: 16),
                          Text(" ${_engineerRating(item)}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16),
                          Text(
                            " ${_engineerLocation(item)}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.business_center_outlined, size: 16),
                          Text(
                            " ${_engineerProjects(item)}",
                            style: const TextStyle(fontSize: 12),
                          ),
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
      color: const Color(0xFFC5E1EB),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.indigo.shade200),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.indigo,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

// The details sheet that opens when tap an engineer
class EngineerDetailSheet extends StatefulWidget {
  final Map<String, dynamic> item;
  const EngineerDetailSheet({super.key, required this.item});

  @override
  State<EngineerDetailSheet> createState() => _EngineerDetailSheetState();
}

class _EngineerDetailSheetState extends State<EngineerDetailSheet> {
  Future<void> _connectWhatsApp() async {
    final phone = _engineerPhone(widget.item);
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This engineer has not added a phone number yet.'),
        ),
      );
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final tags = _engineerTags(widget.item);
    final imageUrl = _engineerImageUrl(widget.item);
    final phone = _engineerPhone(widget.item);

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
            const SizedBox(height: 16),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Header with "Available" status
                Row(
                  children: [
                    imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildAvatar(widget.item, size: 100),
                            ),
                          )
                        : _buildAvatar(widget.item, size: 100),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _engineerName(widget.item),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _engineerIsVerified(widget.item)
                                      ? "Verified"
                                      : "Registered",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _engineerSpecialty(widget.item),
                            style: const TextStyle(
                              color: Color(0xFFDD8436),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_outline,
                                color: Colors.black,
                                size: 18,
                              ),
                              Text(
                                " ${_engineerRating(widget.item)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                                size: 18,
                              ),
                              Expanded(
                                child: Text(
                                  " ${_engineerLocation(widget.item)}",
                                  style: const TextStyle(fontSize: 13),
                                ),
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
                  children: tags.map((tag) => _buildTag(tag)).toList(),
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
                      _buildStatColumn(
                        "Experience",
                        _engineerExperience(widget.item),
                      ),
                      _buildStatColumn(
                        "Projects",
                        _engineerProjects(widget.item),
                      ),
                      _buildStatColumn("Rate", _engineerRate(widget.item)),
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
                  _engineerEmail(widget.item),
                  const Color(0xFFE5D7F5),
                  context,
                ),
                const SizedBox(height: 10),
                _buildContactCard(
                  Icons.phone_outlined,
                  "Phone",
                  phone.isNotEmpty ? phone : 'Not provided',
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
                    border: Border.all(
                      color: const Color(0xFF4DA6FF).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF1E88E5),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You can attach your plan files and add project details directly in the WhatsApp chat.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
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
              onPressed: phone.isNotEmpty ? _connectWhatsApp : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: phone.isNotEmpty
                    ? const Color(0xFF25D366)
                    : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: Image.asset(
                'assets/whatsapp_icon.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.chat, color: Colors.white),
              ),
              label: Text(
                phone.isNotEmpty
                    ? "Connect via WhatsApp"
                    : "Phone number not available",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
          final Uri emailLaunchUri = Uri(scheme: 'mailto', path: value);
          try {
            await launchUrl(emailLaunchUri);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Could not open email: $e")));
          }
        } else if (label == "Phone") {
          final Uri phoneLaunchUri = Uri(scheme: 'tel', path: value);
          try {
            await launchUrl(phoneLaunchUri);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Could not open phone: $e")));
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
  bool isCivil = false;
  bool isStructural = false;
  bool isElectrical = false;
  bool isMechanical = false;
  bool isEnvironmental = false;

  final List<String> _districts = [
    "Colombo",
    "Gampaha",
    "Kalutara",
    "Kandy",
    "Matale",
    "Nuwara Eliya",
    "Galle",
    "Matara",
    "Hambantota",
    "Jaffna",
    "Kilinochchi",
    "Mannar",
    "Vavuniya",
    "Mullaitivu",
    "Batticaloa",
    "Ampara",
    "Trincomalee",
    "Kurunegala",
    "Puttalam",
    "Anuradhapura",
    "Polonnaruwa",
    "Badulla",
    "Moneragala",
    "Ratnapura",
    "Kegalle",
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

String _firstNonEmpty(
  Map<String, dynamic> data,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }
  return fallback;
}

String _engineerName(Map<String, dynamic> data) =>
    _firstNonEmpty(data, ['fullName', 'name'], fallback: 'Unnamed Engineer');

String _engineerSpecialty(Map<String, dynamic> data) => _firstNonEmpty(data, [
  'specialization',
  'specialty',
], fallback: 'General Engineering');

String _engineerDescription(Map<String, dynamic> data) => _firstNonEmpty(data, [
  'description',
  'bio',
  'about',
], fallback: 'Registered engineer on ArchiSri.');

String _engineerCompany(Map<String, dynamic> data) =>
    _firstNonEmpty(data, ['company', 'organization'], fallback: 'Independent');

String _engineerExperience(Map<String, dynamic> data) => _firstNonEmpty(data, [
  'yearsOfExperience',
  'experience',
], fallback: 'Not specified');

String _engineerEmail(Map<String, dynamic> data) =>
    _firstNonEmpty(data, ['email'], fallback: 'Not provided');

String _engineerPhone(Map<String, dynamic> data) => _firstNonEmpty(data, [
  'phoneNumber',
  'phone',
  'mobile',
  'contactNumber',
  'whatsapp',
]);

String _engineerRegistration(Map<String, dynamic> data) => _firstNonEmpty(
  data,
  ['registrationNumber', 'registrationNo'],
  fallback: 'Not provided',
);

String _engineerLocation(Map<String, dynamic> data) => _firstNonEmpty(data, [
  'location',
  'district',
  'address',
], fallback: 'Not specified');

String _engineerImageUrl(Map<String, dynamic> data) =>
    _firstNonEmpty(data, ['imageUrl', 'image_url', 'photoUrl', 'profileImage']);

bool _engineerIsVerified(Map<String, dynamic> data) =>
    data['isVerified'] == true;

String _engineerRate(Map<String, dynamic> data) {
  final rate = _firstNonEmpty(data, ['ratePerHour', 'hourlyRate']);
  if (rate.isEmpty) return 'Rate N/A';
  if (rate.toLowerCase().contains('lkr') || rate.contains('/')) return rate;
  return 'LKR $rate/hr';
}

String _engineerProjects(Map<String, dynamic> data) {
  final dynamic projects = data['projects'];
  if (projects is num) return projects.toInt().toString();
  final parsed = int.tryParse('${projects ?? ''}');
  return parsed?.toString() ?? '0';
}

String _engineerRating(Map<String, dynamic> data) {
  final dynamic rating = data['rating'];
  if (rating is num) return rating.toString();
  final parsed = double.tryParse('${rating ?? ''}');
  return parsed?.toStringAsFixed(1) ?? '0.0';
}

List<String> _engineerTags(Map<String, dynamic> data) {
  final tags = <String>[];
  final specialty = _engineerSpecialty(data);
  final company = _engineerCompany(data);
  final registration = _engineerRegistration(data);

  if (specialty.isNotEmpty && specialty != 'General Engineering')
    tags.add(specialty);
  if (company.isNotEmpty && company != 'Independent') tags.add(company);
  if (registration.isNotEmpty && registration != 'Not provided')
    tags.add('Reg: $registration');

  return tags;
}

Widget _buildAvatar(Map<String, dynamic> item, {double size = 80}) {
  final name = _engineerName(item);
  final parts = name
      .split(' ')
      .where((part) => part.trim().isNotEmpty)
      .toList();
  final initials = parts.isEmpty
      ? 'E'
      : parts.take(2).map((part) => part[0].toUpperCase()).join();

  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFC5E1EB),
      borderRadius: BorderRadius.circular(size > 90 ? 20 : 12),
    ),
    alignment: Alignment.center,
    child: Text(
      initials,
      style: TextStyle(
        fontSize: size * 0.28,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
    ),
  );
}
