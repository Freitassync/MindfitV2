// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_has_app/screens/login_screen.dart'; // Changed from mindfit_app

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo_mindfit.png', // Certifique-se de adicionar o logo em assets
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
