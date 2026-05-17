import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  String _selected = 'EUR';
  bool _isLoading = true;
  bool _isSaving = false;

  final List<Map<String, String>> _currencies = [
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€', 'flag': '🇪🇺'},
    {'code': 'RON', 'name': 'Romanian Leu', 'symbol': 'lei', 'flag': '🇷🇴'},
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$', 'flag': '🇺🇸'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£', 'flag': '🇬🇧'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'CHF', 'flag': '🇨🇭'},
    {'code': 'SEK', 'name': 'Swedish Krona', 'symbol': 'kr', 'flag': '🇸🇪'},
    {'code': 'NOK', 'name': 'Norwegian Krone', 'symbol': 'kr', 'flag': '🇳🇴'},
    {'code': 'DKK', 'name': 'Danish Krone', 'symbol': 'kr', 'flag': '🇩🇰'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final snap = await FirebaseDatabase.instance.ref('users/$uid/currency').get();
      if (snap.exists && snap.value != null) {
        setState(() => _selected = snap.value as String);
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _applyCurrency() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _isSaving = true);
    try {
      await FirebaseDatabase.instance.ref('users/$uid/currency').set(_selected);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Currency set to $_selected'),
          backgroundColor: context.appColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
              decoration: BoxDecoration(
                color: c.card,
                border: Border(bottom: BorderSide(color: c.border)),
              ),
              child: Row(
                children: [
                  _backBtn(c, context),
                  Expanded(child: Center(child: Text('Currency', style: _titleStyle(c)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            if (_isLoading)
              Expanded(child: Center(child: CircularProgressIndicator(color: c.primary)))
            else ...[
              // Info banner
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: c.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: c.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'All prices will be displayed in the selected currency.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _currencies.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final cur = _currencies[i];
                    final isSelected = _selected == cur['code'];
                    return GestureDetector(
                      onTap: () => setState(() => _selected = cur['code']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? c.primary.withValues(alpha: 0.08) : c.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? c.primary : c.border, width: isSelected ? 1.5 : 1),
                        ),
                        child: Row(
                          children: [
                            Text(cur['flag']!, style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(cur['name']!, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: c.textMain)),
                                      Text(cur['code']!, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: c.statsBg,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(cur['symbol']!, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: c.textMain)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (isSelected)
                              Container(
                                width: 22, height: 22,
                                decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
                                child: const Icon(Icons.check, color: Colors.white, size: 14),
                              )
                            else
                              Container(
                                width: 22, height: 22,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.border, width: 1.5)),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _applyCurrency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : Text('Apply Currency', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _backBtn(AppColorScheme c, BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: c.hover, borderRadius: BorderRadius.circular(20)),
      child: Icon(Icons.arrow_back_ios_new, size: 18, color: c.textMain),
    ),
  );
}

TextStyle _titleStyle(AppColorScheme c) => GoogleFonts.plusJakartaSans(
  fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain, letterSpacing: -0.015,
);
