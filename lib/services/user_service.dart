import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_up/models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String currentUid;

  UserService(this.currentUid);

  CollectionReference get users => _db.collection('users');

  Future<UserModel> getUser(String uid) async {
    final doc = await users.doc(uid).get();
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<UserModel> getCurrentUser() async {
    final doc = await users.doc(currentUid).get();
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateProfile(UserModel user) async {
    await users.doc(currentUid).update(user.toJson());
  }

  Future<bool> isUsernameAvailable(String username) async {
    if (username.isEmpty) return false;

    final lower = username.toLowerCase(); // Remove @ and lowercase

    final doc = await _db.collection('usernames').doc(lower).get();

    if (!doc.exists) {
      return true;
    }

    // Username exists — check if it's owned by current user
    final currentUser = await getCurrentUser();
    if (currentUser.userName == null) return false;

    return currentUser.userName?.toLowerCase() == lower;
  }

  // Reserve username on save
  Future<void> reserveUsername(String username, String uid) async {
    final lower = username.replaceFirst('@', '').toLowerCase();
    await _db.collection('usernames').doc(lower).set({
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Send friend request
  Future<void> sendFriendRequest(String targetUid) async {
    final batch = _db.batch();
    batch.update(users.doc(currentUid), {
      'sentRequestUids': FieldValue.arrayUnion([targetUid]),
    });
    batch.update(users.doc(targetUid), {
      'pendingRequestUids': FieldValue.arrayUnion([currentUid]),
    });
    await batch.commit();
  }

  // Accept friend request
  Future<void> acceptFriendRequest(String requesterUid) async {
    final batch = _db.batch();
    batch.update(users.doc(currentUid), {
      'friendUids': FieldValue.arrayUnion([requesterUid]),
      'pendingRequestUids': FieldValue.arrayRemove([requesterUid]),
    });
    batch.update(users.doc(requesterUid), {
      'friendUids': FieldValue.arrayUnion([currentUid]),
      'sentRequestUids': FieldValue.arrayRemove([currentUid]),
    });
    await batch.commit();
  }

  // Get friend requests
  Future<List<UserModel>> getFriendRequests() async {
    final doc = await users.doc(currentUid).get();
    final requesterUids = List<String>.from(doc['pendingRequestUids'] ?? []);

    if (requesterUids.isEmpty) return [];

    final futures = requesterUids.map((uid) => getUser(uid));
    return await Future.wait(futures);
  }

  // Get friends (fresh data)
  Future<List<UserModel>> getFriends() async {
    final doc = await users.doc(currentUid).get();
    final friendUids = List<String>.from(doc['friendUids'] ?? []);

    if (friendUids.isEmpty) return [];

    final futures = friendUids.map((uid) => getUser(uid));
    return await Future.wait(futures);
  }

  // In UserService

  Future<List<UserModel>> getUsersByUids(List<String> uids) async {
    if (uids.isEmpty) return [];

    final snapshots = await Future.wait(uids.map((id) => users.doc(id).get()));
    return snapshots
        .where((s) => s.exists)
        .map((s) => UserModel.fromJson(s.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> declineFriendRequest(String requesterUid) async {
    final batch = _db.batch();
    batch.update(users.doc(currentUid), {
      'pendingRequestUids': FieldValue.arrayRemove([requesterUid]),
    });
    batch.update(users.doc(requesterUid), {
      'sentRequestUids': FieldValue.arrayRemove([currentUid]),
    });
    await batch.commit();
  }

  // Search users
  Future<List<UserModel>> searchUsers(String query, {int limit = 20}) async {
    final lower = query.toLowerCase();
    final snapshot = await users
        .where('usernameLower', isGreaterThanOrEqualTo: lower)
        .where('usernameLower', isLessThanOrEqualTo: '$lower\uf8ff')
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<UserModel?> getTodaysWinner() async {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final doc = await _db.collection('daily_winners').doc(todayStr).get();

    if (!doc.exists) return null;

    final winnerUid = doc['winnerUserId'];
    return await UserService(winnerUid).getUser(winnerUid);
  }

  // Add this method to your existing UserService

  Future<bool> hasUserPostedToday(String uid) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('posts')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThanOrEqualTo: endOfDay)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Or global feed version (more accurate)
  Future<bool> hasUserPostedTodayGlobal(String uid) async {
    final today = DateTime.now();
    final startOfDay = Timestamp.fromDate(
      DateTime(today.year, today.month, today.day),
    );

    final snapshot = await _db
        .collection('feed_posts')
        .where('userId', isEqualTo: uid)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> makeProfilePrivate(String uid, bool isPrivate) async {
    await _db.collection('users').doc(uid).update({
      'isProfilePrivate': isPrivate,
    });
  }
}
