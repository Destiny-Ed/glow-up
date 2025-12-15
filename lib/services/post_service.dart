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
  Future<void> firePost(String postId) async {
    final likeRef = feed.doc(postId).collection('fires').doc(currentUid);
    final postRef = feed.doc(postId);

    final doc = await likeRef.get();
    if (doc.exists) return; // Already fired

    final batch = _db.batch();
    batch.set(likeRef, {'timestamp': FieldValue.serverTimestamp()});
    batch.update(postRef, {'fireCount': FieldValue.increment(1)});
    await batch.commit();
  }

  // Paginated today's feed
  Stream<List<PostModel>> getTodaysFeed({
    DocumentSnapshot? startAfter,
    int limit = 20,
  }) {
    final today = DateTime.now();
    final startOfDay = Timestamp.fromDate(
      DateTime(today.year, today.month, today.day),
    );

    Query query = feed
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startAfter != null) query = query.startAfterDocument(startAfter);

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList(),
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
