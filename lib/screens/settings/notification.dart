import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/core/extensions.dart';
import 'package:glow_up/models/notification_model.dart';
import 'package:glow_up/providers/notification_vm.dart';
import 'package:glow_up/widgets/empty_state.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationViewModel>(
      builder: (context, notifVm, child) {
        if (notifVm.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        final notifications = notifVm.filteredNotifications;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text(
              'Activity',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Badge(
                  label: Text('${notifVm.unreadCount}'),
                  isLabelVisible: notifVm.unreadCount > 0,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter Tabs
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    _filterChip(
                      'All',
                      notifVm.currentFilter == 'All',
                      () => notifVm.setFilter('All'),
                    ),
                    12.width(),
                    _filterChip(
                      'Battles',
                      notifVm.currentFilter == 'Battles',
                      () => notifVm.setFilter('Battles'),
                    ),
                    12.width(),
                    _filterChip(
                      'Votes',
                      notifVm.currentFilter == 'Votes',
                      () => notifVm.setFilter('Votes'),
                    ),
                    12.width(),
                    _filterChip(
                      'Requests',
                      notifVm.currentFilter == 'Requests',
                      () => notifVm.setFilter('Requests'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: notifications.isEmpty
                    ? emptyWidget(
                        context,
                        "No notifications yet",
                        "Notifications will appear when they are available",
                        icon: Icons.notification_add,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          return _notificationItem(
                            context,
                            notification: notif,
                            onTap: () => notifVm.markAsRead(notif.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).textTheme.titleMedium!.color,
          ),
        ),
      ),
    );
  }

  Widget _notificationItem(
    BuildContext context, {
    required NotificationModel notification,
    required VoidCallback onTap,
  }) {
    final bool hasAction =
        notification.type == NotificationType.battleInvite ||
        notification.type == NotificationType.friendRequest;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Theme.of(context).cardColor
              : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: notification.isRead
              ? null
              : Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar / Photo / Icon
            if (notification.imageUrl != null &&
                notification.type != NotificationType.dailyReminder)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: notification.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            else if (notification.type == NotificationType.dailyReminder)
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).cardColor.lighten(),
                child: Icon(
                  Icons.access_time,
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              )
            else
              CircleAvatar(
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(
                  notification.imageUrl ?? 'https://i.pravatar.cc/150',
                ),
              ),

            16.width(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  8.height(),
                  Text(
                    _formatTimeAgo(notification.timestamp),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (hasAction) ...[
                    12.height(),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle accept (battle or friend)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            notification.type == NotificationType.battleInvite
                                ? 'Accept'
                                : 'Confirm',
                            style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                        12.width(),
                        OutlinedButton(
                          onPressed: () {
                            // Handle decline
                          },
                          child: const Text('Decline'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            if (!notification.isRead)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays ~/ 7}w ago';
  }
}
