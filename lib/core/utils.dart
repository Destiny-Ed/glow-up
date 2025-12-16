import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  final ImagePicker picker = ImagePicker();

  Future<File?> pickImageFile({
    ImageSource source = ImageSource.gallery,
  }) async {
    final picked = await picker.pickImage(source: source, imageQuality: 85);

    return picked != null ? File(picked.path) : null;
  }

  Future<File?> pickImageWithDialog(BuildContext context) async {
    final modal = await showModalBottomSheet<File?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                final picked = await pickImageFile(source: ImageSource.gallery);
                Navigator.of(context).pop(picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                final picked = await pickImageFile(source: ImageSource.camera);
                Navigator.of(context).pop(picked);
              },
            ),
          ],
        ),
      ),
    );

    return modal;
  }
}
