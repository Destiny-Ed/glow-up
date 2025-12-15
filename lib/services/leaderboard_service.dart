import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getLeaderboard({
    required String period, // 'daily', 'weekly', 'alltime'
    required String scope,  // 'global' or 'friends'
    required String currentUid,
    int limit = 50,
  }) async {
    DateTime startDate;
    final now = DateTime.now();

    switch (period) {
      case 'daily':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'weekly':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'alltime':
      default:
        startDate = DateTime(2000); // Far past
    }

    final Timestamp startTimestamp = Timestamp.fromDate(startDate);

    // Base query: all posts in period
    final Query query = _db
        .collection('feed_posts')
        .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
        .orderBy('fireCount', descending: true);

    final snapshot = await query.get();

    // Aggregate votes per user
    final Map<String, int> userVotes = {};
    final Map<String, List<DocumentSnapshot>> userPosts = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final userId = data['userId'] as String;
      final fireCount = (data['fireCount'] ?? 0) as int;

      userVotes[userId] = (userVotes[userId] ?? 0) + fireCount;
      userPosts.putIfAbsent(userId, () => []);
      userPosts[userId]!.add(doc);
    }

    // Sort users by total votes
    final sortedUserIds = userVotes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Fetch user profiles
    final List<Map<String, dynamic>> rankings = [];
    int rank = 1;
    for (var entry in sortedUserIds.take(limit)) {
      final userSnap = await _db.collection('users').doc(entry.key).get();
      if (!userSnap.exists) continue;

      final userData = userSnap.data()!;
      rankings.add({
        'rank': rank++,
        'userId': entry.key,
        'userName': userData['userName'],
        'profilePictureUrl': userData['profilePictureUrl'],
        'totalFires': entry.value,
        'isCurrentUser': entry.key == currentUid,
      });
    }

    return rankings;
  }

  // Get current user's rank
  Future<int?> getMyRank(String period, String currentUid) async {
    final all = await getLeaderboard(period: period, scope: 'global', currentUid: currentUid, limit: 1000);
    final myEntry = all.where((e) => e['isCurrentUser']).toList();
    return myEntry.isEmpty ? null : myEntry.first['rank'];
  }
}