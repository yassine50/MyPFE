import 'enums.dart';

class Payment {
  final String id;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime paidAt;

  Payment({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      method: parsePaymentMethod(json['method'] as String? ?? ''),
      status: parsePaymentStatus(json['status'] as String? ?? ''),
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'method': method.name,
      'status': status.name,
      'paidAt': paidAt.toIso8601String(),
    };
  }
}
