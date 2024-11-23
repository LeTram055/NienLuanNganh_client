import 'package:flutter/material.dart';
import 'package:hotelmanagement/managers/customer_manager.dart';
import 'package:provider/provider.dart';
import '../../managers/reservation_manager.dart';
import '../../models/room.dart';
import '../../managers/type_manager.dart';

class ReservationsScreen extends StatefulWidget {
  static const routeName = '/reservation';

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late Future<void> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    final reservationManager =
        Provider.of<ReservationManager>(context, listen: false);
    final customerId =
        Provider.of<CustomerManager>(context, listen: false).customer!.id;

    _reservationsFuture = reservationManager.fetchReservations(customerId);
  }

  @override
  Widget build(BuildContext context) {
    final reservationManager = Provider.of<ReservationManager>(context);
    final typeManager = Provider.of<TypeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn đặt phòng'),
      ),
      body: FutureBuilder(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu'));
          }

          final reservations = reservationManager.reservations;

          if (reservations.isEmpty) {
            return Center(child: Text('Không có đơn đặt phòng nào'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];

              final Future<List<Room>> roomDetails =
                  reservationManager.fetchRoomDetails(reservation.roomIds);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: const Color.fromARGB(255, 231, 250, 251),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ngày đặt: ${reservation.date}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Ngày nhận phòng: ${reservation.checkin}'),
                          Text('Ngày trả phòng: ${reservation.checkout}'),
                          Text('Trạng thái: ${reservation.status}'),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Room>>(
                      future: roomDetails,
                      builder: (context, roomSnapshot) {
                        if (roomSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (roomSnapshot.hasError) {
                          return Text('Lỗi khi lấy thông tin phòng');
                        }

                        final rooms = roomSnapshot.data!;
                        final Map<int, List<Room>> groupedRooms = {};
                        for (var room in rooms) {
                          groupedRooms
                              .putIfAbsent(room.typeId, () => [])
                              .add(room);
                        }

                        List<Widget> roomTypeWidgets = [];
                        groupedRooms.forEach((roomTypeId, roomList) {
                          final roomTypeName =
                              typeManager.getRoomTypeName(roomTypeId);

                          // Thêm từng loại phòng vào danh sách widget
                          roomTypeWidgets.add(
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0,
                                  bottom: 8.0), // Thêm padding trái và dưới
                              child: Align(
                                alignment: Alignment.centerLeft, // Canh trái
                                child: Text(
                                  '$roomTypeName: ${roomList.map((room) => room.name).join(", ")}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        });

                        return ExpansionTile(
                          title: Text(
                            'Danh sách phòng đã đặt (${rooms.length})',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children:
                              roomTypeWidgets, // Thêm tất cả các loại phòng vào đây
                        );

                        // return Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Column(
                        //       children: groupedRooms.entries.map((entry) {
                        //         final roomTypeId = entry.key;
                        //         final roomList = entry.value;
                        //         final roomTypeName =
                        //             typeManager.getRoomTypeName(roomTypeId);

                        //         return ExpansionTile(
                        //           title: Text(
                        //             'Danh sách phòng đã đặt (${roomList.length})',
                        //             style:
                        //                 TextStyle(fontWeight: FontWeight.bold),
                        //           ),
                        //           children: roomList.map((room) {
                        //             return ListTile(
                        //                 title: Text(
                        //                     '${roomTypeName}: ${room.name}'));
                        //           }).toList(),
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ],
                        // );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center, // Canh phải
                        child: reservation.status == 'Chờ xác nhận'
                            ? ElevatedButton.icon(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                label: Text('Hủy đơn'),
                                onPressed: () async {
                                  final confirmCancel = await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Xác nhận hủy đơn'),
                                      content: Text(
                                          'Bạn có chắc chắn muốn hủy đơn đặt phòng này không?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Hủy'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Đồng ý'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(true);
                                          },
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmCancel == true) {
                                    try {
                                      await reservationManager
                                          .cancelReservation(reservation.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Đã hủy đơn đặt phòng')),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Hủy đơn thất bại')),
                                      );
                                    }
                                  }
                                },
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
