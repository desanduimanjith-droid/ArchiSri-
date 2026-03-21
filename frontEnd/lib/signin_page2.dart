import 'dart:convert';
import 'dart:typed_data';
import 'package:archisri_1/login_page2.dart';
import 'package:archisri_1/connection_Engineer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for standard text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Controllers for Engineer-specific fields
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  // File picker state
  String? _pickedFileName;
  Uint8List? _pickedFileBytes;
  bool _isUploading = false;

  // Dropdown value for Specialization
  String? _selectedSpecialization;
  final List<String> _specializations = [
    'Civil Engineering',
    'Structural Engineering',
    'Architectural Engineering',
    'Geotechnical Engineering',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Other',
  ];

  @override
  void dispose() {
    // Clean up controllers when widget is removed
    _nameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _registrationNumberController.dispose();
    _experienceController.dispose();
    _companyController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFEBE4D0);

    return Scaffold(
      backgroundColor: backgroundColor,
      // Transparent AppBar just for the back button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          iconSize: 35,
          onPressed: () {
            // Go back to Engineer Login Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const login_page2()),
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
                  "Engineer Registration",
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
                  "Fill in your professional details to sign up",
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
                    // Same shadow style as login screen
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
                      // --- STANDARD FIELDS ---
                      const Text(
                        "Personal Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Full Name",
                        controller: _nameController,
                        hint: "John Doe",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Email",
                        controller: _emailController,
                        hint: "engineer@email.com",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Contact Number",
                        controller: _contactNumberController,
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

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(thickness: 1),
                      ),

                      // --- PROFESSIONAL FIELDS ---
                      const Text(
                        "Professional Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Engineer Registration Number",
                        controller: _registrationNumberController,
                        hint: "e.g. EC-123456",
                      ),
                      const SizedBox(height: 16),

                      // Dropdown for Specialization
                      const Text(
                        "Engineering Field / Specialization",
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
                        initialValue: _selectedSpecialization,
                        hint: const Text('Select Specialization'),
                        items: _specializations.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSpecialization = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Years of Experience",
                        controller: _experienceController,
                        hint: "e.g. 5",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Engineering Company / Organization",
                        controller: _companyController,
                        hint: "e.g. BuildPro Corp",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Rate per Hour (LKR)",
                        controller: _rateController,
                        hint: "e.g. 1200",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Professional ID Upload Button
                      const Text(
                        "Professional ID Upload",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _pickedFileName != null
                                ? Colors.green.shade400
                                : Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: _pickedFileName != null
                              ? Colors.green.shade50
                              : Colors.grey.shade50,
                        ),
                        child: TextButton.icon(
                          onPressed: _pickFile,
                          icon: Icon(
                            _pickedFileName != null
                                ? Icons.check_circle
                                : Icons.upload_file,
                            color: _pickedFileName != null
                                ? Colors.green
                                : Colors.indigo,
                          ),
                          label: Text(
                            _pickedFileName != null
                                ? "Change File"
                                : "Upload License / IESL Card / Company ID",
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      if (_pickedFileName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file,
                                  size: 18, color: Colors.green),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _pickedFileName!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pickedFileName = null;
                                    _pickedFileBytes = null;
                                  });
                                },
                                child: const Icon(Icons.close,
                                    size: 18, color: Colors.red),
                              ),
                            ],
                          ),
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
                          onPressed: _isUploading ? null : _handleSignUp,
                          child: _isUploading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                            "Register as Engineer",
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
                        // Go back to Login Screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const login_page2(),
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

  // Pick a file from the device
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true, // Load bytes into memory
      );

      if (result != null && result.files.single.bytes != null) {
        final file = result.files.single;
        // Check file size (max 1 MB)
        if (file.size > 1 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File too large! Please select a file under 1 MB."),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        setState(() {
          _pickedFileName = file.name;
          _pickedFileBytes = file.bytes;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${file.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  // Handles the sign up action using Firebase Auth and Firestore
  Future<void> _handleSignUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String contactNumber = _contactNumberController.text.trim();
    String pass = _passwordController.text;
    String confirmPass = _confirmPasswordController.text;

    // Professional details
    String registrationNo = _registrationNumberController.text.trim();
    String experience = _experienceController.text.trim();
    String company = _companyController.text.trim();
    String ratePerHour = _rateController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
      contactNumber.isEmpty ||
        pass.isEmpty ||
        registrationNo.isEmpty ||
        _selectedSpecialization == null) {
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

    setState(() {
      _isUploading = true;
    });

    try {
      // Create user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      // Prepare document data
      Map<String, dynamic> userData = {
        'fullName': name,
        'email': email,
        'phoneNumber': contactNumber,
        'role': 'Engineer',
        'registrationNumber': registrationNo,
        'specialization': _selectedSpecialization,
        'yearsOfExperience': experience,
        'company': company,
        'ratePerHour': ratePerHour,
        'isVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // If a file was picked, convert to base64 and add to document
      if (_pickedFileBytes != null && _pickedFileName != null) {
        String base64File = base64Encode(_pickedFileBytes!);
        userData['professionalIdFile'] = base64File;
        userData['professionalIdFileName'] = _pickedFileName;
      }

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('engineers')
          .doc(userCredential.user!.uid)
          .set(userData);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Engineer Registration Successful!")),
      );

      // Navigate to MainContent automatically
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const connection_Engineer()),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  // Helper widget to build consistent text fields
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
