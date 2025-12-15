import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/notification_service.dart';
import 'package:glow_up/models/notification_model.dart';

class NotificationViewModel extends BaseViewModel {
  late NotificationService _service;
  late String uid;
  List<NotificationModel> notifications = [];

  void initialize(String userUid) {
    uid = userUid;
    _service = NotificationService(uid: uid);
    setLoading(false);
  }

  void listenToNotifications() {
    _service.getNotifications().listen((newNotifications) {
      notifications = newNotifications;
      notifyListeners();
    });
  }

  Future<void> markAsRead(String id) async {
    await _service.markAsRead(id);
  }
}
