import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/gen/assets.gen.dart';
import 'package:glow_up/providers/auth.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/contacts/contact_sync.dart';
import 'package:glow_up/screens/profile/profile_setup.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class SocialAuthScreen extends StatefulWidget {
  const SocialAuthScreen({super.key});

  @override
  State<SocialAuthScreen> createState() => _SocialAuthScreenState();
}

class _SocialAuthScreenState extends State<SocialAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).secondaryHeaderColor,
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).secondaryHeaderColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).cardColor,
                child: ClipOval(
                  child: Image.asset(
                    Assets.google.path, // Make sure you have a logo in assets
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              30.height(),

              Text(
                "Outfit Clash".cap,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              12.height(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Text(
                  "Rate fits. Win battles. Daily.".capitalize,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Social Buttons with ViewModel
              Consumer<AuthViewModel>(
                builder: (context, authVm, child) {
                  return Column(
                    children: [
                      // Google Sign In
                      SocialButton(
                        text: authVm.isLoading
                            ? "Loading...".cap
                            : "Continue with Google".cap,
                        icon: Image.asset(Assets.google.path, width: 30),

                        onTap: authVm.isLoading
                            ? null
                            : () async {
                                final result = await authVm.signInWithGoogle();

                                context.read<UserViewModel>()
                                  ..uid = authVm.currentUid ?? ""
                                  ..initialize(authVm.currentUid ?? "");

                                if (result['user'] != null) {
                                  if (authVm.isNewUser) {
                                    // New user → Profile Setup
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ProfileSetupScreen(),
                                      ),
                                    );
                                  } else {
                                    // Returning user → Contact Sync (or Main if already synced)
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ContactSyncScreen(),
                                      ),
                                    );
                                  }
                                } else if (authVm.hasError) {
                                  Fluttertoast.showToast(
                                    msg:
                                        authVm.errorMessage ?? 'Sign in failed',
                                  );
                                }
                              },
                      ),

                      12.height(),

                      // Apple Sign In
                      SocialButton(
                        text: authVm.isLoading
                            ? "Loading...".cap
                            : "Continue with Apple".cap,
                        icon: const Icon(
                          Icons.apple,
                          size: 32,
                          color: Colors.white,
                        ),

                        onTap: authVm.isLoading
                            ? null
                            : () async {
                                final result = await authVm.signInWithApple();

                                context.read<UserViewModel>()
                                  ..uid = authVm.currentUid ?? ""
                                  ..initialize(authVm.currentUid ?? "");

                                if (result['user'] != null) {
                                  if (authVm.isNewUser) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ProfileSetupScreen(),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ContactSyncScreen(),
                                      ),
                                    );
                                  }
                                } else if (authVm.hasError) {
                                  Fluttertoast.showToast(
                                    msg:
                                        authVm.errorMessage ?? 'Sign in failed',
                                  );
                                }
                              },
                      ),
                    ],
                  );
                },
              ),

              30.height(),

              // Terms & Privacy
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  TextSpan(
                    children: [
                      const TextSpan(text: "By continuing, you agree to our "),
                      TextSpan(
                        text: "Terms of Service",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Open terms URL
                          },
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy.",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Open privacy URL
                          },
                      ),
                    ],
                  ),
                ),
              ),

              50.height(),
            ],
          ),
        ),
      ),
    );
  }
}
