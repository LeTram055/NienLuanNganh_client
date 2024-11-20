import 'package:flutter/foundation.dart';
import '../models/room_type.dart';
import '../services/room_service.dart';

class RoomManager with ChangeNotifier {
  final RoomService _roomService = RoomService();
  List<RoomType> _availableRoomTypes = [];

  List<RoomType> get availableRoomTypes => _availableRoomTypes;

  Future<void> fetchAvailableRooms(String checkin, String checkout) async {
    try {
      _availableRoomTypes = await _roomService.fetchAvailableRoomTypes(
        checkin,
        checkout,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
