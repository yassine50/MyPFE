import 'package:flutter/material.dart';
import 'package:pfe/component/text/Text.dart';

class TitleOfRoom extends StatelessWidget {
  const TitleOfRoom({super.key});

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
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
        Text1(
          text: 'Sunny Private Room near Old Town',
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
              text: 'Bucharest • 2.5 km from center',
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
            const Text(
              '4.8',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              ' (124 reviews)',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
