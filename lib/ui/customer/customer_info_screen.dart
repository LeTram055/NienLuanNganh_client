import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../managers/customer_manager.dart';

class CustomerInfoScreen extends StatelessWidget {
  static const routeName = '/customer-info';

  @override
  Widget build(BuildContext context) {
    final customerManager = Provider.of<CustomerManager>(context);
    final customer = customerManager.customer;
    final account = customerManager.account;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: customer == null || account == null
          ? const Center(child: Text('Không có thông tin người dùng'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: const Color.fromARGB(255, 231, 250, 251),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Tên', customer.name),
                        _buildInfoRow('CCCD', customer.cccd),
                        _buildInfoRow('Email', customer.email),
                        _buildInfoRow('Địa chỉ', customer.address),
                        _buildInfoRow('Tên tài khoản', account.username),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              shadowColor: Theme.of(context).shadowColor,
                            ),
                            onPressed: () async {
                              await _logout(context);
                            },
                            child: const Text('Đăng xuất'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // Hàm tạo một row với tiêu đề và nội dung
  Widget _buildInfoRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Tiêu đề
          Expanded(
            flex: 2,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          // Nội dung
          Expanded(
            flex: 3,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    Provider.of<CustomerManager>(context, listen: false).logout();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout successful!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
