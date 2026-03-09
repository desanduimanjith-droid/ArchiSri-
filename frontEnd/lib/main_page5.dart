import 'package:flutter/material.dart';
import 'package:archisri_1/login_page.dart';
import 'package:archisri_1/login_page2.dart';
import 'package:archisri_1/login_page3.dart';

class MainPage5 extends StatelessWidget {
  const MainPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFEBE4D0,
      ), // Matching login/signup background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Adding the app logo for a more premium feel
            Image.asset(
              'assets/images/ARCHISHI.png',
              height: 120.0,
              width: 120.0,
            ),

            const SizedBox(height: 24),

            const Text(
              "Select Your Role",
              style: TextStyle(
                fontSize: 28, // Slightly larger for elegance
                fontWeight: FontWeight.w800, // Bolder
                fontFamily: 'Serif', // Matching the app's typography
                letterSpacing: 0.5, // Just a tiny bit of breathing room
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Choose your account type to continue",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontFamily: 'Serif',
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // USER BUTTON
                    roleButton(context, "User", Icons.person_outline, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // ENGINEER BUTTON
                    roleButton(
                      context,
                      "Engineer",
                      Icons.engineering_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const login_page2(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // CONSTRUCTION COMPANY BUTTON
                    roleButton(
                      context,
                      "Construction Company",
                      Icons.apartment_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const login_page3(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget roleButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D2D2D), // Dark charcoal match
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 14),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif', // Added serif to button text
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
