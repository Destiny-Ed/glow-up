import 'package:glow_up/models/notification_model.dart';
import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/notification_service.dart';

class NotificationViewModel extends BaseViewModel {
  late NotificationService _service;
  late String uid;

  List<NotificationModel> allNotifications = [];
  List<NotificationModel> filteredNotifications = [];

  String currentFilter = 'All'; // All, Battles, Votes, Requests

  void initialize(String userUid) {
    uid = userUid;
    _service = NotificationService(uid: uid);
    listenToNotifications();
  }

  void listenToNotifications() {
    setLoading(true);
    _service.getNotifications().listen(
      (newNotifications) {
        allNotifications = newNotifications
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
        applyFilter();
        setLoading(false);
      },
      onError: (e) {
        setError('Failed to load notifications');
        setLoading(false);
      },
    );
  }

  void applyFilter() {
    switch (currentFilter) {
      case 'Battles':
        filteredNotifications = allNotifications
            .where(
              (n) =>
                  n.type == NotificationType.battleInvite ||
                  n.type == NotificationType.battleAccepted ||
                  n.type == NotificationType.battleEnded,
            )
            .toList();
        break;
      case 'Votes':
        filteredNotifications = allNotifications
            .where((n) => n.type == NotificationType.voteReceived)
            .toList();
        break;
      case 'Requests':
        filteredNotifications = allNotifications
            .where((n) => n.type == NotificationType.friendRequest)
            .toList();
        break;
      default:
        filteredNotifications = allNotifications;
    }
    notifyListeners();
  }

  void setFilter(String filter) {
    currentFilter = filter;
    applyFilter();
  }

  Future<void> markAsRead(String id) async {
    await _service.markAsRead(id);
    final notif = allNotifications.firstWhere((n) => n.id == id);
    notif.copyWith(isRead: true);
    notifyListeners();
  }

  int get unreadCount => allNotifications.where((n) => !n.isRead).length;
}
