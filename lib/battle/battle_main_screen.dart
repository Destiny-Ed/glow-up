import 'package:flutter/material.dart';
import 'package:glow_up/battle/active_battle.dart';
import 'package:glow_up/battle/battle_finished.dart';
import 'package:glow_up/battle/battle_invitation.dart';
import 'package:glow_up/battle/create_battle.dart';

class BattleMainScreen extends StatefulWidget {
  const BattleMainScreen({super.key});

  @override
  State<BattleMainScreen> createState() => _BattleMainScreenState();
}

class _BattleMainScreenState extends State<BattleMainScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Battles', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Invitations'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateBattleScreen())),
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