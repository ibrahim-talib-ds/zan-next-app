// ZanNext — NotificationRepository

import '../models/notification.dart';
import '../services/api_client.dart';

class NotificationRepository {
  /// List notifications for a user.
  static Future<List<AppNotification>> listForUser(
    String userId, {
    bool unreadOnly = false,
  }) async {
    final path = unreadOnly
        ? '/notifications?user_id=$userId&unread_only=true'
        : '/notifications?user_id=$userId';
    final result = await ApiClient.get(path) as List;
    return result
        .map((j) => AppNotification.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Get a single notification by id.
  static Future<AppNotification> get(String id) async {
    final result = await ApiClient.get('/notifications/$id');
    return AppNotification.fromJson(result as Map<String, dynamic>);
  }

  /// Mark one notification as read.
  static Future<void> markRead(String notificationId) async {
    await ApiClient.patch('/notifications/$notificationId/read');
  }

  /// Mark all notifications as read for the current user.
  static Future<int> markAllRead() async {
    final result = await ApiClient.post('/notifications/read-all');
    final data = result as Map<String, dynamic>;
    return data['marked_read'] as int? ?? 0;
  }
}
