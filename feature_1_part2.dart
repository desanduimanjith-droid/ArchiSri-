import 'package:flutter/material.dart';

class Feature1Part2 extends StatefulWidget {
  const Feature1Part2({super.key});

  @override
  State<Feature1Part2> createState() => _Feature1Part2State();
}

class _Feature1Part2State extends State<Feature1Part2> {
  double currentStep = 2;
  final double totalSteps = 8;
  String? selectedFloor;

  final List<Map<String, dynamic>> floorOptions = [
    {'name': 'Single Floor', 'image': Image(image: AssetImage('assets/images/home_plan.png'), fit: BoxFit.contain)},
    {'name': 'Double Floor', 'image': Image(image: AssetImage('assets/images/home_plan.png'), fit: BoxFit.contain)},
    {'name': 'Triple Floor', 'image': Image(image: AssetImage('assets/images/home_plan.png'), fit: BoxFit.contain)},
    {'name': 'Quadruple Floor', 'image': Image(image: AssetImage('assets/images/home_plan.png'), fit: BoxFit.contain)},
    

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
                    "Select Number of Floors",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "How many floors do you want in your house?",
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
                        final isSelected = selectedFloor == style['name'];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFloor = style['name'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFE68C46)
                                    : Colors.grey.shade300,
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
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5E6D3),
                                    borderRadius: BorderRadius.circular(10),
                                    
                                    
                                  ),
                                  child: style['image'],
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
                        onPressed: selectedFloor != null
                            ? () {
                                // Handle next action
                                print('Selected floor: $selectedFloor');
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