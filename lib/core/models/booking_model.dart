import 'enums.dart';
import 'payment_model.dart';

class Booking {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final BookingStatus status;
  final double totalPrice;
  final DateTime createdAt;
  final Payment? payment;

  Booking({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.payment,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : DateTime.now(),
      status: parseBookingStatus(json['status'] as String? ?? ''),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      payment: json['payment'] != null
          ? Payment.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'payment': payment?.toJson(),
    };
  }
}
