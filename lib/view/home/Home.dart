import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/component/BudgetCardHome/BudgetCardHome.dart';
import 'package:pfe/component/CardHome/CardHome.dart';
import 'package:pfe/component/ListCardHome/ListCardHome.dart';
import 'package:pfe/component/SearchBar/SearchBar.dart';
import 'package:pfe/component/filtreButtons/Filterbutton.dart';
import 'package:pfe/component/header/Header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 HEADER
              HeaderWidget(),

              const SizedBox(height: 20),

              // 🔹 SEARCH BAR
              Searchbar(),

              const SizedBox(height: 20),

              // 🔹 FILTER BUTTONS
              Row(
                children: [
                  Filterbutton(
                    active: true,
                    text: 'Explore',
                    icon: Icons.search,
                  ),
                  const SizedBox(width: 10),
                  Filterbutton(
                    active: false,
                    text: 'Near Metro',
                    icon: Icons.subway,
                  ),
                  const SizedBox(width: 10),
                  Filterbutton(
                    active: false,
                    text: 'Co-living',
                    icon: Icons.people_outline,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔹 FEATURED LISTINGS
              _sectionHeader('Featured Listings'),

              const SizedBox(height: 12),

              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CardHome(
                      price: '350€/mo',
                      title: 'Modern Studio in Pipera',
                      subtitle: 'Wifi included • Near Metro',
                      rating: '4.9',
                      imageUrl:
                          'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',
                    ),
                    CardHome(
                      price: '500€/mo',
                      title: 'Cozy 2-bedroom',
                      subtitle: 'Central Park',
                      rating: '4.8',
                      imageUrl:
                          'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 BUDGET CARD
              BudgetCardHome(),

              const SizedBox(height: 24),

              // 🔹 CO-LIVING
              _sectionHeader('Best for Co-living'),

              const SizedBox(height: 12),
              ListCardHome(title: '3-Bed Apt near Poli', subtitle: 'Regie area • 3 Rooms', price: '600€ / mo', rating: '4.7', imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',),
              ListCardHome(title: 'Sunny Flat in Unirii', subtitle: 'Center • 2 Rooms', price: '480€ / mo', rating: '4.5', imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',),

            

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // 🔹 MAP BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.map),
        label: const Text('Map'),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.firaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'See all',
          style: GoogleFonts.firaSans(
            fontSize: 13,
            color: const Color(0xFF1E6AF0),
          ),
        ),
      ],
    );
  }
}
