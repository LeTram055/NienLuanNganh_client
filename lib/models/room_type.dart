import 'type_image.dart';
import 'facility.dart';

class RoomType {
  final int id;
  final String name;
  final double price;
  final int capacity;
  final double area;
  final List<TypeImage> images;
  final List<Facility> facilities;

  RoomType({
    required this.id,
    required this.name,
    required this.price,
    required this.capacity,
    required this.area,
    required this.images,
    required this.facilities,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['type_id'],
      name: json['type_name'],
      price: (json['type_price'] as num).toDouble(),
      capacity: json['type_capacity'],
      area: (json['type_area'] as num).toDouble(),
      images: (json['images'] as List<dynamic>)
          .map((image) => TypeImage.fromJson(image))
          .toList(),
      facilities: (json['facilities'] as List<dynamic>)
          .map((facility) => Facility.fromJson(facility))
          .toList(),
    );
  }
}
