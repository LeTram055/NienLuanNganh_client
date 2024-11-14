class RoomStatus {
  final int id;
  final String name;

  RoomStatus({
    required this.id,
    required this.name,
  });

  factory RoomStatus.fromJson(Map<String, dynamic> json) {
    return RoomStatus(
      id: json['status_id'],
      name: json['status_name'],
    );
  }
}
