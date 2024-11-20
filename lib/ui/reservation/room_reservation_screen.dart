import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../managers/reservation_manager.dart';
import '../../managers/customer_manager.dart';

class RoomReservationScreen extends StatefulWidget {
  @override
  _RoomReservationScreenState createState() => _RoomReservationScreenState();
}

class _RoomReservationScreenState extends State<RoomReservationScreen> {
  final TextEditingController _checkinController = TextEditingController();
  final TextEditingController _checkoutController = TextEditingController();
  final Map<int, bool> _selectedRooms = {};

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationManager = Provider.of<ReservationManager>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Đặt phòng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _checkinController,
              decoration: const InputDecoration(
                labelText: "Ngày nhận phòng",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _checkinController),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _checkoutController,
              decoration: const InputDecoration(
                labelText: "Ngày trả phòng",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _checkoutController),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (_checkinController.text.isEmpty ||
                    _checkoutController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Vui lòng chọn đầy đủ ngày!")),
                  );
                  return;
                }

                print(
                    "Fetching rooms for: checkin=${_checkinController.text}, checkout=${_checkoutController.text}");

                await reservationManager.fetchAvailableRooms(
                  _checkinController.text,
                  _checkoutController.text,
                );

                // Kiểm tra nếu danh sách phòng trống đã được cập nhật
                print(
                    "Available rooms: ${reservationManager.availableRoomTypes.length}");
              },
              child: Text("Tìm phòng"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reservationManager.availableRoomTypes.isEmpty
                  ? const Center(
                      child: Text(
                        "Chưa có dữ liệu phòng",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: reservationManager.availableRoomTypes.length,
                      itemBuilder: (context, index) {
                        final roomType =
                            reservationManager.availableRoomTypes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          color: const Color.fromARGB(255, 231, 250, 251),
                          child: ExpansionTile(
                            title: Text(
                              roomType.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "Giá: ${roomType.price.toStringAsFixed(0)} VND",
                              style:
                                  const TextStyle(color: Colors.orangeAccent),
                            ),
                            children: roomType.listAvailableRooms.map((room) {
                              return CheckboxListTile(
                                value: _selectedRooms[room.id] ?? false,
                                onChanged: (isSelected) {
                                  setState(() {
                                    _selectedRooms[room.id] =
                                        isSelected ?? false;
                                  });
                                },
                                title: Text(room.name),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
            ),
            if (_selectedRooms.values.contains(true))
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final selectedRoomIds = _selectedRooms.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  if (selectedRoomIds.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Vui lòng chọn ít nhất một phòng để đặt!")),
                    );
                    return;
                  }

                  //Call reservationManager to save reservation
                  try {
                    final reservationManager =
                        Provider.of<ReservationManager>(context, listen: false);
                    final customerManager =
                        Provider.of<CustomerManager>(context, listen: false);
                    await reservationManager.createReservation(
                      customerId: customerManager.customer!.id,
                      checkinDate: _checkinController.text,
                      checkoutDate: _checkoutController.text,
                      roomIds: selectedRoomIds,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Đặt phòng thành công cho ${selectedRoomIds.length} phòng!",
                        ),
                      ),
                    );

                    setState(() {
                      _selectedRooms.clear();
                      _checkinController.clear();
                      _checkoutController.clear();
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Có lỗi xảy ra khi đặt phòng!")),
                    );
                  }
                },
                child: Text("Xác nhận phòng đã chọn"),
              ),
          ],
        ),
      ),
    );
  }
}
