import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationManager with ChangeNotifier {
  final NotificationService _service = NotificationService();
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  Future<void> loadNotifications(int customerId) async {
    try {
      print('Customer ID: $customerId');
      _notifications = await _service.fetchNotifications(customerId);
      print('Notifications: $_notifications');
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addNotification(int customerId, String message) async {
    try {
      await _service.createNotification(customerId, message);
      await loadNotifications(customerId); // Reload notifications
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteNotification(int notificationId, int customerId) async {
    try {
      await _service.deleteNotification(notificationId);
      await loadNotifications(
          customerId); // Cập nhật danh sách thông báo sau khi xóa
    } catch (error) {
      rethrow;
    }
  }
}
