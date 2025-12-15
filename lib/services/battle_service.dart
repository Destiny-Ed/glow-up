import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_up/models/battle_model.dart';

class BattleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String currentUid;

  BattleService(this.currentUid);

  CollectionReference get battles => _db.collection('battles');
  CollectionReference get invitations => _db.collection('battle_invitations');

  // Create new battle
  Future<String> createBattle({
    required String theme,
    String? caption,
    required Duration duration,
    required List<String> opponentUids,
  }) async {
    final docRef = battles.doc();
    final startTime = DateTime.now();

    final battle = BattleModel(
      id: docRef.id,
      creatorUid: currentUid,
      theme: theme,
      caption: caption,
      duration: duration,
      startTime: startTime,
      endTime: startTime.add(duration),
      opponentUids: opponentUids,
    );

    await docRef.set(battle.toJson());

    // Send invitations
    final batch = _db.batch();
    for (var opponent in opponentUids) {
      batch.set(invitations.doc('${docRef.id}_$opponent'), {
        'battleId': docRef.id,
        'fromUid': currentUid,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();

    return docRef.id;
  }

  // Accept invitation
  Future<void> acceptInvitation(String battleId, String invitationId) async {
    final batch = _db.batch();

    // Update invitation
    batch.update(invitations.doc(invitationId), {'status': 'accepted'});

    // Add to battle opponents
    batch.update(battles.doc(battleId), {
      'opponentUids': FieldValue.arrayUnion([currentUid]),
    });

    await batch.commit();
  }

  // Post to battle
  Future<void> postToBattle(String battleId, String postId) async {
    await battles.doc(battleId).update({'posts.$currentUid': postId});
  }

  // Vote in battle (on a specific post)
  Future<void> voteInBattle(String battleId, String targetUserId) async {
    final voteRef = battles.doc(battleId).collection('votes').doc(currentUid);
    if ((await voteRef.get()).exists) return; // Already voted

    final batch = _db.batch();
    batch.set(voteRef, {
      'targetUserId': targetUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    batch.update(battles.doc(battleId), {'voteCount': FieldValue.increment(1)});
    await batch.commit();
  }

  // Get active battles
  Stream<List<BattleModel>> getActiveBattles() {
    return battles
        .where('opponentUids', arrayContains: currentUid)
        .where('status', isEqualTo: 'active')
        .orderBy('startTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BattleModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  // Get invitations
  Stream<List<Map<String, dynamic>>> getInvitations() {
    return invitations
        .where('toUid', isEqualTo: currentUid)
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // Get finished battles
  Stream<List<BattleModel>> getFinishedBattles() {
    return battles
        .where('opponentUids', arrayContains: currentUid)
        .where('status', isEqualTo: 'finished')
        .orderBy('endTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BattleModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  // End battle (via scheduled function, but client can trigger if needed)
  Future<void> endBattle(String battleId) async {
    final snapshot = await battles.doc(battleId).collection('votes').get();
    final voteMap = <String, int>{};
    for (var doc in snapshot.docs) {
      voteMap.update(doc['targetUserId'], (v) => v + 1, ifAbsent: () => 1);
    }

    final winnerUid = voteMap.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    await battles.doc(battleId).update({
      'status': 'finished',
      'winnerUid': winnerUid,
    });
  }
}
