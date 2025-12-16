import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/core/utils.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/screens/contacts/contact_sync.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load existing user data
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Profile Setup'),
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
                            color: Theme.of(context).primaryColor,
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
                      onTap: () {
                        ImagePickerUtil().pickImageWithDialog(context).then((
                          picked,
                        ) {
                          if (picked != null) {
                            userVm.updateAvatar(File(picked.path));
                          }
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 4,
                              ),
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
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor,
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
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: _usernameController,

                        style: Theme.of(context).textTheme.titleMedium,
                        onChanged: (value) {
                          userVm.updateUsername(value);
                          userVm.checkUsername(value);
                        },
                        decoration: InputDecoration(
                          hintText: "@username",
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          suffixIcon: userVm.isCheckingUsername
                              ? SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : userVm.isUsernameAvailable
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                )
                              : const Icon(Icons.error, color: Colors.red),
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
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Error text
                    if (userVm.usernameError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          userVm.usernameError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    20.height(),

                    // Phone
                    _buildLabel('Phone'),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.titleMedium,
                        onChanged: userVm.updatePhone,
                        decoration: _inputDecoration(
                          hintText: '+1 (555) 123-4567',
                        ),
                      ),
                    ),
                    20.height(),

                    // Gender
                    _buildLabel('Gender'),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonFormField<String>(
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          userVm.updateGender(value);
                        },
                        decoration: _inputDecoration(),
                        dropdownColor: Colors.grey[900],
                      ),
                    ),
                    20.height(),

                    // Country
                    _buildLabel('Country'),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonFormField<String>(
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          userVm.updateCountry(value);
                        },
                        decoration: _inputDecoration(),
                        dropdownColor: Colors.grey[900],
                      ),
                    ),
                    20.height(),

                    // Date of Birth
                    _buildLabel('Date of Birth'),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: _dobController,
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
                    ),
                    8.height(),
                    Text(
                      'This won\'t be shown publicly.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    20.height(),

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
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        userVm.errorMessage ??
                                        'Failed to save profile. Please try again.',
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.titleMedium,
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
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
    );
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userVm = context.read<UserViewModel>();
      await userVm.loadUser();

      if (mounted) {
        _usernameController.text = userVm.username;
        _phoneController.text = userVm.phoneNumber;
        if (userVm.birthDate != null) {
          _dobController.text =
              '${userVm.birthDate!.month.toString().padLeft(2, '0')}/${userVm.birthDate!.day.toString().padLeft(2, '0')}/${userVm.birthDate!.year}';
        }
      }
    });
  }
}
