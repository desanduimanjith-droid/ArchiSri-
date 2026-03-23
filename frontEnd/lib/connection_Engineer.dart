import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:archisri_1/login_page2.dart';

class connection_Engineer extends StatefulWidget {
  const connection_Engineer({super.key});

  @override
  State<connection_Engineer> createState() => _connection_EngineerState();
}

class _connection_EngineerState extends State<connection_Engineer> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _getUserData();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _getUserData();
    });
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    if (currentUser != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('engineers')
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
      MaterialPageRoute(builder: (context) => const login_page2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE4D0),
      appBar: AppBar(
        title: const Text(
          "My Profile",
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
                child: Text("No profile data found. Please sign in again."),
              );
            }

            final data = snapshot.data!;

            String capitalizeWords(String input) {
              if (input.isEmpty) return input;
              return input.split(' ').map((word) {
                if (word.isEmpty) return word;
                return word[0].toUpperCase() + word.substring(1).toLowerCase();
              }).join(' ');
            }

            final String fullName = capitalizeWords(data['fullName'] ?? 'N/A');
            final String specialization = data['specialization'] ?? 'N/A';
            final String company = data['company'] ?? 'N/A';
            final String experience = data['yearsOfExperience'] ?? '0';
            final String phoneNumber = data['phoneNumber'] ??
                data['contactNumber'] ??
                data['phone'] ??
                'N/A';
            final String ratePerHour = data['ratePerHour'] ?? '0';
            final int rating = data['rating'] is num
                ? (data['rating'] as num).round()
                : int.tryParse('${data['rating'] ?? ''}') ??
                    (double.tryParse('${data['rating'] ?? ''}')?.round() ?? 5);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F0),
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              border: Border.all(
                                color: Colors.black87,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Name and Title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        fullName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildRatingBadge(rating),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Status Badge ("Available" style)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade200
                                            .withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Registered",
                                        style: TextStyle(
                                          color: Colors.green.shade800,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  specialization,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // tages section
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [_buildBlueTag("Company: $company")],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildMetricColumn(
                              "Experience",
                              "$experience years",
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildMetricColumn(
                              "Rate",
                              "LKR $ratePerHour/hr",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child:
                                _buildMetricColumn("Phone Number", phoneNumber),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(thickness: 1, color: Colors.grey),
                      const SizedBox(height: 20),

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
                                  color: Colors.orange.shade300,
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
                                    builder: (context) => EditProfileScreen(
                                      userData: data,
                                      uid: currentUser!.uid,
                                    ),
                                  ),
                                ).then((_) => _refreshProfile());
                              },
                              child: const Text(
                                "Profile Details",
                                style: TextStyle(
                                  color: Colors.black87,
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
                                backgroundColor: Colors.orange
                                    .shade400, // Matches orange button color
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBlueTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildRatingBadge(int rating) {
    final String ratingText = rating.toString();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: const [
            Icon(Icons.star, size: 24, color: Color(0xFFE8DD64)),
            Icon(Icons.star_border, size: 24, color: Colors.black87),
          ],
        ),
        const SizedBox(width: 6),
        Text(
          ratingText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
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
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String uid;

  const EditProfileScreen({
    super.key,
    required this.userData,
    required this.uid,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _registrationController;
  late TextEditingController _experienceController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _rateController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userData['fullName'] ?? '',
    );
    _specializationController = TextEditingController(
      text: widget.userData['specialization'] ?? '',
    );
    _registrationController = TextEditingController(
      text: widget.userData['registrationNumber'] ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.userData['yearsOfExperience'] ?? '',
    );
    _companyController = TextEditingController(
      text: widget.userData['company'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.userData['phoneNumber'] ??
          widget.userData['contactNumber'] ??
          widget.userData['phone'] ??
          '',
    );
    _rateController = TextEditingController(
      text: widget.userData['ratePerHour'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _registrationController.dispose();
    _experienceController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('engineers')
          .doc(widget.uid)
          .update({
        'fullName': _nameController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'registrationNumber': _registrationController.text.trim(),
        'yearsOfExperience': _experienceController.text.trim(),
        'company': _companyController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'ratePerHour': _rateController.text.trim(),
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
          "Edit Profile Details",
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
              _buildTextField(label: "Full Name", controller: _nameController),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Specialization",
                controller: _specializationController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Years of Experience",
                controller: _experienceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(label: "Company", controller: _companyController),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Phone Number",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Rate per Hour (LKR)",
                controller: _rateController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
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
