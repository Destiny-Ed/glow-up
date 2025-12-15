import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/gen/assets.gen.dart';
import 'package:glow_up/screens/contacts/contact_sync.dart';
import 'package:glow_up/screens/profile/profile_setup.dart';
import 'package:glow_up/widgets/custom_button.dart';

class SocialAuthScreen extends StatefulWidget {
  const SocialAuthScreen({super.key});

  @override
  SocialAuthScreenState createState() => SocialAuthScreenState();
}

class SocialAuthScreenState extends State<SocialAuthScreen> {
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
              const Spacer(),

              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).cardColor,
                child: Image.asset(
                  Assets.google.path,
                  width: MediaQuery.of(context).size.width - 100,
                ),
              ),
              20.height(),
              Text(
                "outfit clash".cap,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 30),
              ),
              10.height(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Text(
                  "rate fits. Win battles. Daily".capitalize,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!
                    ..color?.darken(),
                ),
              ),
              Spacer(),
              //Social buttons
              SocialButton(
                text: "continue with apple".cap,
                icon: Image.asset(Assets.google.path, width: 35),
                onTap: () {},
              ),
              10.height(),
              SocialButton(
                text: "continue with apple".cap,
                icon: Icon(
                  Icons.apple,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileSetupScreen(),
                    ),
                  );
                },
              ),

              20.height(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!
                    ..color?.darken(),
                  TextSpan(
                    children: [
                      const TextSpan(text: "By continuing, you agree to our "),
                      TextSpan(
                        text: "terms or service ".cap,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).textTheme.titleMedium!.color!.darken(),
                        ),
                      ),
                      const TextSpan(text: "and "),
                      TextSpan(
                        text: "privacy policy.".cap,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).textTheme.titleMedium!.color!.darken(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
