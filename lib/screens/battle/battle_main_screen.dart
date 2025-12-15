import 'package:flutter/material.dart';
import 'package:glow_up/screens/battle/tabs/active_battle.dart';
import 'package:glow_up/screens/battle/tabs/battle_finished.dart';
import 'package:glow_up/screens/battle/tabs/battle_invitation.dart';
import 'package:glow_up/screens/battle/create_battle.dart';

class BattleMainScreen extends StatefulWidget {
  const BattleMainScreen({super.key});

  @override
  State<BattleMainScreen> createState() => _BattleMainScreenState();
}

class _BattleMainScreenState extends State<BattleMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Battles'),
        bottom: TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Invitations'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateBattleScreen()),
        ),
        child: const Icon(Icons.add, size: 32),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BattleActiveScreen(),
          BattleInvitationsScreen(),
          BattleFinishedScreen(),
        ],
      ),
    );
  }
}
