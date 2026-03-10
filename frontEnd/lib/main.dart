import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:archisri_1/iot_result_Report.dart';
import 'firebase_options.dart';
// import 'package:archisri_1/main_page1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SoilTestingScreen(),
    );
  }
}
