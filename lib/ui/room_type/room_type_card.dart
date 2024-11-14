// room_type_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/room_type.dart';
import 'room_type_detail_screen.dart';

class RoomTypeCard extends StatelessWidget {
  final RoomType roomType;

  RoomTypeCard({
    super.key,
    required this.roomType,
  });

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'vi_VN', // Định dạng theo chuẩn Việt Nam
    symbol: 'VND',
    decimalDigits: 0, // Không hiển thị phần thập phân
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomTypeDetailScreen(
              roomTypeId: roomType.id,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color.fromARGB(255, 231, 251, 232),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
              child: Image.network(
                roomType.images[0].imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomType.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Giá: ${currencyFormat.format(roomType.price)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
