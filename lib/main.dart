import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/constants.dart';
import 'package:glow_up/firebase_options.dart';
import 'package:glow_up/providers/auth.dart';
import 'package:glow_up/providers/battle_viewmodel.dart';
import 'package:glow_up/providers/contact_viewmodel.dart';
import 'package:glow_up/providers/leaderboard_viewmodel.dart';
import 'package:glow_up/providers/notification_vm.dart';
import 'package:glow_up/providers/profile_vm.dart';
import 'package:glow_up/providers/settings.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/authentication/splash.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GlowUpApp());
}

class GlowUpApp extends StatelessWidget {
  const GlowUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardViewModel()),
        ChangeNotifierProvider(create: (_) => ContactViewModel()),
        // Only global providers here — NO UID-dependent ones
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingVm, _) {
          return MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingVm.isLightTheme
                ? ThemeMode.light
                : ThemeMode.dark,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
