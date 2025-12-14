import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? uid;

  DatabaseService({this.uid});

  // Post daily photo
  Future<void> postDailyPhoto(String photoUrl) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    await _db.collection('users').doc(uid).collection('posts').doc(today).set({
      'photoUrl': photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'votes': {'fire': 0, 'solid': 0, 'meh': 0},
    });
  }

  // Vote on a post
  Future<void> voteOnPost(String friendUid, String voteType) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final postRef = _db.collection('users').doc(friendUid).collection('posts').doc(today);
    await postRef.update({
      'votes.$voteType': FieldValue.increment(1),
    });
  }

  // Get friends' posts stream
  Stream<QuerySnapshot> getFriendsPosts() {
    // Assume friends list stored in user doc; fetch dynamically
    return _db.collectionGroup('posts').where('timestamp', isGreaterThan: DateTime.now().subtract(const Duration(days: 1))).snapshots();
  }

  // Crown winner (run via cloud function ideally, but simulate here)
  Future<String?> getDailyWinner() async {
    // Logic to tally votes and return winner UID/photo
    return null; // Placeholder
  }
}