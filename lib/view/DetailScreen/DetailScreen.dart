import 'package:flutter/material.dart';
import 'package:pfe/component/Amenetis/Amenetis.dart';
import 'package:pfe/component/BottomActionbutton/ButtomActionButton.dart';
import 'package:pfe/component/CurrentResident/CurrentResident.dart';
import 'package:pfe/component/ImgSlider/ImgSlider.dart';
import 'package:pfe/component/PricingCard/PricingCard.dart';
import 'package:pfe/component/ReviewCard/ReviewCards.dart';
import 'package:pfe/component/TitleOfRoom/TitleOfRoom.dart';
import 'package:pfe/component/location/Location.dart';
import 'package:pfe/view/ratingSummry/RatingSummry.dart';


class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        Divider(),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            PricingCard(
                              icon: Icons.payments,
                              title: "€450",
                              subtitle: "/month",
                            ),
                            PricingCard(
                              icon: Icons.calendar_today,
                              title: "Now",
                              subtitle: "Move-in",
                            ),
                            PricingCard(
                              icon: Icons.meeting_room,
                              title: "Private",
                              subtitle: "Type",
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Current Residents - FIXED layout
                        CurrentResident(),

                        const SizedBox(height: 32),

                        // About section
                        const Text(
                          'About the space',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enjoy a bright, fully furnished private room in a modern shared apartment in the heart of Bucharest. '
                          'You’ll be sharing the common areas with three friendly young professionals. '
                          'The apartment features a spacious living room, a fully equipped kitchen, and two bathrooms.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: Colors.grey[800],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Amenities
                        Amenetis(),
                        const SizedBox(height: 8),

                        Location(),

                        const SizedBox(height: 6),
                        const Text(
                          "Exact location provided after booking.",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        const SizedBox(height: 28),

                       Ratingsummry(),
                        const SizedBox(height: 20),

                        // ================= REVIEW CARDS =================
                        SizedBox(
                          height: 170,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [


                              ReviewCard(
                                name: "Alexandru Popa",
                                date: "October 2023",
                                text:
                                    "Great place! The roommates were super welcoming and the location is unbeatable.",
                              ),
                              ReviewCard(
                                name: "Maria Ionescu",
                                date: "September 2023",
                                text:
                                    "Very clean and modern. The kitchen has everything you need.",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80), // space for bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action bar
           ButtomActionButton()
          ],
        ),
      ),
    );
  }
}



