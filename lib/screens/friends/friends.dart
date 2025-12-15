import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';

class FriendsRequestScreen extends StatelessWidget {
  const FriendsRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Friend',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar

          // Pending Requests Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PENDING REQUESTS (3)',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Manage',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),

          // Pending Request Cards
          ...List.generate(3, (index) {
            return _buildPendingRequest(
              context,
              avatar: 'https://via.placeholder.com/60', // Replace with real
              name: 'Elena Rodriguez',
              username: '@elena_style',
              info: '12 mutual battles',
              time: '2h',
              hasBadge: true,
            );
          }),

          // People You Might Know
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FRIENDS (3)',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Manage',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildFriends(
            context,
            name: 'Sarah K.',
            username: "@elena_style",
            avatar: 'https://via.placeholder.com/60',
          ),
          _buildFriends(
            context,
            name: 'David R.',
            username: '@elena_style',
            avatar: 'https://via.placeholder.com/60',
          ),

          const SizedBox(height: 32),

          // Find Friends Section (from Find Opponents)
          const Text(
            'Find friends by username or contact',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),

          _buildActionTile(
            context,
            icon: Icons.search,
            title: 'Find by username...',
            subtitle: '',
          ),
          _buildActionTile(
            context,
            icon: Icons.contacts,
            title: 'Invite from Contacts',
            subtitle: 'Find people you already know',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequest(
    BuildContext context, {
    required String avatar,
    required String name,
    required String username,
    required String info,
    required String time,
    bool hasBadge = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                ),
                Text(
                  '$username · $info',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.white70),
                ),
                10.height(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.black),
                      ),
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
          ),
          Text(time, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildFriends(
    BuildContext context, {
    required String name,
    required String username,
    required String avatar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  username,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      subtitle: subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: Colors.white70),
            ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }
}
