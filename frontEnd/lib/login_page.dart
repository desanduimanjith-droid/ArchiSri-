import 'package:flutter/material.dart';
import 'package:archisri_1/signin_page.dart';
import 'package:archisri_1/main_content_part.dart';
import 'package:archisri_1/main_page5.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<LoginPage> {
  // Controllers to retrieve text from the fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFEBE4D0);

    return Scaffold(
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
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPage5(),
                          ),
                        );
                      }
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
                        color: Colors.black.withOpacity(0.05),
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
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "password",
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
                            print("Sign In Clicked");
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
                              if (userCredential.user != null && mounted) {
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
                              if (mounted) {
                                String errorMessage = 'Authentication failed';
                                if (e.code == 'user-not-found') {
                                  errorMessage =
                                      'No user found for that email.';
                                } else if (e.code == 'wrong-password' ||
                                    e.code == 'invalid-credential') {
                                  errorMessage = 'Wrong email or password.';
                                } else if (e.code == 'too-many-requests') {
                                  errorMessage =
                                      'Too many attempts. Please wait a few minutes and try again.';
                                } else if (e.message != null) {
                                  errorMessage = e.message!;
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
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
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
                            print("Forgot Password Clicked");
                            // Add navigation to forgot password screen
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Google Button
                    _socialButton(
                      label: "Google",
                      //google  icon
                      icon: Image.asset(
                        "assets/images/google.webp",
                        height: 28,
                        width: 28,
                      ),
                      onTap: () async {
                        // Changed to match your defined method name
                        final user = await _googleSignInGoogle();

                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainContentPart(),
                            ),
                          );
                        }
                        print("Google Login Clicked");
                      },
                    ),

                    const SizedBox(width: 16), // Spacing between buttons
                    // Facebook Button
                    _socialButton(
                      label: "Facebook",
                      // facebook icon
                      icon: const Icon(
                        Icons.facebook,
                        color: Colors.blue,
                        size: 28,
                      ),
                      onTap: () {
                        print("Facebook Login Clicked");
                      },
                    ),
                  ],
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
                        print("Sign Up Clicked");
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
      print("Google Sign In Error: $e");
      return null;
    }
  }

  // Helper widget to create the Social Buttons (Google/Facebook)
  Widget _socialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Light grey background
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
