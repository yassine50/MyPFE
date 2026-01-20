import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pfe/view/DashbordMessage/DashbordMessage.dart';
import 'package:pfe/view/Host/Dashbord/Dashbord.dart';
import 'package:pfe/view/Host/MyBooking/MyBooking.dart';
import 'package:pfe/view/Host/MyListing/MyListing.dart';
import 'package:pfe/view/MybookingRent/MyBookingRenter.dart';
import 'package:pfe/view/Saved/Saved.dart';
import 'package:pfe/view/Setting/Setting.dart';
import 'package:pfe/view/home/Home.dart';

class GoogleNavBar extends StatefulWidget {
  final bool renter ; 
  const GoogleNavBar({super.key, required this.renter});

  @override
  State<GoogleNavBar> createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleNavBar> {
  int _selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
      final List<Widget> _screens =  widget.renter ? [
    HomeScreen(),
    Saved(),  
   MyBookingRenter(),
   InboxWidget(),
    Setting(),
  ] :
  [
    Dashbord(),
   
   MyListing(),  
  
  MyBooking(),
  InboxWidget(),
    
     Setting(),
  ] ;
    return Scaffold(
      backgroundColor: Colors.white,

      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              duration: const Duration(milliseconds: 400),

              // 🎨 COLORS (MATCH IMAGE)
              backgroundColor: Colors.white,
              color: Colors.grey.shade500, // inactive icon
              activeColor: const Color(0xFF1E6AF0), // active icon & text
              tabBackgroundColor:
                  const Color(0xFFEAF1FF), // active pill background

              textStyle: GoogleFonts.firaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E6AF0),
              ),

              tabs: widget.renter ? [
                GButton(
                  icon: Icons.search,
                  text: 'Explore',
                ),
                GButton(
                  icon: Icons.favorite_border,
                  text: 'Saved',
                ),
                GButton(
                  icon: Icons.calendar_month_outlined,
                  text: 'Bookings',
                ),
                GButton(
                  icon: Icons.chat_bubble_outline,
                  text: 'Messages',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                ),
              ] :[
                GButton(
                  icon: Icons.dashboard_outlined,
                  text: 'Dashbord',
                ),
                GButton(
                  icon: Icons.apartment_outlined,
                  text: 'Listings',
                ),
                GButton(
                  icon: Icons.calendar_month_outlined,
                  text: 'Bookings',
                ),
                GButton(
                  icon: Icons.chat_bubble_outline,
                  text: 'Messages',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                ),
              ] ,

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
