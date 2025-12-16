import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePhoto(File photo, String uid) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final ref = _storage.ref('users/$uid/$today.jpg');
    await ref.putFile(photo);
    return await ref.getDownloadURL();
  }

  Future<String> uploadPostImage(File image) async {
    // Use Firebase Storage
    final ref = FirebaseStorage.instance.ref().child(
      'posts/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
