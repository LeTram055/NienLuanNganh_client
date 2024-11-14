import 'room_status.dart';

class Room {
  final int id;
  final String name;
  final String? note;
  final RoomStatus status;

  Room({
    required this.id,
    required this.name,
    this.note,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['room_id'],
      name: json['room_name'],
      note: json['room_note'],
      status: RoomStatus.fromJson(json['status']),
    );
  }
}
