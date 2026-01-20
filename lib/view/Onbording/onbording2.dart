import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/component/blueButton/BlueButton.dart';
import 'package:pfe/component/skip%20/Skip.dart';
import 'package:pfe/component/text/Text.dart';
import 'package:pfe/view/Onbording/onbording3.dart';

class Onbording2 extends StatelessWidget {
  const Onbording2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header/Skip button
                Skip(),

                // Illustration/Image Section
                Expanded(
                  child: Center(
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/onbording2.png',
                            fit: BoxFit.contain,
                            width: 320,
                            height: 320,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Text Content
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text1(
                        text: 'Verified by RoRent',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                      const SizedBox(height: 22),
                      Text1(
                        text:
                            'Inspected for quality & safety\n100% Verified Homes\nNo more catfishing.We personally visit\nand verify every listing in Romania to\nensure it matches the photos.',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First dot (active)
                     Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Second dot (inactive)
                   
                    Container(
                      width: 30,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D8CFF), // Blue color
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Third dot (inactive)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                 const SizedBox(height: 30), // Reduced spacing for dots

                // Next Button
                Bluebutton(onPressed: () { 
                  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => const Onbording3(),
    ),
  );
                 }, textButton: 'Next',),
                
               

                // 3 Indicator Dots (Page Indicators)
               

                const SizedBox(height: 30), // Bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}