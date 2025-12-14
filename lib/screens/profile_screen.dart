import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch past wins from DB
    return Scaffold(
      appBar: AppBar(title: const Text('My GlowUps')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 10, // Placeholder for past wins
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Share reel
              Share.share('Check my GlowUp win! #GlowUpApp');
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network('placeholder_win_url', fit: BoxFit.cover),
                Lottie.asset('assets/lottie/crown.json', height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}