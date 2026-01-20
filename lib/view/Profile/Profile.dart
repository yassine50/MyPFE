import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/component/GoogleNavBar/Navbar.dart';
import 'package:pfe/view/EditProfile/EditProfile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDarkMode);

    return Scaffold(
      backgroundColor: colors['background'],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Top App Bar
              _buildTopAppBar(colors, context),
              
              // Profile Header
              _buildProfileHeader(colors),
              
              // Stats Grid
              _buildStatsGrid(colors),
              
              // Bio Text
              _buildBioText(colors),
              
              // Personal Info Grid
              _buildPersonalInfoGrid(colors),
              
              // Divider
              _buildDivider(colors),
              
              // Settings List
              _buildSettingsList(colors),
              
              // Action Buttons
              _buildActionButtons(colors, context),
            ],
          ),
        ),
      ),
    );
  }

  // Top App Bar
  Widget _buildTopAppBar(Map<String, Color> colors,BuildContext context ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: colors['card'],
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors['hover'],
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              padding: EdgeInsets.zero,
              color: colors['textMain'],
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
                  color: colors['textMain'],
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
              color: colors['hover'],
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
              color: colors['primary'],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Header
  Widget _buildProfileHeader(Map<String, Color> colors) {
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
                  border: Border.all(
                    color: colors['card']!,
                    width: 4,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCjTlI_2k6pNuXcOcgORYzbBlQG-1xVxP49PGP9Md7fAJXqe9zxCHm2puNvuyMCnZL7uhYERFaNC5p9pl23W1cNlPadTFmmf0Hh56ZQf8npOD5IyxLoYIMnWgDmsioahXL32VXmIdcJgFjIGhoVyyVKMFySkBY2utRS_lk4ZwRw5JfmeVOoIVS3nJE3CzUO7qJE0Z0BpM47hep3JAhxg7suwaPGzBawlHcjurgDjfbHjnTL35aTrQuMMxjA7LcQx-hXHfxFHswke_k',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                  color: colors['card'],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.verified,
                  color: colors['primary'],
                  size: 20,
                ),
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
              color: colors['textMain'],
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: colors['textSecondary'],
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                'Bucharest, Romania',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colors['textSecondary'],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Verification Badge Text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors['verifiedBackground'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: colors['verifiedText'],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Identity Verified',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors['verifiedText'],
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
  Widget _buildStatsGrid(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Stays
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors['statsBackground'],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors['statsBorder']!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                      color: colors['textMain'],
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'STAYS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colors['textSecondary'],
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
                color: colors['statsBackground'],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors['statsBorder']!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                          color: colors['textMain'],
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        color: colors['star'],
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RATING',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colors['textSecondary'],
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
                color: colors['statsBackground'],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors['statsBorder']!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                      color: colors['textMain'],
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RESPONSE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colors['textSecondary'],
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
  Widget _buildBioText(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        'Digital nomad looking for cozy apartments in Transylvania. I love hiking, local coffee shops, and exploring hidden gems in the city.',
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colors['textSecondary'],
          height: 1.5,
        ),
      ),
    );
  }

  // Personal Info Grid
  Widget _buildPersonalInfoGrid(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      child: Container(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colors['divider']!,
              width: 1,
            ),
          ),
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
                    color: colors['textSecondary'],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'March 2021',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors['textMain'],
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
                    color: colors['textSecondary'],
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
                        color: colors['textMain'],
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
                    color: colors['textSecondary'],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'RO, EN, FR',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors['textMain'],
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
                    color: colors['textSecondary'],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Product Designer',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors['textMain'],
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
  Widget _buildDivider(Map<String, Color> colors) {
    return Container(
      height: 8,
      width: double.infinity,
      color: colors['dividerBackground'],
      margin: const EdgeInsets.only(top: 16, bottom: 16),
    );
  }

  // Settings List
  Widget _buildSettingsList(Map<String, Color> colors) {
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
                color: colors['textMain'],
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Personal Information
          _buildSettingListItem(
            colors: colors,
            icon: Icons.person,
            title: 'Personal Information',
            onTap: () {
              // Handle personal information tap
            },
          ),
          
          // Login & Security
          _buildSettingListItem(
            colors: colors,
            icon: Icons.lock,
            title: 'Login & Security',
            onTap: () {
              // Handle login & security tap
            },
          ),
          
          // Payments and Payouts
          _buildSettingListItem(
            colors: colors,
            icon: Icons.payments,
            title: 'Payments and Payouts',
            onTap: () {
              // Handle payments tap
            },
          ),
          
          // Translation
          _buildSettingListItem(
            colors: colors,
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
    required Map<String, Color> colors,
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
                  color: colors['settingsIconBackground'],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: colors['settingsIcon'],
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Title
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors['textMain'],
                  ),
                ),
              ),
              
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: colors['textSecondary'],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons(Map<String, Color> colors,BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Switch to Host Mode Button
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: colors['card'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors['buttonBorder']!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                          builder: (context) => const GoogleNavBar(renter: false,),
                        ),
                      );
                },
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_work,
                      color: colors['textMain'],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Switch to Host Mode',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors['textMain'],
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
              color: colors['logoutBackground'],
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
                      color: colors['logoutText'],
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

  // Colors based on theme
  Map<String, Color> _getColors(bool isDarkMode) {
    if (isDarkMode) {
      return {
        'primary': const Color(0xFF136DEC),
        'background': const Color(0xFF101822),
        'card': const Color(0xFF0F172A),
        'textMain': Colors.white,
        'textSecondary': const Color(0xFF94A3B8),
        'hover': const Color(0xFF1E293B),
        'verifiedBackground': const Color(0xFF065F46).withOpacity(0.2),
        'verifiedText': const Color(0xFF34D399),
        'statsBackground': const Color(0xFF1E293B),
        'statsBorder': const Color(0xFF334155),
        'star': const Color(0xFFF59E0B),
        'divider': const Color(0xFF1E293B),
        'dividerBackground': Colors.black.withOpacity(0.2),
        'settingsIconBackground': const Color(0xFF1E293B),
        'settingsIcon': const Color(0xFF94A3B8),
        'buttonBorder': const Color(0xFF334155),
        'logoutBackground': const Color(0xFF1E293B).withOpacity(0.5),
        'logoutText': const Color(0xFF94A3B8),
      };
    } else {
      return {
        'primary': const Color(0xFF136DEC),
        'background': const Color(0xFFF6F7F8),
        'card': Colors.white,
        'textMain': const Color(0xFF0F172A),
        'textSecondary': const Color(0xFF64748B),
        'hover': const Color(0xFFF1F5F9),
        'verifiedBackground': const Color(0xFFDCFCE7),
        'verifiedText': const Color(0xFF16A34A),
        'statsBackground': const Color(0xFFF8FAFC),
        'statsBorder': const Color(0xFFE2E8F0),
        'star': const Color(0xFFF59E0B),
        'divider': const Color(0xFFE2E8F0),
        'dividerBackground': const Color(0xFFF6F7F8),
        'settingsIconBackground': const Color(0xFFF1F5F9),
        'settingsIcon': const Color(0xFF64748B),
        'buttonBorder': const Color(0xFFE2E8F0),
        'logoutBackground': const Color(0xFFF1F5F9),
        'logoutText': const Color(0xFF64748B),
      };
    }
  }
}