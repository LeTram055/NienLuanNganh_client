import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account.dart';
import '../models/customer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomerService {
  // Địa chỉ API backend
  final String? baseUrl = dotenv.env['API_URL'];

  // Lấy thông tin khách hàng và tài khoản đã đăng nhập
  Future<Map<String, dynamic>> getUserInfo(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getuserbyusername/$username'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Error: ${response.statusCode}');
    print("response-getuserbyusername: ${response.body}");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final customer = Customer.fromJson(responseData['customer']);
      final account = Account.fromJson(responseData['account']);
      return {'customer': customer, 'account': account};
    } else {
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Lỗi không xác định');
    }
  }

  // Đăng ký khách hàng
  Future<String> registerCustomer(Account account, Customer customer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'account_username': account.username,
        'account_password': account.accountPassword,
        'account_role': account.accountRole,
        'account_active': account.accountActive,
        'customer_name': customer.name,
        'customer_cccd': customer.cccd,
        'customer_email': customer.email,
        'customer_address': customer.address,
      }),
    );

    print('response-register: ${response.body}');
    if (response.statusCode == 201) {
      return 'Đăng ký thành công';
    } else {
      final responseData = json.decode(response.body);
      return responseData['message'] ?? 'Đăng ký thât bại';
    }
  }

  // Đăng nhập khách hàng
  Future<String> loginCustomer(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'account_username': username,
        'account_password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData['message'] ?? 'Đăng nhập thành công';
    } else {
      final responseData = json.decode(response.body);
      return responseData['message'] ?? 'Đăng nhập thất bại';
    }
  }

  Future<Map<String, dynamic>> changePassword(
      String username, String currentPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/changepassword'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );
    print('Error: ${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Lỗi không xác định');
    }
  }
}
