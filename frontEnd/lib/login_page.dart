import 'package:flutter/material.dart';
import 'package:archisri_1/signin_page.dart';
import 'package:archisri_1/main_content_part.dart';
import 'package:archisri_1/main_page5.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<LoginPage> {
  // Controllers to retrieve text from the fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFEBE4D0);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage5(),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPage5(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

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

                const SizedBox(height: 20),

                // title and subtitle
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign in to continue building your dream home",
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
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "example@email.com",
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

                      // Password Field
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
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                            try {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter email and password',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Sign in with Firebase Authentication
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                              // Navigate to home page on successful login
                              if (userCredential.user != null && context.mounted) {
                                // Update displayName in background (don't block navigation)
                                final user = userCredential.user!;
                                if (user.displayName == null || user.displayName!.isEmpty) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .get()
                                      .then((doc) {
                                    if (doc.exists && doc.data() != null) {
                                      final fullName = doc.data()!['fullName'] ?? '';
                                      if (fullName.isNotEmpty) {
                                        user.updateDisplayName(fullName);
                                      }
                                    }
                                  }).catchError((_) {});
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainContentPart(),
                                  ),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              debugPrint(
                                'LoginPage auth error -> code: ${e.code}, message: ${e.message}',
                              );
                              if (context.mounted) {
                                String errorMessage = 'Authentication failed.';
                                if (e.code == 'user-not-found') {
                                  errorMessage =
                                      'No user found for that email.';
                                } else if (e.code == 'wrong-password' ||
                                    e.code == 'invalid-credential') {
                                  errorMessage = 'Wrong email or password.';
                                } else if (e.code == 'invalid-email') {
                                  errorMessage = 'Please enter a valid email address.';
                                } else if (e.code == 'user-disabled') {
                                  errorMessage = 'This account has been disabled.';
                                } else if (e.code == 'network-request-failed') {
                                  errorMessage =
                                      'Network error. Check your internet connection and try again.';
                                } else if (e.code == 'operation-not-allowed') {
                                  errorMessage =
                                      'Email/password login is not enabled in Firebase Authentication.';
                                } else if (e.code == 'configuration-not-found') {
                                  errorMessage =
                                      'Firebase Auth is not fully configured for this app. Enable Email/Password and add localhost in Authorized domains.';
                                } else if (e.code == 'too-many-requests') {
                                  errorMessage =
                                      'Too many attempts. Please wait a few minutes and try again.';
                                } else if (e.code == 'internal-error') {
                                  errorMessage =
                                      'Internal authentication error. Please try again shortly.';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      errorMessage,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint('LoginPage sign-in error: $e');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Sign in failed. Please try again.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
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
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- 4. "OR CONTINUE WITH" DIVIDER ---
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1.5,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      "Or continue with",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1.5,
                        indent: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // --- 5. SOCIAL BUTTONS ---
                // Google Button
                _socialButton(
                  label: "Continue with Google",
                  //google  icon
                  icon: Image.asset(
                    "assets/images/google.webp",
                    height: 24,
                    width: 24,
                  ),
                  onTap: () async {
                    // Changed to match your defined method name
                    final user = await _googleSignInGoogle();

                    if (user != null && context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainContentPart(),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 30),

                //sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Sign Up Screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors
                              .pinkAccent, // Matching the pink color in image
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
    ),
    );
  }

  // Added a '?' after UserCredential
  Future<UserCredential?> _googleSignInGoogle() async {
    try {
      if (kIsWeb) {
        // Correct implementation for Flutter Web
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        return await FirebaseAuth.instance.signInWithPopup(authProvider);
      } else {
        // Native Implementation (Android/iOS)
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      return null;
    }
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
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: resetEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "example@email.com",
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
                        borderSide: const BorderSide(color: Color(0xFF2D2D2D), width: 1.5),
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
                                content: Text('Please enter your email address'),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isSending = true);

                          try {
                            debugPrint('Sending password reset email to: $email');
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            debugPrint('Password reset email sent successfully to: $email');

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
                            String msg = 'Failed to send reset email.';
                            if (e.code == 'user-not-found') {
                              msg = 'No account found with that email.';
                            } else if (e.code == 'invalid-email') {
                              msg = 'Please enter a valid email address.';
                            } else if (e.code == 'too-many-requests') {
                              msg = 'Too many attempts. Please try again later.';
                            }
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

  // Helper widget to create the Social Button (Google)
  Widget _socialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
