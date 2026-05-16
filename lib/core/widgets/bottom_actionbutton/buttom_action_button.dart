import 'package:flutter/material.dart';
import 'package:pfe/features/booking/presentation/send_request/send_request.dart';
import 'package:pfe/core/models/property_model.dart';

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.price,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'per month',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendRequest(property: property)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Request to Book',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
