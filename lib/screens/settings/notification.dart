import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _filter = 'All'; // All, Battles, Votes, Requests

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Activity',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          IconButton(icon: Icon(Icons.keyboard_arrow_down), onPressed: null),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                _filterChip('All', true),
                const SizedBox(width: 12),
                _filterChip('Battles', false),
                const SizedBox(width: 12),
                _filterChip('Votes', false),
                const SizedBox(width: 12),
                _filterChip('Requests', false),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Text(
                  'New',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _notificationItem(
                  avatar: 'https://i.pravatar.cc/150?img=10',
                  title: 'Sarah challenged you to a \'Vintage Denim\' battle.',
                  time: '2m ago',
                  actionButton: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Accept'),
                  ),
                  hasBadge: true,
                ),
                _notificationItem(
                  avatar: 'https://i.pravatar.cc/150?img=22',
                  title: 'Mike sent you a friend request.',
                  time: '15m ago',
                  actionButton: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Confirm'),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text('Today', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                _notificationItem(
                  photo: 'https://i.pravatar.cc/150?img=22',
                  title:
                      'Your \'Summer Friday\' outfit is heating up! +12 votes',
                  time: '2h ago',
                  hasPhoto: true,
                ),
                _notificationItem(
                  icon: Icons.access_time,
                  title:
                      'Daily Drop: Time to post your outfit for the \'Neon Nights\' theme.',
                  time: '5h ago',
                ),

                const SizedBox(height: 30),
                const Text(
                  'Yesterday',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                _notificationItem(
                  avatar: 'https://i.pravatar.cc/150?img=35',
                  title: 'Jessica voted for you in the battle against Tom.',
                  time: '1d ago',
                ),
                _notificationItem(
                  icon: Icons.emoji_events,
                  title:
                      'Battle \'Streetwear Sunday\' has ended. See the winner!',
                  time: '1d ago',
                  hasArrow: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.green : Colors.white10,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(color: active ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  Widget _notificationItem({
    String? avatar,
    String? photo,
    IconData? icon,
    required String title,
    required String time,
    Widget? actionButton,
    bool hasBadge = false,
    bool hasPhoto = false,
    bool hasArrow = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasPhoto)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: photo!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            )
          else if (icon != null)
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white10,
              child: Icon(icon, color: Colors.white),
            )
          else
            CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(avatar!),
            ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                Text(
                  time,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                if (actionButton != null) const SizedBox(height: 12),
                if (actionButton != null) actionButton,
              ],
            ),
          ),
          if (hasArrow) const Icon(Icons.chevron_right, color: Colors.white54),
          if (hasBadge)
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: const Text('2', style: TextStyle(fontSize: 10)),
              ),
            ),
        ],
      ),
    );
  }
}
