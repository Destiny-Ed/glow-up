import 'package:flutter/material.dart';
import 'package:glow_up/screens/battle/battle_view_screen.dart';

class BattleFinishedScreen extends StatelessWidget {
  const BattleFinishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildFinishedBattle(
          context,
          'STREETWEAR',
          'You won! 🔥',
          '2 days ago',
          true,
        ),
        _buildFinishedBattle(
          context,
          'DATE NIGHT',
          '@sarah_k won',
          '1 week ago',
          false,
        ),
        _buildFinishedBattle(context, 'GYM FIT', 'Tie', '2 weeks ago', false),
      ],
    );
  }

  Widget _buildFinishedBattle(
    BuildContext context,
    String theme,
    String result,
    String timeAgo,
    bool won,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const BattleViewScreen(isActive: false),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              won ? Icons.emoji_events : Icons.whatshot,
              color: won ? Theme.of(context).primaryColor : Colors.white70,
              size: 32,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  theme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  result,
                  style: TextStyle(
                    color: won
                        ? Theme.of(context).primaryColor
                        : Colors.white70,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(timeAgo, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
