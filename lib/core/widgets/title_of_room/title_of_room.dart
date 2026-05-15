import 'package:flutter/material.dart';
import 'package:pfe/core/widgets/text/text.dart';

import 'package:pfe/core/models/property_model.dart';
class TitleOfRoom extends StatelessWidget {
  final PropertyModel property;
  const TitleOfRoom({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.verified, color: Colors.blue, size: 18),
            SizedBox(width: 6),
            Text(
              "Verified Listing",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text1(
          text: property.title,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),

        // Titl
        const SizedBox(height: 12),

        // Location + Rating
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Text1(
              text: property.subtitle,
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey[700]!,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // const Spacer(),
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 6),
            // const SizedBox(width: 4),
            Text(
              property.rating,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              ' (${property.reviews.length} reviews)',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
