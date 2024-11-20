import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/room_type.dart';

class ReservationService {
  final String? baseUrl = dotenv.env['API_URL'];

  Future<List<RoomType>> fetchAvailableRoomTypes(
      String checkin, String checkout) async {
    final url = Uri.parse('$baseUrl/available-room-types').replace(
      queryParameters: {
        'checkin': checkin,
        'checkout': checkout,
      },
    );

    final response = await http.get(url);
    print('Response status: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RoomType.fromJson(json)).toList();
    } else {
      throw Exception('Thất bại khi lấy thông tin phòng trống');
    }
  }

  Future<void> createReservation({
    required int customerId,
    required String checkinDate,
    required String checkoutDate,
    required List<int> roomIds,
  }) async {
    final url = Uri.parse('$baseUrl/reservations');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customer_id': customerId,
        'checkin': checkinDate,
        'checkout': checkoutDate,
        'room_ids': roomIds,
      }),
    );

    if (response.statusCode == 201) {
      print("Reservation successful: ${response.body}");
    } else {
      print("Thất bại để tạo đơn đặt phòng: ${response.body}");
      throw Exception('Thất bại để tạo đơn đặt phòng');
    }
  }
}
