import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/features/property_details/presentation/detail_screen/detail_screen.dart';
class ListCardHome extends StatefulWidget {
  final PropertyModel property;

  const ListCardHome({
    super.key,
    required this.property,
  });

  @override
  State<ListCardHome> createState() => _ListCardHomeState();
}

class _ListCardHomeState extends State<ListCardHome> {
  void _toggleLike(bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save properties.')),
      );
      return;
    }

    final ref = FirebaseDatabase.instance.ref('favorites/${user.uid}/${widget.property.id}');
    if (isLiked) {
      await ref.remove();
    } else {
      await ref.set({
        'id': widget.property.id,
        'addedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Widget _buildLikeButton(bool isLiked) {
    return GestureDetector(
      onTap: () => _toggleLike(isLiked),
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        size: 18,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(property: widget.property))); },
      child: Container(
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
              widget.property.images.isNotEmpty ? widget.property.images.first : '',
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
                  widget.property.title,
                  style: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.property.subtitle,
                  style: GoogleFonts.firaSans(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// PRICE + RATING + LIKE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              user == null
                  ? _buildLikeButton(false)
                  : StreamBuilder<DatabaseEvent>(
                      stream: FirebaseDatabase.instance
                          .ref('favorites/${user.uid}/${widget.property.id}')
                          .onValue,
                      builder: (context, snapshot) {
                        final isLiked = snapshot.hasData && snapshot.data!.snapshot.value != null;
                        return _buildLikeButton(isLiked);
                      },
                    ),
              const SizedBox(height: 6),
              Text(
                widget.property.price,
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
                  Text(widget.property.rating),
                ],
              ),
            ],
          ),
        ],
      ),
    ),);
  }
}
