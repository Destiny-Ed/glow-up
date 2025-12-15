import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildPostItem(
  BuildContext context,
  Map<String, dynamic> post,
  int index,
  PageController pageController,
) {
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
          top: 100,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              _buildVoteButton(
                context,
                Icons.thumb_up,
                'Solid',
                Colors.grey,
                onTap: () {
                  if (pageController.hasClients) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
              _buildVoteButton(
                context,
                Icons.whatshot,
                'FIRE',
                Theme.of(context).primaryColor,
                isFire: true,
                padding: 20,
                onTap: () {
                  // Play fire animation or glow

                  // Call provider.voteOnPost(...)
                  if (pageController.hasClients) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
              _buildVoteButton(
                context,
                Icons.close,
                'Skip',
                Colors.grey,
                onTap: () {
                  if (pageController.hasClients) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
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
  BuildContext context,
  IconData icon,
  String label,
  Color color, {
  bool isFire = false,
  double? padding,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(padding ?? 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFire
                ? Theme.of(context).primaryColor.withOpacity(0.9)
                : Colors.black54,
            boxShadow: isFire
                ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: 20,
                    ),
                  ]
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
