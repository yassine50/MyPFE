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

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

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
                  ImgSlider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleOfRoom(),
                        const SizedBox(height: 16),
                        Divider(color: c.border),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PricingCard(
                              icon: Icons.payments,
                              title: '€450',
                              subtitle: '/month',
                            ),
                            PricingCard(
                              icon: Icons.calendar_today,
                              title: 'Now',
                              subtitle: 'Move-in',
                            ),
                            PricingCard(
                              icon: Icons.meeting_room,
                              title: 'Private',
                              subtitle: 'Type',
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        CurrentResident(),

                        const SizedBox(height: 32),

                        // About section
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
                          'Enjoy a bright, fully furnished private room in a modern shared apartment '
                          "in the heart of Bucharest. You'll be sharing the common areas with three "
                          'friendly young professionals. The apartment features a spacious living room, '
                          'a fully equipped kitchen, and two bathrooms.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: c.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 32),

                        Amenetis(),
                        const SizedBox(height: 8),

                        Location(),

                        const SizedBox(height: 6),
                        Text(
                          'Exact location provided after booking.',
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 28),

                        Ratingsummry(),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 170,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              ReviewCard(
                                name: 'Alexandru Popa',
                                date: 'October 2023',
                                text:
                                    'Great place! The roommates were super welcoming and the location is unbeatable.',
                              ),
                              ReviewCard(
                                name: 'Maria Ionescu',
                                date: 'September 2023',
                                text:
                                    'Very clean and modern. The kitchen has everything you need.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action bar
            ButtomActionButton(),
          ],
        ),
      ),
    );
  }
}
