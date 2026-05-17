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
import 'package:pfe/features/notifications/presentation/notifications_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GoogleNavBar extends StatefulWidget {
  final bool renter;
  const GoogleNavBar({super.key, required this.renter});

  @override
  State<GoogleNavBar> createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleNavBar> {
  int _selectedIndex = 0;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _listenUnread();
  }

  void _listenUnread() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    FirebaseDatabase.instance
        .ref('notifications/$uid')
        .onValue
        .listen((event) {
      if (!mounted) return;
      int count = 0;
      if (event.snapshot.value != null) {
        final raw = event.snapshot.value as Map<dynamic, dynamic>;
        raw.forEach((_, val) {
          if (val is Map && val['read'] != true) count++;
        });
      }
      setState(() => _unreadCount = count);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = widget.renter
        ? [
            HomeScreen(),
            Saved(),
            const NotificationsScreen(),
            MyBookingRenter(),
            InboxWidget(isRenter: true),
            Setting(isHostMode: false),
          ]
        : [
            Dashbord(),
            MyListing(),
            const NotificationsScreen(),
            MyBooking(),
            InboxWidget(isRenter: false),
            Setting(isHostMode: true),
          ];

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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: GNav(
              gap: 4,
              iconSize: 22,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: const Duration(milliseconds: 400),
              backgroundColor: Colors.white,
              color: Colors.grey.shade500,
              activeColor: const Color(0xFF1E6AF0),
              tabBackgroundColor: const Color(0xFFEAF1FF),
              textStyle: GoogleFonts.firaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E6AF0),
              ),
              tabs: widget.renter
                  ? [
                      GButton(icon: Icons.search, text: AppStrings.navExplore),
                      GButton(icon: Icons.favorite_border, text: AppStrings.navSaved),
                      GButton(
                        icon: Icons.notifications_outlined,
                        text: 'Alerts',
                        leading: _unreadCount > 0
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(Icons.notifications_outlined,
                                      size: _selectedIndex == 2 ? 22 : 24, 
                                      color: _selectedIndex == 2 ? const Color(0xFF1E6AF0) : Colors.grey.shade500),
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          _unreadCount > 9 ? '9+' : '$_unreadCount',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                      GButton(
                        icon: Icons.calendar_month_outlined,
                        text: 'Bookings',
                      ),
                      GButton(
                        icon: Icons.chat_bubble_outline,
                        text: 'Inbox',
                      ),
                      GButton(icon: Icons.person_outline, text: AppStrings.navProfile),
                    ]
                  : [
                      GButton(icon: Icons.dashboard_outlined, text: AppStrings.navDashbord),
                      GButton(icon: Icons.apartment_outlined, text: 'Listings'),
                      GButton(
                        icon: Icons.notifications_outlined,
                        text: 'Alerts',
                        leading: _unreadCount > 0
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(Icons.notifications_outlined,
                                      size: _selectedIndex == 2 ? 22 : 24, 
                                      color: _selectedIndex == 2 ? const Color(0xFF1E6AF0) : Colors.grey.shade500),
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          _unreadCount > 9 ? '9+' : '$_unreadCount',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                      GButton(
                        icon: Icons.calendar_month_outlined,
                        text: 'Bookings',
                      ),
                      GButton(
                        icon: Icons.chat_bubble_outline,
                        text: 'Inbox',
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
