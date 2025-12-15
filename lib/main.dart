// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:glow_up/screens/onboarding_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const GlowUpApp());
// }

// class GlowUpApp extends StatelessWidget {
//   const GlowUpApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'GlowUp',
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           foregroundColor: Colors.black,
//         ),
//         textTheme: GoogleFonts.poppinsTextTheme(
//           Theme.of(context).textTheme.apply(bodyColor: Colors.black),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepOrange,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           ),
//         ),
//         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(background: Colors.white),
//       ),
//       home: const OnboardingScreen(),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/constants.dart';
import 'package:glow_up/firebase_options.dart';
import 'package:glow_up/providers/auth.dart';
import 'package:glow_up/providers/glow_up.dart';
import 'package:glow_up/providers/settings.dart';
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
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => GlowUpProvider()),
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
