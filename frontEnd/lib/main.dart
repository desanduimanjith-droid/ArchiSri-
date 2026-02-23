import 'package:flutter/material.dart';
import 'package:archisri_1/screens/onboarding/splash_screen.dart';
import 'package:archisri_1/screens/auth/login_page.dart';
import 'package:archisri_1/screens/auth/signup_page.dart';

void main() {
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

