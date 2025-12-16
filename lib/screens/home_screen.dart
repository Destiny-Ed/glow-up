import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/post_vm.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:glow_up/widgets/empty_state.dart';
import 'package:glow_up/widgets/post_item_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  bool _friendsMode = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize feed on first load
    // final postVm = context.read<PostViewModel>();
    // postVm.listenToTodayFeed(); // Global feed
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, postVm, child) {
        // Show loading only on first load
        if (postVm.isLoading && postVm.todayPosts.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        // Show error if failed
        if (postVm.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load feed',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white70),
                  ),
                  20.height(),
                  ElevatedButton(
                    onPressed: () => postVm.listenToTodayFeed(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final posts = postVm.todayPosts;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              posts.isEmpty
                  ? emptyWidget(
                      context,
                      "No outfits yet today",
                      "Be the first to post your fit and start the battle!",
                    )
                  : PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return buildPostItem(
                          context,
                          post,
                          index,
                          _pageController,
                        );
                      },
                    ),

              // Top Tabs + Post Button
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
                      const Spacer(),
                      if (!postVm.hasPostedToday)
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: CustomButton(
                            padding: 8,
                            text: "Post",
                            onTap: () async {
                              // Optional: Check if user can post today
                              final canPost = await postVm.canPostToday();
                              print(canPost);
                              if (!canPost) {
                                Fluttertoast.showToast(
                                  msg: "You've already posted today!",
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CameraScreen(),
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

        // Switch feed mode
        final postVm = context.read<PostViewModel>();
        if (_friendsMode) {
          postVm.listenToFriendsFeed(context.read<UserViewModel>());
        } else {
          postVm.listenToTodayFeed(); // Global
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active ? Theme.of(context).cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
