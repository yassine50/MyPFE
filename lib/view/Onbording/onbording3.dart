import 'package:flutter/material.dart';
import 'package:pfe/component/blueButton/BlueButton.dart';
import 'package:pfe/component/skip%20/Skip.dart';
import 'package:pfe/component/text/Text.dart';
import 'package:pfe/view/SelectLanguage/SelectLanguage.dart';

class Onbording3 extends StatelessWidget {
  const Onbording3({super.key});

  // Function for button press
  void _handleStartExploring(BuildContext context) {
    print('Start Exploring pressed');
    // Navigate to main app or next screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  // Function for login navigation
  void _handleLogin(BuildContext context) {
    print('Login pressed');
    // Navigate to login screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

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
                // Skip button at top right
             const SizedBox(height: 60),

                // Main content - centered
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image Section - NO MARGINS
                        Container(
                          width: MediaQuery.of(context).size.width - 48, // Full width minus horizontal padding
                          height: 320,
                          decoration: BoxDecoration(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/onbording3.png',
                              fit: BoxFit.cover, // Changed to cover to fill completely
                              width: MediaQuery.of(context).size.width - 48,
                              height: 320,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Title - Multi-line with proper spacing
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text1(
                                text: 'Community & Legal',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                              const SizedBox(height: 4),
                              Text1(
                                text: 'Support',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Description with proper line breaks
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text1(
                            text: 'Rent with confidence. We provide verified listings, standardized contracts, and 24/7 community support for your peace of mind.',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // "Start Exploring" button
                        Bluebutton(
                          onPressed: () {
                            Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => LanguageSelectionScreen(),
    ),
  );
                          },
                          textButton: 'Start Exploring',
                        ),

                        const SizedBox(height: 24),

                        // Already have account? Login text
                        Center(
                          child: GestureDetector(
                            onTap: () => _handleLogin(context),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF64748B),
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Already have an account? ',
                                  ),
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Page indicator dots (3 dots, 3rd one active)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // First dot (inactive)
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
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Third dot (active - this page)
                            Container(
                              width: 30,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D8CFF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}