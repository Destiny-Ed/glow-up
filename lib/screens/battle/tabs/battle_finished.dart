// import 'package:flutter/material.dart';
// import 'package:glow_up/screens/battle/battle_view_screen.dart';

// class BattleFinishedScreen extends StatelessWidget {
//   const BattleFinishedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildFinishedBattle(
//           context,
//           'STREETWEAR',
//           'You won! 🔥',
//           '2 days ago',
//           true,
//         ),
//         _buildFinishedBattle(
//           context,
//           'DATE NIGHT',
//           '@sarah_k won',
//           '1 week ago',
//           false,
//         ),
//         _buildFinishedBattle(context, 'GYM FIT', 'Tie', '2 weeks ago', false),
//       ],
//     );
//   }

//   Widget _buildFinishedBattle(
//     BuildContext context,
//     String theme,
//     String result,
//     String timeAgo,
//     bool won,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const BattleViewScreen(isActive: false),
//         ),
//       ),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white10,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               won ? Icons.emoji_events : Icons.whatshot,
//               color: won ? Theme.of(context).primaryColor : Colors.white70,
//               size: 32,
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   theme,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   result,
//                   style: TextStyle(
//                     color: won
//                         ? Theme.of(context).primaryColor
//                         : Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             Text(timeAgo, style: const TextStyle(color: Colors.white54)),
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

class BattleFinishedScreen extends StatelessWidget {
  const BattleFinishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BattleViewModel>(
      builder: (context, battleVm, child) {
        if (battleVm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (battleVm.finishedBattles.isEmpty) {
          return const Center(
            child: Text(
              'No finished battles',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: battleVm.finishedBattles.length,
          itemBuilder: (context, index) {
            final battle = battleVm.finishedBattles[index];
            final won =
                battle.winnerUid == context.read<UserViewModel>().user?.id;

            return _buildFinishedBattle(
              context,
              battle.theme,
              won ? 'You won! 🔥' : '@${battle.winnerUid} won',
              '2 days ago', // TODO: calculate
              won,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BattleViewScreen(isActive: false, battleId: battle.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFinishedBattle(
    BuildContext context,
    String theme,
    String result,
    String timeAgo,
    bool won, {
    VoidCallback? onTap,
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
        child: Row(
          children: [
            Icon(
              won ? Icons.emoji_events : Icons.whatshot,
              color: won ? Colors.green : Colors.white70,
              size: 32,
            ),
            16.width(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  theme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  result,
                  style: TextStyle(color: won ? Colors.green : Colors.white70),
                ),
              ],
            ),
            const Spacer(),
            Text(timeAgo, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
