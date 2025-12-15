import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/screens/battle/battle_view_screen.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';

class BattleActiveScreen extends StatelessWidget {
  const BattleActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActiveBattleCard(
          context,
          theme: 'STREETWEAR',
          participants: ['You', '@elena_style', '@mike_drips'],
          postedCount: 2,
          timeLeft: '18h left',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BattleViewScreen(isActive: true),
            ),
          ),
        ),
        _buildActiveBattleCard(
          context,
          theme: 'DATE NIGHT',
          participants: ['You', '@sarah_k'],
          postedCount: 1,
          timeLeft: '2h left',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const BattleViewScreen(isActive: true, theme: "DATE NIGHT"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveBattleCard(
    BuildContext context, {
    required String theme,
    required List<String> participants,
    required int postedCount,
    required String timeLeft,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.whatshot, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(theme, style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                Text(
                  timeLeft,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 10),

            AnimatedAvatarStack(
              height: 40,
              avatars: [
                for (var n = 0; n < 15; n++)
                  CachedNetworkImageProvider(
                    'https://i.pravatar.cc/150?img=$n',
                  ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              postedCount == participants.length
                  ? 'All posted!'
                  : '$postedCount/${participants.length} posted',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraScreen(),
                        ),
                      );
                    },
                    child: Chip(
                      avatar: Icon(
                        Icons.add,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ),
                      label: Text(
                        "Post",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),

                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  ...participants
                      .map(
                        (p) => Chip(
                          label: Text(
                            p,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          backgroundColor: Theme.of(context).cardColor,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
