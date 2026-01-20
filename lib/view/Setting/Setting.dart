import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/view/Profile/Profile.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Setting> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _faceIDLogin = true;

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
              _buildTopAppBar(colors),
              
              // Profile Section
              _buildProfileSection(colors),
              
              // General Section
              _buildGeneralSection(colors),
              
              // Notifications Section
              _buildNotificationsSection(colors),
              
              // Payments & Subscription Section
              _buildPaymentsSection(colors),
              
              // Privacy & Security Section
              _buildPrivacySection(colors),
              
              // Support Section
              _buildSupportSection(colors),
              
              // Footer
              _buildFooter(colors),
            ],
          ),
        ),
      ),
    );
  }

  // Top App Bar
  Widget _buildTopAppBar(Map<String, Color> colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          
          Expanded(
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors['textMain'],
                height: 1.2,
                letterSpacing: -0.015,
              ),
            ),
          ),
          const SizedBox(width: 40), // For balance
        ],
      ),
    );
  }

  // Profile Section
  Widget _buildProfileSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors['card'],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? 
              colors['card']!.withOpacity(0.1) : 
              colors['card']!.withOpacity(0.05),
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
              // Handle profile tap
               Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => Profile(),
    ),
  );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDeimHG6ybhdO74f5hEmh30HrvaUYsrMPztDpWKlfi-MkGRj_YkQH1Bg4Nx2M_lkt6h1OWJ8L9FBCSJYZtDhNISystwQNPMMcv3i-PHIf0tjdLhtuclLfyoIXjpSM0IZ5_NcC9Nu-4WMYuuZV3DvKc4q5Tu3c-zIfkBKHhf1a1kJpYmSqQ3TGomH_ubcpSueGIb0WP98jekJG0YeGW4lhoRpSghizds4tMLI6Cpm9rfHcHjkRdnjQNXWdSIXVq5kXThj2werSNufkc',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and Edit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alexandru Popescu',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors['textMain'],
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Edit Profile',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors['primary'],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Chevron
                  Icon(
                    Icons.chevron_right,
                    color: colors['textSecondary'],
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // General Section
  Widget _buildGeneralSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'GENERAL',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors['textSecondary'],
                letterSpacing: 1,
              ),
            ),
          ),
          // Section Content
          Container(
            decoration: BoxDecoration(
              color: colors['card'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? 
                  colors['card']!.withOpacity(0.1) : 
                  colors['card']!.withOpacity(0.05),
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
                // Language
                _buildSettingItem(
                  colors: colors,
                  icon: Icons.language,
                  title: 'Language',
                  value: 'English',
                  onTap: () {
                    // Handle language tap
                  },
                  showDivider: true,
                ),
                // Currency
                _buildSettingItem(
                  colors: colors,
                  icon: Icons.currency_exchange,
                  title: 'Currency',
                  value: 'RON',
                  onTap: () {
                    // Handle currency tap
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Notifications Section
  Widget _buildNotificationsSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'NOTIFICATIONS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors['textSecondary'],
                letterSpacing: 1,
              ),
            ),
          ),
          // Section Content
          Container(
            decoration: BoxDecoration(
              color: colors['card'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? 
                  colors['card']!.withOpacity(0.1) : 
                  colors['card']!.withOpacity(0.05),
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
                // Push Notifications
                _buildToggleItem(
                  colors: colors,
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                  showDivider: true,
                ),
                // Email Updates
                _buildToggleItem(
                  colors: colors,
                  icon: Icons.mail,
                  title: 'Email Updates',
                  value: _emailUpdates,
                  onChanged: (value) {
                    setState(() {
                      _emailUpdates = value;
                    });
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Payments & Subscription Section
  Widget _buildPaymentsSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'PAYMENTS & SUBSCRIPTION',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors['textSecondary'],
                letterSpacing: 1,
              ),
            ),
          ),
          // Section Content
          Container(
            decoration: BoxDecoration(
              color: colors['card'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? 
                  colors['card']!.withOpacity(0.1) : 
                  colors['card']!.withOpacity(0.05),
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
                // Payment Methods
                _buildSettingItem(
                  colors: colors,
                  icon: Icons.credit_card,
                  title: 'Payment Methods',
                  value: '',
                  onTap: () {
                    // Handle payment methods tap
                  },
                  showDivider: true,
                ),
                // Billing History
                _buildSettingItem(
                  colors: colors,
                  icon: Icons.receipt_long,
                  title: 'Billing History',
                  value: '',
                  onTap: () {
                    // Handle billing history tap
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Privacy & Security Section
  Widget _buildPrivacySection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'PRIVACY & SECURITY',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors['textSecondary'],
                letterSpacing: 1,
              ),
            ),
          ),
          // Section Content
          Container(
            decoration: BoxDecoration(
              color: colors['card'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? 
                  colors['card']!.withOpacity(0.1) : 
                  colors['card']!.withOpacity(0.05),
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
                // Change Password
                _buildSettingItem(
                  colors: colors,
                  icon: Icons.lock,
                  title: 'Change Password',
                  value: '',
                  onTap: () {
                    // Handle change password tap
                  },
                  showDivider: true,
                ),
                // FaceID Login
                _buildToggleItem(
                  colors: colors,
                  icon: Icons.face,
                  title: 'FaceID Login',
                  value: _faceIDLogin,
                  onChanged: (value) {
                    setState(() {
                      _faceIDLogin = value;
                    });
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Support Section
  Widget _buildSupportSection(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'SUPPORT',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors['textSecondary'],
                letterSpacing: 1,
              ),
            ),
          ),
          // Section Content
          Container(
            decoration: BoxDecoration(
              color: colors['card'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? 
                  colors['card']!.withOpacity(0.1) : 
                  colors['card']!.withOpacity(0.05),
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
                // Help Center
                _buildSettingItem(
                  colors: colors,
                  icon: Icons.help,
                  title: 'Help Center',
                  value: '',
                  onTap: () {
                    // Handle help center tap
                  },
                  showDivider: true,
                ),
                // Terms of Service
                _buildSettingItem(
                  colors: colors,
                  icon: Icons.description,
                  title: 'Terms of Service',
                  value: '',
                  onTap: () {
                    // Handle terms tap
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Footer
  Widget _buildFooter(Map<String, Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Log Out Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Handle logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors['red']!.withOpacity(0.1),
                foregroundColor: colors['red'],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide.none,
              ),
              child: Text(
                'Log Out',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Version
          Text(
            'Version 2.4.1 (Build 2024)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: colors['textSecondary'],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for setting items with chevron
  Widget _buildSettingItem({
    required Map<String, Color> colors,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors['primary']!.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: colors['primary'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colors['textMain'],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Value and Chevron
                    Row(
                      children: [
                        if (value.isNotEmpty)
                          Text(
                            value,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: colors['textSecondary'],
                            ),
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: colors['textSecondary'],
                          size: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showDivider)
                Container(
                  height: 1,
                  color: isDarkMode ? 
                    colors['card']!.withOpacity(0.1) : 
                    colors['card']!.withOpacity(0.05),
                  margin: const EdgeInsets.only(left: 56),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for toggle items
  Widget _buildToggleItem({
    required Map<String, Color> colors,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors['primary']!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: colors['primary'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors['textMain'],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Custom Toggle Switch
                GestureDetector(
                  onTap: () => onChanged(!value),
                  child: Container(
                    width: 44,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: value ? colors['primary'] : colors['card']!.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Container(
              height: 1,
              color: isDarkMode ? 
                colors['card']!.withOpacity(0.1) : 
                colors['card']!.withOpacity(0.05),
              margin: const EdgeInsets.only(left: 56),
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
        'card': const Color(0xFF1A2634),
        'textMain': Colors.white,
        'textSecondary': const Color(0xFF9CA3AF),
        'red': const Color(0xFFF87171),
      };
    } else {
      return {
        'primary': const Color(0xFF136DEC),
        'background': const Color(0xFFF6F7F8),
        'card': Colors.white,
        'textMain': const Color(0xFF111418),
        'textSecondary': const Color(0xFF617289),
        'red': const Color(0xFFDC2626),
      };
    }
  }

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
}