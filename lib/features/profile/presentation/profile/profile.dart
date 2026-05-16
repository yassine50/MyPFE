import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/widgets/google_nav_bar/navbar.dart';
import 'package:pfe/features/profile/presentation/edit_profile/edit_profile.dart';
import 'package:pfe/features/auth/data/services/auth_service.dart';
import 'package:pfe/features/onboarding/presentation/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/models/user_model.dart' as app_user;
import 'package:intl/intl.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: uid == null
            ? Center(
                child: Text('Not logged in',
                    style: GoogleFonts.plusJakartaSans(color: c.textSecondary)))
            : StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref('users/$uid').onValue,
                builder: (context, snapshot) {
                  app_user.User? user;
                  if (snapshot.hasData && snapshot.data!.snapshot.exists) {
                    user = app_user.User.fromJson(Map<String, dynamic>.from(
                        snapshot.data!.snapshot.value as Map));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      user == null) {
                    return Center(
                        child: CircularProgressIndicator(color: c.primary));
                  }
                  return _ProfileContent(user: user, uid: uid);
                },
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ProfileContent extends StatelessWidget {
  final app_user.User? user;
  final String uid;
  const _ProfileContent({required this.user, required this.uid});

  // ─── Language code → display name ─────────────────────────────────────────
  static const _langMap = {
    'en': 'English', 'fr': 'French', 'ro': 'Romanian', 'de': 'German',
    'es': 'Spanish', 'ar': 'Arabic', 'zh': 'Chinese', 'tr': 'Turkish',
  };

  // ─── Nationality code → display name ──────────────────────────────────────
  static const _natMap = {
    'us': 'American', 'ro': 'Romanian', 'uk': 'British',
    'fr': 'French', 'de': 'German', 'es': 'Spanish',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildTopAppBar(c, context),
          _buildProfileHeader(c),
          _buildStatsGrid(c, context),
          _buildBioText(c),
          _buildPersonalInfoGrid(c),
          _buildDivider(c),
          _buildSettingsList(c, context),
          _buildActionButtons(c, context),
        ],
      ),
    );
  }

  // ─── Top App Bar ───────────────────────────────────────────────────────────
  Widget _buildTopAppBar(AppColorScheme c, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: c.card,
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: c.hover),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              padding: EdgeInsets.zero,
              color: c.textMain,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppStrings.profileTitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18, fontWeight: FontWeight.bold,
                  color: c.textMain, height: 1.2, letterSpacing: -0.015,
                ),
              ),
            ),
          ),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: c.hover),
            child: IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute<void>(builder: (_) => const EditProfil())),
              icon: const Icon(Icons.edit, size: 24),
              padding: EdgeInsets.zero,
              color: c.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Profile Header ────────────────────────────────────────────────────────
  Widget _buildProfileHeader(AppColorScheme c) {
    final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'Your Name';
    final photoUrl = user?.profileImage ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 128, height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(64),
                  border: Border.all(color: c.card, width: 4),
                  color: c.statsBg,
                  image: photoUrl.isNotEmpty
                      ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                      : null,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                child: photoUrl.isEmpty
                    ? Icon(Icons.person, size: 56, color: c.textSecondary)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: c.card, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Icon(Icons.verified, color: c.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 22, fontWeight: FontWeight.bold, color: c.textMain, height: 1.2),
          ),
          const SizedBox(height: 4),
          if (user?.phone.isNotEmpty == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: c.textSecondary, size: 16),
                const SizedBox(width: 4),
                Text(user!.phone,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w500, color: c.textSecondary)),
              ],
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: c.verifiedBg, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: c.verifiedText, size: 16),
                const SizedBox(width: 4),
                Text('Identity Verified',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w600, color: c.verifiedText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Stats Grid (stays from real bookings) ─────────────────────────────────
  Widget _buildStatsGrid(AppColorScheme c, BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings').onValue,
      builder: (context, snap) {
        int stays = 0;
        if (snap.hasData && snap.data!.snapshot.exists) {
          final raw = snap.data!.snapshot.value as Map;
          raw.forEach((_, val) {
            final b = Map<String, dynamic>.from(val as Map);
            if ((b['userId'] == uid || b['tenantId'] == uid) &&
                (b['status'] == 'accepted' || b['status'] == 'confirmed')) {
              stays++;
            }
          });
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _statCell('$stays', AppStrings.stays, c),
              const SizedBox(width: 12),
              _statCell('4.9 ★', AppStrings.rating, c),
              const SizedBox(width: 12),
              _statCell('100%', AppStrings.response, c),
            ],
          ),
        );
      },
    );
  }

  Widget _statCell(String value, String label, AppColorScheme c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.statsBg, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.statsBorder),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 20, fontWeight: FontWeight.bold, color: c.textMain, height: 1.2)),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, fontWeight: FontWeight.w500, color: c.textSecondary, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  // ─── Bio ───────────────────────────────────────────────────────────────────
  Widget _buildBioText(AppColorScheme c) {
    final bio = user?.bio.isNotEmpty == true
        ? user!.bio
        : 'No bio added yet. Tap the edit button to tell hosts about yourself.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        bio,
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
            fontSize: 16, fontWeight: FontWeight.normal, color: c.textSecondary, height: 1.5),
      ),
    );
  }

  // ─── Personal Info Grid ────────────────────────────────────────────────────
  Widget _buildPersonalInfoGrid(AppColorScheme c) {
    final joinDate = DateFormat('MMMM yyyy').format(user?.createdAt ?? DateTime.now());
    final natCode = user?.nationality ?? '';
    final nationality = _natMap[natCode] ?? (natCode.isNotEmpty ? natCode : '—');
    final occupation = user?.occupation.isNotEmpty == true ? user!.occupation : '—';
    final langCode = user?.language ?? 'en';
    final langName = _langMap[langCode] ?? langCode.toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      child: Container(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.divider, width: 1)),
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 32,
          childAspectRatio: 2,
          children: [
            _infoCell(AppStrings.joinedIn, joinDate, c),
            _infoCell(AppStrings.nationality, nationality, c),
            _infoCell(AppStrings.preferredLanguage, langName, c),
            _infoCell(AppStrings.occupation, occupation, c),
          ],
        ),
      ),
    );
  }

  Widget _infoCell(String label, String value, AppColorScheme c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, fontWeight: FontWeight.w500, color: c.textSecondary)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 16, fontWeight: FontWeight.w600, color: c.textMain),
            maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // ─── Divider ───────────────────────────────────────────────────────────────
  Widget _buildDivider(AppColorScheme c) {
    return Container(
      height: 8, width: double.infinity,
      color: c.divider,
      margin: const EdgeInsets.only(top: 16, bottom: 16),
    );
  }

  // ─── Settings List ─────────────────────────────────────────────────────────
  Widget _buildSettingsList(AppColorScheme c, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(AppStrings.accountSettings,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
          ),
          const SizedBox(height: 8),
          _settingItem(c, Icons.person, AppStrings.personalDetails,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const EditProfil()))),
          _settingItem(c, Icons.lock, 'Login & Security', onTap: () {}),
          _settingItem(c, Icons.payments, 'Payments and Payouts', onTap: () {}),
          _settingItem(c, Icons.translate, 'Translation', onTap: () {}),
        ],
      ),
    );
  }

  Widget _settingItem(AppColorScheme c, IconData icon, String title,
      {required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: c.settingsIconBg, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Icon(icon, color: c.settingsIcon, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 16, fontWeight: FontWeight.w600, color: c.textMain)),
              ),
              Icon(Icons.arrow_forward_ios, color: c.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Action Buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons(AppColorScheme c, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Switch to Host Mode
          Container(
            width: double.infinity, height: 48,
            decoration: BoxDecoration(
              color: c.card, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.buttonBorder),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute<void>(builder: (_) => const GoogleNavBar(renter: false))),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_work, color: c.textMain, size: 20),
                    const SizedBox(width: 8),
                    Text(AppStrings.switchToHostMode,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Log Out
          Container(
            width: double.infinity, height: 48,
            decoration: BoxDecoration(color: c.logoutBg, borderRadius: BorderRadius.circular(12)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: c.card,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text('Log Out',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold, color: c.textMain)),
                      content: Text('Are you sure you want to log out?',
                          style: GoogleFonts.plusJakartaSans(color: c.textSecondary)),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text('Cancel',
                                style: GoogleFonts.plusJakartaSans(color: c.textSecondary))),
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text('Log Out',
                                style: GoogleFonts.plusJakartaSans(
                                    color: Colors.red, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  );
                  if (confirmed == true && context.mounted) {
                    await AuthService().signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                        (r) => false,
                      );
                    }
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(AppStrings.logOut,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.w600, color: c.logoutText)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
