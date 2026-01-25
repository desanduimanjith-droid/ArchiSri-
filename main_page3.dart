import 'package:flutter/material.dart';
import 'package:archisri_1/main_page4.dart';


class MainPage3 extends StatelessWidget {
  const MainPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor:  const Color.fromARGB(224, 245, 156, 4),
      body:Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left:30,top:10),
            child: Center(
              child: Align(
                alignment: AlignmentGeometry.topLeft,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/ARCHISHI.png',
                      height: 125.0,
                      width: 125.0,

                      ),
                    
                   
                    

                  ],

                ),

              ),
                
              
            ),
          )
        
          ),
          Expanded(
            flex:3,
            child: Center(
              child:Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 159, 44),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:Colors.grey.withOpacity(0.5),
      
                      blurRadius: 10,
                      offset: const Offset(0, 5),

                    )
                  ],
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  size:120,
                  color: Colors.black87

                ),
                
                    

                  ),
                ),

            
              




          ),

        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),

              ),

            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Analyze Soil Before You Build",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    fontStyle: FontStyle.normal,

                  ),

                ),
                //Description Text
                const Text(
                  "Get real-time soil analysis with our IoT sensors to ensure the best foundation for your home.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                    fontWeight: FontWeight.w500
                  ),
                ),

                //Pagination Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Container(
                      width:8,
                      height:8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(224, 245, 156, 4),
                        borderRadius: BorderRadius.circular(4),
                                             
                      ),

                    ),

                    const SizedBox(width: 8),

                    Container(
                      width:30,
                      height:8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(224, 245, 156, 4),
                        borderRadius: BorderRadius.circular(5),
                    
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      width:8,
                      height:8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(224, 245, 156, 4),
                        borderRadius: BorderRadius.circular(5),

                      ),

                    ),
                    

                   

                  ],

                ),
                //Skip Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child:ElevatedButton(
                  onPressed: () {
                    // Navigate to the next page
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage4(), 
                    ),
                      );
                    // Navigate to the next page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(224, 245, 156, 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

              ),
               
              ],
              

            ),
            
          ),
        ),
      ],
      )
      
      
      
      
      );
  
  }
}