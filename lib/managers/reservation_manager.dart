import 'package:flutter/foundation.dart';
//import 'package:provider/provider.dart';
import '../models/room_type.dart';
import '../services/reservation_service.dart';
import '../models/reservation.dart';
import '../models/room.dart';
import '../managers/type_manager.dart';
import '../managers/notification_manager.dart';

class ReservationManager with ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  final NotificationManager _notificationManager = NotificationManager();

  List<RoomType> _availableRoomTypes = [];
  List<RoomType> get availableRoomTypes => _availableRoomTypes;

  List<Reservation> _reservations = [];

  List<Reservation> get reservations => _reservations;
  Future<void> fetchAvailableRooms(String checkin, String checkout) async {
    try {
      _availableRoomTypes =
          await _reservationService.fetchAvailableRoomTypes(checkin, checkout);
      print('Available room types: $_availableRoomTypes');
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createReservation({
    required int customerId,
    required String checkinDate,
    required String checkoutDate,
    required List<int> roomIds,
  }) async {
    try {
      print("customerId: $customerId");
      await _reservationService.createReservation(
        customerId: customerId,
        checkinDate: checkinDate,
        checkoutDate: checkoutDate,
        roomIds: roomIds,
      );

      // Thêm thông báo sau khi tạo đặt phòng
      final message = "Đặt phòng thành công từ $checkinDate đến $checkoutDate.";
      print(customerId);
      print('message: $message');
      await _notificationManager.addNotification(customerId, message);
      print("message: $message");
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchReservations(int customerId) async {
    try {
      _reservations =
          await _reservationService.fetchCustomerReservations(customerId);
      print('Reservations: $_reservations');
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<Room>> fetchRoomDetails(List<int> roomIds) async {
    try {
      return await _reservationService.fetchRoomDetails(roomIds);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  double calculateTotalPriceForReservation(Reservation reservation) {
    double totalPrice = 0.0;

    // Duyệt qua các roomIds trong Reservation
    for (var roomId in reservation.roomIds) {
      // Lấy thông tin chi tiết của phòng
      try {
        final typeManager = TypeManager();
        final roomType = typeManager.getRoomType(roomId);

        totalPrice += roomType.price;
      } catch (error) {
        print('Lỗi khi lấy thông tin phòng: $error');
      }
    }

    return totalPrice;
  }

  Future<void> cancelReservation(int reservationId, int customer) async {
    try {
      await _reservationService.cancelReservation(reservationId);

      // Thêm thông báo sau khi hủy đặt phòng
      final message = "Hủy đơn đặt phòng $reservationId thành công.";
      await _notificationManager.addNotification(customer, message);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
