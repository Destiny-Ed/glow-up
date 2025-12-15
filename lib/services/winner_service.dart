// services/winner_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_up/models/daily_winner_model.dart';
import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/models/post_model.dart';

class WinnerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String currentUid;

  WinnerService(this.currentUid);

  CollectionReference get dailyWinners => _db.collection('daily_winners');

  /// Get today's winner (if processed)
  Future<DailyWinnerModel?> getTodaysWinner() async {
    final todayStr = DateTime.now().toIso8601String().split('T')[0]; // "2025-12-15"
    final doc = await dailyWinners.doc(todayStr).get();

    if (!doc.exists) return null;

    return DailyWinnerModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// Check if current user won today
  Future<bool> didIWinToday() async {
    final winner = await getTodaysWinner();
    return winner != null && winner.winnerUserId == currentUid;
  }

  /// Get winner details with full UserModel + PostModel
  Future<Map<String, dynamic>?> getTodaysWinnerDetails() async {
    final winner = await getTodaysWinner();
    if (winner == null) return null;

    final userSnap = await _db.collection('users').doc(winner.winnerUserId).get();
    final postSnap = await _db.collection('feed_posts').doc(winner.winnerPostId).get();

    if (!userSnap.exists || !postSnap.exists) return null;

    return {
      'winner': DailyWinnerModel.fromJson(winner.toJson()),
      'user': UserModel.fromJson(userSnap.data() as Map<String, dynamic>),
      'post': PostModel.fromJson(postSnap.data() as Map<String, dynamic>),
    };
  }

  /// Get past winners (for leaderboard/history)
  Stream<List<DailyWinnerModel>> getPastWinners({int limit = 30}) {
    return dailyWinners
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DailyWinnerModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Get specific date winner
  Future<DailyWinnerModel?> getWinnerByDate(String dateStr) async {
    final doc = await dailyWinners.doc(dateStr).get();
    if (!doc.exists) return null;
    return DailyWinnerModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// Listen to today's winner in real-time (for crown animation trigger)
  Stream<DailyWinnerModel?> todaysWinnerStream() {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    return dailyWinners.doc(todayStr).snapshots().map((doc) {
      if (!doc.exists) return null;
      return DailyWinnerModel.fromJson(doc.data() as Map<String, dynamic>);
    });
  }
}