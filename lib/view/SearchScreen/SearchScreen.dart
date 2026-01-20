import 'package:flutter/material.dart';
import 'package:pfe/component/ListCardHome/ListCardHome.dart';
import 'package:pfe/component/SearchBar/SearchBar.dart';
import 'package:pfe/component/header/Header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 FIXED CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(),
                  const SizedBox(height: 20),
                  Searchbar(),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            /// 🔹 SCROLLABLE LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ListCardHome(
                    title: '3-Bed Apt near Poli',
                    subtitle: 'Regie area • 3 Rooms',
                    price: '600€ / mo',
                    rating: '4.7',
                    imageUrl:
                        'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',
                  ),
                  ListCardHome(
                    title: 'Sunny Flat in Unirii',
                    subtitle: 'Center • 2 Rooms',
                    price: '480€ / mo',
                    rating: '4.5',
                    imageUrl:
                        'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔹 MAP BUTTON (FLOATING)
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.map),
        label: const Text('Map'),
      ),
    );
  }
}
