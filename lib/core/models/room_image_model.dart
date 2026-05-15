class RoomImage {
  final String id;
  final String imageUrl;
  final bool isMain;

  RoomImage({
    required this.id,
    required this.imageUrl,
    required this.isMain,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isMain: json['isMain'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'isMain': isMain,
    };
  }
}
