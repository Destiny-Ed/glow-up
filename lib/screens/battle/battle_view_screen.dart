import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/models/post_model.dart';
import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/providers/battle_viewmodel.dart';
import 'package:glow_up/widgets/post_item_widget.dart';
import 'package:lottie/lottie.dart'; // For confetti when won

// class BattleViewScreen extends StatefulWidget {
//   final bool isActive;
//   final String theme;
//   final String? winnerUsername; // null if active or tie
//   final bool didUserWin;

//   const BattleViewScreen({
//     super.key,
//     required this.isActive,
//     this.theme = 'STREETWEAR',
//     this.winnerUsername,
//     this.didUserWin = false,
//   });

// @override
// State<BattleViewScreen> createState() => _BattleViewScreenState();
// }
// screens/battle/battle_view_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/models/battle_model.dart';
import 'package:provider/provider.dart';

class BattleViewScreen extends StatefulWidget {
  final bool isActive;
  final String battleId;

  const BattleViewScreen({
    super.key,
    required this.isActive,
    required this.battleId,
  });

  @override
  State<BattleViewScreen> createState() => _BattleViewScreenState();
}

class _BattleViewScreenState extends State<BattleViewScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final battleVm = context.read<BattleViewModel>();

    return FutureBuilder<BattleModel?>(
      future: battleVm.getBattleById(
        widget.battleId,
      ), // Add this method to BattleService/ViewModel
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        final battle = snapshot.data!;

        final entries = battle.posts.entries
            .map(
              (e) => {
                'userId': e.key,
                'postId': e.value,
                'votes': 0, // Fetch from votes subcollection
              },
            )
            .toList();

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              '${battle.theme} BATTLE',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: battleVm.getPostAndUser(
                      entry['postId'] as String,
                      entry['userId'] as String,
                    ),
                    builder: (context, postSnapshot) {
                      if (!postSnapshot.hasData) {
                        return Container(color: Colors.white10);
                      }

                      final data = postSnapshot.data!;
                      final post = data['post'] as PostModel;
                      final user = data['user'] as UserModel;

                      return buildPostItem(
                        context,
                        post,
                        index,
                        // onFire: () =>
                        //     battleVm.voteInBattle(widget.battleId, post.userId),
                        _pageController,
                      );
                    },
                  );
                },
              ),

              // Timer
              if (widget.isActive)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white.withOpacity(0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, color: Colors.white70),
                        8.width(),
                        Text(
                          _formatTimeLeft(battle.endTime!),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: widget.isActive
              ? Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildVoteButton(
                        context,
                        Icons.thumb_up,
                        'Solid',
                        Colors.grey,
                        pageController: _pageController,
                      ),
                      _buildVoteButton(
                        context,
                        Icons.whatshot,
                        'FIRE',
                        Colors.green,
                        isFire: true,
                        pageController: _pageController,
                      ),
                      _buildVoteButton(
                        context,
                        Icons.close,
                        'Skip',
                        Colors.grey,
                        pageController: _pageController,
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  String _formatTimeLeft(DateTime endTime) {
    final diff = endTime.difference(DateTime.now());
    if (diff.inHours > 0) return '${diff.inHours}h left';
    return '${diff.inMinutes}m left';
  }

  Widget _buildVoteButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    bool isFire = false,
    required PageController pageController,
  }) {
    return GestureDetector(
      onTap: () {
        if (pageController.hasClients) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isFire ? 22 : 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFire ? Colors.green : Colors.white10,
              boxShadow: isFire
                  ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.6),
                        blurRadius: 20,
                      ),
                    ]
                  : [],
            ),
            child: Icon(icon, color: Colors.white, size: isFire ? 36 : 32),
          ),
          10.height(),
          Text(
            label,
            style: TextStyle(
              color: isFire ? Colors.green : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
