enum ListingStatus { active, pending, rented, inactive }

enum BookingStatus { pending, accepted, confirmed, rejected, cancelled, completed }

enum PaymentMethod { card, cash, bankTransfer }

enum PaymentStatus { pending, success, failed, refunded }

ListingStatus parseListingStatus(String value) {
  return ListingStatus.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => ListingStatus.pending,
  );
}

BookingStatus parseBookingStatus(String value) {
  return BookingStatus.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => BookingStatus.pending,
  );
}

PaymentMethod parsePaymentMethod(String value) {
  return PaymentMethod.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => PaymentMethod.cash,
  );
}

PaymentStatus parsePaymentStatus(String value) {
  return PaymentStatus.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => PaymentStatus.pending,
  );
}
