import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/widgets/list_card_home/list_card_home.dart';
import 'package:pfe/core/widgets/search_bar/search_bar.dart';
import 'package:pfe/core/widgets/header/header.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/core/utils/currency_formatter.dart';
import 'package:pfe/features/home/presentation/map/map_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<PropertyModel>? properties;
  const SearchScreen({super.key, this.properties});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
              child: widget.properties != null 
                ? (widget.properties!.isEmpty 
                    ? const Center(child: Text('No properties found.'))
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: widget.properties!.map((p) => ListCardHome(property: p)).toList(),
                      )
                  )
                : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ListCardHome(
                    property: PropertyModel(
                      id: 'search1',
                      title: '3-Bed Apt near Poli',
                      subtitle: 'Regie area • 3 Rooms',
                      price: '${CurrencyFormatter.format(600)} / mo',
                      rating: '4.7',
                      images: [
                          'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',
                      ],
                    ),
                  ),
                  ListCardHome(
                    property: PropertyModel(
                      id: 'search2',
                      title: 'Sunny Flat in Unirii',
                      subtitle: 'Center • 2 Rooms',
                      price: '${CurrencyFormatter.format(480)} / mo',
                      rating: '4.5',
                      images: [
                          'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔹 MAP BUTTON (FLOATING)
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapScreen(
                properties: widget.properties ?? [],
              ),
            ),
          );
        },
        icon: const Icon(Icons.map),
        label: const Text('Map'),
      ),
    );
  }
}
