import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _isGlobal = true;
  String _timeFilter = 'DAILY'; // DAILY, WEEKLY, ALL-TIME

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: null,
          ),
        ],
      ),
      body: Column(
        children: [
          // Global / Friends Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                _toggleChip('Global', _isGlobal),
                const SizedBox(width: 12),
                _toggleChip('Friends', !_isGlobal),
              ],
            ),
          ),

          // Time Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _timeChip('DAILY', _timeFilter == 'DAILY'),
                const SizedBox(width: 12),
                _timeChip('WEEKLY', _timeFilter == 'WEEKLY'),
                const SizedBox(width: 12),
                _timeChip('ALL-TIME', _timeFilter == 'ALL-TIME'),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Podium
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _podiumUser(
                rank: 2,
                name: 'SilverStyler',
                votes: '12.4k',
                avatar: 'https://i.pravatar.cc/150?img=5',
              ),
              const SizedBox(width: 30),
              _podiumUser(
                rank: 1,
                name: 'GoldKing',
                votes: '15.8k',
                avatar: 'https://i.pravatar.cc/150?img=8',
                isWinner: true,
              ),
              const SizedBox(width: 30),
              _podiumUser(
                rank: 3,
                name: 'BronzeBabe',
                votes: '10.1k',
                avatar: 'https://i.pravatar.cc/150?img=3',
              ),
            ],
          ),

          const SizedBox(height: 40),

          // List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _rankRow(
                  4,
                  'Jessica M.',
                  'Urban Chic',
                  '9.2k',
                  'https://i.pravatar.cc/150?img=12',
                ),
                _rankRow(
                  5,
                  'David K.',
                  'Streetwear Pro',
                  '8.9k',
                  'https://i.pravatar.cc/150?img=15',
                ),
                _rankRow(
                  6,
                  'Sarah L.',
                  'Vintage Vibes',
                  '8.5k',
                  'https://i.pravatar.cc/150?img=20',
                ),
                _rankRow(
                  7,
                  'Mike R.',
                  'Minimalist',
                  '8.1k',
                  'https://i.pravatar.cc/150?img=25',
                ),
                _rankRow(
                  8,
                  'Emily W.',
                  'Boho Queen',
                  '7.8k',
                  'https://i.pravatar.cc/150?img=30',
                ),

                const SizedBox(height: 30),

                // Your Rank Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        '42',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=40',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Keep battling!',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.whatshot,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '4.2k',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleChip(String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isGlobal = !_isGlobal),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Theme.of(context).primaryColor : Colors.white10,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeChip(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _timeFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Theme.of(context).primaryColor : Colors.white10,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(color: active ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  Widget _podiumUser({
    required int rank,
    required String name,
    required String votes,
    required String avatar,
    bool isWinner = false,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            CircleAvatar(
              radius: isWinner ? 60 : 45,
              backgroundColor: isWinner
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              child: CircleAvatar(
                radius: isWinner ? 58 : 43,
                backgroundImage: NetworkImage(avatar),
              ),
            ),
            if (isWinner)
              const Positioned(
                top: -10,
                child: Icon(Icons.king_bed, color: Colors.yellow, size: 50),
              ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isWinner
                      ? Theme.of(context).primaryColor
                      : Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.whatshot,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            Text(' $votes', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _rankRow(
    int rank,
    String name,
    String tagline,
    String votes,
    String avatar,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '$rank',
            style: const TextStyle(color: Colors.white70, fontSize: 24),
          ),
          const SizedBox(width: 20),
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tagline,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.whatshot, color: Theme.of(context).primaryColor),
              const SizedBox(width: 6),
              Text(
                votes,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
