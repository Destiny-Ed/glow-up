
import 'package:flutter/material.dart';
import 'package:glow_up/providers/post_vm.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/battle/battle_main_screen.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';
import 'package:glow_up/screens/friends/friends.dart';
import 'package:glow_up/screens/home_screen.dart';
import 'package:glow_up/screens/profile/profile.dart';
import 'package:glow_up/screens/profile/profile_setup.dart';
import 'package:provider/provider.dart';

class MainActivityScreen extends StatefulWidget {
  const MainActivityScreen({super.key});

  @override
  State<MainActivityScreen> createState() => _MainActivityScreenState();
}

class _MainActivityScreenState extends State<MainActivityScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Index 0
    const BattleMainScreen(), // index 1
    const FriendsRequestScreen(), // Index 2
    ProfileScreen(), // Index 3
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<PostViewModel>();
    final userVm = context.read<UserViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.listenToTodayFeed(); // Global feed
      provider.listenToMyPosts(); //check if user has posted today
      await userVm.loadUser();

      if (!userVm.isProfileComplete) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
        );
      } else {
        if (!provider.hasPostedToday) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CameraScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0E0A),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: 'Battle'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.people),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.red,
                    child: Text(
                      '1',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            label: 'Friends',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
