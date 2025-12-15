import 'dart:developer' as developer;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/screens/camera/camera_screen.dart';
import 'package:glow_up/services/contact_service.dart'; // Your new file name
import 'package:glow_up/widgets/custom_button.dart';

class ContactSyncScreen extends StatefulWidget {
  const ContactSyncScreen({super.key});

  @override
  State<ContactSyncScreen> createState() => _ContactSyncScreenState();
}

class _ContactSyncScreenState extends State<ContactSyncScreen> {
  bool _isLoading = false;
  int _friendsOnAppCount = 0; // You'll update this after backend check

  Future<void> _syncContacts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final contacts = await AppContactService().requestAndGetContacts();

    setState(() => _isLoading = false);

    if (contacts.isEmpty) {
      Fluttertoast.showToast(msg: 'No contacts found or permission denied');
      return;
    }

    developer.log('Fetched ${contacts.length} contacts successfully!');

    // TODO: Send hashed phone numbers/emails to your backend to find matches
    // For now, simulate finding some friends
    setState(() => _friendsOnAppCount = 12); // Replace with real count

    Fluttertoast.showToast(msg: 'Synced ${contacts.length} contacts!');
  }

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => const CircleAvatar(radius: 30),
                ),
              ),
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
                      "$_friendsOnAppCount contacts are already here",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: _friendsOnAppCount > 0
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SocialButton(
                color: Theme.of(context).primaryColor,
                text: _isLoading ? "Syncing..." : "Sync Contacts".cap,
                icon: const Icon(Icons.contact_mail, color: Colors.white),
                onTap: () {
                  // if (_isLoading == true) return;
                  // _syncContacts();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen()),
                  );
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
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(decoration: TextDecoration.underline),

                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pop(context), // Or go next
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
  }
}
