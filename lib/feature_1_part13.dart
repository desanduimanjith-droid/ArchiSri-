import 'package:flutter/material.dart';
import 'feature_1_part2.dart';

//living room selection screen (1st floor living room)

class Feature1Part1 extends StatefulWidget {
  const Feature1Part1({super.key});

  @override
  State<Feature1Part1> createState() => _Feature1Part1State();
}

class _Feature1Part1State extends State<Feature1Part1> {
  double currentStep = 6;
  final double totalSteps = 8;
  List<String> selectedRooms = [];

  final List<Map<String, dynamic>> houseStyles = [
    {'name': '1', 'image': Image(image: AssetImage('assets/images/living-room.png'), fit: BoxFit.contain)},
    {'name': '2', 'image': Image(image: AssetImage('assets/images/living-room.png'), fit: BoxFit.contain)},
    {'name': '3', 'image': Image(image: AssetImage('assets/images/living-room.png'), fit: BoxFit.contain)},
    {'name': '4', 'image': Image(image: AssetImage('assets/images/living-room.png'), fit: BoxFit.contain)},
  ];

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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Start designing with AI assistance",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 17),
                      Text(
                        "Step ${currentStep.toInt()} of ${totalSteps.toInt()}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: currentStep / totalSteps,
                            backgroundColor: Colors.white.withOpacity(0.3),
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

          // Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "living room(s)",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "How many living rooms should include in first floor?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Grid of style options
                  Flexible(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemCount: houseStyles.length,
                      itemBuilder: (context, index) {
                        final style = houseStyles[index];
                        final isSelected = selectedRooms.contains(style['name']);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedRooms.contains(style['name'])) {
                                selectedRooms.remove(style['name']);
                              } else {
                                selectedRooms.add(style['name']);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFE68C46)
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    
                                    
                                  ),
                                  child: style['image'],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  style['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  ),
                                
                                
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 8),

                  // Next Button
                  Center(
                    child: ElevatedButton(
                      onPressed: selectedRooms.isNotEmpty
                          ? () {
                              // Handle next action
                              print('Selected rooms: $selectedRooms');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Feature1Part2()),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE68C46),
                        disabledBackgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 25),
                        ],
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
}