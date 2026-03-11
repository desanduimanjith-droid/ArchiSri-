import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/whatsapp_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";
  List<String> _selectedSpecialties = [];
  String _selectedLocation = "";

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  // Filter constructors based on search and filters
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filterConstructors(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> constructors,
  ) {
    return constructors.where((doc) {
      final data = doc.data();
      final name = _constructorName(data).toLowerCase();
      final specialty = _constructorSpecialty(data).toLowerCase();
      final description = _constructorDescription(data).toLowerCase();
      final location = _constructorLocation(data).toLowerCase();

      final matchesSearch =
          _searchQuery.isEmpty ||
          name.contains(_searchQuery.toLowerCase()) ||
          specialty.contains(_searchQuery.toLowerCase()) ||
          description.contains(_searchQuery.toLowerCase());

      final matchesSpecialty =
          _selectedSpecialties.isEmpty ||
          _selectedSpecialties.any((s) => specialty.contains(s.toLowerCase()));

      final matchesLocation =
          _selectedLocation.isEmpty ||
          location.contains(_selectedLocation.toLowerCase());

      return matchesSearch && matchesSpecialty && matchesLocation;
    }).toList();
  }

  Widget _buildOwnCompanyFallbackList({Object? error}) {
    final userId = _currentUserId;
    if (userId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            error == null
                ? "No constructors found matching your criteria."
                : "Could not read companies list. Please login with a company account or update Firestore read rules.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('companies')
          .where(FieldPath.documentId, isEqualTo: userId)
          .snapshots(),
      builder: (context, ownSnapshot) {
        if (ownSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFCABF58)),
          );
        }

        final docs = ownSnapshot.data?.docs ?? [];
        final filtered = _filterConstructors(docs);
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                error == null
                    ? "No constructors found matching your criteria."
                    : "Company account created, but list access is restricted by Firestore rules. Showing only your account when available.",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) =>
              ConstructorCard(item: filtered[index].data()),
        );
      },
    );
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
                    Icons.engineering,
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
                        "Connect with\nConstructors",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Find verified construction professionals",
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
                        hintText: "Search constructors",
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
                      color: Color(0xFFFFF3F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.tune, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // The constructors list count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('companies')
                    .snapshots(),
                builder: (context, snapshot) {
                  final companyDocs = snapshot.data?.docs ?? [];
                  if (companyDocs.isNotEmpty) {
                    final filtered = _filterConstructors(companyDocs);
                    return Text(
                      "${filtered.length} constructors found",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  }

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('constructors')
                        .snapshots(),
                    builder: (context, legacySnapshot) {
                      final filtered = _filterConstructors(
                        legacySnapshot.data?.docs ?? [],
                      );
                      return Text(
                        "${filtered.length} constructors found",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Fetch constructors from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('companies')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCABF58)),
                  );
                }

                if (snapshot.hasError) {
                  return _buildOwnCompanyFallbackList(error: snapshot.error);
                }

                final companyDocs = snapshot.data?.docs ?? [];
                if (companyDocs.isNotEmpty) {
                  final filtered = _filterConstructors(companyDocs);
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No constructors found matching your criteria.",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        ConstructorCard(item: filtered[index].data()),
                  );
                }

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('constructors')
                      .snapshots(),
                  builder: (context, legacySnapshot) {
                    if (legacySnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFCABF58),
                        ),
                      );
                    }

                    if (legacySnapshot.hasError) {
                      return _buildOwnCompanyFallbackList(
                        error: legacySnapshot.error,
                      );
                    }

                    final filtered = _filterConstructors(
                      legacySnapshot.data?.docs ?? [],
                    );
                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          "No constructors found matching your criteria.",
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          ConstructorCard(item: filtered[index].data()),
                    );
                  },
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

