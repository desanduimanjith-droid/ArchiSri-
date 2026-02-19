import 'package:flutter/material.dart';
import 'dart:async';
import 'package:archisri_1/main_page2.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 2), (){
      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage2()),
        );
      }
      
      
    });
  }


@override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: const Color(0xFFE1C796),
      body: Center(
        child:Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            color: const Color(0xFFDD8436),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),

              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
           
            child: Image.asset(
              "assets/images/ARCHISHI.png",
              fit: BoxFit.contain,
              
              

            ),
        
          ),
      

        )
      )


      
        

      





    );
  }
  

}