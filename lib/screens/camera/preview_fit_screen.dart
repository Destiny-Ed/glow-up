import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/main_activity/main_activity.dart';
import 'package:glow_up/providers/post_vm.dart';
import 'package:glow_up/services/storage_service.dart';
import 'package:glow_up/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class PreviewFitScreen extends StatefulWidget {
  final File imageFile;
  const PreviewFitScreen({super.key, required this.imageFile});

  @override
  State<PreviewFitScreen> createState() => _PreviewFitScreenState();
}

class _PreviewFitScreenState extends State<PreviewFitScreen> {
  final TextEditingController _tagsController = TextEditingController();

  @override
  void dispose() {
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _postFit() async {
    final postVm = context.read<PostViewModel>();

    // Extract hashtags
    final String tagsText = _tagsController.text.trim();
    final List<String> hashtags = tagsText
        .split(RegExp(r'\s+'))
        .where((tag) => tag.startsWith('#'))
        .map((tag) => tag.toLowerCase())
        .toList();

    final success = await postVm.uploadTodayPost(
      image: widget.imageFile,
      caption: _tagsController.text.isEmpty ? null : _tagsController.text,
      hashtags: hashtags,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainActivityScreen()),
        (route) => false,
      );
    } else {
      Fluttertoast.showToast(msg: postVm.errorMessage ?? 'Failed to post fit');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Preview Fit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Image Preview
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(
                  widget.imageFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            30.height(),

            // Ready Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  10.width(),
                  Text(
                    'Ready to battle',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            40.height(),

            // Tags Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _tagsController,
                style: const TextStyle(color: Colors.white),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  suffixText: 'e.g. #Streetwear #DateNight',
                  suffixStyle: const TextStyle(color: Colors.white54),
                ),
              ),
            ),

            50.height(),

            // Post Button
            Consumer<PostViewModel>(
              builder: (context, postVm, child) {
                return SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: postVm.isLoading ? "POSTING..." : "POST FIT >",
                    onTap: postVm.isLoading ? null : _postFit,
                  ),
                );
              },
            ),

            20.height(),

            // Retake
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Retake Photo',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

            30.height(),
          ],
        ),
      ),
    );
  }
}
