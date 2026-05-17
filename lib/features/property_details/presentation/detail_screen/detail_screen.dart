import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/widgets/amenetis/amenetis.dart';
import 'package:pfe/core/widgets/bottom_actionbutton/buttom_action_button.dart';
import 'package:pfe/core/widgets/current_resident/current_resident.dart';
import 'package:pfe/core/widgets/img_slider/img_slider.dart';
import 'package:pfe/core/widgets/pricing_card/pricing_card.dart';
import 'package:pfe/core/widgets/review_card/review_cards.dart';
import 'package:pfe/core/widgets/title_of_room/title_of_room.dart';
import 'package:pfe/core/widgets/location/location.dart';
import 'package:pfe/features/property_details/presentation/rating_summry/rating_summry.dart';
import 'package:pfe/core/utils/currency_formatter.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe/features/profile/presentation/profile/profile.dart' as pfe_profile;
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final PropertyModel property;
  final bool isReadOnly;
  const DetailScreen({super.key, required this.property, this.isReadOnly = false});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? _hostData;

  @override
  void initState() {
    super.initState();
    _fetchHostData();
  }

  Future<void> _fetchHostData() async {
    if (widget.property.hostId.isEmpty) return;
    try {
      final snap = await FirebaseDatabase.instance.ref('users/${widget.property.hostId}').get();
      if (snap.exists && mounted) {
        setState(() {
          _hostData = Map<String, dynamic>.from(snap.value as Map);
        });
      }
    } catch (_) {}
  }

  Future<void> _showAddReviewDialog(BuildContext context, String propertyId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to write a review')));
      return;
    }

    final commentController = TextEditingController();
    double rating = 5.0;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: context.appColors.card,
              title: const Text('Write a Review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (commentController.text.trim().isEmpty) return;
                    
                    // Fetch user details for name
                    String authorName = 'Anonymous';
                    try {
                      final userSnap = await FirebaseDatabase.instance.ref('users/${user.uid}').get();
                      if (userSnap.exists) {
                        final data = Map<String, dynamic>.from(userSnap.value as Map);
                        authorName = data['fullName'] ?? 'Anonymous';
                      }
                    } catch (_) {}

                    final newReview = {
                      'userId': user.uid,
                      'name': authorName,
                      'text': commentController.text.trim(),
                      'rating': rating,
                      'date': DateTime.now().toString().substring(0, 10),
                    };

                    // Add to property
                    final dbRef = FirebaseDatabase.instance.ref('properties/$propertyId/reviews');
                    await dbRef.push().set(newReview);
                    
                    // Update local UI
                    setState(() {
                      widget.property.reviews.add(newReview);
                    });
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review added successfully!')));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final property = widget.property;

    return ValueListenableBuilder<String>(
      valueListenable: CurrencyFormatter.symbolNotifier,
      builder: (context, symbol, child) {
        return Scaffold(
          backgroundColor: c.background,
          body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImgSlider(images: property.images),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleOfRoom(property: property),
                        const SizedBox(height: 16),
                        Divider(color: c.border),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PricingCard(
                              icon: Icons.payments,
                              title: property.displayPrice.replaceAll(RegExp(r'\s*/\s*month|\s*/\s*mo|\s+'), ''),
                              subtitle: '/month',
                            ),
                            PricingCard(
                              icon: Icons.calendar_today,
                              title: property.moveInDate,
                              subtitle: 'Move-in',
                            ),
                            PricingCard(
                              icon: Icons.meeting_room,
                              title: property.roomType,
                              subtitle: 'Type',
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // CurrentResident now fetches dynamically from Firebase
                        CurrentResident(
                          propertyId: property.id,
                        ),
                        const SizedBox(height: 32),

                        if (property.description.isNotEmpty) ...[
                          Text(
                            'About the space',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: c.textMain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            property.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.45,
                              color: c.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        const SizedBox(height: 32),

                        Amenetis(amenities: property.amenities),
                        const SizedBox(height: 8),

                        Location(
                          locationName: property.subtitle,
                          mapImageUrl: property.mapImageUrl,
                          latitude: property.latitude,
                          longitude: property.longitude,
                        ),


                        const SizedBox(height: 28),

                        // ─── Host Section ───────────────────────────────
                        if (widget.property.hostId.isNotEmpty) _buildHostCard(c, context),
                        if (widget.property.hostId.isNotEmpty) const SizedBox(height: 28),

                        Ratingsummry(rating: property.rating, reviewsCount: property.reviews.length),
                        const SizedBox(height: 20),

                        if (property.reviews.isNotEmpty)
                          SizedBox(
                            height: 170,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: property.reviews.length,
                              itemBuilder: (context, index) {
                                final review = property.reviews[index];
                                return ReviewCard(
                                  name: review['name'] ?? 'Anonymous',
                                  date: review['date'] ?? 'Unknown Date',
                                  text: review['text'] ?? '',
                                );
                              },
                            ),
                          )
                        else
                          const Text(
                            'No reviews yet.',
                            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                        
                        const SizedBox(height: 16),
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () => _showAddReviewDialog(context, property.id),
                            icon: const Icon(Icons.edit),
                            label: const Text('Write a Review'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: c.primary,
                              side: BorderSide(color: c.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (!widget.isReadOnly)
              ButtomActionButton(property: property),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildHostCard(AppColorScheme c, BuildContext context) {
    final hostName = _hostData?['fullName'] as String? ?? 'Host';
    final hostAvatar = _hostData?['profileImage'] as String? ?? '';
    final hostRating = _hostData?['rating']?.toString() ?? '0.0';
    final hostBio = _hostData?['bio'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meet your Host',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: c.textMain,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundColor: c.segmentBg,
                backgroundImage: hostAvatar.isNotEmpty ? NetworkImage(hostAvatar) : null,
                child: hostAvatar.isEmpty
                    ? Icon(Icons.person, size: 32, color: c.textSecondary)
                    : null,
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hostName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: c.textMain,
                      ),
                    ),
                    if (hostRating != '0.0') ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '$hostRating rating',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (hostBio.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        hostBio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pfe_profile.Profile(viewedUserId: widget.property.hostId),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: c.primary,
                side: BorderSide(color: c.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'View Host Profile',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
