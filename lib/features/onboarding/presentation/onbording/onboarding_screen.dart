import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:pfe/core/widgets/blue_button/blue_button.dart';
import 'package:pfe/core/widgets/skip/skip.dart';
import 'package:pfe/core/widgets/text/text.dart';
import 'package:pfe/features/auth/presentation/login/login.dart';
import 'package:pfe/features/onboarding/presentation/select_language/select_language.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/onbording1.png',
      'title': 'Find trusted co-living',
      'description':
          'Join a community of verified residents.\nFind a home, not just a room, in Romania\'s best neighborhoods.',
    },
    {
      'image': 'assets/images/onbording2.png',
      'title': 'Verified by RoRent',
      'description':
          'Every roommate and property is vetted.\nWe ensure a safe, scam-free environment for your co-living journey.',
    },
    {
      'image': 'assets/images/onbording3.png',
      'title': 'Community & Legal Support',
      'description':
          'Rent with confidence. We provide verified listings, standardized contracts, and 24/7 community support for your peace of mind.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            colors: [AppColors.primaryBackground, AppColors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header/Skip button
                Skip(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageSelectionScreen(),
                      ),
                    );
                  },
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F4FD),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                _onboardingData[index]['image']!,
                                fit: BoxFit.contain,
                                width: 320,
                                height: 320,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Text1(
                                  text: _onboardingData[index]['title']!,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                                const SizedBox(height: 22),
                                Text1(
                                  text: _onboardingData[index]['description']!,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Dots Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 30 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primaryBlue
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Next Button
                Bluebutton(
                  onPressed: _nextPage,
                  textButton: _currentPage == _onboardingData.length - 1
                      ? AppStrings.onboardingGetStarted
                      : AppStrings.onboardingNext,
                ),

                if (_currentPage == _onboardingData.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey600,
                            ),
                            children: const [
                              TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
