import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/features/search/presentation/search_screen/search_screen.dart';

import 'package:pfe/core/models/property_model.dart';

class BudgetCardHome extends StatefulWidget {
  final List<PropertyModel> properties;
  const BudgetCardHome({super.key, required this.properties});

  @override
  State<BudgetCardHome> createState() => _BudgetCardHomeState();
}

class _BudgetCardHomeState extends State<BudgetCardHome> {
  double _budget = 450;
  @override
  Widget build(BuildContext context) {
    final filteredProperties = widget.properties.where((p) {
      final priceStr = p.price.replaceAll(RegExp(r'[^0-9]'), '');
      if (priceStr.isEmpty) return false;
      final priceNum = int.tryParse(priceStr) ?? 0;
      return priceNum <= _budget;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF1F6FF), Color(0xFFEAF1FF)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 HEADER
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.g_mobiledata,
                  color: Color(0xFF1E6AF0),
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Set your budget',
                style: GoogleFonts.firaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 🔹 DESCRIPTION
          Text(
            'Find a place that fits your wallet. Average rent in your area is 400€.',
            style: GoogleFonts.firaSans(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 SLIDER
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: const Color(0xFF1E6AF0),
              inactiveTrackColor: const Color(0xFFDCE5F2),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF1E6AF0).withValues(alpha: 0.15),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              min: 100,
              max: 1000,
              value: _budget,
              onChanged: (value) {
                setState(() {
                  _budget = value;
                });
              },
            ),
          ),

          // 🔹 SLIDER LABELS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '100€',
                  style: GoogleFonts.firaSans(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${_budget.toInt()}€ / mo',
                  style: GoogleFonts.firaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E6AF0),
                  ),
                ),
                Text(
                  '1K€+',
                  style: GoogleFonts.firaSans(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 CTA BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6DE6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (context) => SearchScreen(properties: filteredProperties)),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show ${filteredProperties.length} Rentals',
                    style: GoogleFonts.firaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
