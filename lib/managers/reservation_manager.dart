import 'package:flutter/foundation.dart';
//import 'package:provider/provider.dart';
import '../models/room_type.dart';
import '../services/reservation_service.dart';

class ReservationManager with ChangeNotifier {
  final ReservationService _reservationService = ReservationService();

  List<RoomType> _availableRoomTypes = [];
  List<RoomType> get availableRoomTypes => _availableRoomTypes;
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
}
