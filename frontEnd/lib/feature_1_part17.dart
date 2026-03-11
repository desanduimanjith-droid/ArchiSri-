import 'package:flutter/material.dart';
import 'package:archisri_1/Engineer-connect-feature/screens/engineer_screen.dart';

class Feature1Part17 extends StatefulWidget {
  const Feature1Part17({super.key});

  @override
  State<Feature1Part17> createState() => _Feature1Part17State();
}

class _Feature1Part17State extends State<Feature1Part17> {
  // 1. State Variables
  double currentStep = 7;
  final double totalSteps = 8;
  double _landSize = 1000; // Initial value for the slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFFF5E6D3),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 40,top: 60, right: 40, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFFD4C55A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE68C46),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  padding: const EdgeInsets.all(10),
                 
                  child: Image.asset(
                    'assets/images/artificial-intelligence.png',
                    
                  ),
                ),
                  
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AI House Plan Designer",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Start designing with AI assistant",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 17),
                      Text("Step ${currentStep.toInt()} of ${totalSteps.toInt()}",
                          style: const TextStyle(color: Colors.white70, fontSize: 14)),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: currentStep / totalSteps,
                          backgroundColor: Colors.white24.withValues(alpha: 0.3 ),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        ),

                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Body Content ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Land Size",
                     style: TextStyle(
                      fontSize: 18,
                       fontWeight: FontWeight.bold,
                       color: Colors.black87
                       )
                      ),
                      const SizedBox(height: 4),
                  const Text(
                    "Enter Your Plot Dimensions",
                     style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      )
                      ),
                  const SizedBox(height: 20),

                  // 2. Land Size Slider Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Text("Land Size (sq ft)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Slider(
                          value: _landSize,
                          min: 500,
                          max: 5000,
                          activeColor: const Color(0xFFD4C55A),
                          onChanged: (value) {
                            setState(() => _landSize = value);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text("500"), Text("1000 sq ft"), Text("5000")],
                        ),
                        const SizedBox(height: 20),
                        // Quick selection buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _sizeButton(1000),
                            _sizeButton(2000),
                            _sizeButton(3000),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Selection Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Your Section", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 10),
                        _summaryRow("Floors", "2"),
                        _summaryRow("Style", "Traditional"),
                        _summaryRow("Size", "${_landSize.toInt()}sq ft"),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // 4. Generate Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EngineerHomeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome, size: 20),
                      label: const Text("Generate", style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE68C46),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the 1000, 2000, 3000 buttons
  Widget _sizeButton(int size) {
    return ElevatedButton(
      onPressed: () => setState(() => _landSize = size.toDouble()),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text("$size"),
    );
  }

  // Helper widget for the text rows in the summary section
  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title - ", style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.black54, fontSize: 16)),
        ],
      ),
    );
  }
}