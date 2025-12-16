// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:glow_up/screens/camera/camera_screen.dart';

// class BattleInvitationsScreen extends StatelessWidget {
//   const BattleInvitationsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildInvitationCard(
//           context,
//           fromUserName: '@elena_style',
//           fromName: "Elena Rodriguez",
//           theme: 'GYM FIT',
//           message: 'Let\'s see who slays the gym look better 💪',
//           onAccept: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const CameraScreen()),
//             );
//           },
//         ),
//         _buildInvitationCard(
//           context,
//           fromUserName: '@mike_drips',
//           fromName: "Mike Drips",
//           theme: '90s VIBES',
//           message: 'Throwback battle! You in?',
//           onAccept: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildInvitationCard(
//     BuildContext context, {
//     required String fromUserName,
//     required String fromName,
//     required String theme,
//     required String message,
//     required VoidCallback onAccept,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white10,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const CircleAvatar(
//                 radius: 20,
//                 backgroundImage: CachedNetworkImageProvider(
//                   'https://via.placeholder.com/60',
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(fromName, style: Theme.of(context).textTheme.titleLarge),
//                   Text(
//                     fromUserName,
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'challenged you to',
//             style: const TextStyle(color: Colors.white70),
//           ),
//           Text(
//             theme,
//             style: TextStyle(
//               color: Theme.of(context).primaryColor,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(message, style: const TextStyle(color: Colors.white)),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               ElevatedButton(
//                 onPressed: onAccept,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   'Accept',
//                   style: Theme.of(context).textTheme.titleSmall,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               OutlinedButton(
//                 onPressed: () {},
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: Colors.white70,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   'Decline',
//                   style: Theme.of(context).textTheme.titleSmall,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/battle_viewmodel.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';
import 'package:provider/provider.dart';

class BattleInvitationsScreen extends StatelessWidget {
  const BattleInvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BattleViewModel>(
      builder: (context, battleVm, child) {
        if (battleVm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (battleVm.invitations.isEmpty) {
          return const Center(
            child: Text(
              'No pending invitations',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: battleVm.invitations.length,
          itemBuilder: (context, index) {
            final invite = battleVm.invitations[index];
            final battleId = invite['battleId'];
            final invitationId =
                invite['id'] ??
                '${battleId}_${context.read<UserViewModel>().user?.id}';

            return _buildInvitationCard(
              context,
              fromUserName: '@${invite['fromUid']}',
              fromName: 'Unknown', // TODO: fetch user name
              theme: 'THEME', // TODO: fetch from battle doc
              message: 'Let\'s battle!',
              onAccept: () async {
                await battleVm.acceptInvitation(battleId, invitationId);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraScreen()),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildInvitationCard(
    BuildContext context, {
    required String fromUserName,
    required String fromName,
    required String theme,
    required String message,
    required VoidCallback onAccept,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20),
              12.width(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fromName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    fromUserName,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          12.height(),
          const Text(
            'challenged you to',
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            theme,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          8.height(),
          Text(message, style: const TextStyle(color: Colors.white)),
          20.height(),
          Row(
            children: [
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Accept'),
              ),
              12.width(),
              OutlinedButton(onPressed: () {}, child: const Text('Decline')),
            ],
          ),
        ],
      ),
    );
  }
}
