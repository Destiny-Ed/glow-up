import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/contact_service.dart';

class ContactViewModel extends BaseViewModel {
  final AppContactService _service = AppContactService();

  int friendsFound = 0;
  List<Map<String, dynamic>> usersOnApp = [];

  Future<void> syncContacts() async {
    setLoading(true);
    try {
      final result = await _service.syncAndFindFriends();
      friendsFound = result.friendsFoundOnApp;
      usersOnApp = result.usersOnApp;
    } catch (e) {
      setError('Sync failed');
    }
    setLoading(false);
  }
}
