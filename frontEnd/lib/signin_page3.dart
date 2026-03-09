import 'package:archisri_1/login_page3.dart';
import 'package:archisri_1/connection_Construction.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signin_page3 extends StatefulWidget {
  const signin_page3({super.key});

  @override
  State<signin_page3> createState() => _CompanySignUpScreenState();
}

class _CompanySignUpScreenState extends State<signin_page3> {
  // Required Text Controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _businessRegNoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Dropdown value for Construction Type
  String? _selectedConstructionType;
  final List<String> _constructionTypes = [
    'Residential',
    'Commercial',
    'Industrial',
    'Infrastructure',
    'Mixed-Use',
    'Renovation & Remodeling',
    'Other',
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _businessRegNoController.dispose();
    _emailController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _experienceController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFEBE4D0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          iconSize: 35,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const login_page3()),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ARCHISHI.png',
                  height: 125.0,
                  width: 125.0,
                ),
                const Text(
                  "Company Registration",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Register your construction company",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 30),

                // --- MAIN FORM CONTAINER ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        "Company Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Company Name",
                        controller: _companyNameController,
                        hint: "e.g. BuildPro Corp",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Business Registration Number",
                        controller: _businessRegNoController,
                        hint: "e.g. PV-12345",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Company Email",
                        controller: _emailController,
                        hint: "company@email.com",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Company Address",
                        controller: _addressController,
                        hint: "123 Main St, City",
                      ),
                      const SizedBox(height: 16),

                      // Construction Type Dropdown
                      const Text(
                        "Construction Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        value: _selectedConstructionType,
                        hint: const Text('Select Construction Type'),
                        items: _constructionTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedConstructionType = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Years of Experience",
                        controller: _experienceController,
                        hint: "e.g. 10",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Business Registration Upload Button
                      const Text(
                        "Registration Certificate",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            // TODO: Add file picker logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Certificate upload logic coming soon!",
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.indigo,
                          ),
                          label: const Text(
                            "Upload Business Registration",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(thickness: 1),
                      ),

                      // --- CONTACT DETAILS ---
                      const Text(
                        "Representative Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Contact Person Name",
                        controller: _contactPersonController,
                        hint: "e.g. Jane Smith",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Phone Number",
                        controller: _phoneController,
                        hint: "+94 77 123 4567",
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Password",
                        controller: _passwordController,
                        hint: "********",
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Confirm Password",
                        controller: _confirmPasswordController,
                        hint: "********",
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF2D2D2D,
                            ), // Dark charcoal
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _handleSignUp,
                          child: const Text(
                            "Register Company",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Back to Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already registered? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const login_page3(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign In Here",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handle Firebase Sign Up & Firestore Entry
  Future<void> _handleSignUp() async {
    String companyName = _companyNameController.text.trim();
    String regNo = _businessRegNoController.text.trim();
    String email = _emailController.text.trim();
    String contactPerson = _contactPersonController.text.trim();
    String phone = _phoneController.text.trim();
    String address = _addressController.text.trim();
    String experience = _experienceController.text.trim();
    String pass = _passwordController.text;
    String confirmPass = _confirmPasswordController.text;

    if (companyName.isEmpty ||
        regNo.isEmpty ||
        email.isEmpty ||
        contactPerson.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        experience.isEmpty ||
        pass.isEmpty ||
        _selectedConstructionType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Please fill all required fields")),
      );
      return;
    }

    if (pass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Passwords do not match")),
      );
      return;
    }

    try {
      // Create user with Firebase Auth (uses email & pass)
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      // Save company details into Firestore
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(userCredential.user!.uid)
          .set({
            'companyName': companyName,
            'businessRegistrationNumber': regNo,
            'email': email,
            'contactPersonName': contactPerson,
            'phoneNumber': phone,
            'companyAddress': address,
            'constructionType': _selectedConstructionType,
            'yearsOfExperience': experience,
            'role': 'Construction Company',
            'isVerified': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Company Registration Successful!")),
      );

      // Auto-navigate to MainContent upon successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const connection_Construction(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Auth Error: ${e.message}")));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Consistent UI Widget for Inputs
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
