class Room {
  final int id;
  final String name;
  final String? note;
  final int statusId;
  final int typeId;

  Room({
    required this.id,
    required this.name,
    this.note,
    required this.statusId,
    required this.typeId,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['room_id'] ?? 0,
      name: json['room_name'] ?? '',
      note: json['room_note'] ?? '',
      statusId: json['status_id'] ?? 0,
      typeId: json['type_id'] ?? 0,
    );
  }
}
