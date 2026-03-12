import 'package:flutter/material.dart';
import 'package:archisri_1/login_page.dart';
import 'package:archisri_1/login_page2.dart';
import 'package:archisri_1/login_page3.dart';

class MainPage5 extends StatefulWidget {
  const MainPage5({super.key});

  @override
  State<MainPage5> createState() => _MainPage5State();
}

class _MainPage5State extends State<MainPage5> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE4D0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            
            // Logo
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _fadeAnimation,
                child: Image.asset(
                  'assets/images/ARCHISHI.png',
                  height: 130.0,
                  width: 130.0,
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Select Your Role",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w900, 
                fontFamily: 'Serif', 
                color: Colors.black87
              ),
            ),
            
            const SizedBox(height: 15),

           
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40), 
                    topRight: Radius.circular(40)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), 
                      blurRadius: 10, 
                      offset: const Offset(0, -5)
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        // Drag Handle
                        Container(
                          width: 40, 
                          height: 5, 
                          decoration: BoxDecoration(
                            color: Colors.grey[300], 
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        
                        const SizedBox(height: 30),

                        // status icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem("4.9/5 Rating", Icons.star_rounded, Colors.amber),
                            _buildStatItem("Verified Pros", Icons.verified_user_rounded, Colors.blueGrey),
                            _buildStatItem("24/7 Support", Icons.support_agent_rounded, Colors.green),
                          ],
                        ),

                        const SizedBox(height: 35),

                        // role selction buttons
                        _roleButton(context, "User", "Find projects & hire experts", Icons.person_outline, 
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()))),
                        const SizedBox(height: 16),
                        _roleButton(context, "Engineer", "Manage technical designs", Icons.engineering_outlined, 
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const login_page2()))),
                        const SizedBox(height: 16),
                        _roleButton(context, "Construction Co.", "Handle large scale builds", Icons.apartment_outlined, 
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const login_page3()))),

                        const SizedBox(height: 40),

                    
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "OUR SERVICES",
                            style: TextStyle(letterSpacing: 1.5, fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        Row(
                          children: [
                            _buildFeatureCard("House plan genarator", Icons.edit_note_rounded),
                            const SizedBox(width: 15),
                            _buildFeatureCard("Conect with enginners and construction companies", Icons.account_balance_wallet_outlined),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _buildFeatureCard("Iot feedback with smart recommendation", Icons.map_outlined),
                            const SizedBox(width: 15),
                            _buildFeatureCard("Smart market place", Icons.chat_bubble_outline_rounded),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Service Features
  Widget _buildFeatureCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2D2D2D), size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
      ],
    );
  }

  Widget _roleButton(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.1),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}