import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

class NotificationsView extends StatelessWidget {
  final List<NotificationItem> notifications;
  final Function(String) onDismiss;
  final Function(String) onMarkAsRead;

  const NotificationsView({
    super.key,
    required this.notifications,
    required this.onDismiss,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Stay informed about your brooder status',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        if (notifications.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: AppColors.pastelYellow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.check_circle, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text('No notifications', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                const SizedBox(height: 4),
                Text('All systems operating normally', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return GestureDetector(
                onTap: () {
                  if (!notification.read) onMarkAsRead(notification.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[100]!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Active indicator border simulation using Container border logic above isn't enough for just left border
                      // So we add a Row structure
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!notification.read)
                            Container(
                              width: 4,
                              height: 60,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.pastelYellowDark,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          
                          // Icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getBgColor(notification.type),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_getIcon(notification.type), size: 20, color: _getIconColor(notification.type)),
                          ),
                          const SizedBox(width: 12),
                          
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24.0), // Space for close button
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.message,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notification.timestamp,
                                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Dismiss Button
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onDismiss(notification.id),
                          child: Icon(Icons.close, size: 16, color: Colors.grey[400]),
                        ),
                      ),

                      // Unread Dot
                      if (!notification.read)
                        const Positioned(
                          top: 0,
                          right: 32,
                          child: CircleAvatar(radius: 4, backgroundColor: AppColors.pastelYellowDark),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getBgColor(String type) {
    switch (type) {
      case 'warning': return AppColors.orange50;
      case 'success': return AppColors.green50;
      default: return AppColors.blue50;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'warning': return Icons.warning_amber_rounded;
      case 'success': return Icons.check_circle_outline;
      default: return Icons.info_outline;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'warning': return AppColors.warning;
      case 'success': return AppColors.success;
      default: return Colors.blue;
    }
  }
}