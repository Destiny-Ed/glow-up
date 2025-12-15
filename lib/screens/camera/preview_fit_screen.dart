import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glow_up/main_activity/main_activity.dart';
import 'package:glow_up/widgets/custom_button.dart';

class PreviewFitScreen extends StatefulWidget {
  final File imageFile;
  const PreviewFitScreen({super.key, required this.imageFile});

  @override
  State<PreviewFitScreen> createState() => _PreviewFitScreenState();
}

class _PreviewFitScreenState extends State<PreviewFitScreen> {
  final TextEditingController _tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Preview Fit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.file(widget.imageFile, fit: BoxFit.cover),
                ),
              ),
            ),

            // Ready Badge
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    'Ready to battle',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Tags Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _tagsController,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: 'Add title or tags (optional)...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.tag, color: Colors.white54),
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
                  suffixText: 'e.g. #Streetwear #DateNight',
                  suffixStyle: const TextStyle(color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Post Button
            CustomButton(
              text: "post fit".toUpperCase(),
              onTap: () {
                // Upload post logic
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainActivityScreen()),
                  (route) => false,
                );
              },
            ),

            // Retake
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Retake Photo',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
