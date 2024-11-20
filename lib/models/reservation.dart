class Reservation {
  final String checkin;
  final String checkout;
  final List<int> roomIds;

  Reservation({
    required this.checkin,
    required this.checkout,
    required this.roomIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'checkin': checkin,
      'checkout': checkout,
      'room_ids': roomIds,
    };
  }
}
