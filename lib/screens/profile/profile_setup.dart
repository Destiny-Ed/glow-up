import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/contacts/contact_sync.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load existing user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadUser();
    });
  }

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      context.read<UserViewModel>().updateAvatar(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile Setup',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<UserViewModel>(
            builder: (context, userVm, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Let\'s get you ready',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Colors.green,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    12.height(),
                    Text(
                      'Complete your profile to join the battle arena.',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    40.height(),

                    // Avatar
                    GestureDetector(
                      onTap: _pickAvatar,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 4),
                              image: userVm.avatarImage != null
                                  ? DecorationImage(
                                      image: FileImage(userVm.avatarImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : (userVm.user?.profilePictureUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              userVm.user!.profilePictureUrl!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null),
                            ),
                            child:
                                userVm.avatarImage == null &&
                                    userVm.user?.profilePictureUrl == null
                                ? const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white54,
                                    size: 50,
                                  )
                                : null,
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    40.height(),

                    // Username
                    _buildLabel('Username'),
                    TextFormField(
                      initialValue: userVm.username,
                      style: const TextStyle(color: Colors.white),
                      onChanged: userVm.updateUsername,
                      decoration: _inputDecoration(hintText: '@username'),
                    ),
                    20.height(),

                    // Phone
                    _buildLabel('Phone'),
                    TextFormField(
                      initialValue: userVm.phoneNumber,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      onChanged: userVm.updatePhone,
                      decoration: _inputDecoration(
                        hintText: '+1 (555) 123-4567',
                      ),
                    ),
                    20.height(),

                    // Gender
                    _buildLabel('Gender'),
                    DropdownButtonFormField<String>(
                      value: userVm.gender,
                      items:
                          [
                                'Select your gender',
                                'Male',
                                'Female',
                                'Non-binary',
                                'Prefer not to say',
                              ]
                              .map(
                                (g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(
                                    g,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => userVm.updateGender,
                      decoration: _inputDecoration(),
                      dropdownColor: Colors.grey[900],
                    ),
                    20.height(),

                    // Country
                    _buildLabel('Country'),
                    DropdownButtonFormField<String>(
                      value: userVm.country,
                      items:
                          [
                                'Where are you from?',
                                'United States',
                                'United Kingdom',
                                'Canada',
                                'Australia',
                                'Other',
                              ]
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => userVm.updateCountry,
                      decoration: _inputDecoration(),
                      dropdownColor: Colors.grey[900],
                    ),
                    20.height(),

                    // Date of Birth
                    _buildLabel('Date of Birth'),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: userVm.birthDate ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) userVm.updateBirthDate(date);
                      },
                      decoration: _inputDecoration(
                        hintText: userVm.birthDate == null
                            ? 'mm/dd/yyyy'
                            : '${userVm.birthDate!.month.toString().padLeft(2, '0')}/${userVm.birthDate!.day.toString().padLeft(2, '0')}/${userVm.birthDate!.year}',
                      ),
                    ),
                    8.height(),
                    Text(
                      'This won\'t be shown publicly.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                    ),
                    40.height(),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: userVm.isLoading ? "Saving..." : "Continue",
                        onTap: userVm.isLoading
                            ? null
                            : () async {
                                final success = await userVm.saveProfile();
                                if (success && mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ContactSyncScreen(),
                                    ),
                                  );
                                }
                              },
                      ),
                    ),
                    30.height(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
    );
  }
}
