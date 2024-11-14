class TypeImage {
  final int id;
  final String imageUrl;

  TypeImage({
    required this.id,
    required this.imageUrl,
  });

  factory TypeImage.fromJson(Map<String, dynamic> json) {
    return TypeImage(
      id: json['image_id'],
      imageUrl: json['image_url'],
    );
  }
}
