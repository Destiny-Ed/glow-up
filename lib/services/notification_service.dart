import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_up/models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? uid;

  NotificationService({required this.uid});

  // Send notification
  Future<void> sendNotification(NotificationModel notificationData) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .add(notificationData.toJson());
  }

  // Get notifications stream
  Stream<List<NotificationModel>> getNotifications() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}
