import 'package:flutter/material.dart';

//bathroom type selection screen

class Feature1Part6 extends StatefulWidget {
  const Feature1Part6({super.key});

  @override
  State<Feature1Part6> createState() => _Feature1Part6State();
}

class _Feature1Part6State extends State<Feature1Part6> {
  double currentStep = 5;
  final double totalSteps = 8;
  List<String> selectedRooms = [];

  final List<Map<String, dynamic>> floorOptions = [
    {'name': 'One single bedroom', 'icon': Icons.bathroom_rounded}, 
    {'name': '2nd bedroom', 'icon': Icons.bathroom_rounded},
    {'name': '3rd bedroom', 'icon': Icons.bathroom_rounded},
    {'name': '4th bedroom', 'icon': Icons.bathroom_rounded}
  
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
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attach Bathroom",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Select rooms to add attached bathroom to (1st floor only)",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Grid of style options
                  Flexible(
                    child: ListView.builder(
                      
                      itemCount: floorOptions.length,
                      itemBuilder: (context, index) {
                        final style = floorOptions[index];
                        final isSelected = selectedRooms.contains(style['name']);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          
                          child: GestureDetector(
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
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFE68C46)
                                    : Colors.black87,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5E6D3),
                                    borderRadius: BorderRadius.circular(10),
                                    
                                    
                                  ),
                                  child: Icon(style['icon'], size: 30, color: const Color(0xFFE68C46)),
                                  
                                ),
                                const SizedBox(height: 16),
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
                        ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                            Icon(Icons.arrow_back, size: 25),
                            SizedBox(width: 8),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),




                  
                      const SizedBox(height: 8),

                      // Next Button
                    
                      ElevatedButton(
                        onPressed: selectedRooms.isNotEmpty
                            ? () {
                                // Handle next action
                                print('Selected rooms: $selectedRooms');
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
                    ],
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