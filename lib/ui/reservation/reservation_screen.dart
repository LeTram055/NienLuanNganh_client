import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final customerId =
        Provider.of<CustomerManager>(context, listen: false).customer!.id;

    String formatCurrency(double value) {
      final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
      return formatter.format(value);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn đặt phòng'),
      ),
      body: FutureBuilder(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Lỗi khi tải dữ liệu'));
          }

          final reservations = reservationManager.reservations;

          if (reservations.isEmpty) {
            return const Center(child: Text('Không có đơn đặt phòng nào'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final Future<List<Room>> roomDetails =
                  reservationManager.fetchRoomDetails(reservation.roomIds);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Ngày nhận phòng: ${reservation.checkin}'),
                          Text('Ngày trả phòng: ${reservation.checkout}'),
                          Text('Trạng thái: ${reservation.status}'),
                          FutureBuilder<List<Room>>(
                            future: roomDetails,
                            builder: (context, roomSnapshot) {
                              if (roomSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Đang tính tổng tiền...');
                              } else if (roomSnapshot.hasError) {
                                return const Text('Không thể tính tổng tiền');
                              }

                              // Tính tổng tiền
                              final totalPrice =
                                  roomSnapshot.data!.fold(0.0, (sum, room) {
                                final roomType =
                                    typeManager.getRoomType(room.typeId);
                                return sum + (roomType.price);
                              });

                              return Text(
                                'Tổng tiền: ${formatCurrency(totalPrice)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Room>>(
                      future: roomDetails,
                      builder: (context, roomSnapshot) {
                        if (roomSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (roomSnapshot.hasError) {
                          return const Text('Lỗi khi lấy thông tin phòng');
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
                          final roomType = typeManager.getRoomType(roomTypeId);
                          final roomTypeName = roomType.name;
                          final pricePerRoom = roomType.price;
                          final roomCount = roomList.length;
                          final subtotal = pricePerRoom * roomCount;

                          roomTypeWidgets.add(
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0,
                                  bottom: 8.0), // Thêm padding trái và dưới
                              child: Align(
                                alignment: Alignment.centerLeft, // Canh trái
                                child: Text(
                                  '$roomTypeName: ${roomList.map((room) => room.name).join(", ")}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                          roomTypeWidgets.add(
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, bottom: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Giá: ${formatCurrency(pricePerRoom)} x $roomCount = ${formatCurrency(subtotal)}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          );
                        });

                        return ExpansionTile(
                          title: Text(
                            'Danh sách phòng đã đặt (${rooms.length})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: roomTypeWidgets,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center, // Canh phải
                        child: reservation.status == 'Chờ xác nhận'
                            ? ElevatedButton.icon(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                label: const Text('Hủy đơn'),
                                onPressed: () async {
                                  final confirmCancel = await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Xác nhận hủy đơn'),
                                      content: const Text(
                                          'Bạn có chắc chắn muốn hủy đơn đặt phòng này không?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Hủy'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Đồng ý'),
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
                                          .cancelReservation(
                                              reservation.id, customerId);

                                      setState(() {
                                        _reservationsFuture = reservationManager
                                            .fetchReservations(
                                                Provider.of<CustomerManager>(
                                                        context,
                                                        listen: false)
                                                    .customer!
                                                    .id);
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Đã hủy đơn đặt phòng'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Hủy đơn thất bại'),
                                            backgroundColor: Colors.red),
                                      );
                                    }
                                  }
                                },
                              )
                            : const SizedBox(),
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
