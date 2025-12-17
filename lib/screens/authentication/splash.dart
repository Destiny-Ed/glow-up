import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/main_activity/main_activity.dart';
import 'package:glow_up/providers/auth.dart';
import 'package:glow_up/providers/battle_viewmodel.dart';
import 'package:glow_up/providers/friends_vm.dart';
import 'package:glow_up/providers/notification_vm.dart';
import 'package:glow_up/providers/post_vm.dart';
import 'package:glow_up/providers/profile_vm.dart';
import 'package:glow_up/providers/settings.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/authentication/social_auth.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // Lottie.asset(
              //   'assets/lottie/bug-hunting.json',
              //   width: 200,
              // ), // Add your Lottie
              Text('GlowUp', style: Theme.of(context).textTheme.headlineLarge),
              20.height(),
              Text(
                'The daily outfit battel your friends\nare already playing.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Column(
                spacing: 10,
                children: [
                  const LinearProgressIndicator(),
                  Text("v1.2.0", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _init() async {
    final authVm = context.read<AuthViewModel>();
    await authVm.loadCurrentUser();
    Future.delayed(const Duration(seconds: 3), () {
      if (authVm.isLoggedIn) {
        final uid = authVm.currentUid!;
        _initAllUidViewModels(uid);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainActivityScreen()),
        );

        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SocialAuthScreen()),
      );
    });
  }

  void _initAllUidViewModels(String uid) {
    // Initialize all UID-dependent ViewModels
    context.read<UserViewModel>()
      ..uid = uid
      ..initialize(uid);
    context.read<ProfileViewModel>()
      ..uid = uid
      ..initialize(uid);
    context.read<BattleViewModel>()
      ..uid = uid
      ..initialize(uid);
    context.read<NotificationViewModel>()
      ..uid = uid
      ..initialize(uid);

    context.read<PostViewModel>()
      ..uid = uid
      ..initialize(uid);

    context.read<SettingsViewModel>()
      ..uid = uid
      ..initialize(uid);

    context.read<FriendsViewModel>()
      ..uid = uid
      ..initialize(uid);
  }
}
