import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/auth.dart';
import 'package:glow_up/providers/settings.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/authentication/social_auth.dart';
import 'package:glow_up/screens/profile/profile_setup.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        title: const Text('Settings'),
      ),
      body: Consumer2<UserViewModel, SettingsViewModel>(
        builder: (context, userVm, settingsVm, child) {
          final user = userVm.user;

          if (user == null) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // User Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,

                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user.profilePictureUrl != null
                              ? NetworkImage(user.profilePictureUrl!)
                              : null,
                          child: user.profilePictureUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white54,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              'PRO',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    16.width(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? 'Alex Stylez',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '@${user.userName ?? 'stylemaster'} • Battle Rank: #${user.votes}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileSetupScreen(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              30.height(),

              Text('ACCOUNT', style: Theme.of(context).textTheme.titleLarge),
              12.height(),
              _settingsTile(
                context,
                icon: Icons.lock,
                title: 'Change Password',
                hasArrow: true,
              ),
              _settingsTile(
                context,
                icon: Icons.link,
                title: 'Linked Accounts',
                subtitle: 'Instagram',
                hasArrow: true,
              ),

              30.height(),

              Text(
                'NOTIFICATIONS',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              12.height(),
              _settingsTile(
                context,
                icon: Icons.notifications,
                title: 'Battle Reminders',
                subtitle: 'Daily voting alerts',
                trailing: Switch(
                  value: settingsVm.battleReminders,
                  onChanged: settingsVm.toggleBattleReminders,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              _settingsTile(
                context,
                icon: Icons.how_to_vote,
                title: 'New Votes Alerts',
                trailing: Switch(
                  value: settingsVm.newVotesAlerts,
                  onChanged: settingsVm.toggleNewVotesAlerts,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),

              30.height(),

              Text(
                'PRIVACY & SUPPORT',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              12.height(),
              _settingsTile(
                context,
                icon: Icons.visibility,
                title: 'Profile Visibility',
                subtitle: settingsVm.isProfilePrivate
                    ? 'Friends Only'
                    : 'Public',
                trailing: Switch(
                  value: settingsVm.isProfilePrivate,
                  onChanged: settingsVm.toggleProfilePrivacy,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              _settingsTile(
                context,
                icon: Icons.block,
                title: 'Blocked Users',
                hasArrow: true,
              ),
              _settingsTile(
                context,
                icon: Icons.help,
                title: 'Help & Support',
                hasArrow: true,
              ),

              10.height(),

              Center(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Theme.of(context).cardColor,
                        title: Text(
                          'Log Out?',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        content: Text(
                          'Are you sure you want to log out?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await context.read<AuthViewModel>().signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SocialAuthScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              10.height(),

              Center(
                child: Text(
                  'Outfit Battles v2.4.0',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Center(
                child: Text(
                  'Made with ❤️ for fashion',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              20.height(),
            ],
          );
        },
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool hasArrow = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                icon,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
            16.width(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                ],
              ),
            ),
            trailing ??
                (hasArrow
                    ? Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).textTheme.titleMedium!.color,
                      )
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
