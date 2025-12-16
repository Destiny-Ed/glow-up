import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/enum.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/models/post_model.dart';
import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/providers/post_vm.dart';
import 'package:provider/provider.dart';

Widget buildPostItem(
  BuildContext context,
  PostModel post,
  int index,
  PageController pageController,
) {
  final postVm = context.read<PostViewModel>();

  final currentUid = postVm.uid;

  return FutureBuilder<UserModel>(
    future: postVm.getUserForPost(post.userId),
    builder: (context, snapshot) {
      final user = snapshot.data;

      final hasPosted = post.hasPosted;

      return Stack(
        fit: StackFit.expand,
        children: [
          hasPosted
              ? CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.black26),
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
          if (post.challenge != null)
            Positioned(
              top: 100,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    8.width(),
                    Text(
                      'CHALLENGE: ${post.challenge}',
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
                if (user != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          user.profilePictureUrl ?? '',
                        ),
                      ),
                      8.width(),
                      Text(
                        '@${user.userName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${post.timestamp.timeAgo()} ago',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ] else
                  const Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white70),
                  ),

                8.height(),

                if (post.caption != null)
                  Text(
                    post.caption!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),

                if (post.hashtags.isNotEmpty)
                  Text(
                    post.hashtags.map((e) => '#$e').join(' '),
                    style: TextStyle(color: Theme.of(context).primaryColor),
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
                _buildActionIcon(context, Icons.share, 'Share'),
                16.height(),
                _buildActionIcon(context, Icons.more_horiz, ''),
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
                  _buildVoteButton(
                    context,
                    Icons.thumb_up,
                    VotingAction.solid,
                    Colors.grey,
                    postId: post.id,
                    padding: 8,
                    postOwnerUid: post.userId,
                    currentUid: currentUid,
                    pageController: pageController,
                  ),
                  _buildVoteButton(
                    context,
                    Icons.whatshot,
                    VotingAction.fire,
                    Theme.of(context).primaryColor,
                    postId: post.id,
                    postOwnerUid: post.userId,
                    currentUid: currentUid,
                    pageController: pageController,
                  ),
                  _buildVoteButton(
                    context,
                    Icons.close,
                    VotingAction.skip,
                    Colors.grey,
                    postId: post.id,
                    padding: 8,
                    postOwnerUid: post.userId,
                    currentUid: currentUid,
                    pageController: pageController,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildActionIcon(BuildContext context, IconData icon, String label) {
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
        Text(label, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

Widget _buildVoteButton(
  BuildContext context,
  IconData icon,
  VotingAction actionLabel,
  Color color, {
  double padding = 20,
  required String postId,
  required String postOwnerUid,
  required String currentUid,
  required PageController pageController,
}) {
  final postVm = context.read<PostViewModel>();

  return FutureBuilder<bool>(
    future: actionLabel == VotingAction.fire
        ? postVm.hasUserFiredPost(postId, currentUid)
        : postVm.hasUserLikedPost(postId, currentUid), // Optional for Solid
    builder: (context, snapshot) {
      final hasVoted = snapshot.data ?? false;
      final isLoading = snapshot.connectionState == ConnectionState.waiting;

      return GestureDetector(
        onTap: hasVoted || isLoading
            ? null
            : () async {
                if (actionLabel == VotingAction.fire) {
                  await postVm.firePost(postId, postOwnerUid);
                } else if (actionLabel == VotingAction.solid) {
                  await postVm.likePost(postId); // Optional Solid
                } else {
                  if (pageController.hasClients) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
        child: Opacity(
          // opacity: hasVoted || postOwnerUid == currentUid ? 0.5 : 1.0,
          opacity: hasVoted ? 0.5 : 1.0,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: actionLabel == VotingAction.fire
                      ? Theme.of(
                          context,
                        ).primaryColor.withOpacity(hasVoted ? 0.5 : 0.9)
                      : Theme.of(context).cardColor,
                  boxShadow: actionLabel == VotingAction.fire && !hasVoted
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.6),
                            blurRadius: 20,
                          ),
                        ]
                      : [],
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        icon,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                        size: 24,
                      ),
              ),
              8.height(),
              Text(
                actionLabel == VotingAction.fire
                    ? 'FIRE'
                    : actionLabel.name.capitalize,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).cardColor,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
