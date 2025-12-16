import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/settings.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/profile/profile_setup.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<UserViewModel>().user?.id ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
                  color: Colors.white10,
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
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${user.userName ?? 'stylemaster'} • Battle Rank: #${user.votes}',
                            style: const TextStyle(color: Colors.white70),
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

              const Text(
                'ACCOUNT',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
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

              const Text(
                'NOTIFICATIONS',
                style: TextStyle(color: Colors.white70, fontSize: 14),
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

              const Text(
                'PRIVACY & SUPPORT',
                style: TextStyle(color: Colors.white70, fontSize: 14),
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

              40.height(),

              Center(
                child: TextButton(
                  onPressed: () {
                    // Log out logic from AuthViewModel
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              ),

              30.height(),

              const Center(
                child: Text(
                  'Outfit Battles v2.4.0',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              const Center(
                child: Text(
                  'Made with ❤️ for fashion',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
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
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white10,
              child: Icon(icon, color: Colors.white),
            ),
            16.width(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                (hasArrow
                    ? const Icon(Icons.chevron_right, color: Colors.white54)
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
