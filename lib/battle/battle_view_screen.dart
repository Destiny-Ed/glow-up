import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // For confetti when won

class BattleViewScreen extends StatelessWidget {
  final bool isActive;
  final String theme;
  final String? winnerUsername; // null if active or tie
  final bool didUserWin;

  const BattleViewScreen({
    super.key,
    required this.isActive,
    this.theme = 'STREETWEAR',
    this.winnerUsername,
    this.didUserWin = false,
  });

  // Dummy entries — replace with real data from provider/Firestore
  final List<Map<String, dynamic>> entries = const [
    {
      'username': 'You',
      'photoUrl': 'https://assets.vogue.com/photos/616062ff816ea2de6ec85809/master/w_2560%2Cc_limit/00_story.jpg',
      'votes': 58,
      'hasPosted': true,
    },
    {
      'username': '@elena_style',
      'photoUrl': 'https://media.istockphoto.com/id/1489381517/photo/portrait-of-gorgeous-brunette-woman-standing-city-street-fashion-model-wears-black-leather.jpg?s=612x612&w=0&k=20&c=Ji-vXNMVdjtgiO0ZH1B5d5BbIhmpwngkhx1u4QaiG1g=',
      'votes': 52,
      'hasPosted': true,
    },
    {
      'username': '@mike_drips',
      'photoUrl': 'https://gentwith.com/wp-content/uploads/2021/02/10-Men%E2%80%99s-Style-Tips-To-Look-Powerful.jpg',
      'votes': 41,
      'hasPosted': true,
    },
    {
      'username': '@j_smith99',
      'photoUrl': '',
      'votes': 0,
      'hasPosted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sortedEntries = List.from(entries)..sort((a, b) => b['votes'].compareTo(a['votes']));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          isActive ? '$theme BATTLE' : '$theme BATTLE • FINISHED',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: const [
          IconButton(icon: Icon(Icons.share), onPressed: null),
        ],
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Timer (only if active)
              if (isActive)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.white.withOpacity(0.05),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text('18 hours left', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),

              // Entries Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: sortedEntries.length,
                  itemBuilder: (context, index) {
                    final entry = sortedEntries[index];
                    final isWinner = !isActive && index == 0;

                    return _buildEntryCard(
                      username: entry['username'],
                      photoUrl: entry['photoUrl'],
                      votes: entry['votes'],
                      hasPosted: entry['hasPosted'],
                      isWinner: isWinner,
                      isUserEntry: entry['username'] == 'You',
                    );
                  },
                ),
              ),
            ],
          ),

          // Winner Overlay (only if finished and someone won)
          if (!isActive && winnerUsername != null)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/lottie/confetti.json', width: 300, repeat: false),
                    const SizedBox(height: 20),
                    Icon(Icons.emoji_events, color: Colors.green, size: 80),
                    const SizedBox(height: 20),
                    Text(
                      didUserWin ? 'YOU WON!' : '@$winnerUsername WON!',
                      style: const TextStyle(color: Colors.green, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text('This battle is complete', style: TextStyle(color: Colors.white70, fontSize: 18)),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Share reel
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 12),
                          Text('Share Victory Reel', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      // Voting Buttons (only if active)
      bottomNavigationBar: isActive
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVoteButton(label: 'Solid', icon: Icons.thumb_up),
                  _buildVoteButton(label: 'FIRE', icon: Icons.whatshot, isFire: true),
                  _buildVoteButton(label: 'Skip', icon: Icons.close),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildEntryCard({
    required String username,
    required String photoUrl,
    required int votes,
    required bool hasPosted,
    required bool isWinner,
    required bool isUserEntry,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isWinner ? Colors.green : Colors.transparent,
              width: isWinner ? 4 : 0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: hasPosted
                ? CachedNetworkImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(color: Colors.white10),
                  )
                : Container(
                    color: Colors.white10,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pending, color: Colors.white54, size: 40),
                          Text('Not posted yet', style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ),
                  ),
          ),
        ),

        // Username Tag
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              username,
              style: TextStyle(
                color: isUserEntry ? Colors.green : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Votes Badge
        if (hasPosted && votes > 0)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 10)],
              ),
              child: Text(
                '$votes 🔥',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),

        // Winner Crown
        if (isWinner)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Icon(Icons.emoji_events, color: Colors.green, size: 60),
          ),
      ],
    );
  }

  Widget _buildVoteButton({required String label, required IconData icon, bool isFire = false}) {
    return GestureDetector(
      onTap: () {
        // Handle vote
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFire ? Colors.green : Colors.white.withOpacity(0.1),
              boxShadow: isFire ? [BoxShadow(color: Colors.green.withOpacity(0.6), blurRadius: 20)] : [],
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: isFire ? Colors.green : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}