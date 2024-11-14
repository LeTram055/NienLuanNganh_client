class Facility {
  final int id;
  final String name;
  final String description;

  Facility({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['facility_id'],
      name: json['facility_name'],
      description: json['facility_description'],
    );
  }
}
