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
import 'package:pfe/core/models/property_model.dart';

class DetailScreen extends StatefulWidget {
  final PropertyModel property;
  const DetailScreen({super.key, required this.property});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final property = widget.property;

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
                              title: property.price.replaceAll('/mo', '').replaceAll(' ', ''),
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

                        if (property.residentDemographics.isNotEmpty || property.residentAvatars.isNotEmpty) ...[
                          CurrentResident(
                            demographics: property.residentDemographics,
                            avatars: property.residentAvatars,
                          ),
                          const SizedBox(height: 32),
                        ],

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

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action bar
            ButtomActionButton(price: property.price),
          ],
        ),
      ),
    );
  }
}
