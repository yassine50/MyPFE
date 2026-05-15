class PropertyModel {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final List<String> images;
  final String mapImageUrl;
  final double latitude;
  final double longitude;
  final bool isFeatured;
  final bool isColiving;
  
  // New deep fields
  final String description;
  final String moveInDate;
  final String roomType;
  final List<String> amenities;
  final String residentDemographics;
  final List<Map<String, dynamic>> reviews;
  final List<String> residentAvatars;

  PropertyModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.images,
    this.mapImageUrl = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.isFeatured = false,
    this.isColiving = false,
    this.description = '',
    this.moveInDate = '',
    this.roomType = '',
    this.amenities = const [],
    this.residentDemographics = '',
    this.reviews = const [],
    this.residentAvatars = const [],
  });

  factory PropertyModel.fromJson(Map<dynamic, dynamic> json, String id) {
    List<String> parseStringList(dynamic data, List<String> fallback) {
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return fallback;
    }

    List<Map<String, dynamic>> parseReviews(dynamic data) {
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    }

    return PropertyModel(
      id: id,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      price: json['price'] ?? '',
      rating: json['rating'] ?? '0.0',
      images: json['images'] != null 
          ? parseStringList(json['images'], []) 
          : (json['imageUrl'] != null ? [json['imageUrl'] as String] : []),
      mapImageUrl: json['mapImageUrl'] ?? '',
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : 0.0,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : 0.0,
      isFeatured: json['isFeatured'] ?? false,
      isColiving: json['isColiving'] ?? false,
      
      description: json['description'] ?? '',
      moveInDate: json['moveInDate'] ?? '',
      roomType: json['roomType'] ?? '',
      amenities: parseStringList(json['amenities'], []),
      residentDemographics: json['residentDemographics'] ?? '',
      reviews: parseReviews(json['reviews']),
      residentAvatars: parseStringList(json['residentAvatars'], []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'rating': rating,
      'images': images,
      'mapImageUrl': mapImageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'isFeatured': isFeatured,
      'isColiving': isColiving,
      'description': description,
      'moveInDate': moveInDate,
      'roomType': roomType,
      'amenities': amenities,
      'residentDemographics': residentDemographics,
      'reviews': reviews,
      'residentAvatars': residentAvatars,
    };
  }
}
