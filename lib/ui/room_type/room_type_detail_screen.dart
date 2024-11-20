import 'dart:async'; // Để sử dụng Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../managers/type_manager.dart';

class RoomTypeDetailScreen extends StatefulWidget {
  static const routeName = '/room-type-detail';
  final int roomTypeId;

  const RoomTypeDetailScreen({super.key, required this.roomTypeId});

  @override
  _RoomTypeDetailScreenState createState() => _RoomTypeDetailScreenState();
}

class _RoomTypeDetailScreenState extends State<RoomTypeDetailScreen> {
  final PageController _pageController =
      PageController(); // Sử dụng PageController
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final typeManager = Provider.of<TypeManager>(context, listen: false);
    typeManager.fetchRoomTypeDetails(widget.roomTypeId);

    // Tạo timer để tự động trượt ảnh
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.toInt() ?? 0) +
            1; // Kiểm tra null và đảm bảo là kiểu int
        final pageCount =
            typeManager.selectedType?.images.length ?? 0; // Kiểm tra null trước
        final nextIndex = nextPage >= pageCount
            ? 0
            : nextPage; // Quay lại ảnh đầu tiên nếu đã đến ảnh cuối
        _pageController.animateToPage(
          nextIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy Timer khi widget bị hủy
    super.dispose();
  }

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'vi_VN', // Định dạng theo chuẩn Việt Nam
    symbol: 'VND',
    decimalDigits: 0, // Không hiển thị phần thập phân
  );

  @override
  Widget build(BuildContext context) {
    final typeManager = Provider.of<TypeManager>(context);
    final roomType = typeManager.selectedType; // Lấy roomType từ typeManager

    return Scaffold(
      appBar: AppBar(
        title: Text(roomType?.name ?? 'Loại phòng'),
      ),
      body: roomType == null
          ? const Center(
              child: CircularProgressIndicator()) // Chờ nếu chưa có roomType
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slider hình ảnh sử dụng PageView
                  SizedBox(
                    height: 250.0,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: roomType.images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Khoảng cách xung quanh hình ảnh
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              roomType.images[index].imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thông tin chi tiết phòng
                        Text(
                          roomType.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Giá: ${currencyFormat.format(roomType.price)}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Diện tích: ${roomType.area} m²',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Sức chứa: ${roomType.capacity} người',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8.0),
                        // Số phòng trống
                        Text(
                          'Số phòng trống: ${roomType.availableRooms}', // Bạn có thể cập nhật số phòng trống ở đây
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Divider(height: 32.0, thickness: 1),
                        // Danh sách tiện ích
                        const Text(
                          'Tiện nghi:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Column(
                          children: roomType.facilities.map((facility) {
                            return ListTile(
                              leading: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              title: Text(facility.name),
                              subtitle: Text(facility.description),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/reservation',
                        );
                      },
                      child: const Text("Đặt phòng ngay"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
