// import 'package:avatar_stack/animated_avatar_stack.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:glow_up/screens/battle/battle_view_screen.dart';
// import 'package:glow_up/screens/camera/camera_screen.dart';

// class BattleActiveScreen extends StatelessWidget {
//   const BattleActiveScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildActiveBattleCard(
//           context,
//           theme: 'STREETWEAR',
//           participants: ['You', '@elena_style', '@mike_drips'],
//           postedCount: 2,
//           timeLeft: '18h left',
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const BattleViewScreen(isActive: true),
//             ),
//           ),
//         ),
//         _buildActiveBattleCard(
//           context,
//           theme: 'DATE NIGHT',
//           participants: ['You', '@sarah_k'],
//           postedCount: 1,
//           timeLeft: '2h left',
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) =>
//                   const BattleViewScreen(isActive: true, theme: "DATE NIGHT"),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActiveBattleCard(
//     BuildContext context, {
//     required String theme,
//     required List<String> participants,
//     required int postedCount,
//     required String timeLeft,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white10,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.whatshot, color: Theme.of(context).primaryColor),
//                 const SizedBox(width: 8),
//                 Text(theme, style: Theme.of(context).textTheme.titleLarge),
//                 const Spacer(),
//                 Text(
//                   timeLeft,
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleSmall!.copyWith(color: Colors.white70),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),

//             AnimatedAvatarStack(
//               height: 40,
//               avatars: [
//                 for (var n = 0; n < 15; n++)
//                   CachedNetworkImageProvider(
//                     'https://i.pravatar.cc/150?img=$n',
//                   ),
//               ],
//             ),
//             const SizedBox(height: 10),

//             Text(
//               postedCount == participants.length
//                   ? 'All posted!'
//                   : '$postedCount/${participants.length} posted',
//               style: TextStyle(color: Theme.of(context).primaryColor),
//             ),
//             const SizedBox(height: 8),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 spacing: 8,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CameraScreen(),
//                         ),
//                       );
//                     },
//                     child: Chip(
//                       avatar: Icon(
//                         Icons.add,
//                         color: Theme.of(context).textTheme.titleSmall!.color,
//                       ),
//                       label: Text(
//                         "Post",
//                         style: Theme.of(context).textTheme.titleSmall,
//                       ),

//                       backgroundColor: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   ...participants
//                       .map(
//                         (p) => Chip(
//                           label: Text(
//                             p,
//                             style: Theme.of(context).textTheme.titleSmall,
//                           ),
//                           backgroundColor: Theme.of(context).cardColor,
//                         ),
//                       )
//                       .toList(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/battle_viewmodel.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/battle/battle_view_screen.dart';
import 'package:provider/provider.dart';

class BattleActiveScreen extends StatelessWidget {
  const BattleActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BattleViewModel>(
      builder: (context, battleVm, child) {
        if (battleVm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (battleVm.activeBattles.isEmpty) {
          return const Center(
            child: Text(
              'No active battles',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: battleVm.activeBattles.length,
          itemBuilder: (context, index) {
            final battle = battleVm.activeBattles[index];
            final participants = [
              context.read<UserViewModel>().user?.userName ?? 'You',
              ...battle.opponentUids.map((id) => '@$id'),
            ];
            final postedCount = battle.posts.length;

            // Calculate time left
            final timeLeft = battle.endTime != null
                ? _formatTimeLeft(battle.endTime!)
                : 'Unknown';

            return _buildActiveBattleCard(
              context,
              theme: battle.theme,
              participants: participants,
              postedCount: postedCount,
              timeLeft: timeLeft,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BattleViewScreen(isActive: true, battleId: battle.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimeLeft(DateTime endTime) {
    final diff = endTime.difference(DateTime.now());
    if (diff.isNegative) return 'Ended';
    if (diff.inDays > 0) return '${diff.inDays}d left';
    if (diff.inHours > 0) return '${diff.inHours}h left';
    return '${diff.inMinutes}m left';
  }

  Widget _buildActiveBattleCard(
    BuildContext context, {
    required String theme,
    required List<String> participants,
    required int postedCount,
    required String timeLeft,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.whatshot, color: Colors.green),
                8.width(),
                Text(
                  theme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(timeLeft, style: const TextStyle(color: Colors.white70)),
              ],
            ),
            12.height(),
            Text(
              postedCount == participants.length
                  ? 'All posted!'
                  : '$postedCount/${participants.length} posted',
              style: const TextStyle(color: Colors.green),
            ),
            8.height(),
            Wrap(
              spacing: 8,
              children: participants
                  .map(
                    (p) => Chip(
                      label: Text(p, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.white10,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
