import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../managers/notification_manager.dart';
import '../../managers/customer_manager.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notification';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerId =
        Provider.of<CustomerManager>(context, listen: false).customer!.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
      ),
      body: FutureBuilder(
        future: Provider.of<NotificationManager>(context, listen: false)
            .loadNotifications(customerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          } else {
            return Consumer<NotificationManager>(
              builder: (context, notificationManager, child) {
                final notifications = notificationManager.notifications;

                if (notifications.isEmpty) {
                  return const Center(
                    child: Text('Không có thông báo nào.'),
                  );
                }

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(
                          notification.message,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          'Ngày: ${notification.createdAt}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
