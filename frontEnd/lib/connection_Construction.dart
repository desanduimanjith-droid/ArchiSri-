import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:archisri_1/login_page3.dart';

class connection_Construction extends StatefulWidget {
  const connection_Construction({super.key});

  @override
  State<connection_Construction> createState() =>
      _connection_ConstructionState();
}

class _connection_ConstructionState extends State<connection_Construction> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _getCompanyData();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _getCompanyData();
    });
  }

  Future<Map<String, dynamic>?> _getCompanyData() async {
    if (currentUser != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('companies')
          .doc(currentUser!.uid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    }
    return null;
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const login_page3()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE4D0),
      appBar: AppBar(
        title: const Text(
          "Company Profile",
          style: TextStyle(
            fontFamily: 'Serif',
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading profile."));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("No company data found. Please sign in again."),
              );
            }

            final data = snapshot.data!;

            final String companyName = data['companyName'] ?? 'N/A';
            final String constructionType =
                data['constructionType'] ?? 'General';
            final String location = data['location'] ?? 'N/A';
            final String projects = data['projects'] ?? '0';
            final String experience = data['yearsOfExperience'] ?? '0';
            final String email = data['email'] ?? 'N/A';
            final String contactPerson = data['contactPersonName'] ?? 'N/A';
            final String phone = data['phoneNumber'] ?? 'N/A';
            final String about = data['about'] ?? 'No description';
            final String profileImageUrl = (data['profileImageUrl'] ?? '')
                .toString();

            // Just a static 5.0 for rating as per the mock
            final String rating = "5.0";

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    // --- TOP CARD SECTION (To match Image) ---
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6F0),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.black87, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left profile image (circular with black border)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: ClipOval(
                              child: profileImageUrl.isNotEmpty
                                  ? Image.network(
                                      profileImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.black54,
                                              ),
                                            );
                                          },
                                    )
                                  : Container(
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.black54,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Right Details Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Company Name
                                Text(
                                  companyName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                // Type Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    constructionType,
                                    style: TextStyle(
                                      color: Colors.cyan.shade900,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Description Snippet (using about)
                                Text(
                                  about.isNotEmpty
                                      ? about
                                      : "Focusing on large scale developments...",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    height: 1.3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 14),
                                // Icons Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Rating
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Color(
                                            0xFFFBE05B,
                                          ), // Yellowish star
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Location
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.black87,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          location,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Projects
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.business_center_outlined,
                                          color: Colors.black87,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          projects,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
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

                    const SizedBox(height: 24),

                    // --- METRICS & EXTRA DETAILS SECTION ---
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6F0),
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Additional Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoTile(
                            Icons.history,
                            "Experience",
                            "$experience years",
                            Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoTile(
                            Icons.person_outline,
                            "Contact Person",
                            contactPerson,
                            Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoTile(
                            Icons.phone_outlined,
                            "Phone Number",
                            phone,
                            Colors.orange,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoTile(
                            Icons.email_outlined,
                            "Email Address",
                            email,
                            Colors.red,
                          ),

                          const SizedBox(height: 24),
                          const Divider(thickness: 1, color: Colors.grey),
                          const SizedBox(height: 24),

                          // --- BOTTOM BUTTONS ---
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    side: BorderSide(
                                      color: Colors.indigo.shade300,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditCompanyProfileScreen(
                                              userData: data,
                                              uid: currentUser!.uid,
                                            ),
                                      ),
                                    ).then((_) => _refreshProfile());
                                  },
                                  child: const Text(
                                    "Profile Details",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF2D2D2D,
                                    ), // Charcoal color
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _logout,
                                  child: const Text(
                                    "Log Out",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
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
          },
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color.shade700, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditCompanyProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String uid;

  const EditCompanyProfileScreen({
    super.key,
    required this.userData,
    required this.uid,
  });

  @override
  State<EditCompanyProfileScreen> createState() =>
      _EditCompanyProfileScreenState();
}

class _EditCompanyProfileScreenState extends State<EditCompanyProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _experienceController;
  late TextEditingController _locationController;
  late TextEditingController _projectsController;
  late TextEditingController _contactPersonController;
  late TextEditingController _phoneController;
  late TextEditingController _aboutController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userData['companyName'] ?? '',
    );
    _typeController = TextEditingController(
      text: widget.userData['constructionType'] ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.userData['yearsOfExperience'] ?? '',
    );
    _locationController = TextEditingController(
      text: widget.userData['location'] ?? '',
    );
    _projectsController = TextEditingController(
      text: widget.userData['projects'] ?? '',
    );
    _contactPersonController = TextEditingController(
      text: widget.userData['contactPersonName'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.userData['phoneNumber'] ?? '',
    );
    _aboutController = TextEditingController(
      text: widget.userData['about'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    _projectsController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.uid)
          .update({
            'companyName': _nameController.text.trim(),
            'constructionType': _typeController.text.trim(),
            'yearsOfExperience': _experienceController.text.trim(),
            'location': _locationController.text.trim(),
            'projects': _projectsController.text.trim(),
            'contactPersonName': _contactPersonController.text.trim(),
            'phoneNumber': _phoneController.text.trim(),
            'about': _aboutController.text.trim(),
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE4D0),
      appBar: AppBar(
        title: const Text(
          "Edit Company Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                label: "Company Name",
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Construction Type",
                controller: _typeController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "About (Max 50 chars)",
                controller: _aboutController,
                maxLength: 50,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Location / City",
                controller: _locationController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Years of Experience",
                controller: _experienceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Projects Completed",
                controller: _projectsController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Contact Person Name",
                controller: _contactPersonController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Phone Number",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2D2D), // Charcoal
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