// Constructor Card Widget
class ConstructorCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const ConstructorCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = _constructorImageUrl(item);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFFFFF3F3),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          builder: (context) => ConstructorDetailSheet(item: item),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3F3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
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
                          _buildConstructorAvatar(item, size: 80),
                    ),
                  )
                : _buildConstructorAvatar(item, size: 80),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _constructorName(item),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _constructorDescription(item),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600], size: 16),
                          Text(" ${_constructorRating(item)}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16),
                          Text(
                            " ${_constructorLocation(item)}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.business_center_outlined, size: 16),
                          Text(
                            " ${_constructorProjects(item)}",
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

// The details sheet that opens when tap a constructor
class ConstructorDetailSheet extends StatefulWidget {
  final Map<String, dynamic> item;
  const ConstructorDetailSheet({super.key, required this.item});

  @override
  State<ConstructorDetailSheet> createState() => _ConstructorDetailSheetState();
}

class _ConstructorDetailSheetState extends State<ConstructorDetailSheet> {
  Future<void> _connectWhatsApp() async {
    final phone = _constructorPhone(widget.item);
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This constructor has not added a phone number yet.'),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);

    final success = await WhatsAppHelper.contactConstructor(
      constructorName: _constructorName(widget.item),
      constructorPhone: phone,
      requestDetails:
          'Hi, I found your profile on Constructor Connect and would like to discuss a project.',
    );

    if (!success) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open WhatsApp. Please make sure WhatsApp is installed.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _constructorImageUrl(widget.item);

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
                // 1. Header with "Verified" badge
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
                                  _buildConstructorAvatar(
                                    widget.item,
                                    size: 100,
                                  ),
                            ),
                          )
                        : _buildConstructorAvatar(widget.item, size: 100),
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
                                  _constructorName(widget.item),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFFD16BFF),
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _constructorSpecialty(widget.item),
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
                                " ${_constructorRating(widget.item)}",
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
                                  " ${_constructorLocation(widget.item)}",
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
                const Divider(height: 1),
                const SizedBox(height: 10),

                // 2. ABOUT SECTION
                const Text(
                  "About",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _constructorDescription(widget.item),
                  style: const TextStyle(
                    color: Colors.black87,
                    height: 1.4,
                    fontSize: 14,
                  ),
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
                        "Rating",
                        "${_constructorRating(widget.item)} ⭐",
                      ),
                      _buildStatColumn(
                        "Projects",
                        _constructorProjects(widget.item),
                      ),
                      _buildStatColumn(
                        "Location",
                        _constructorLocation(widget.item),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // 4. CONTACT INFORMATION SECTION
                const Text(
                  "Contact Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _buildContactCard(
                  Icons.email_outlined,
                  "Email",
                  _constructorEmail(widget.item),
                  const Color(0xFFE5D7F5),
                  context,
                ),
                const SizedBox(height: 10),
                _buildContactCard(
                  Icons.phone_outlined,
                  "Phone",
                  _constructorPhone(widget.item).isNotEmpty
                      ? _constructorPhone(widget.item)
                      : 'Not provided',
                  const Color(0xFFF3E7D5),
                  context,
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // 5. TIP NOTICE
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4DA6FF).withValues(alpha: 0.3),
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
                          'You can share your project details and requirements directly in the WhatsApp chat.',
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

            // 6. BOTTOM BUTTON
            ElevatedButton.icon(
              onPressed: _connectWhatsApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), // WhatsApp green
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
              label: const Text(
                "Connect via WhatsApp",
                style: TextStyle(
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

  // Helper for Rating/Projects/Location stats
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

// Filter Sheet Widget
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool isVerified =
      false; // Tracks the checkbox state for Verified Constructors
  bool isResidential = false; // Tracks the checkbox state for Residential
  bool isCommercial = false; // Tracks the checkbox state for Commercial
  bool isIndustrial = false; // Tracks the checkbox state for Industrial
  bool isSustainable = false; // Tracks the checkbox state for Sustainable
  bool isRestoration = false; // Tracks the checkbox state for Restoration
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
  String? selectedDistrict; //  to store the selected district
  double _currentRating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The top drag bar
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

          // This Row handles the right side check box alignment
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // This pushes items to the far ends
            children: [
              const Text(
                "Verified Constructors Only",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
            "Speciality",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Residential filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Residential", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isResidential, // Uses the separate residential variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isResidential = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Commercial filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Commercial", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isCommercial, // Uses the separate commercial variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isCommercial = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Industrial filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Industrial", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isIndustrial, // Uses the separate industrial variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isIndustrial = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Sustainable filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sustainable", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isSustainable, // Uses the separate sustainable variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isSustainable = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Restoration filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Restoration", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isRestoration, // Uses the separate restoration variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isRestoration = value ?? false;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(),
          const SizedBox(height: 10),
          // Location dropdown
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
            activeColor: const Color(0xFFCABF58), // Using your header color
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
              if (isResidential) specialties.add("Residential");
              if (isCommercial) specialties.add("Commercial");
              if (isIndustrial) specialties.add("Industrial");
              if (isSustainable) specialties.add("Eco-Friendly");
              if (isRestoration) specialties.add("Restoration");

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
}

// ─── Firestore helper functions for constructor documents ───────────────────

String _constructorFirstNonEmpty(
  Map<String, dynamic> data,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  return fallback;
}

String _constructorName(Map<String, dynamic> data) => _constructorFirstNonEmpty(
  data,
  ['companyName', 'name', 'displayName'],
  fallback: 'Unnamed Company',
);

String _constructorSpecialty(Map<String, dynamic> data) =>
    _constructorFirstNonEmpty(data, [
      'constructionType',
      'specialty',
      'specialization',
    ], fallback: 'General Construction');

String _constructorDescription(Map<String, dynamic> data) =>
    _constructorFirstNonEmpty(data, [
      'description',
      'bio',
      'about',
    ], fallback: 'Registered construction company on ArchiSri.');

String _constructorEmail(Map<String, dynamic> data) =>
    _constructorFirstNonEmpty(data, ['email'], fallback: 'Not provided');

String _constructorPhone(Map<String, dynamic> data) =>
    _constructorFirstNonEmpty(data, [
      'phone',
      'phoneNumber',
      'mobile',
      'contactNumber',
      'whatsapp',
    ]);

String _constructorLocation(Map<String, dynamic> data) =>
    _constructorFirstNonEmpty(data, [
      'location',
      'district',
      'address',
    ], fallback: 'Not specified');

String _constructorImageUrl(Map<String, dynamic> data) =>
    _constructorFirstNonEmpty(data, [
      'imageUrl',
      'image_url',
      'photoUrl',
      'profileImage',
    ]);

String _constructorRating(Map<String, dynamic> data) {
  final dynamic rating = data['rating'];
  if (rating is num) return rating.toStringAsFixed(1);
  final parsed = double.tryParse('${rating ?? ''}');
  return parsed?.toStringAsFixed(1) ?? '0.0';
}

String _constructorProjects(Map<String, dynamic> data) {
  final dynamic projects = data['projects'];
  if (projects is num) return projects.toInt().toString();
  final parsed = int.tryParse('${projects ?? ''}');
  return parsed?.toString() ?? '0';
}

Widget _buildConstructorAvatar(Map<String, dynamic> item, {double size = 80}) {
  final name = _constructorName(item);
  final parts = name
      .split(' ')
      .where((part) => part.trim().isNotEmpty)
      .toList();
  final initials = parts.isEmpty
      ? 'C'
      : parts.take(2).map((part) => part[0].toUpperCase()).join();

  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFD4C55A),
      borderRadius: BorderRadius.circular(size > 90 ? 20 : 12),
    ),
    alignment: Alignment.center,
    child: Text(
      initials,
      style: TextStyle(
        fontSize: size * 0.28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
