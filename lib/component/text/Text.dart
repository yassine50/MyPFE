import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Text1 extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  Text1({super.key, required this.text, required this.fontSize, required this.fontWeight, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
                 text,
                 textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight:fontWeight, // Bold
                    height: 1.2,
                    color:color,
                  ),
                );
  }
}
