import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/features/property_details/presentation/detail_screen/detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:pfe/core/models/property_model.dart';
class CardHome extends StatefulWidget {
  final PropertyModel property;

  const CardHome({
    super.key,
    required this.property,
  });

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(property: widget.property)),
        );
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE SECTION
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      widget.property.images.isNotEmpty ? widget.property.images.first : '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// ❤️ LIKE BUTTON
                  Positioned(
                    top: 10,
                    right: 10,
                    child: user == null
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
                  ),

                  /// PRICE TAG
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.property.price,
                        style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// CONTENT SECTION
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.property.title,
                    style: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.property.subtitle,
                    style: GoogleFonts.firaSans(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(widget.property.rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton(bool isLiked) {
    return GestureDetector(
      onTap: () => _toggleLike(isLiked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
