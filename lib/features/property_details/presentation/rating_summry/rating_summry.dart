import 'package:flutter/material.dart';

class Ratingsummry extends StatelessWidget {
  final String rating;
  final int reviewsCount;
  const Ratingsummry({super.key, required this.rating, required this.reviewsCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Reviews",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "View all",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Rating summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    rating,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      Icon(Icons.star_half, size: 14, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$reviewsCount reviews",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 24),

              // Progress bars
              Expanded(
                child: Column(
                  children: const [
                    _RatingBar(label: "5", value: 0.75),
                    _RatingBar(label: "4", value: 0.15),
                    _RatingBar(label: "3", value: 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final double value;

  const _RatingBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
