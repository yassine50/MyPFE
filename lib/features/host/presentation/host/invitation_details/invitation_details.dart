import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/theme/app_theme.dart';

class InvitationDetails extends StatelessWidget {
  const InvitationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Container(
          color: c.background,
          child: Column(
            children: [
              // ── Top App Bar ──────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: c.card.withValues(alpha: 0.95),
                  border: Border(
                    bottom: BorderSide(color: c.border),
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
                          color: c.buttonBg,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                          ),
                          color: c.textMain,
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
                              color: c.textMain,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileSection(c),
                      _buildPropertySection(c),
                      _buildReservationDatesSection(c),
                      _buildGuestMessageSection(c),
                      _buildPayoutSummarySection(c),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Fixed Footer ──────────────────────────────────────────
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: c.card.withValues(alpha: 0.95),
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.buttonBg,
                    foregroundColor: c.textMain,
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
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
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

  // ── Profile Section ───────────────────────────────────────────
  Widget _buildProfileSection(AppColorScheme c) {
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
                  border: Border.all(color: c.card, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.background, width: 2),
                ),
                child: const Icon(Icons.verified, color: AppColors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Andrei Ionescu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: c.star, size: 16),
              const SizedBox(width: 4),
              Text(
                '4.9 Rating • Verified Member',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Member since Jan 2021',
            style: TextStyle(fontSize: 14, color: c.textSecondary),
          ),
        ],
      ),
    );
  }

  // ── Property Section ──────────────────────────────────────────
  Widget _buildPropertySection(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text(
              'PROPERTY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: c.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: c.statsBg,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.apartment,
                    color: AppColors.primaryBlue,
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
                          color: c.textMain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bucharest, Romania',
                        style: TextStyle(
                          fontSize: 12,
                          color: c.textSecondary,
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

  // ── Reservation Dates Section ─────────────────────────────────
  Widget _buildReservationDatesSection(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text(
              'RESERVATION DATES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: c.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Row(
            children: [
              _dateCard('CHECK-IN', 'Oct 12, 2023', c),
              const SizedBox(width: 12),
              _dateCard('CHECK-OUT', 'Oct 20, 2023', c),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.primaryBlue, size: 16),
                const SizedBox(width: 8),
                Text(
                  '8 Nights Total stay',
                  style: TextStyle(fontSize: 14, color: c.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateCard(String label, String date, AppColorScheme c) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: c.statsBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: c.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Guest Message Section ─────────────────────────────────────
  Widget _buildGuestMessageSection(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text(
              'MESSAGE FROM ANDREI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: c.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(4),
              ),
              border: const Border(
                left: BorderSide(color: AppColors.primaryBlue, width: 4),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              '"Hi! I\'m moving to Bucharest for a 3-month IT project and I\'m looking for a comfortable place with a community vibe. Your space looks perfect for focusing on work while meeting other professionals. Hope to stay with you!"',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: c.textMain,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Payout Summary Section ────────────────────────────────────
  Widget _buildPayoutSummarySection(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withValues(alpha: 0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
                    const Text(
                      'YOUR ESTIMATED PAYOUT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBFDBFE),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1.450 RON',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.payments,
                  color: Color(0xFFBFDBFE),
                  size: 40,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'RESPONSE REQUIRED WITHIN 14 HOURS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: c.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
