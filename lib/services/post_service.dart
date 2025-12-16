import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_up/models/post_model.dart';
import 'package:glow_up/services/user_service.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String currentUid;

  PostService(this.currentUid);

  // Global feed collection
  CollectionReference get feed => _db.collection('feed_posts');

  // Add post (denormalized to global feed)
  Future<void> addPost(PostModel post) async {
    final batch = _db.batch();

    // User's profile posts
    batch.set(
      _db.collection('users').doc(currentUid).collection('posts').doc(post.id),
      post.toJson(),
    );

    // Global feed
    batch.set(feed.doc(post.id), {...post.toJson(), 'userId': currentUid});

    await batch.commit();
  }

  // Fire vote (separate collection)
  // In PostViewModel or PostService

  Future<void> firePost(String postId, String postOwnerId) async {
    final String uid = currentUid; // Already set in service/viewmodel

    final DocumentReference postRef = _db.collection('feed_posts').doc(postId);
    final DocumentReference fireRef = postRef.collection('fires').doc(uid);
    final DocumentReference userRef = _db
        .collection('users')
        .doc(postOwnerId); // Owner of the post

    // Check if already fired
    final fireDoc = await fireRef.get();
    if (fireDoc.exists) {
      // Already voted — silently ignore (or throw if you want feedback)
      return;
    }

    // // Prevent self-voting
    // if (uid == postOwnerId) {
    //   return; // Or throw error: "Can't fire your own post"
    // }

    final WriteBatch batch = _db.batch();

    // 1. Record the individual fire vote
    batch.set(fireRef, {
      'timestamp': FieldValue.serverTimestamp(),
      'voterUid': uid,
    });

    // 2. Increment post fire count
    batch.update(postRef, {'fireCount': FieldValue.increment(1)});

    // 3. Increment lifetime votes for the POST OWNER
    batch.update(userRef, {'votes': FieldValue.increment(1)});

    // Commit all at once — atomic & consistent
    await batch.commit();
  }

  Future<void> likePost(String postId) async {
    final likeRef = feed.doc(postId).collection('likes').doc(currentUid);
    final postRef = feed.doc(postId);

    final doc = await likeRef.get();
    if (doc.exists) return; // Already fired

    final batch = _db.batch();
    batch.set(likeRef, {'timestamp': FieldValue.serverTimestamp()});
    batch.update(postRef, {'likesCount': FieldValue.increment(1)});
    await batch.commit();
  }

  // Paginated today's feed
  Stream<List<PostModel>> getTodaysFeed({
    DocumentSnapshot? startAfter,
    int limit = 20,
  }) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    Query query = feed
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
        )
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startAfter != null) query = query.startAfterDocument(startAfter);

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        log(
          "data: ${PostModel.fromJson(doc.data() as Map<String, dynamic>).toJson()}",
        );
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList(),
    );
  }

  Future<bool> canUserPostToday(String uid) async {
    return !(await UserService(uid).hasUserPostedTodayGlobal(uid));
  }

  Stream<List<PostModel>> getUserPostsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // For current user
  Stream<List<PostModel>> getMyPostsStream() => getUserPostsStream(currentUid);
}
