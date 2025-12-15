import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // User Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=45')),
                    Positioned(bottom: 0, right: 0, child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: const Text('PRO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                    )),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Alex Stylez', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('@stylemaster • Battle Rank: #42', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const Icon(Icons.edit, color: Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 30),
          const Text('ACCOUNT', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          _settingsTile(icon: Icons.lock, title: 'Change Password'),
          _settingsTile(icon: Icons.link, title: 'Linked Accounts', subtitle: 'Instagram', hasArrow: true),

          const SizedBox(height: 30),
          const Text('NOTIFICATIONS', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          _settingsTile(icon: Icons.notifications, title: 'Battle Reminders', subtitle: 'Daily voting alerts', trailing: Switch(value: true, onChanged: null, activeColor: Colors.green)),
          _settingsTile(icon: Icons.how_to_vote, title: 'New Votes Alerts', trailing: Switch(value: true, onChanged: null, activeColor: Colors.green)),

          const SizedBox(height: 30),
          const Text('PRIVACY & SUPPORT', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          _settingsTile(icon: Icons.visibility, title: 'Profile Visibility', subtitle: 'Friends Only', hasArrow: true),
          _settingsTile(icon: Icons.block, title: 'Blocked Users', hasArrow: true),
          _settingsTile(icon: Icons.help, title: 'Help & Support', hasArrow: true),

          const SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 18)),
            ),
          ),

          const SizedBox(height: 30),
          const Center(
            child: Text('Outfit Battles v2.4.0', style: TextStyle(color: Colors.white54)),
          ),
          const Center(
            child: Text('Made with ❤️ for fashion', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({required IconData icon, required String title, String? subtitle, Widget? trailing, bool hasArrow = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: Colors.white10, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                if (subtitle != null) Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          trailing ?? (hasArrow ? const Icon(Icons.chevron_right, color: Colors.white54) : const SizedBox()),
        ],
      ),
    );
  }
}