import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final List<Map<String, String>> _faqs = [
    {
      'q': 'How do I book a property?',
      'a': 'Browse properties on the Explore tab, tap on one you like, select your move-in and move-out dates, then tap "Request to Book". The host will review and accept or decline your request.',
    },
    {
      'q': 'How does payment work?',
      'a': 'Once your booking is confirmed, the first month\'s rent and any service fee is charged to your saved payment method. Subsequent months are charged on the same date each month.',
    },
    {
      'q': 'Can I cancel a booking?',
      'a': 'Yes. Go to My Bookings, find the booking and tap the three-dot menu. Cancellation policies vary by listing — check the property details before booking.',
    },
    {
      'q': 'How do I contact my host?',
      'a': 'Once your booking is accepted, you can message your host directly from the Inbox tab. Both parties can also share contact details after confirmation.',
    },
    {
      'q': 'What if there\'s an issue with the property?',
      'a': 'Contact your host first via the Inbox. If the issue is not resolved within 24 hours, use the "Report Issue" option in your booking details to escalate to our support team.',
    },
    {
      'q': 'How do I become a host?',
      'a': 'Tap your profile in the bottom nav, then "Switch to Host Mode". From there, use the "New Listing" button on the Host Dashboard to create and publish your first property.',
    },
    {
      'q': 'Is my personal data safe?',
      'a': 'Yes. All data is encrypted in transit and at rest. We use Firebase Authentication for secure login and never share your personal information with third parties without your consent.',
    },
  ];

  int? _expanded;
  final _contactCtrl = TextEditingController();

  @override
  void dispose() {
    _contactCtrl.dispose();
    super.dispose();
  }

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
                  Expanded(child: Center(child: Text('Help Center', style: _titleStyle(c)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick actions
                    Row(
                      children: [
                        Expanded(child: _quickAction(Icons.chat_bubble_outline, 'Live Chat', 'Chat with us', c, () {})),
                        const SizedBox(width: 12),
                        Expanded(child: _quickAction(Icons.email_outlined, 'Email Us', 'support@rently.ro', c, () {})),
                        const SizedBox(width: 12),
                        Expanded(child: _quickAction(Icons.phone_outlined, 'Call Us', '+40 21 000 000', c, () {})),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text('Frequently Asked Questions',
                        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
                    const SizedBox(height: 12),

                    // FAQ accordion
                    ..._faqs.asMap().entries.map((entry) {
                      final i = entry.key;
                      final faq = entry.value;
                      final isOpen = _expanded == i;
                      return GestureDetector(
                        onTap: () => setState(() => _expanded = isOpen ? null : i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isOpen ? c.primary.withValues(alpha: 0.05) : c.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isOpen ? c.primary.withValues(alpha: 0.3) : c.border),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(faq['q']!,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14, fontWeight: FontWeight.w600,
                                            color: isOpen ? c.primary : c.textMain,
                                          )),
                                    ),
                                    Icon(isOpen ? Icons.expand_less : Icons.expand_more,
                                        color: isOpen ? c.primary : c.textSecondary),
                                  ],
                                ),
                              ),
                              if (isOpen)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                                  child: Text(faq['a']!,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textSecondary, height: 1.6)),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Contact form
                    Text('Still need help?',
                        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
                    const SizedBox(height: 8),
                    Text('Describe your issue and our team will get back to you within 24 hours.',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _contactCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe your issue…',
                        hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textHint),
                        filled: true,
                        fillColor: c.inputBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.inputBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.inputBorder)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primary)),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          _contactCtrl.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Message sent! We\'ll reply within 24 hours.'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text('Send Message', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold)),
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

  Widget _quickAction(IconData icon, String title, String sub, AppColorScheme c, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        child: Column(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: c.primary, size: 22),
            ),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: c.textMain), textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(sub, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: c.textSecondary), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
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
