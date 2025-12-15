import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlowUpProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _todayPosts = [];
  bool _isLoading = true;
  Map<String, dynamic>? _todayWinner; // For crown screen

  List<Map<String, dynamic>> get todayPosts => _todayPosts;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get todayWinner => _todayWinner;

  Future<void> fetchTodayPosts({bool friendsOnly = true}) async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final today = DateTime.now().toIso8601String().split('T')[0];
    Query query = FirebaseFirestore.instance
        .collectionGroup('posts')
        .where('date', isEqualTo: today)
        .orderBy('timestamp', descending: true);

    // If friendsOnly, add whereIn or subcollection logic (expand later)
    final snapshot = await query.get();
    _todayPosts = [];
    // _todayPosts = snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> voteOnPost(String postId, String voteType) async {
    // Increment vote in Firestore
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'votes.$voteType': FieldValue.increment(1),
    });
    notifyListeners();
  }

  Future<void> checkAndSetWinner() async {
    // Simulate or fetch winner (run via cloud function in production)
    // For demo, pick highest fire votes
    if (_todayPosts.isNotEmpty) {
      _todayWinner = _todayPosts.reduce(
        (a, b) => (a['votes']['fire'] ?? 0) > (b['votes']['fire'] ?? 0) ? a : b,
      );
      notifyListeners();
    }
  }
}
