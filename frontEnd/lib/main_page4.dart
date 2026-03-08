
import 'package:flutter/material.dart';
import 'package:archisri_1/login_page.dart';


class MainPage4 extends StatefulWidget {
  const MainPage4({super.key});

  @override
  State<MainPage4> createState() => _MainPage4State();
}

class _MainPage4State extends State<MainPage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor:  const Color(0xFF00CED1),
      body:Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left:30,top:10),
            child: Center(
              child: Align(
                alignment: Alignment.topLeft,
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
                  color: const Color(0xFF17A2B8),
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
                  Icons.memory_outlined,
                  size:170,
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
                  "Smart IoT-Based Foundation Advisor",
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
                  "Make informed decisions with AI-powered recommendations for foundation type and materials.",
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
                        color: const Color(0xFF00CED1),
                        borderRadius: BorderRadius.circular(4),
                                             
                      ),

                    ),

                    const SizedBox(width: 8),

                    Container(
                      width:8,
                      height:8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00CED1),
                        borderRadius: BorderRadius.circular(5),
                    
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      width:30,
                      height:8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00CED1),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        
                        builder: (context) => const LoginPage(), 
                      ),
                    );
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 229, 255),
            
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Get Start",
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