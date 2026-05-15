import 'user_model.dart';
import 'room_listing_model.dart';

class Host extends User {
  final List<RoomListing> listings;
  final double rating;

  Host({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.profileImage,
    required super.createdAt,
    this.listings = const [],
    required this.rating,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      listings: (json['listings'] as List<dynamic>?)
              ?.map((e) => RoomListing.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'listings': listings.map((e) => e.toJson()).toList(),
      'rating': rating,
    };
  }
}
