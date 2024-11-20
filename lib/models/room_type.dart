import 'type_image.dart';
import 'facility.dart';
import 'room.dart';

class RoomType {
  final int id;
  final String name;
  final double price;
  final int capacity;
  final double area;
  final List<TypeImage> images;
  final List<Facility> facilities;
  final int availableRooms;
  final List<Room> listAvailableRooms;

  RoomType({
    required this.id,
    required this.name,
    required this.price,
    required this.capacity,
    required this.area,
    required this.images,
    required this.facilities,
    required this.availableRooms,
    required this.listAvailableRooms,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['type_id'] ?? 0,
      name: json['type_name'] ?? '',
      price: (json['type_price'] as num?)?.toDouble() ?? 0,
      capacity: json['type_capacity'] ?? 0,
      area: (json['type_area'] as num?)?.toDouble() ?? 0,
      images: (json['images'] as List<dynamic>?)
              ?.map((image) => TypeImage.fromJson(image))
              .toList() ??
          [],
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((facility) => Facility.fromJson(facility))
              .toList() ??
          [],
      availableRooms: json['available_rooms'] ?? 0,
      listAvailableRooms: (json['list_available_rooms'] as List<dynamic>?)
              ?.map((room) => Room.fromJson(room))
              .toList() ??
          [],
    );
  }
}
