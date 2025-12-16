import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_up/models/battle_model.dart';
import 'package:glow_up/models/post_model.dart';
import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/battle_service.dart';

class BattleViewModel extends BaseViewModel {
  late BattleService _service;
  late String uid;

  List<BattleModel> activeBattles = [];
  List<BattleModel> finishedBattles = [];
  List<Map<String, dynamic>> invitations = [];

  final _db = FirebaseFirestore.instance;

  void initialize(String userUid) {
    uid = userUid;
    _service = BattleService(uid);
    loadAll();
  }

  Future<void> loadAll() async {
    setLoading(true);
    await Future.wait([loadActive(), loadFinished(), loadInvitations()]);
    setLoading(false);
  }

  Future<BattleModel?> getBattleById(String battleId) async {
    final doc = await _service.battles.doc(battleId).get();
    if (!doc.exists) return null;
    return BattleModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getPostAndUser(
    String postId,
    String userId,
  ) async {
    final postSnap = await _db.collection('feed_posts').doc(postId).get();
    final userSnap = await _db.collection('users').doc(userId).get();

    return {
      'post': PostModel.fromJson(postSnap.data()!),
      'user': UserModel.fromJson(userSnap.data()!),
    };
  }

  Future<void> loadActive() async {
    setLoading(true);
    try {
      activeBattles = await _service.getActiveBattles().first;
    } catch (e) {
      setError('Failed to load active battles');
    }
    setLoading(false);
  }

  Future<void> loadFinished() async {
    setLoading(true);
    try {
      finishedBattles = await _service.getFinishedBattles().first;
    } catch (e) {
      setError('Failed to load finished battles');
    }
    setLoading(false);
  }

  Future<void> loadInvitations() async {
    setLoading(true);
    try {
      invitations = await _service.getInvitations().first;
    } catch (e) {
      setError('Failed to load invitations');
    }
    setLoading(false);
  }

  Future<void> createBattle({
    required String theme,
    String? caption,
    required Duration duration,
    required List<String> opponentUids,
  }) async {
    setLoading(true);
    try {
      await _service.createBattle(
        theme: theme,
        caption: caption,
        duration: duration,
        opponentUids: opponentUids,
      );
      await loadActive();
    } catch (e) {
      setError('Failed to create battle');
    }
    setLoading(false);
  }

  Future<void> acceptInvitation(String battleId, String invitationId) async {
    setLoading(true);
    try {
      await _service.acceptInvitation(battleId, invitationId);
      await loadAll();
    } catch (e) {
      setError('Failed to accept invitation');
    }
    setLoading(false);
  }
}
