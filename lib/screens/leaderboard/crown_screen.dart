import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class CrownScreen extends StatelessWidget {
  final Map<String, dynamic> winnerPost;

  const CrownScreen({super.key, required this.winnerPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: winnerPost['photoUrl'],
            fit: BoxFit.cover,
          ),

          // Dark Overlay + Confetti
          Container(color: Colors.black54),
          Lottie.asset(
            'assets/lottie/confetti.json',
            fit: BoxFit.cover,
          ), // Add confetti Lottie
          // Music Toggle
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                child:   Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.music_note,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'MUSIC ON',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Crown & Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/crown.json',
                  width: 120,
                ), // Glowing crown animation
                const SizedBox(height: 20),
                const Text(
                  'You are today\'s',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                Text(
                  'GlowUp',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Reel Ready Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.movie, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '5s Reel Ready',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.yellow),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Text(
                  'Your outfit won the battle! We\'ve\ngenerated an auto-reel with music just for\nyou. 🎶',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),

                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Share.share(
                    'Check my GlowUp crown! 🔥 ${winnerPost['photoUrl']}',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload),
                      SizedBox(width: 12),
                      Text('Share your crown', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
                  child: const Text(
                    'View Leaderboard →',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
