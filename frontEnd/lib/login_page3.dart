import 'package:flutter/material.dart';
import 'package:archisri_1/connection_Construction.dart';
// Note: You will likely need a signup screen for companies later.
import 'package:archisri_1/signin_page3.dart';
import 'package:archisri_1/utils/company_login_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class login_page3 extends StatefulWidget {
  const login_page3({super.key});

  @override
  State<login_page3> createState() => _CompanyLoginScreenState();
}

class _CompanyLoginScreenState extends State<login_page3> {
  // Controllers to retrieve text from the fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Container(
                  height: 150,
                  width: 200,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/ARCHISHI.png',
                        height: 140.0,
                        width: 140.0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // title and subtitle
                const Text(
                  "Company Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign in to manage your construction profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'Serif',
                  ),
                ),

                const SizedBox(height: 30),

                //text fileds
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
                      // Company Name Field
                      const Text(
                        "Company Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _companyNameController,
                        decoration: InputDecoration(
                          hintText: "BuildPro Corp",
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
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Email Field
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "company@email.com",
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
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: "password",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
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
                      ),

                      const SizedBox(height: 24),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF2D2D2D,
                            ), // Dark charcoal color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final companyName = _companyNameController.text
                                .trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();

                            final validationError = validateCompanyLoginInputs(
                              companyName: companyName,
                              email: email,
                              password: password,
                            );
                            if (validationError != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(validationError)),
                              );
                              return;
                            }

                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                              final uid = userCredential.user?.uid;
                              if (uid == null) {
                                throw FirebaseAuthException(
                                  code: 'user-not-found',
                                  message: 'Authentication failed.',
                                );
                              }

                              final doc = await FirebaseFirestore.instance
                                  .collection('companies')
                                  .doc(uid)
                                  .get();

                              if (!doc.exists) {
                                await FirebaseAuth.instance.signOut();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Company profile not found. Use a registered company account.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final data = doc.data() ?? <String, dynamic>{};
                              final savedCompanyName =
                                  (data['companyName'] ?? '').toString().trim();

                              if (savedCompanyName.isNotEmpty &&
                                  savedCompanyName.toLowerCase() !=
                                      companyName.toLowerCase()) {
                                await FirebaseAuth.instance.signOut();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Company name does not match this account.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if account is verified by admin
                              final isVerified = data['isVerified'] == true;

                              if (!isVerified) {
                                await FirebaseAuth.instance.signOut();
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: const Color(0xFFF5F0E6),
                                    title: const Row(
                                      children: [
                                        Icon(Icons.hourglass_top, color: Colors.orange, size: 28),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Pending Verification',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Serif',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      'Your company account is currently under review by the ArchiSri admin team.\n\nYou will be able to sign in once your business registration and documents have been verified.\n\nPlease check back later.',
                                      style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF2D2D2D),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('OK', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const connection_Construction(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (!context.mounted) return;
                              final String errorMessage =
                                  mapCompanyLoginErrorCode(
                                    e.code,
                                    fallbackMessage: e.message,
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Forgot Password Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showForgotPasswordDialog();
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                //sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have a company account? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Company Sign Up Screen (signin_page3)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const signin_page3(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.pinkAccent, // Matching the pink color
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

  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        bool isSending = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color(0xFFF5F0E6),
              title: const Text(
                "Reset Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your email address and we'll send you a link to reset your password.",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: resetEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "company@email.com",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
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
                        borderSide: const BorderSide(
                          color: Color(0xFF2D2D2D),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSending ? null : () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final email = resetEmailController.text.trim();
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your email address',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isSending = true);

                          try {
                            debugPrint(
                              'Sending password reset email to: $email',
                            );
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: email,
                            );
                            debugPrint(
                              'Password reset email sent successfully to: $email',
                            );

                            if (context.mounted) Navigator.pop(context);

                            if (this.context.mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password reset link sent! Check your inbox or spam folder.',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setDialogState(() => isSending = false);
                            final msg = mapResetPasswordErrorCode(e.code);
                            if (this.context.mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            setDialogState(() => isSending = false);
                            if (this.context.mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Something went wrong. Please try again.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2D2D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "Send Reset Link",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
