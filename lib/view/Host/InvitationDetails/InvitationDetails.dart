import 'package:flutter/material.dart';

class InvitationDetails extends StatelessWidget {
  const InvitationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF101822) : Colors.white,
      body: SafeArea(
        child: Container(
          color: isDarkMode ? const Color(0xFF101822) : Colors.white,
          child: Column(
            children: [
              // Top App Bar
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? const Color(0xFF101822).withOpacity(0.8) 
                      : Colors.white.withOpacity(0.8),
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDarkMode 
                              ? const Color(0xFF1F2937) 
                              : const Color(0xFFF9FAFB),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          color: isDarkMode ? Colors.white : const Color(0xFF111418),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Booking Request',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : const Color(0xFF111418),
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // For balance
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header
                      _buildProfileSection(isDarkMode),
                      
                      // Property Section
                      _buildPropertySection(isDarkMode),
                      
                      // Reservation Dates Section
                      _buildReservationDatesSection(isDarkMode),
                      
                      // Guest Message Section
                      _buildGuestMessageSection(isDarkMode),
                      
                      // Payout Summary Section
                      _buildPayoutSummarySection(isDarkMode),
                      
                      const SizedBox(height: 100), // Space for fixed footer
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Fixed Footer Actions
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode 
              ? const Color(0xFF101822).withOpacity(0.9) 
              : Colors.white.withOpacity(0.9),
          border: Border(
            top: BorderSide(
              color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode 
                        ? const Color(0xFF1F2937) 
                        : const Color(0xFFF3F4F6),
                    foregroundColor: isDarkMode ? Colors.white : const Color(0xFF111418),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF136DEC),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Accept Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? const Color(0xFF374151) : Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuASw6s7PuUKQ0yxaRizLWFSHj2ohZ31Bsd9XU_GJVwrkI6HT-ect7Ja0lAJwb3A3k6HkfPYO1_AqaS7QjzizD1F_Z45ibEx18e7Q4ucAHabZv4QuQu3fxvsIwKKkmWX0HwJKqVjHB3RBi_mz7l8f665d-ZQ8ZIwG6Lpi78eXKdMBGAPdcyT6qZafEGLKcpKdYkOtiOYnhaZwfYsHTL8hAKQhK9NCdivn06z6fuOGpJAN3vIL4ue60KGbAQ7Q7PoMIYZd4YF8MuCqo0',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF136DEC),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? const Color(0xFF101822) : Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Andrei Ionescu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF111418),
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFFBBF24),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '4.9 Rating • Verified Member',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF617289),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Member since Jan 2021',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF617289),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertySection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text(
              'Property'.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white.withOpacity(0.6) : const Color(0xFF111418).withOpacity(0.6),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1F2937).withOpacity(0.5) : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF136DEC).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.apartment,
                    color: Color(0xFF136DEC),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Co-Living Space - Sector 3',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : const Color(0xFF111418),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bucharest, Romania',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF617289),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationDatesSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text(
              'Reservation Dates'.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white.withOpacity(0.6) : const Color(0xFF111418).withOpacity(0.6),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1F2937).withOpacity(0.5) : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHECK-IN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF617289),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Oct 12, 2023',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF111418),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1F2937).withOpacity(0.5) : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHECK-OUT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF617289),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Oct 20, 2023',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF111418),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: Color(0xFF136DEC),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '8 Nights Total stay',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF617289),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestMessageSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text(
              'Message from Andrei'.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white.withOpacity(0.6) : const Color(0xFF111418).withOpacity(0.6),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF136DEC).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(4),
              ),
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF136DEC),
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              '"Hi! I\'m moving to Bucharest for a 3-month IT project and I\'m looking for a comfortable place with a community vibe. Your space looks perfect for focusing on work while meeting other professionals. Hope to stay with you!"',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: isDarkMode ? const Color(0xFFE5E7EB) : const Color(0xFF111418),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutSummarySection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF136DEC).withOpacity(0.2) : const Color(0xFF111827),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR ESTIMATED PAYOUT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? const Color(0xFF93C5FD) : const Color(0xFFD1D5DB),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1.450 RON',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.white,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.payments,
                  color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF93C5FD),
                  size: 40,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Response required within 14 hours'.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF617289),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}