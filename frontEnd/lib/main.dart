//import the packeges according to the folder
import 'package:flutter/material.dart';
import 'package:archisri_1/main_page1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:archisri_1/firebase_options.dart';
import 'package:archisri_1/IoTResultreport.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase Initialized Successfully");
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class ArchisriIoTReportApp extends StatelessWidget {
  const ArchisriIoTReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SoilTestingScreen(),
    );
  }
}