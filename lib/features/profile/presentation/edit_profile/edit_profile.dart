import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe/core/utils/currency_formatter.dart';
import 'package:pfe/core/models/user_model.dart' as app_user;

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfil> {
  // ─── Controllers ────────────────────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _bioController  = TextEditingController();
  final _phoneController = TextEditingController();
  final _occupationController = TextEditingController();

  // ─── State ──────────────────────────────────────────────────────────────────
  String _nationality     = 'ro';
  String _preferredLang   = 'en';
  RangeValues _budget     = const RangeValues(300, 800);
  DateTime _moveInDate    = DateTime.now();
  double _screenWidth     = 0;

  bool _isLoading  = true;   // loading from Firebase
  bool _isSaving   = false;  // saving to Firebase

  String _currentPhotoUrl = '';
  File?  _pickedImageFile;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // ─── Nationality options ─────────────────────────────────────────────────────
  static const _nationalities = [
    {'code': 'us', 'label': '🇺🇸 American'},
    {'code': 'ro', 'label': '🇷🇴 Romanian'},
    {'code': 'uk', 'label': '🇬🇧 British'},
    {'code': 'fr', 'label': '🇫🇷 French'},
    {'code': 'de', 'label': '🇩🇪 German'},
    {'code': 'es', 'label': '🇪🇸 Spanish'},
  ];

  // ─── Language options ──────────────────────────────────────────────────────
  static const _languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'ro', 'label': 'Romanian'},
    {'code': 'fr', 'label': 'French'},
    {'code': 'de', 'label': 'German'},
    {'code': 'es', 'label': 'Spanish'},
    {'code': 'ar', 'label': 'Arabic'},
  ];

  // ─── Init ──────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final uid = _uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final snap = await FirebaseDatabase.instance.ref('users/$uid').get();
      if (snap.exists && snap.value != null) {
        final user = app_user.User.fromJson(
            Map<String, dynamic>.from(snap.value as Map));
        setState(() {
          _nameController.text = user.fullName;
          _bioController.text  = user.bio;
          _phoneController.text = user.phone;
          _occupationController.text = user.occupation;
          _nationality   = user.nationality.isNotEmpty ? user.nationality : 'ro';
          _preferredLang = user.language.isNotEmpty ? user.language : 'en';
          _budget        = RangeValues(user.budgetMin, user.budgetMax);
          _currentPhotoUrl = user.profileImage;
          if (user.moveInDate.isNotEmpty) {
            final parsed = DateTime.tryParse(user.moveInDate);
            if (parsed != null) _moveInDate = parsed;
          }
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  // ─── Save ──────────────────────────────────────────────────────────────────
  Future<void> _saveChanges() async {
    final uid = _uid;
    if (uid == null) return;
    setState(() => _isSaving = true);

    try {
      // 1. Upload new profile photo if picked
      String photoUrl = _currentPhotoUrl;
      if (_pickedImageFile != null) {
        final ref = FirebaseStorage.instance
            .ref('profile_photos/$uid.jpg');
        await ref.putFile(_pickedImageFile!);
        photoUrl = await ref.getDownloadURL();
      }

      // 2. Write profile fields to Realtime Database
      await FirebaseDatabase.instance.ref('users/$uid').update({
        'fullName':   _nameController.text.trim(),
        'bio':        _bioController.text.trim(),
        'phone':      _phoneController.text.trim(),
        'occupation': _occupationController.text.trim(),
        'nationality':  _nationality,
        'language':     _preferredLang,
        'budgetMin':    _budget.start.roundToDouble(),
        'budgetMax':    _budget.end.roundToDouble(),
        'moveInDate':   _moveInDate.toIso8601String(),
        'profileImage': photoUrl,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: context.appColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── Date picker ────────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _moveInDate.isBefore(now) ? now : _moveInDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: ctx.appColors.primary,
            onPrimary: Colors.white,
            onSurface: ctx.appColors.textMain,
          ),
          dialogTheme: DialogThemeData(backgroundColor: ctx.appColors.card),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _moveInDate = picked);
  }

  // ─── Photo picker ───────────────────────────────────────────────────────────
  Future<void> _changeProfilePhoto() async {
    final c = context.appColors;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Change Profile Photo',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: c.primary),
              title: Text('Take Photo',
                  style: GoogleFonts.plusJakartaSans(fontSize: 16, color: c.textMain)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: c.primary),
              title: Text('Choose from Gallery',
                  style: GoogleFonts.plusJakartaSans(fontSize: 16, color: c.textMain)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: GoogleFonts.plusJakartaSans(fontSize: 16, color: c.textSecondary)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source == null) return;
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
        source: source, maxWidth: 800, maxHeight: 800, imageQuality: 85);
    if (xFile != null && mounted) {
      setState(() => _pickedImageFile = File(xFile.path));
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    if (_screenWidth == 0) _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        top: true, bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(c),
                if (_isLoading)
                  Expanded(child: Center(child: CircularProgressIndicator(color: c.primary)))
                else
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        children: [
                          _buildPhotoSection(c),
                          Container(height: 8, color: c.divider),
                          _buildPersonalSection(c),
                          Container(height: 8, color: c.divider,
                              margin: const EdgeInsets.only(top: 32)),
                          _buildPreferencesSection(c),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: SafeArea(top: false, child: _buildSaveButton(c)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
          color: c.card, border: Border(bottom: BorderSide(color: c.border))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: c.card),
              child: Icon(Icons.close, size: 24, color: c.textMain),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Edit Profile',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, fontWeight: FontWeight.bold,
                      color: c.textMain, height: 1.2, letterSpacing: -0.015)),
            ),
          ),
          GestureDetector(
            onTap: _isSaving ? null : _saveChanges,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Save',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: _isSaving ? c.textSecondary : c.primary)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Photo Section ─────────────────────────────────────────────────────────
  Widget _buildPhotoSection(AppColorScheme c) {
    final hasLocalPick = _pickedImageFile != null;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          GestureDetector(
            onTap: _changeProfilePhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 128, height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(color: c.card, width: 4),
                    color: c.statsBg,
                    boxShadow: [BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(64),
                    child: hasLocalPick
                        ? Image.file(_pickedImageFile!, fit: BoxFit.cover)
                        : _currentPhotoUrl.isNotEmpty
                            ? Image.network(_currentPhotoUrl, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Icon(Icons.person, size: 56, color: c.textSecondary))
                            : Icon(Icons.person, size: 56, color: c.textSecondary),
                  ),
                ),
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: c.primary, borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: c.card, width: 3),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: const Icon(Icons.photo_camera, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _changeProfilePhoto,
            child: Text('Change Photo',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, fontWeight: FontWeight.bold,
                    color: c.primary, height: 1.2, letterSpacing: -0.015)),
          ),
        ],
      ),
    );
  }

  // ─── Personal Details ──────────────────────────────────────────────────────
  Widget _buildPersonalSection(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Details',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20, fontWeight: FontWeight.bold, color: c.textMain)),
          const SizedBox(height: 16),
          _textField(label: 'Full Name', controller: _nameController,
              hint: 'e.g. John Doe', c: c),
          const SizedBox(height: 20),
          _textField(label: 'Phone Number', controller: _phoneController,
              hint: 'e.g. +40 700 000 000', c: c,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 20),
          _textField(label: 'Occupation', controller: _occupationController,
              hint: 'e.g. Software Engineer', c: c),
          const SizedBox(height: 20),
          _dropdown<String>(
            label: 'Nationality',
            value: _nationality,
            items: _nationalities
                .map((n) => DropdownMenuItem(value: n['code']!, child: Text(n['label']!)))
                .toList(),
            onChanged: (v) { if (v != null) setState(() => _nationality = v); },
            c: c,
          ),
          const SizedBox(height: 20),
          _textField(label: 'Bio', controller: _bioController,
              hint: 'Tell hosts a bit about yourself...', maxLines: 4, c: c),
          const SizedBox(height: 20),
          _dropdown<String>(
            label: 'Preferred Language',
            value: _preferredLang,
            items: _languages
                .map((l) => DropdownMenuItem(value: l['code']!, child: Text(l['label']!)))
                .toList(),
            onChanged: (v) { if (v != null) setState(() => _preferredLang = v); },
            c: c,
          ),
        ],
      ),
    );
  }

  // ─── Rental Preferences ────────────────────────────────────────────────────
  Widget _buildPreferencesSection(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rental Preferences',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20, fontWeight: FontWeight.bold, color: c.textMain)),
          const SizedBox(height: 16),
          _buildBudgetSlider(c),
          const SizedBox(height: 24),
          _buildDatePicker(c),
        ],
      ),
    );
  }

  // ─── Budget Slider ─────────────────────────────────────────────────────────
  Widget _buildBudgetSlider(AppColorScheme c) {
    const minB = 100.0;
    const maxB = 2000.0;
    final leftPos = ((_budget.start - minB) / (maxB - minB)) * (_screenWidth - 32);
    final rightPos = ((_budget.end - minB) / (maxB - minB)) * (_screenWidth - 32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Monthly Budget',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, fontWeight: FontWeight.w600, color: c.textLabel)),
            Text('${CurrencyFormatter.format(_budget.start)} – ${CurrencyFormatter.format(_budget.end)}',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 18, fontWeight: FontWeight.bold, color: c.primary)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: Stack(
            children: [
              Center(child: Container(height: 4, width: double.infinity,
                  decoration: BoxDecoration(color: c.sliderTrack,
                      borderRadius: BorderRadius.circular(2)))),
              Positioned(left: 0, right: 0, child: Container(height: 4,
                  decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2)))),
              Positioned(
                left: leftPos.clamp(0, _screenWidth - 32),
                right: (_screenWidth - 32) - rightPos.clamp(0, _screenWidth - 32),
                child: Container(height: 4,
                    decoration: BoxDecoration(color: c.primary,
                        borderRadius: BorderRadius.circular(2))),
              ),
              _thumb(leftPos, onPan: (dx) {
                final nv = _budget.start + (dx / (_screenWidth - 32)) * (maxB - minB);
                if (nv >= minB && nv <= _budget.end - 100) {
                  setState(() => _budget = RangeValues(nv, _budget.end));
                }
              }, c: c),
              _thumb(rightPos, onPan: (dx) {
                final nv = _budget.end + (dx / (_screenWidth - 32)) * (maxB - minB);
                if (nv <= maxB && nv >= _budget.start + 100) {
                  setState(() => _budget = RangeValues(_budget.start, nv));
                }
              }, c: c),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CurrencyFormatter.format(minB),
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
              Text('${CurrencyFormatter.format(maxB)}+',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thumb(double pos, {required void Function(double) onPan, required AppColorScheme c}) {
    return Positioned(
      left: pos.clamp(14, _screenWidth - 46) - 14,
      top: 8,
      child: GestureDetector(
        onPanUpdate: (d) => onPan(d.delta.dx),
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: c.card, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.primary, width: 2),
            boxShadow: [BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Center(child: Container(width: 6, height: 6,
              decoration: BoxDecoration(color: c.primary,
                  borderRadius: BorderRadius.circular(3)))),
        ),
      ),
    );
  }

  // ─── Date Picker ────────────────────────────────────────────────────────────
  Widget _buildDatePicker(AppColorScheme c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Desired Move-in Date',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, fontWeight: FontWeight.w600, color: c.textLabel)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
                color: c.inputBg, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.inputBorder)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(DateFormat('yyyy-MM-dd').format(_moveInDate),
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, color: c.textMain)),
                ),
                Icon(Icons.calendar_today, color: c.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Save Button ───────────────────────────────────────────────────────────
  Widget _buildSaveButton(AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: c.border)),
        boxShadow: [BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary, foregroundColor: Colors.white,
          elevation: 8, shadowColor: c.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 56),
        ),
        child: _isSaving
            ? const SizedBox(width: 24, height: 24,
                child: CircularProgressIndicator(strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, size: 24),
                  const SizedBox(width: 12),
                  Text('Save Changes',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }

  // ─── Field helpers ─────────────────────────────────────────────────────────
  Widget _textField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required AppColorScheme c,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w600, color: c.textLabel)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.inputBorder)),
          child: TextField(
            controller: controller,
            maxLines: maxLines, minLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 16, color: c.textHint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: GoogleFonts.plusJakartaSans(fontSize: 16, color: c.textMain),
            cursorColor: c.primary,
          ),
        ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required AppColorScheme c,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w600, color: c.textLabel)),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
              color: c.inputBg, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.inputBorder)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 16, color: c.textMain),
              icon: Icon(Icons.expand_more, color: c.textSecondary),
              dropdownColor: c.inputBg,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
