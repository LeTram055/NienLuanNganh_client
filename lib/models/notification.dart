class NotificationModel {
  final int id;
  final int customerId;
  final String message;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.customerId,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['notification_id'],
      customerId: json['customer_id'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
