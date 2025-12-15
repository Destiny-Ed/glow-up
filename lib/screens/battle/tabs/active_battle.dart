import 'package:flutter/material.dart';
import 'package:glow_up/screens/battle/battle_view_screen.dart';

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
              builder: (_) => const BattleViewScreen(isActive: true),
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
                Text(
                  theme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(timeLeft, style: const TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              postedCount == participants.length
                  ? 'All posted!'
                  : '$postedCount/${participants.length} posted',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: participants
                  .map(
                    (p) => Chip(
                      label: Text(p, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.white10,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
