import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/room_type.dart';

class RoomService {
  final String? baseUrl = dotenv.env['API_URL'];

  Future<List<RoomType>> fetchAvailableRoomTypes(
      String checkin, String checkout) async {
    // Đưa checkin và checkout vào query parameters
    final url = Uri.parse('$baseUrl/customer/available-room-types').replace(
      queryParameters: {
        'checkin': checkin,
        'checkout': checkout,
      },
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RoomType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load available room types');
    }
  }
}
