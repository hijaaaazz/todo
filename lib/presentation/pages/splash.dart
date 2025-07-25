import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body:
      
   Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
       SizedBox(height: MediaQuery.of(context).size.height *0.1),
      
    ],
  ));
}

      
    
  
}
