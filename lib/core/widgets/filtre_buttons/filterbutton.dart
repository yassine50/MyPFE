import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Filterbutton extends StatelessWidget {
  final bool active;
  final String text;
  final IconData icon;
  final VoidCallback? onTap;
  const Filterbutton({
    super.key,
    required this.active,
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1E6AF0) : const Color(0xFFF3F5F7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: active ? Colors.white : Colors.black),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.firaSans(
                fontSize: 13,
                color: active ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
