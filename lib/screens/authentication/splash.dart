import 'package:flutter/material.dart';
import 'package:glow_up/screens/authentication/social_auth.dart';

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SocialAuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // Lottie.asset(
              //   'assets/lottie/bug-hunting.json',
              //   width: 200,
              // ), // Add your Lottie
              const Text(
                'GlowUp',
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'The daily outfit battel your friends\nare already playing.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Column(
                spacing: 10,
                children: [
                  const LinearProgressIndicator(),
                  Text("v1.2.0", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
