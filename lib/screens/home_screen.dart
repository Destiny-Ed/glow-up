import 'package:flutter/material.dart';
import 'package:glow_up/providers/glow_up.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:glow_up/widgets/post_item_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchTodayPosts(friendsOnly: _friendsMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlowUpProvider>(
      builder: (context, provider, child) {
        // if (provider.isLoading)
        //   return const Scaffold(
        //     backgroundColor: Colors.black,
        //     body: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
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
                  return buildPostItem(context, post, index, _pageController);
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
                      Spacer(),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: CustomButton(
                          text: "Post",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CameraScreen(),
                              ),
                            );
                          },
                        ),
                      ),
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
          color: active ? Colors.white38 : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active
                ? Theme.of(context).textTheme.titleSmall!.color
                : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
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
    'hasPosted': true,
  },
  {
    'username': 'mike_drips',
    'photoUrl':
        'https://media.istockphoto.com/id/2161831582/photo/portrait-of-luxury-modern-woman-in-new-york-city.jpg?s=612x612&w=0&k=20&c=Xa9jp15HVew7wxFRYxXTJB6bl-rNBCFbj2JFV8miPzo=',
    'caption': 'Clean fit today 🔥',
    'hashtags': '#mensfashion #glowup',
    'timeAgo': '4h ago',
    'hasPosted': true,
  },
  {
    'username': 'sarah_k',
    'photoUrl': 'https://cdn.mos.cms.futurecdn.net/TDqFXPmU8KXtvVQCeBAbi9.jpg',
    'caption': 'Cozy but make it fashion',
    'hashtags': '#hoodieseason',
    'timeAgo': '6h ago',
    'hasPosted': true,
  },
  {
    'username': 'elena_style',
    'photoUrl':
        'https://media.istockphoto.com/id/1489381517/photo/portrait-of-gorgeous-brunette-woman-standing-city-street-fashion-model-wears-black-leather.jpg?s=612x612&w=0&k=20&c=Ji-vXNMVdjtgiO0ZH1B5d5BbIhmpwngkhx1u4QaiG1g=',
    'caption': 'Leather weather 🖤',
    'hashtags': '#edgy #fashion',
    'timeAgo': '1d ago',
    'hasPosted': true,
  },
  {
    'username': 'mike_drips',
    'photoUrl':
        'https://c8.alamy.com/comp/3A51KWH/portrait-of-an-african-american-woman-standing-with-hands-on-hips-looking-away-in-an-urban-streetscape-a-trendy-street-style-scene-with-a-bold-colorful-outfit-and-modern-fashion-vibe-ideal-for-lifestyle-and-fashion-campaigns-3A51KWH.jpg',
    'caption': 'Clean fit today 🔥',
    'hashtags': '#mensfashion #glowup',
    'timeAgo': '4h ago',
    'hasPosted': true,
  },
];
