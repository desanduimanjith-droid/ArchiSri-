import 'package:archisri_1/login_page.dart';
import 'package:archisri_1/main_content_part.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Country code dropdown
  Map<String, String> _selectedCountry = {'name': 'Sri Lanka', 'flag': '🇱🇰', 'code': '+94'};
  final List<Map<String, String>> _countries = [
    {'name': 'Sri Lanka', 'flag': '🇱🇰', 'code': '+94'},
    {'name': 'India', 'flag': '🇮🇳', 'code': '+91'},
    {'name': 'United States', 'flag': '🇺🇸', 'code': '+1'},
    {'name': 'United Kingdom', 'flag': '🇬🇧', 'code': '+44'},
    {'name': 'Australia', 'flag': '🇦🇺', 'code': '+61'},
    {'name': 'Canada', 'flag': '🇨🇦', 'code': '+1'},
    {'name': 'Germany', 'flag': '🇩🇪', 'code': '+49'},
    {'name': 'France', 'flag': '🇫🇷', 'code': '+33'},
    {'name': 'Japan', 'flag': '🇯🇵', 'code': '+81'},
    {'name': 'China', 'flag': '🇨🇳', 'code': '+86'},
    {'name': 'South Korea', 'flag': '🇰🇷', 'code': '+82'},
    {'name': 'Singapore', 'flag': '🇸🇬', 'code': '+65'},
    {'name': 'Malaysia', 'flag': '🇲🇾', 'code': '+60'},
    {'name': 'Pakistan', 'flag': '🇵🇰', 'code': '+92'},
    {'name': 'Bangladesh', 'flag': '🇧🇩', 'code': '+880'},
    {'name': 'Nepal', 'flag': '🇳🇵', 'code': '+977'},
    {'name': 'Maldives', 'flag': '🇲🇻', 'code': '+960'},
    {'name': 'UAE', 'flag': '🇦🇪', 'code': '+971'},
    {'name': 'Saudi Arabia', 'flag': '🇸🇦', 'code': '+966'},
    {'name': 'Qatar', 'flag': '🇶🇦', 'code': '+974'},
    {'name': 'Italy', 'flag': '🇮🇹', 'code': '+39'},
    {'name': 'Spain', 'flag': '🇪🇸', 'code': '+34'},
    {'name': 'Netherlands', 'flag': '🇳🇱', 'code': '+31'},
    {'name': 'Sweden', 'flag': '🇸🇪', 'code': '+46'},
    {'name': 'Switzerland', 'flag': '🇨🇭', 'code': '+41'},
    {'name': 'New Zealand', 'flag': '🇳🇿', 'code': '+64'},
    {'name': 'South Africa', 'flag': '🇿🇦', 'code': '+27'},
    {'name': 'Brazil', 'flag': '🇧🇷', 'code': '+55'},
    {'name': 'Mexico', 'flag': '🇲🇽', 'code': '+52'},
    {'name': 'Russia', 'flag': '🇷🇺', 'code': '+7'},
    {'name': 'Thailand', 'flag': '🇹🇭', 'code': '+66'},
    {'name': 'Indonesia', 'flag': '🇮🇩', 'code': '+62'},
    {'name': 'Philippines', 'flag': '🇵🇭', 'code': '+63'},
    {'name': 'Vietnam', 'flag': '🇻🇳', 'code': '+84'},
    {'name': 'Nigeria', 'flag': '🇳🇬', 'code': '+234'},
    {'name': 'Egypt', 'flag': '🇪🇬', 'code': '+20'},
    {'name': 'Kenya', 'flag': '🇰🇪', 'code': '+254'},
    {'name': 'Turkey', 'flag': '🇹🇷', 'code': '+90'},
    {'name': 'Ireland', 'flag': '🇮🇪', 'code': '+353'},
    {'name': 'Portugal', 'flag': '🇵🇹', 'code': '+351'},
    {'name': 'Poland', 'flag': '🇵🇱', 'code': '+48'},
    {'name': 'Norway', 'flag': '🇳🇴', 'code': '+47'},
    {'name': 'Denmark', 'flag': '🇩🇰', 'code': '+45'},
    {'name': 'Finland', 'flag': '🇫🇮', 'code': '+358'},
    {'name': 'Belgium', 'flag': '🇧🇪', 'code': '+32'},
    {'name': 'Austria', 'flag': '🇦🇹', 'code': '+43'},
    {'name': 'Greece', 'flag': '🇬🇷', 'code': '+30'},
    {'name': 'Argentina', 'flag': '🇦🇷', 'code': '+54'},
    {'name': 'Colombia', 'flag': '🇨🇴', 'code': '+57'},
    {'name': 'Chile', 'flag': '🇨🇱', 'code': '+56'},
  ];

  @override
  void dispose() {
    // Clean up controllers when widget is removed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            // Go back to Login Screen
             Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(), 
                    ),
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
                  "Create Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif', 
                    color: Colors.black,
                  ),
                ),
                 const SizedBox(height: 5),
                 const Text(
                  "Fill in the details below to sign up",
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
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Using a helper function to avoid repeating code for fields
                      _buildInputField(
                        label: "Full Name", 
                        controller: _nameController, 
                        hint: "John Doe"
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInputField(
                        label: "Email", 
                        controller: _emailController, 
                        hint: "example@email.com"
                      ),
                      const SizedBox(height: 16),

                      // Phone Number with Country Code
                      const Text(
                        "Phone Number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 110,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCountry['name'],
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, size: 18),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                selectedItemBuilder: (context) {
                                  return _countries.map((c) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${c['flag']} ${c['code']}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: _countries.map((c) {
                                  return DropdownMenuItem<String>(
                                    value: c['name'],
                                    child: Text(
                                      '${c['flag']} ${c['name']} (${c['code']})',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedCountry = _countries
                                        .firstWhere((c) => c['name'] == val);
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                hintText: "77 123 4567",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                counterText: '',
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        label: "Password", 
                        controller: _passwordController, 
                        hint: "********",
                        isPassword: true,
                        obscure: _obscurePassword,
                        onToggleObscure: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInputField(
                        label: "Confirm Password", 
                        controller: _confirmPasswordController, 
                        hint: "********",
                        isPassword: true,
                        obscure: _obscureConfirmPassword,
                        onToggleObscure: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D2D2D), // Dark charcoal
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _handleSignUp,
                          child: const Text(
                            "Sign Up",
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
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Go back to Login Screen
                        
                     Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(), 
                    ),
                      );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.pinkAccent, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  

  // Handles the sign up action using Firebase Auth and Firestore
  Future<void> _handleSignUp() async {
     String name = _nameController.text.trim();
     String email = _emailController.text.trim();
     String phoneDigits = _phoneController.text.trim();
     String fullPhone = '${_selectedCountry['code']} $phoneDigits';
     String pass = _passwordController.text;
     String confirmPass = _confirmPasswordController.text;

     // Client-side validations
     if (name.isEmpty || email.isEmpty || phoneDigits.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
       _showError('Please fill in all fields.');
       return;
     }

     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
       _showError('Please enter a valid email address.');
       return;
     }

     if (!RegExp(r'^[0-9]{7,10}$').hasMatch(phoneDigits)) {
       _showError('Please enter a valid phone number (7-10 digits).');
       return;
     }

     if (pass.length < 6) {
       _showError('Password must be at least 6 characters long.');
       return;
     }

     if (pass != confirmPass) {
       _showError('Passwords do not match.');
       return;
     }

     try {
       // Create user with Firebase Auth
       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: email,
         password: pass,
       );

       // Set displayName on the Auth profile so it's available everywhere
       await userCredential.user!.updateDisplayName(name);

       // Insert details to Firestore
       await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
         'fullName': name,
         'email': email,
         'phoneNumber': fullPhone,
         'createdAt': FieldValue.serverTimestamp(),
       });

       if (!context.mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Account created successfully!'),
           backgroundColor: Colors.green,
         ),
       );
       
       // Navigate to MainContent instead of LoginPage
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(
           builder: (context) => const MainContentPart(), 
         ),
       );
     } on FirebaseAuthException catch (e) {
       if (!context.mounted) return;
       String errorMessage = 'Sign up failed. Please try again.';
       if (e.code == 'email-already-in-use') {
         errorMessage = 'An account already exists with this email. Try signing in instead.';
       } else if (e.code == 'weak-password') {
         errorMessage = 'Password is too weak. Use at least 6 characters.';
       } else if (e.code == 'invalid-email') {
         errorMessage = 'Please enter a valid email address.';
       } else if (e.code == 'operation-not-allowed') {
         errorMessage = 'Email/password sign up is not enabled. Please contact support.';
       } else if (e.code == 'network-request-failed') {
         errorMessage = 'Network error. Check your internet connection and try again.';
       } else if (e.code == 'too-many-requests') {
         errorMessage = 'Too many attempts. Please wait a few minutes and try again.';
       } else if (e.code == 'configuration-not-found') {
         errorMessage = 'Firebase is not fully configured for this app.';
       }
       _showError(errorMessage);
     } catch (e) {
       if (!context.mounted) return;
       _showError('Something went wrong. Please try again.');
     }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Helper widget to build consistent text fields
  Widget _buildInputField({
    required String label, 
    required TextEditingController controller, 
    required String hint,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword ? obscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
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