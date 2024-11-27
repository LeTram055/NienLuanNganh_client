import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/notification.dart';

class NotificationService {
  // Địa chỉ API backend
  final String? baseUrl = dotenv.env['API_URL'];

  Future<List<NotificationModel>> fetchNotifications(int customerId) async {
    print('customerId: $customerId');
    final response =
        await http.get(Uri.parse('$baseUrl/notifications/$customerId'));
    print('$baseUrl/notifications/$customerId');
    print('Error: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Thât bại khi lấy thông báo');
    }
  }

  Future<void> createNotification(int customerId, String message) async {
    print('customerId: $customerId');
    print('message: $message');
    final response = await http.post(
      Uri.parse('$baseUrl/notifications'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'customer_id': customerId, 'message': message}),
    );
    print('Error: ${response.statusCode}');
    if (response.statusCode != 201) {
      throw Exception('Thất bại khi tạo thông báo');
    }
  }
}
