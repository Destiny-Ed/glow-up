import 'package:flutter/material.dart';

class FriendsRequestScreen extends StatelessWidget {
  const FriendsRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Friend Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          IconButton(icon: Icon(Icons.settings), onPressed: null),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search requests',
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

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
          const SizedBox(height: 12),

          // Pending Request Cards
          _buildPendingRequest(
            context,
            avatar: 'https://via.placeholder.com/60', // Replace with real
            name: 'Elena Rodriguez',
            username: '@elena_style',
            info: '12 mutual battles',
            time: '2h',
            hasBadge: true,
          ),
          _buildPendingRequest(
            context,
            avatar: 'https://via.placeholder.com/60',
            name: 'Jordan Smith',
            username: '@j_smith99',
            info: 'Top 5% Stylist',
            time: '5h',
          ),
          _buildPendingRequest(
            context,
            avatar: 'https://via.placeholder.com/60',
            name: 'Marcus Chen',
            username: '@mchen_designs',
            info: '5 mutuals',
            time: '1d',
            hasBadge: true,
          ),

          const SizedBox(height: 32),

          // People You Might Know
          const Text(
            'PEOPLE YOU MIGHT KNOW',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),

          _buildSuggestion(
            context,
            name: 'Sarah K.',
            info: 'From your contacts',
            avatar: 'https://via.placeholder.com/60',
          ),
          _buildSuggestion(
            context,
            name: 'David R.',
            info: 'Similar style',
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
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 12),
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
                  '$username · $info',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
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

  Widget _buildSuggestion(BuildContext context,{
    required String name,
    required String info,
    required String avatar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 12),
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
                  info,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon:   Icon(
              Icons.add_circle,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context,{
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }
}
