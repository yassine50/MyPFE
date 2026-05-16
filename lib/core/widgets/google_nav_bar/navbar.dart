import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pfe/features/chat/presentation/dashbord_message/dashbord_message.dart';
import 'package:pfe/features/host/presentation/host/dashbord/dashbord.dart';
import 'package:pfe/features/host/presentation/host/my_booking/my_booking.dart';
import 'package:pfe/features/host/presentation/host/my_listing/my_listing.dart';
import 'package:pfe/features/booking/presentation/mybooking_rent/my_booking_renter.dart';
import 'package:pfe/features/property_details/presentation/saved/saved.dart';
import 'package:pfe/features/profile/presentation/setting/setting.dart';
import 'package:pfe/features/home/presentation/home/home.dart';

class GoogleNavBar extends StatefulWidget {
  final bool renter;
  const GoogleNavBar({super.key, required this.renter});

  @override
  State<GoogleNavBar> createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = widget.renter
        ? [HomeScreen(), Saved(), MyBookingRenter(), InboxWidget(isRenter: true), Setting()]
        : [Dashbord(), MyListing(), MyBooking(), InboxWidget(isRenter: false), Setting()];
    return Scaffold(
      backgroundColor: Colors.white,

      body: screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GNav(
              gap: 8,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 400),

              // 🎨 COLORS (MATCH IMAGE)
              backgroundColor: Colors.white,
              color: Colors.grey.shade500, // inactive icon
              activeColor: const Color(0xFF1E6AF0), // active icon & text
              tabBackgroundColor: const Color(
                0xFFEAF1FF,
              ), // active pill background

              textStyle: GoogleFonts.firaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E6AF0),
              ),

              tabs: widget.renter
                  ? [
                      GButton(icon: Icons.search, text: AppStrings.navExplore),
                      GButton(icon: Icons.favorite_border, text: AppStrings.navSaved),
                      GButton(
                        icon: Icons.calendar_month_outlined,
                        text: AppStrings.navBookings,
                      ),
                      GButton(
                        icon: Icons.chat_bubble_outline,
                        text: AppStrings.navMessages,
                      ),
                      GButton(icon: Icons.person_outline, text: AppStrings.navProfile),
                    ]
                  : [
                      GButton(icon: Icons.dashboard_outlined, text: AppStrings.navDashbord),
                      GButton(icon: Icons.apartment_outlined, text: AppStrings.navListings),
                      GButton(
                        icon: Icons.calendar_month_outlined,
                        text: AppStrings.navBookings,
                      ),
                      GButton(
                        icon: Icons.chat_bubble_outline,
                        text: AppStrings.navMessages,
                      ),
                      GButton(icon: Icons.person_outline, text: AppStrings.navProfile),
                    ],

              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
