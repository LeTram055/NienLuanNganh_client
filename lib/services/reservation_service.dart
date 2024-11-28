import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/room_type.dart';
import '../models/reservation.dart';
import '../models/room.dart';

class ReservationService {
  final String? baseUrl = dotenv.env['API_URL'];

  Future<String> saveToDownloads(String filePath) async {
    try {
      final file = File(filePath);

      // Lấy đường dẫn thư mục Tải xuống (Android)
      final downloadsDirectory = Directory('/storage/emulated/0/Download');

      if (!await downloadsDirectory.exists()) {
        throw Exception('Không tìm thấy thư mục Tải xuống');
      }

      // Tạo đường dẫn mới trong thư mục Tải xuống
      final newFilePath = join(downloadsDirectory.path, basename(filePath));

      // Sao chép file sang thư mục Tải xuống
      final newFile = await file.copy(newFilePath);

      return newFile.path; // Trả về đường dẫn file mới
    } catch (error) {
      print('Lỗi khi lưu file: $error');
      throw Exception('Không thể lưu file vào Tải xuống');
    }
  }

  Future<String> fetchInvoicePdf(int reservationId) async {
    final url = Uri.parse('$baseUrl/payment/invoice/$reservationId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final tempDir = Directory.systemTemp;
        final filePath = '${tempDir.path}/invoice_$reservationId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath; // Trả về đường dẫn file
      } else {
        throw Exception('Không thể tải hóa đơn');
      }
    } catch (error) {
      print("Error: $error"); // In lỗi chi tiết
      throw Exception('Lỗi khi kết nối đến server');
    }
  }

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

  Future<List<Reservation>> fetchCustomerReservations(int customerId) async {
    final url = Uri.parse('$baseUrl/reservations/$customerId');
    final response = await http.get(url);

    print('URL: $url');
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final reservation =
          data.map((json) => Reservation.fromJson(json)).toList();

      return reservation;
    } else {
      throw Exception('Thất bại khi lấy danh sách đặt phòng');
    }
  }

  Future<List<Room>> fetchRoomDetails(List<int> roomIds) async {
    //final url = Uri.parse('$baseUrl/rooms');
    final queryParameters = roomIds.map((id) => 'room_ids[]=$id').join('&');
    final url = Uri.parse('$baseUrl/rooms?$queryParameters');
    final response = await http.get(url);
    print(' Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Thất bại khi lấy thông tin phòng');
    }
  }

  Future<void> cancelReservation(int reservationId) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId/cancel');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Hủy đơn đặt phòng thành công');
    } else {
      throw Exception('Thất bại khi hủy đơn đặt phòng');
    }
  }
}
