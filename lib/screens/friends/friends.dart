import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/providers/friends_vm.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/contacts/contact_sync.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class FriendsRequestScreen extends StatelessWidget {
  const FriendsRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Friends',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<FriendsViewModel>(
        builder: (context, friendsVm, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  onChanged: friendsVm.searchUsers,
                  style: Theme.of(context).textTheme.titleMedium,

                  decoration: InputDecoration(
                    hintText: 'Search by username...',
                    hintStyle: Theme.of(context).textTheme.titleMedium,

                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              20.height(),

              if (friendsVm.searchQuery.isNotEmpty) ...[
                if (friendsVm.searchResults.isEmpty)
                  Center(
                    child: Text(
                      'No users found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                else
                  ...friendsVm.searchResults.map(
                    (user) => _buildSearchResult(context, user),
                  ),
                30.height(),
              ],

              // Pending Requests
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PENDING REQUESTS (${friendsVm.pendingRequests.length})',
                    style: Theme.of(context).textTheme.titleLarge,
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
              12.height(),

              if (friendsVm.pendingRequests.isEmpty)
                Center(
                  child: Text(
                    'No pending requests',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              else
                ...friendsVm.pendingRequests.map(
                  (user) => _buildPendingRequest(
                    context,
                    user: user,
                    onAccept: () => friendsVm.acceptRequest(user.id),
                    onDecline: () => friendsVm.declineRequest(user.id),
                  ),
                ),

              30.height(),

              // Friends List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FRIENDS (${friendsVm.friends.length})',
                    style: Theme.of(context).textTheme.titleLarge,
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
              12.height(),

              if (friendsVm.friends.isEmpty)
                Center(
                  child: Text(
                    'No friends yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              else
                ...friendsVm.friends.map((user) => _buildFriend(context, user)),

              40.height(),

              // Find Friends Section
              Text(
                'Find friends by username or contact',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              16.height(),

              _buildActionTile(
                context,
                icon: Icons.contacts,
                title: 'Invite from Contacts',
                subtitle: 'Find people you already know',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactSyncScreen()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPendingRequest(
    BuildContext context, {
    required UserModel user,
    required VoidCallback onAccept,
    required VoidCallback onDecline,
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
            backgroundImage: user.profilePictureUrl != null
                ? CachedNetworkImageProvider(user.profilePictureUrl!)
                : null,
            child: user.profilePictureUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          12.width(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Unknown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '@${user.userName ?? 'unknown'} · 12 mutual battles',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                10.height(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'Accept',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    12.width(),
                    OutlinedButton(
                      onPressed: onDecline,
                      child: const Text('Decline'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text('2h', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildFriend(BuildContext context, UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: user.profilePictureUrl != null
                ? CachedNetworkImageProvider(user.profilePictureUrl!)
                : null,
          ),
          12.width(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Friend',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '@${user.userName ?? 'username'}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult(BuildContext context, UserModel user) {
    final currentUid = context.read<UserViewModel>().user?.id;
    final friendVm = context.read<FriendsViewModel>();
    final isFriend = friendVm.friends.any((f) => f.id == user.id);
    final hasPending = context.read<FriendsViewModel>().pendingRequests.any(
      (p) => p.id == user.id,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: user.profilePictureUrl != null
                ? CachedNetworkImageProvider(user.profilePictureUrl!)
                : null,
          ),
          16.width(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'User',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '@${user.userName ?? 'username'}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          if (user.id != currentUid && !isFriend && !hasPending)
            Expanded(
              child: CustomButton(
                text: "add",
                onTap: () async {
                  await friendVm.sendFriendRequest(user.id);
                  if (friendVm.hasError) {
                    Fluttertoast.showToast(
                      msg:
                          friendVm.errorMessage ??
                          "error sending friend request",
                    );
                    return;
                  }
                  Fluttertoast.showToast(
                    msg: friendVm.errorMessage ?? "Friend request sent",
                  );
                },
              ),
            )
          else if (hasPending)
            Text('Pending', style: Theme.of(context).textTheme.titleMedium)
          else
            Text(
              'Friend',
              style: TextStyle(color: Theme.of(context).primaryColor),
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
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).textTheme.titleLarge!.color,
      ),
      onTap: onTap,
    );
  }
}
