import 'package:flutter/material.dart';
import '../services/type_service.dart';
import '../models/room_type.dart';

class TypeManager extends ChangeNotifier {
  final TypeService _typeService = TypeService();

  List<RoomType> _roomTypes = [];
  RoomType? _selectedType;
  String? _errorMessage;
  List<RoomType> _filteredRoomTypes = [];

  List<RoomType> get roomTypes => _roomTypes;

  // List<RoomType> get roomTypes =>
  //     _filteredRoomTypes.isEmpty ? _roomTypes : _filteredRoomTypes;

  List<RoomType> get filteredRoomTypes => _filteredRoomTypes;
  RoomType? get selectedType => _selectedType;
  String? get errorMessage => _errorMessage;

  void resetFilters() {
    _filteredRoomTypes = _roomTypes;
    notifyListeners();
  }

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

  void searchRoomTypesWithFilters({
    required String query,
    String? capacity,
    String? area,
  }) {
    _filteredRoomTypes = _roomTypes.where((type) {
      final matchesQuery = query.isEmpty ||
          type.name.toLowerCase().contains(query.toLowerCase()) ||
          type.price.toString().contains(query);
      final matchesCapacity =
          capacity == null || type.capacity.toString() == capacity;
      final matchesArea = area == null || type.area.toString() == area;

      return matchesQuery && matchesCapacity && matchesArea;
    }).toList();

    notifyListeners();
  }

  void searchRoomTypes(String query) {
    if (query.isEmpty) {
      _filteredRoomTypes = [];
    } else {
      _filteredRoomTypes = _roomTypes
          .where(
              (type) => type.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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

  String getRoomTypeName(int typeId) {
    // Kiểm tra nếu đã có thông tin loại phòng trong danh sách
    final roomType = _roomTypes.firstWhere((type) => type.id == typeId);

    return roomType.name;
  }

  RoomType getRoomType(int typeId) {
    // Kiểm tra nếu đã có thông tin loại phòng trong danh sách
    final roomType = _roomTypes.firstWhere((type) => type.id == typeId);

    return roomType;
  }

  Future<RoomType?> getRoomTypeDetails(int typeId) async {
    // Kiểm tra nếu loại phòng đã được lấy trong danh sách trước đó
    final existingType = _roomTypes.firstWhere(
      (type) => type.id == typeId,
    );
    return existingType;
  }
}
