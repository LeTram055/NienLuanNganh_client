class Reservation {
  final int id;
  final String date;
  final String checkin;
  final String checkout;
  final String status;
  final List<int> roomIds;
  // final List<Room> rooms;

  Reservation({
    required this.id,
    required this.date,
    required this.checkin,
    required this.checkout,
    required this.status,
    required this.roomIds,
    //required this.rooms,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['reservation_id'],
      date: json['reservation_date'],
      checkin: json['reservation_checkin'],
      checkout: json['reservation_checkout'],
      status: json['reservation_status'],
      roomIds: List<int>.from(json['rooms'].map((room) => room['room_id'])),
      // rooms:
      //     (json['rooms'] as List).map((room) => Room.fromJson(room)).toList(),
    );
  }
}
