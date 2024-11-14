import 'package:flutter/material.dart';

class IntroductionCard extends StatelessWidget {
  const IntroductionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Ảnh nền mờ
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/hotel.jpg'), // Đường dẫn ảnh
                  fit: BoxFit.cover,
                ),
              ),
              // Không đặt height để Container tự điều chỉnh theo nội dung
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.black.withOpacity(0.7), // Lớp phủ mờ
                ),
                padding:
                    const EdgeInsets.all(16.0), // Thêm khoảng cách nội dung
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Chào mừng đến với \nÁnh Dương Hotel',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 6),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '🌟🌟🌟🌟🌟',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Đắm mình trong không gian sang trọng và thanh lịch, '
                      'nơi mà mỗi khoảnh khắc đều được thiết kế để mang lại sự thoải mái và niềm vui tuyệt đối. '
                      'Hãy để chúng tôi mang đến cho bạn những trải nghiệm khó quên!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
