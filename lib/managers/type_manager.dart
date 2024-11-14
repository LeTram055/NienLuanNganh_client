import 'package:flutter/material.dart';
import '../services/type_service.dart';
import '../models/room_type.dart';

class TypeManager extends ChangeNotifier {
  final TypeService _typeService = TypeService();

  List<RoomType> _roomTypes = [];
  RoomType? _selectedType;
  String? _errorMessage;

  List<RoomType> get roomTypes => _roomTypes;
  RoomType? get selectedType => _selectedType;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoomTypes() async {
    try {
      final response = await _typeService.fetchRoomTypes();
      _roomTypes =
          response.map<RoomType>((data) => RoomType.fromJson(data)).toList();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    }
    notifyListeners();
  }

  Future<void> fetchRoomTypeDetails(int id) async {
    try {
      final response = await _typeService.fetchRoomTypeById(id);
      _selectedType = RoomType.fromJson(response);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      notifyListeners();
    }
  }
}
