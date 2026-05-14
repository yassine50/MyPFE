import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:pfe/core/widgets/text/text.dart';

class SelectLanguage extends StatelessWidget {
  final String countryCode;
  final String title;
  final String description;
  final bool select;
  const SelectLanguage({
    super.key,
    required this.select,
    required this.countryCode,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: select ? const Color(0xFFE8F2FF) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: select ? const Color(0xFF0066CC) : Colors.transparent,
          width: 1.5,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(12),

      child: Row(
        children: [
          CountryFlag.fromCountryCode(
            countryCode,
            theme: const ImageTheme(shape: Circle()),
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text1(
                color: Colors.black,
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8),
              Text1(
                color: Colors.grey,
                text: description,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),

          const Spacer(),
          if (select)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF0066CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
        ],
      ),
    );
  }
}
