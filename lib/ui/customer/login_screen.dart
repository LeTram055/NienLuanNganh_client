import 'package:flutter/material.dart';
import '../../managers/customer_manager.dart';
import 'register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF026269),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Vòng tròn nền gradient
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 247, 32, 32),
                          Color.fromARGB(255, 251, 243, 137)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  // Tiêu đề "Ánh Dương Hotel"
                  Text(
                    'Ánh Dương Hotel',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(3, 3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer<CustomerManager>(
                      builder: (context, authManager, child) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: accountNameController,
                                decoration: const InputDecoration(
                                    labelText: 'Tên tài khoản'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập tên tài khoản';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                    labelText: 'Mật khẩu'),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28.0, vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  shadowColor: Theme.of(context).shadowColor,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await authManager.login(
                                      accountNameController.text,
                                      passwordController.text,
                                    );
                                    if (authManager.statusMessage
                                        .contains('thành công')) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Đăng nhập thành công'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                LoginScreen.routeName);
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(authManager.statusMessage),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Đăng nhập'),
                              ),
                              //  if (authManager.statusMessage.isNotEmpty)
                              //     ScaffoldMessenger.of(context)
                              //             .showSnackBar(
                              //           SnackBar(
                              //             content: Text(authManager.statusMessage),
                              //             backgroundColor:
                              //                 authManager.statusMessage.contains('thành công')
                              //                     ? Colors.green
                              //                     : Colors.red,
                              //             duration: const Duration(seconds: 3),
                              //           ),
                              //         );
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       authManager.statusMessage,
                              //       style: const TextStyle(color: Colors.red),
                              //     ),
                              //   ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                    RegisterScreen.routeName,
                                  );
                                },
                                child: const Text(
                                    'Chưa có tài khoản? Đăng ký ngay'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
