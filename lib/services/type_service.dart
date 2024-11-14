import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TypeService {
  final String? baseUrl = dotenv.env['API_URL'];

  Future<List<dynamic>> fetchRoomTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load room types');
    }
  }

  Future<Map<String, dynamic>> fetchRoomTypeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/types/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load room type details');
    }
  }
}
