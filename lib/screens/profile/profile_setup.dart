import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/screens/contacts/contact_sync.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  File? _avatarImage;
  final TextEditingController _usernameController = TextEditingController(
    text: '@glowup_star',
  );
  final TextEditingController _phoneController = TextEditingController();
  String _gender = 'Select your gender';
  String _country = 'Where are you from?';
  DateTime? _birthDate;

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _avatarImage = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              Text(
                'Let\'s get you ready',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                'Complete your profile to join the\nbattle arena.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Avatar
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                        image: _avatarImage != null
                            ? DecorationImage(
                                image: FileImage(_avatarImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _avatarImage == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).cardColor,
                              size: 30,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.edit, size: 15),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Username
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: _usernameController,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
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
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phone',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: _phoneController,
                style: Theme.of(context).textTheme.titleMedium,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Enter phone number",
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              // Gender
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gender',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                items:
                    [
                          'Select your gender',
                          'Male',
                          'Female',
                          'Non-binary',
                          'Prefer not to say',
                        ]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                onChanged: (val) => setState(() => _gender = val!),
                decoration: InputDecoration(
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
                ),
                dropdownColor: Colors.grey[900],
              ),

              // Country
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Country',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              DropdownButtonFormField<String>(
                value: _country,
                items:
                    [
                          'Where are you from?',
                          'United States',
                          'United Kingdom',
                          'Canada',
                          'Australia',
                        ]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                onChanged: (val) => setState(() => _country = val!),
                decoration: InputDecoration(
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
                ),
                dropdownColor: Colors.grey[900],
              ),

              // Date of Birth
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date of Birth',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextField(
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _birthDate = date);
                },
                decoration: InputDecoration(
                  hintText: _birthDate == null
                      ? 'mm/dd/yyyy'
                      : '${_birthDate!.month}/${_birthDate!.day}/${_birthDate!.year}',
                  hintStyle: const TextStyle(color: Colors.white54),
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.white54,
                  ),
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
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'This won\'t be shown publicly.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              CustomButton(
                text: "continue",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ContactSyncScreen(),
                    ),
                  );
                },
              ),
              30.height(),
            ],
          ),
        ),
      ),
    );
  }
}
