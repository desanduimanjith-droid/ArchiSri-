//import the packeges according to the folder
import 'package:flutter/material.dart';
import 'package:archisri_1/main_page1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:archisri_1/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase Initialized Successfully');
    } else {
      Firebase.app();
      debugPrint('Firebase already initialized: using existing [DEFAULT] app');
    }

    debugPrint(
      'Firebase project: ${DefaultFirebaseOptions.currentPlatform.projectId}',
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
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

