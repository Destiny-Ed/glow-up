
import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/leaderboard_service.dart';

class LeaderboardViewModel extends BaseViewModel {
  final LeaderboardService _service = LeaderboardService();
  List<Map<String, dynamic>> _rankings = [];
  String _period = 'alltime';
  String _scope = 'global';

  List<Map<String, dynamic>> get rankings => _rankings;
  String get period => _period;
  String get scope => _scope;

  Future<void> loadLeaderboard(String currentUid) async {
    setLoading(true);
    try {
      _rankings = await _service.getLeaderboard(
        period: _period,
        scope: _scope,
        currentUid: currentUid,
      );
    } catch (e) {
      setError('Failed to load leaderboard');
    }
    setLoading(false);
  }

  void setPeriod(String newPeriod) {
    _period = newPeriod;
    notifyListeners();
  }

  void setScope(String newScope) {
    _scope = newScope;
    notifyListeners();
  }
}