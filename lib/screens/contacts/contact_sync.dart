import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/contact_viewmodel.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ContactSyncScreen extends StatefulWidget {
  const ContactSyncScreen({super.key});

  @override
  State<ContactSyncScreen> createState() => _ContactSyncScreenState();
}

class _ContactSyncScreenState extends State<ContactSyncScreen> {
  @override
  void initState() {
    super.initState();
    // Start sync automatically on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactViewModel>().syncContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactViewModel>(
      builder: (context, contactVm, child) {
        final friendsCount = contactVm.friendsFound;
        final foundUsers = contactVm.usersOnApp;

        // Build avatar list from real found users
        final List<CachedNetworkImageProvider> avatars = foundUsers.isEmpty
            ? List.generate(
                0,
                (i) => const CachedNetworkImageProvider(
                  'https://i.pravatar.cc/150',
                ),
              )
            : foundUsers
                  .map(
                    (user) => CachedNetworkImageProvider(
                      user['profilePictureUrl'] ?? 'https://i.pravatar.cc/150',
                    ),
                  )
                  .toList();

        return Container(
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
            appBar: AppBar(
              title: Text("Find Opponents".cap),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  20.height(),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Who do you want to\n",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(fontSize: 30),
                        ),
                        TextSpan(
                          text: "battle?",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  10.height(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Text(
                      "Challenge your friends to a daily outfit.\nCheck and see who wins the vote."
                          .capitalize,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Spacer(),

                  // Real avatars from found friends
                  AnimatedAvatarStack(height: 60, avatars: avatars),

                  20.height(),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Theme.of(context).cardColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          friendsCount > 0
                              ? "$friendsCount contacts are already here — join them?"
                              : "No friends found yet",
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: friendsCount > 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Sync Button
                  SocialButton(
                    color: Theme.of(context).primaryColor,
                    text: contactVm.isLoading
                        ? "Syncing..."
                        : "Sync Contacts".cap,
                    icon: contactVm.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.contact_mail, color: Colors.white),
                    onTap: () {
                      if (contactVm.isLoading) return;
                      context.read<ContactViewModel>().syncContacts();
                    },
                  ),

                  20.height(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "We securely hash your contacts to find friends. Your address book is never uploaded or stored.\n\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: "Skip for now".cap,
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CameraScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),

                  30.height(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
