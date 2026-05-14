import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/widgets/google_nav_bar/navbar.dart';
import 'package:pfe/features/profile/presentation/edit_profile/edit_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Top App Bar
              _buildTopAppBar(c, context),

              // Profile Header
              _buildProfileHeader(c),

              // Stats Grid
              _buildStatsGrid(c),

              // Bio Text
              _buildBioText(c),

              // Personal Info Grid
              _buildPersonalInfoGrid(c),

              // Divider
              _buildDivider(c),

              // Settings List
              _buildSettingsList(c),

              // Action Buttons
              _buildActionButtons(c, context),
            ],
          ),
        ),
      ),
    );
  }

  // Top App Bar
  Widget _buildTopAppBar(AppColorScheme c, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: c.card,
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: c.hover,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              padding: EdgeInsets.zero,
              color: c.textMain,
            ),
          ),

          // Title
          Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                  height: 1.2,
                  letterSpacing: -0.015,
                ),
              ),
            ),
          ),

          // Edit Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: c.hover,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const EditProfil(),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 24),
              padding: EdgeInsets.zero,
              color: c.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Profile Header
  Widget _buildProfileHeader(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          // Avatar with Verification Badge
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // Avatar
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(64),
                  border: Border.all(color: c.card, width: 4),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCjTlI_2k6pNuXcOcgORYzbBlQG-1xVxP49PGP9Md7fAJXqe9zxCHm2puNvuyMCnZL7uhYERFaNC5p9pl23W1cNlPadTFmmf0Hh56ZQf8npOD5IyxLoYIMnWgDmsioahXL32VXmIdcJgFjIGhoVyyVKMFySkBY2utRS_lk4ZwRw5JfmeVOoIVS3nJE3CzUO7qJE0Z0BpM47hep3JAhxg7suwaPGzBawlHcjurgDjfbHjnTL35aTrQuMMxjA7LcQx-hXHfxFHswke_k',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),

              // Verification Badge
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.verified, color: c.primary, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            'Alexandru Popescu',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 4),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: c.textSecondary, size: 18),
              const SizedBox(width: 4),
              Text(
                'Bucharest, Romania',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Verification Badge Text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: c.verifiedBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: c.verifiedText,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Identity Verified',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.verifiedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stats Grid
  Widget _buildStatsGrid(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Stays
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.statsBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.statsBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '12',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'STAYS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Rating
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.statsBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.statsBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '4.9',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: c.textMain,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.star, color: c.star, size: 16),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RATING',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Response
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.statsBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.statsBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '100%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RESPONSE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bio Text
  Widget _buildBioText(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        'Digital nomad looking for cozy apartments in Transylvania. I love hiking, local coffee shops, and exploring hidden gems in the city.',
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: c.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  // Personal Info Grid
  Widget _buildPersonalInfoGrid(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      child: Container(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.divider, width: 1)),
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 32,
          childAspectRatio: 2,
          children: [
            // Joined in
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Joined in',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'March 2021',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textMain,
                  ),
                ),
              ],
            ),

            // Nationality
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nationality',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Romanian',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: c.textMain,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Languages
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Languages',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'RO, EN, FR',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textMain,
                  ),
                ),
              ],
            ),

            // Occupation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Occupation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Product Designer',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textMain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Divider
  Widget _buildDivider(AppColorScheme c) {
    return Container(
      height: 8,
      width: double.infinity,
      color: c.divider,
      margin: const EdgeInsets.only(top: 16, bottom: 16),
    );
  }

  // Settings List
  Widget _buildSettingsList(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Account Settings',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: c.textMain,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Personal Information
          _buildSettingListItem(
            c: c,
            icon: Icons.person,
            title: 'Personal Information',
            onTap: () {
              // Handle personal information tap
            },
          ),

          // Login & Security
          _buildSettingListItem(
            c: c,
            icon: Icons.lock,
            title: 'Login & Security',
            onTap: () {
              // Handle login & security tap
            },
          ),

          // Payments and Payouts
          _buildSettingListItem(
            c: c,
            icon: Icons.payments,
            title: 'Payments and Payouts',
            onTap: () {
              // Handle payments tap
            },
          ),

          // Translation
          _buildSettingListItem(
            c: c,
            icon: Icons.translate,
            title: 'Translation',
            onTap: () {
              // Handle translation tap
            },
          ),
        ],
      ),
    );
  }

  // Setting List Item
  Widget _buildSettingListItem({
    required AppColorScheme c,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.settingsIconBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: c.settingsIcon, size: 24),
              ),

              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textMain,
                  ),
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: c.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons(AppColorScheme c, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Switch to Host Mode Button
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.buttonBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle switch to host mode
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const GoogleNavBar(renter: false),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_work, color: c.textMain, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Switch to Host Mode',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: c.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Log Out Button
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: c.logoutBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle logout
                },
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.logoutText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
