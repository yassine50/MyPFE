import 'package:flutter/material.dart';
import 'package:pfe/features/booking/presentation/send_request/send_request.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/core/utils/currency_formatter.dart' as pfe_currency;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ButtomActionButton extends StatelessWidget {
  final PropertyModel property;
  const ButtomActionButton({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            ValueListenableBuilder<String>(
              valueListenable: pfe_currency.CurrencyFormatter.symbolNotifier,
              builder: (context, symbol, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.displayPrice.replaceAll(RegExp(r'\s*/\s*month|\s*/\s*mo'), ''),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'per month',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref('bookings')
                  .orderByChild('guestId')
                  .equalTo(FirebaseAuth.instance.currentUser?.uid)
                  .onValue,
              builder: (context, snapshot) {
                bool hasRequested = false;
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  for (var val in data.values) {
                    final b = val as Map<dynamic, dynamic>;
                    if (b['propertyId'] == property.id && (b['status'] == 'pending' || b['status'] == 'accepted' || b['status'] == 'confirmed')) {
                      hasRequested = true;
                      break;
                    }
                  }
                }

                return ElevatedButton(
                  onPressed: hasRequested ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SendRequest(property: property)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasRequested ? Colors.grey : const Color(0xFF0066FF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    disabledForegroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    hasRequested ? 'Request Sent' : 'Request to Book',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
