import 'enums.dart';
import 'room_image_model.dart';

class RoomListing {
  final String id;
  final String title;
  final String description;
  final double pricePerMonth;
  final String address;
  final double latitude;
  final double longitude;
  final int availableRooms;
  final List<String> amenities;
  final ListingStatus status;
  final DateTime createdAt;
  final List<RoomImage> images;

  RoomListing({
    required this.id,
    required this.title,
    required this.description,
    required this.pricePerMonth,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.availableRooms,
    required this.amenities,
    required this.status,
    required this.createdAt,
    this.images = const [],
  });

  factory RoomListing.fromJson(Map<String, dynamic> json) {
    return RoomListing(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pricePerMonth: (json['pricePerMonth'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      availableRooms: json['availableRooms'] as int? ?? 0,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: parseListingStatus(json['status'] as String? ?? ''),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => RoomImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pricePerMonth': pricePerMonth,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'availableRooms': availableRooms,
      'amenities': amenities,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}
