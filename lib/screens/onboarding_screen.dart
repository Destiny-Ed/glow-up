import 'package:flutter/material.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';
import 'package:glow_up/services/auth_service.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'GlowUp',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Daily outfit battles with friends',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                onPressed: () async {
                  await auth.signInWithGoogle();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CameraScreen(isFirst: true),
                    ),
                  );
                },
                child: const Text('Sign in with Google'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await auth.signInWithApple();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CameraScreen(isFirst: true),
                    ),
                  );
                },
                child: const Text('Sign in with Apple'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Phone sign-in flow
                  await auth.signInWithPhone('+1'); // Placeholder
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CameraScreen(isFirst: true),
                    ),
                  );
                },
                child: const Text('Sign in with Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
