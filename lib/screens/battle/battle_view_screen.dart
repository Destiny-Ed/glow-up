import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/widgets/post_item_widget.dart';
import 'package:lottie/lottie.dart'; // For confetti when won

class BattleViewScreen extends StatefulWidget {
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

  @override
  State<BattleViewScreen> createState() => _BattleViewScreenState();
}

class _BattleViewScreenState extends State<BattleViewScreen> {
  late PageController _pageController;

  // Dummy entries — replace with real data from provider/Firestore
  final List<Map<String, dynamic>> entries = const [
    {
      'username': 'You',
      'photoUrl':
          'https://assets.vogue.com/photos/616062ff816ea2de6ec85809/master/w_2560%2Cc_limit/00_story.jpg',
      'votes': 58,
      'caption': 'Ready for the weekend vintage jacket combo! 🛍️',
      'hasPosted': true,
      'hashtags': '#ootd #streetstyle',
      'timeAgo': '1d ago',
    },
    {
      'username': 'elena_style',
      'caption': 'Clean fit today 🔥',
      'photoUrl':
          'https://media.istockphoto.com/id/1489381517/photo/portrait-of-gorgeous-brunette-woman-standing-city-street-fashion-model-wears-black-leather.jpg?s=612x612&w=0&k=20&c=Ji-vXNMVdjtgiO0ZH1B5d5BbIhmpwngkhx1u4QaiG1g=',
      'votes': 52,
      'hasPosted': true,
      'timeAgo': '1d ago',
    },
    {
      'username': 'mike_drips',
      'photoUrl':
          'https://gentwith.com/wp-content/uploads/2021/02/10-Men%E2%80%99s-Style-Tips-To-Look-Powerful.jpg',
      'votes': 41,
      'hasPosted': true,
      'caption': 'Leather weather 🖤',
      'timeAgo': '1d ago',
    },
    {'username': 'j_smith99', 'photoUrl': '', 'votes': 0, 'hasPosted': false},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = List.from(entries)
      ..sort((a, b) => b['votes'].compareTo(a['votes']));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.isActive
              ? '${widget.theme} BATTLE'
              : '${widget.theme} BATTLE • FINISHED',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Timer (only if active)
              if (widget.isActive)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.white.withOpacity(0.05),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '18 hours left',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),

              // Entries Grid
              if (!widget.isActive)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: sortedEntries.length,
                    itemBuilder: (context, index) {
                      final entry = sortedEntries[index];
                      final isWinner = !widget.isActive && index == 0;

                      return _buildEntryCard(
                        context,
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

              if (widget.isActive)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    // itemCount: provider.todayPosts.length,
                    itemCount: sortedEntries.length,
                    itemBuilder: (context, index) {
                      // final post = provider.todayPosts[index];
                      final post = sortedEntries[index];
                      return buildPostItem(
                        context,
                        post,
                        index,
                        _pageController,
                      );
                    },
                  ),
                ),
            ],
          ),

          // Winner Overlay (only if finished and someone won)
          if (!widget.isActive && widget.winnerUsername != null)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/lottie/confetti.json',
                      width: 300,
                      repeat: false,
                    ),
                    const SizedBox(height: 20),
                    Icon(
                      Icons.emoji_events,
                      color: Theme.of(context).primaryColor,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.didUserWin
                          ? 'YOU WON!'
                          : '@${widget.winnerUsername} WON!',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This battle is complete',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Share reel
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 12),
                          Text(
                            'Share Victory Reel',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context, {
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
              color: isWinner
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
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
                    placeholder: (context, url) =>
                        Container(color: Colors.white10),
                  )
                : Container(
                    color: Colors.white10,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pending, color: Colors.white54, size: 40),
                          Text(
                            'Not posted yet',
                            style: TextStyle(color: Colors.white54),
                          ),
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
                color: isUserEntry
                    ? Theme.of(context).primaryColor
                    : Colors.white,
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
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                '$votes 🔥',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Winner Crown
        if (isWinner)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Icon(
              Icons.emoji_events,
              color: Theme.of(context).primaryColor,
              size: 60,
            ),
          ),
      ],
    );
  }

  Widget _buildVoteButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    bool isFire = false,
  }) {
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
              color: isFire
                  ? Theme.of(context).primaryColor
                  : Colors.white.withOpacity(0.1),
              boxShadow: isFire
                  ? [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                        blurRadius: 20,
                      ),
                    ]
                  : [],
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: isFire ? Theme.of(context).primaryColor : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
