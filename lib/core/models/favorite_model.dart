class Favorite {
  final String id;
  final DateTime addedAt;

  Favorite({
    required this.id,
    required this.addedAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String? ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
