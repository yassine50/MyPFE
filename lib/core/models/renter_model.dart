import 'user_model.dart';
import 'booking_model.dart';
import 'review_model.dart';

class Renter extends User {
  final List<Booking> bookings;
  final List<Review> reviews;

  Renter({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.profileImage,
    required super.createdAt,
    this.bookings = const [],
    this.reviews = const [],
  });

  factory Renter.fromJson(Map<String, dynamic> json) {
    return Renter(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      bookings: (json['bookings'] as List<dynamic>?)
              ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'bookings': bookings.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}
