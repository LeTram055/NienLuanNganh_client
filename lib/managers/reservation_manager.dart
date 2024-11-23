import 'package:flutter/foundation.dart';
//import 'package:provider/provider.dart';
import '../models/room_type.dart';
import '../services/reservation_service.dart';
import '../models/reservation.dart';
import '../models/room.dart';

class ReservationManager with ChangeNotifier {
  final ReservationService _reservationService = ReservationService();

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

  Future<void> cancelReservation(int reservationId) async {
    try {
      await _reservationService.cancelReservation(reservationId);
      _reservations.removeWhere((res) => res.id == reservationId);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
