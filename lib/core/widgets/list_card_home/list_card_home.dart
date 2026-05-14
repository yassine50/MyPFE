import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListCardHome extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final String imageUrl;

  const ListCardHome({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  @override
  State<ListCardHome> createState() => _ListCardHomeState();
}

class _ListCardHomeState extends State<ListCardHome> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF6F7F9),
      ),
      child: Row(
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          /// TITLE + SUBTITLE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.firaSans(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// PRICE + RATING + LIKE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: _isLiked ? Colors.red : Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.price,
                style: GoogleFonts.firaSans(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E6AF0),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(widget.rating),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
