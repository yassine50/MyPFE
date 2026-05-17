import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfe/features/onboarding/presentation/select_language/bloc/select_lang_bloc.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selected = 'en';
  bool _isLoading = true;
  bool _isSaving = false;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English', 'flag': '🇬🇧'},
    {'code': 'fr', 'name': 'French', 'native': 'Français', 'flag': '🇫🇷'},
    {'code': 'ro', 'name': 'Romanian', 'native': 'Română', 'flag': '🇷🇴'},
    {'code': 'de', 'name': 'German', 'native': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'es', 'name': 'Spanish', 'native': 'Español', 'flag': '🇪🇸'},
    {'code': 'ar', 'name': 'Arabic', 'native': 'العربية', 'flag': '🇸🇦'},
    {'code': 'zh', 'name': 'Chinese', 'native': '中文', 'flag': '🇨🇳'},
    {'code': 'tr', 'name': 'Turkish', 'native': 'Türkçe', 'flag': '🇹🇷'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final snap = await FirebaseDatabase.instance.ref('users/$uid/language').get();
      if (snap.exists && snap.value != null) {
        setState(() => _selected = snap.value as String);
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _applyLanguage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _isSaving = true);
    try {
      // 1. Persist to Firebase
      await FirebaseDatabase.instance.ref('users/$uid/language').set(_selected);

      // 2. Get the index of the selected language in the list
      final langIndex = _languages.indexWhere((l) => l['code'] == _selected);
      final langName = _languages[langIndex]['name']!;

      if (!mounted) return;

      // 3. Fire the BLoC event — this triggers a full MaterialApp rebuild with the new locale
      context.read<SelectLangBloc>().add(SelectLanguageEvent(langIndex));

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language updated to $langName'),
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
                  Expanded(
                    child: Center(
                      child: Text('Language', style: _titleStyle(c)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            if (_isLoading)
              Expanded(child: Center(child: CircularProgressIndicator(color: c.primary)))
            else ...[
              // Search hint
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: c.inputBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search, color: c.textSecondary, size: 20),
                      const SizedBox(width: 8),
                      Text('Search language…', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textHint)),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final lang = _languages[i];
                    final isSelected = _selected == lang['code'];
                    return _LanguageTile(
                      flag: lang['flag']!,
                      name: lang['name']!,
                      native: lang['native']!,
                      isSelected: isSelected,
                      c: c,
                      onTap: () => setState(() => _selected = lang['code']!),
                    );
                  },
                ),
              ),

              // Apply button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _applyLanguage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : Text('Apply Language', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
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

class _LanguageTile extends StatelessWidget {
  final String flag, name, native;
  final bool isSelected;
  final AppColorScheme c;
  final VoidCallback onTap;
  const _LanguageTile({required this.flag, required this.name, required this.native, required this.isSelected, required this.c, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            Text(flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: c.textMain)),
                  Text(native, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary)),
                ],
              ),
            ),
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
