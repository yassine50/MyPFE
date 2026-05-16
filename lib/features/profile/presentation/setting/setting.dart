import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/features/profile/presentation/profile/profile.dart';
import 'package:pfe/features/auth/data/services/auth_service.dart';
import 'package:pfe/features/onboarding/presentation/splash_screen/splash_screen.dart';
import 'package:pfe/features/profile/presentation/setting/language_page.dart';
import 'package:pfe/features/profile/presentation/setting/currency_page.dart';
import 'package:pfe/features/profile/presentation/setting/change_password_page.dart';
import 'package:pfe/features/profile/presentation/setting/payment_methods_page.dart';
import 'package:pfe/features/profile/presentation/setting/billing_history_page.dart';
import 'package:pfe/features/profile/presentation/setting/help_center_page.dart';
import 'package:pfe/features/profile/presentation/setting/terms_of_service_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/models/user_model.dart' as app_user;

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Setting> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _faceIDLogin = true;

  String _selectedLanguage = 'English';
  String _selectedCurrency = 'EUR';

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildTopAppBar(c),
              if (uid != null)
                StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance.ref('users/$uid').onValue,
                  builder: (context, snapshot) {
                    app_user.User? user;
                    if (snapshot.hasData && snapshot.data!.snapshot.exists) {
                      user = app_user.User.fromJson(Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map));
                    }
                    return _buildProfileSection(c, user);
                  },
                )
              else
                _buildProfileSection(c, null),
              _buildGeneralSection(c),
              _buildNotificationsSection(c),
              _buildPaymentsSection(c),
              _buildPrivacySection(c),
              _buildSupportSection(c),
              _buildFooter(c),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Top App Bar ───────────────────────────────────────────────────────────
  Widget _buildTopAppBar(AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.settingsTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain, height: 1.2, letterSpacing: -0.015,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ─── Profile Section ───────────────────────────────────────────────────────
  Widget _buildProfileSection(AppColorScheme c, app_user.User? user) {
    final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'Your Name';
    final photoUrl = user?.profileImage ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const Profile())),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: c.statsBg,
                      image: photoUrl.isNotEmpty
                          ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                          : null,
                      border: Border.all(color: c.border),
                    ),
                    child: photoUrl.isEmpty
                        ? Icon(Icons.person, size: 32, color: c.textSecondary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain, height: 1.2),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(AppStrings.editProfile,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: c.primary)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: c.textSecondary, size: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── General Section ───────────────────────────────────────────────────────
  Widget _buildGeneralSection(AppColorScheme c) {
    return _sectionWrapper(
      label: AppStrings.sectionGeneral,
      c: c,
      children: [
        _buildSettingItem(
          c: c, icon: Icons.language, title: AppStrings.language, value: _selectedLanguage,
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const LanguagePage()));
            // In a real app, read the result back; for now just label stays
          },
          showDivider: true,
        ),
        _buildSettingItem(
          c: c, icon: Icons.currency_exchange, title: AppStrings.currency, value: _selectedCurrency,
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const CurrencyPage())),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── Notifications Section ─────────────────────────────────────────────────
  Widget _buildNotificationsSection(AppColorScheme c) {
    return _sectionWrapper(
      label: AppStrings.sectionNotifications,
      c: c,
      children: [
        _buildToggleItem(
          c: c, icon: Icons.notifications, title: AppStrings.pushNotifications,
          value: _pushNotifications,
          onChanged: (v) => setState(() => _pushNotifications = v),
          showDivider: true,
        ),
        _buildToggleItem(
          c: c, icon: Icons.mail, title: AppStrings.emailUpdates,
          value: _emailUpdates,
          onChanged: (v) => setState(() => _emailUpdates = v),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── Payments Section ──────────────────────────────────────────────────────
  Widget _buildPaymentsSection(AppColorScheme c) {
    return _sectionWrapper(
      label: AppStrings.sectionPayments,
      c: c,
      children: [
        _buildSettingItem(
          c: c, icon: Icons.credit_card, title: AppStrings.paymentMethods, value: '',
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PaymentMethodsPage())),
          showDivider: true,
        ),
        _buildSettingItem(
          c: c, icon: Icons.receipt_long, title: AppStrings.billingHistory, value: '',
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const BillingHistoryPage())),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── Privacy & Security Section ────────────────────────────────────────────
  Widget _buildPrivacySection(AppColorScheme c) {
    return _sectionWrapper(
      label: AppStrings.sectionPrivacy,
      c: c,
      children: [
        _buildSettingItem(
          c: c, icon: Icons.lock, title: AppStrings.changePassword, value: '',
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ChangePasswordPage())),
          showDivider: true,
        ),
        _buildToggleItem(
          c: c, icon: Icons.face, title: AppStrings.faceIdLogin,
          value: _faceIDLogin,
          onChanged: (v) => setState(() => _faceIDLogin = v),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── Support Section ───────────────────────────────────────────────────────
  Widget _buildSupportSection(AppColorScheme c) {
    return _sectionWrapper(
      label: AppStrings.sectionSupport,
      c: c,
      children: [
        _buildSettingItem(
          c: c, icon: Icons.help, title: AppStrings.helpCenter, value: '',
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const HelpCenterPage())),
          showDivider: true,
        ),
        _buildSettingItem(
          c: c, icon: Icons.description, title: AppStrings.termsOfService, value: '',
          onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const TermsOfServicePage())),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── Footer ────────────────────────────────────────────────────────────────
  Widget _buildFooter(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: c.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text('Log Out', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: c.textMain)),
                    content: Text('Are you sure you want to log out?', style: GoogleFonts.plusJakartaSans(color: c.textSecondary)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: c.textSecondary))),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Log Out', style: GoogleFonts.plusJakartaSans(color: c.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && mounted) {
                  await AuthService().signOut();
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SplashScreen()),
                      (route) => false,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: c.red.withValues(alpha: 0.1),
                foregroundColor: c.red,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide.none,
              ),
              child: Text(AppStrings.logOut, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Version 1.0.0 (Build 2026)', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
        ],
      ),
    );
  }

  // ─── Shared Wrappers ───────────────────────────────────────────────────────
  Widget _sectionWrapper({required String label, required AppColorScheme c, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: c.textSecondary, letterSpacing: 1)),
          ),
          Container(
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required AppColorScheme c,
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
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(icon, color: c.primary, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500, color: c.textMain), overflow: TextOverflow.ellipsis)),
                    Row(children: [
                      if (value.isNotEmpty)
                        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textSecondary)),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: c.textSecondary, size: 24),
                    ]),
                  ],
                ),
              ),
              if (showDivider)
                Container(height: 1, color: c.border, margin: const EdgeInsets.only(left: 56)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required AppColorScheme c,
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
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: c.primary, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500, color: c.textMain), overflow: TextOverflow.ellipsis)),
                GestureDetector(
                  onTap: () => onChanged(!value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44, height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: value ? c.primary : c.border,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 2, offset: const Offset(0, 1))],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showDivider) Container(height: 1, color: c.border, margin: const EdgeInsets.only(left: 56)),
        ],
      ),
    );
  }
}
