import 'package:flutter/material.dart';

class BattleInvitationsScreen extends StatelessWidget {
  const BattleInvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInvitationCard(
          context,
          from: '@elena_style',
          theme: 'GYM FIT',
          message: 'Let\'s see who slays the gym look better 💪',
          onAccept: () {
            // Navigator.push(context, MaterialPageRoute(builder: (_) => const BattleViewScreen(isActive: false)));
          },
        ),
        _buildInvitationCard(
          context,
          from: '@mike_drips',
          theme: '90s VIBES',
          message: 'Throwback battle! You in?',
          onAccept: () {},
        ),
      ],
    );
  }

  Widget _buildInvitationCard(
    BuildContext context, {
    required String from,
    required String theme,
    required String message,
    required VoidCallback onAccept,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://via.placeholder.com/60'),
              ),
              const SizedBox(width: 12),
              Text(
                from,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'challenged you to',
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            theme,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Accept'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Decline'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
