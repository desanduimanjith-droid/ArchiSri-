import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:archisri_1/screens/onboarding/splash_screen.dart';
import 'package:archisri_1/screens/auth/login_page.dart';
import 'package:archisri_1/screens/auth/signup_page.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArchiSri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}

