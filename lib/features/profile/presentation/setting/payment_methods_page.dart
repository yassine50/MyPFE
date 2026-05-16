import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final List<Map<String, dynamic>> _cards = [
    {'brand': 'Visa', 'last4': '4242', 'expiry': '12/27', 'isDefault': true, 'color': const Color(0xFF1A56DB)},
    {'brand': 'Mastercard', 'last4': '1234', 'expiry': '08/26', 'isDefault': false, 'color': const Color(0xFFEB5757)},
  ];

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
                  Expanded(child: Center(child: Text('Payment Methods', style: _titleStyle(c)))),
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
                    Text('Your Cards', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
                    const SizedBox(height: 12),

                    // Cards
                    ..._cards.asMap().entries.map((entry) {
                      final i = entry.key;
                      final card = entry.value;
                      return _CardTile(card: card, c: c, onSetDefault: () {
                        setState(() {
                          for (var c in _cards) { c['isDefault'] = false; }
                          _cards[i]['isDefault'] = true;
                        });
                      }, onDelete: () {
                        setState(() => _cards.removeAt(i));
                      });
                    }),

                    const SizedBox(height: 20),

                    // Add new card button
                    GestureDetector(
                      onTap: () => _showAddCardSheet(c),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: c.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.primary, style: BorderStyle.solid),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline, color: c.primary, size: 20),
                            const SizedBox(width: 8),
                            Text('Add New Card', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: c.primary)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text('Other Payment Methods', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
                    const SizedBox(height: 12),

                    _otherMethod(Icons.account_balance, 'Bank Transfer', 'Connect your bank account', c),
                    const SizedBox(height: 8),
                    _otherMethod(Icons.paypal_rounded, 'PayPal', 'Link your PayPal account', c),

                    const SizedBox(height: 24),

                    // Security note
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outlined, color: Colors.green, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your payment info is encrypted and stored securely.',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.green.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherMethod(IconData icon, String title, String sub, AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: c.statsBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: c.textMain, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: c.textMain)),
                Text(sub, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: c.textSecondary),
        ],
      ),
    );
  }

  void _showAddCardSheet(AppColorScheme c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Add Card', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
            const SizedBox(height: 16),
            _sheetField('Card Number', '0000 0000 0000 0000', c),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _sheetField('Expiry Date', 'MM/YY', c)),
              const SizedBox(width: 12),
              Expanded(child: _sheetField('CVV', '•••', c)),
            ]),
            const SizedBox(height: 12),
            _sheetField('Cardholder Name', 'Full name on card', c),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Save Card', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetField(String label, String hint, AppColorScheme c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: c.textLabel)),
      const SizedBox(height: 6),
      TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textHint),
          filled: true,
          fillColor: c.inputBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c.inputBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c.inputBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c.primary)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    ],
  );
}

class _CardTile extends StatelessWidget {
  final Map<String, dynamic> card;
  final AppColorScheme c;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _CardTile({required this.card, required this.c, required this.onSetDefault, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [card['color'] as Color, (card['color'] as Color).withValues(alpha: 0.7)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(card['brand'], style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (card['isDefault'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
                      child: Text('Default', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('•••• •••• •••• ${card['last4']}',
                  style: GoogleFonts.firaSans(fontSize: 18, color: Colors.white, letterSpacing: 2)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Expires ${card['expiry']}', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white70)),
                  Row(children: [
                    if (card['isDefault'] != true)
                      GestureDetector(
                        onTap: onSetDefault,
                        child: Text('Set Default', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white, decoration: TextDecoration.underline)),
                      ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete_outline, color: Colors.white70, size: 18),
                    ),
                  ]),
                ],
              ),
            ],
          ),
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
