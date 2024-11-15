import 'package:flutter/material.dart';
import '../models/account.dart';
import '../models/customer.dart';
import '../services/customer_service.dart';

class CustomerManager with ChangeNotifier {
  final CustomerService _authService = CustomerService();

  String _statusMessage = '';
  String get statusMessage => _statusMessage;

  bool isAuth = false;

  Customer? _customer;
  Customer? get customer => _customer;

  Account? _account;
  Account? get account => _account;

  // Đăng ký khách hàng
  Future<void> register(Account account, Customer customer) async {
    try {
      final result = await _authService.registerCustomer(account, customer);

      // Cập nhật thông báo khi thành công
      _statusMessage = result;
    } catch (error) {
      _statusMessage = 'Đã xảy ra lỗi: $error'; // Thông báo lỗi nếu có
    }

    notifyListeners();
  }

  // Đăng nhập khách hàng
  Future<void> login(String username, String password) async {
    try {
      final result = await _authService.loginCustomer(username, password);

      if (result == 'Đăng nhập thành công') {
        final userInfo = await _authService.getUserInfo(username);
        _customer = userInfo['customer'];
        _account = userInfo['account'];
        isAuth = true;
      }

      _statusMessage = result;
    } catch (error) {
      _statusMessage = 'Đã xảy ra lỗi: $error';
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _customer = null;
    _account = null;
    isAuth = false;
    _statusMessage = '';

    notifyListeners();
  }
}
