import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/features/search/presentation/search_screen/search_screen.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: const Icon(Icons.search),
                hintText: 'Where to next? (e.g., Bucharest)',
                border: InputBorder.none,
                hintStyle: GoogleFonts.firaSans(fontSize: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => const SearchScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.tune),
          ),
        ),
      ],
    );
  }
}
