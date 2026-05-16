import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(color: c.card, border: Border(bottom: BorderSide(color: c.border))),
              child: Row(
                children: [
                  _backBtn(c, context),
                  Expanded(child: Center(child: Text('Terms of Service', style: _titleStyle(c)))),
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: c.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Last updated badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: c.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Last updated: May 15, 2026',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: c.primary)),
                    ),

                    const SizedBox(height: 20),

                    _section('1. Introduction', '''Welcome to Rently. By using our platform, you agree to these Terms of Service. Please read them carefully before using the app.

These terms apply to all users, including renters and hosts. If you disagree with any part, please discontinue use of the platform.''', c),

                    _section('2. User Accounts', '''To access most features, you must create an account. You are responsible for:
• Maintaining the confidentiality of your password
• All activities that occur under your account
• Notifying us immediately of any unauthorized use

We reserve the right to suspend accounts that violate these terms.''', c),

                    _section('3. Renter Responsibilities', '''As a renter, you agree to:
• Provide accurate personal and payment information
• Respect the listed house rules for each property
• Not sublease or transfer your booking without host consent
• Pay all fees on time as agreed at booking confirmation''', c),

                    _section('4. Host Responsibilities', '''As a host, you agree to:
• Provide accurate and truthful property descriptions
• Maintain the property in safe and habitable condition
• Honor accepted bookings and communicate promptly
• Comply with all applicable local housing laws and regulations''', c),

                    _section('5. Payments & Fees', '''All payments are processed securely through our payment provider. Rently charges a service fee on each booking. Refunds are subject to the individual listing\'s cancellation policy.

Hosts receive payouts 24 hours after the tenant\'s check-in date, minus the platform commission.''', c),

                    _section('6. Cancellations & Refunds', '''Cancellation policies are set by individual hosts and are clearly displayed on each listing. In cases of extenuating circumstances (natural disasters, government restrictions), we may issue exceptions at our discretion.''', c),

                    _section('7. Privacy & Data', '''We collect and process personal data as described in our Privacy Policy. By using Rently, you consent to the collection and use of your data for service improvement, marketing communications (if opted in), and legal compliance.''', c),

                    _section('8. Prohibited Activities', '''Users may not:
• Post false, misleading, or fraudulent listings
• Harass, threaten, or intimidate other users
• Circumvent the platform to conduct off-platform payments
• Use the app for any illegal purpose''', c),

                    _section('9. Limitation of Liability', '''Rently acts as an intermediary platform. We are not responsible for the actions of hosts or renters, property conditions beyond disclosed information, or disputes between parties. Our liability is limited to the service fee paid.''', c),

                    _section('10. Changes to Terms', '''We may update these Terms at any time. Continued use after changes are posted constitutes acceptance of the new Terms. We will notify you of significant changes via email or in-app notification.''', c),

                    const SizedBox(height: 12),

                    // Contact
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.statsBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Questions?', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: c.textMain)),
                          const SizedBox(height: 6),
                          Text('Contact us at legal@rently.ro or visit our Help Center.', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary, height: 1.5)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body, AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
          const SizedBox(height: 8),
          Container(width: 32, height: 3, decoration: BoxDecoration(color: c.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 10),
          Text(body, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textSecondary, height: 1.7)),
        ],
      ),
    );
  }
}

Widget _backBtn(AppColorScheme c, BuildContext context) => GestureDetector(
  onTap: () => Navigator.pop(context),
  child: Container(
    width: 40, height: 40,
    decoration: BoxDecoration(color: c.hover, borderRadius: BorderRadius.circular(20)),
    child: Icon(Icons.arrow_back_ios_new, size: 18, color: c.textMain),
  ),
);

TextStyle _titleStyle(AppColorScheme c) => GoogleFonts.plusJakartaSans(
  fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain, letterSpacing: -0.015,
);
