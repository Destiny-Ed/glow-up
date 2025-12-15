import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/providers/glow_up.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // For fire animation on tap

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  bool _friendsMode = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    final provider = Provider.of<GlowUpProvider>(context, listen: false);
    provider.fetchTodayPosts(friendsOnly: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlowUpProvider>(
      builder: (context, provider, child) {
        // if (provider.isLoading)
        //   return const Scaffold(
        //     backgroundColor: Colors.black,
        //     body: Center(child: CircularProgressIndicator(color: Colors.green)),
        //   );

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                // itemCount: provider.todayPosts.length,
                itemCount: dummyPosts.length,
                itemBuilder: (context, index) {
                  // final post = provider.todayPosts[index];
                  final post = dummyPosts[index];
                  return _buildPostItem(post, index);
                },
              ),

              // Top Tabs
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      _buildTab('Friends', _friendsMode),
                      const SizedBox(width: 16),
                      _buildTab('Global', !_friendsMode),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(String text, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() => _friendsMode = !_friendsMode);
        Provider.of<GlowUpProvider>(
          context,
          listen: false,
        ).fetchTodayPosts(friendsOnly: _friendsMode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(imageUrl: post['photoUrl'], fit: BoxFit.cover),

        // Dark Overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
        ),

        // Challenge Tag
        if (post['challenge'] != null)
          Positioned(
            top: 80,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'CHALLENGE: ${post['challenge']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // User Info & Caption
        Positioned(
          bottom: 120,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${post['username']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${post['timeAgo']}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                post['caption'] ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (post['hashtags'] != null)
                Text(
                  post['hashtags'],
                  style: const TextStyle(color: Colors.blueAccent),
                ),
            ],
          ),
        ),

        // Right Actions
        Positioned(
          right: 20,
          bottom: 120,
          child: Column(
            children: [
              _buildActionIcon(Icons.share, 'Share'),
              const SizedBox(height: 16),
              _buildActionIcon(Icons.more_horiz, ''),
            ],
          ),
        ),

        // Bottom Voting Buttons
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildVoteButton(Icons.thumb_up, 'Solid', Colors.grey),
                _buildVoteButton(
                  Icons.whatshot,
                  'FIRE',
                  Colors.green,
                  isFire: true,
                  padding: 20,
                ),
                _buildVoteButton(Icons.close, 'Skip', Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black54,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        if (label.isNotEmpty)
          Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildVoteButton(
    IconData icon,
    String label,
    Color color, {
    bool isFire = false,
    double? padding,
  }) {
    return GestureDetector(
      onTap: () {
        if (isFire) {
          // Play fire animation or glow
        }
        // Call provider.voteOnPost(...)
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(padding ?? 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFire ? Colors.green.withOpacity(0.9) : Colors.black54,
              boxShadow: isFire
                  ? [const BoxShadow(color: Colors.green, blurRadius: 20)]
                  : [],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: padding != null ? 30 : 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> dummyPosts = [
  {
    'username': 'jess_style',
    'photoUrl':
        'https://assets.vogue.com/photos/616062ff816ea2de6ec85809/master/w_2560%2Cc_limit/00_story.jpg',
    'caption': 'Ready for the weekend vintage jacket combo! 🛍️',
    'hashtags': '#ootd #streetstyle',
    'timeAgo': '2h ago',
    'challenge': 'STREETWEAR',
  },
  {
    'username': 'mike_drips',
    'photoUrl':
        'https://gentwith.com/wp-content/uploads/2021/02/10-Men%E2%80%99s-Style-Tips-To-Look-Powerful.jpg',
    'caption': 'Clean fit today 🔥',
    'hashtags': '#mensfashion #glowup',
    'timeAgo': '4h ago',
  },
  {
    'username': 'sarah_k',
    'photoUrl': 'https://cdn.mos.cms.futurecdn.net/TDqFXPmU8KXtvVQCeBAbi9.jpg',
    'caption': 'Cozy but make it fashion',
    'hashtags': '#hoodieseason',
    'timeAgo': '6h ago',
  },
  {
    'username': 'elena_style',
    'photoUrl':
        'https://media.istockphoto.com/id/1489381517/photo/portrait-of-gorgeous-brunette-woman-standing-city-street-fashion-model-wears-black-leather.jpg?s=612x612&w=0&k=20&c=Ji-vXNMVdjtgiO0ZH1B5d5BbIhmpwngkhx1u4QaiG1g=',
    'caption': 'Leather weather 🖤',
    'hashtags': '#edgy #fashion',
    'timeAgo': '1d ago',
  },
];
