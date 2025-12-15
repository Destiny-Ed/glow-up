import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/battle_service.dart';
import 'package:glow_up/models/battle_model.dart';

class BattleViewModel extends BaseViewModel {
  late BattleService _service;
  late String uid;
  List<BattleModel> activeBattles = [];
  List<BattleModel> finishedBattles = [];
  List<Map<String, dynamic>> invitations = [];

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

  Future<void> loadActive() async {
    setLoading(true);
    activeBattles = await _service.getActiveBattles().first;
    setLoading(false);
  }

  Future<void> loadFinished() async {
    setLoading(true);
    finishedBattles = await _service.getFinishedBattles().first;
    setLoading(false);
  }

  Future<void> loadInvitations() async {
    setLoading(true);
    invitations = await _service.getInvitations().first;
    setLoading(false);
  }
}
