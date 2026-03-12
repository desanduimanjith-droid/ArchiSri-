import 'package:archisri_1/signin_page.dart';
import 'package:archisri_1/signin_page3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:archisri_1/login_page.dart';

class MainPage5 extends StatefulWidget {
  const MainPage5({super.key});

  @override
  State<MainPage5> createState() => _MainPage5State();
}

class _MainPage5State extends State<MainPage5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE4D0), 
      body: SafeArea(
        child: AnimationLimiter(
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo Section
              AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 800),
                child: const FadeInAnimation(
                  child: Image(
                    image: AssetImage('assets/images/ARCHISHI.png'),
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Select Your Role",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Serif',
                  color: Color(0xFF2D2D2D),
                ),
              ),

              const Text(
                "Your journey in architecture starts here",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 35, left: 25, right: 25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), 
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 600),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          
                          roleButton(context, "User", Icons.person_outline, () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          }),
                          const SizedBox(height: 15),
                          roleButton(context, "Engineer", Icons.engineering_outlined, () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                          }),
                          const SizedBox(height: 15),
                          roleButton(context, "Construction Company", Icons.apartment_outlined, () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const signin_page3()));
                          }),

                          const SizedBox(height: 40),

                         //status 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem("500+", "Projects", const Color(0xFF8D7B68)), 
                              _buildStatItem("150+", "Engineers", const Color(0xFF678983)), 
                              _buildStatDivider(),
                              _buildStatItem("4.9/5", "Rating", const Color(0xFF706233)), 
                            ],
                          ),

                          const SizedBox(height: 40),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Featured Excellence",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          
                          SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                projectCard("Residential", Icons.home_filled, const Color(0xFFF2EAD3)),
                                projectCard("Commercial", Icons.business_rounded, const Color(0xFFDFD7BF)),
                                projectCard("Industrial", Icons.factory_outlined, const Color(0xFFEBE4D0)),
                                projectCard("Interior", Icons.chair_outlined, const Color(0xFFF2EAD3)),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Footer
                          const Divider(thickness: 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Need help?", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              TextButton(
                                onPressed: () {}, 
                                child: const Text(
                                  "Contact Support", 
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D7B68))
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  Widget _buildStatItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.2));
  }

  Widget projectCard(String title, IconData icon, Color bgColor) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: bgColor, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: const Color(0xFF434242)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF434242))),
        ],
      ),
    );
  }

  Widget roleButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D2D2D), 
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 15),
            Text(text, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}