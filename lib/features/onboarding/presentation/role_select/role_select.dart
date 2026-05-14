import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/widgets/google_nav_bar/navbar.dart';

class RoleSelect extends StatelessWidget {
  const RoleSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ FIX OVERFLOW
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Back + Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    TextButton(onPressed: () {}, child: const Text("Log in")),
                  ],
                ),

                const SizedBox(height: 20),

                // 📝 Title
                const Text(
                  AppStrings.roleSelectTitle,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  AppStrings.roleSelectSubtitle,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                // 🏠 RENTER CARD
                _RoleCard(
                  image: 'assets/images/renter.jpg',
                  tag: 'Popular',
                  title: AppStrings.roleRenterTitle,
                  description: AppStrings.roleRenterDesc,
                  buttonText: AppStrings.roleRenterButton,
                  filled: true,
                ),

                const SizedBox(height: 20),

                // 🏡 HOST CARD
                _RoleCard(
                  image: 'assets/images/host.jpg',
                  title: AppStrings.roleHostTitle,
                  description: AppStrings.roleHostDesc,
                  buttonText: AppStrings.roleHostButton,
                  filled: false,
                ),

                const SizedBox(height: 30),

                // 📄 Terms
                const Center(
                  child: Text(
                    AppStrings.roleTerms,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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

class _RoleCard extends StatelessWidget {
  final String image;
  final String? tag;
  final String title;
  final String description;
  final String buttonText;
  final bool filled;

  const _RoleCard({
    required this.image,
    this.tag,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (tag != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(tag!, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: AppColors.grey600)),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filled ? AppColors.primaryBlue : AppColors.white,
                      foregroundColor: filled ? AppColors.white : AppColors.primaryBlue,
                      side: filled
                          ? null
                          : const BorderSide(color: AppColors.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              const GoogleNavBar(renter: true),
                        ),
                      );
                    },
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
