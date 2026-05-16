import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  double _passwordStrength(String p) {
    if (p.isEmpty) return 0;
    double s = 0;
    if (p.length >= 8) s += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) s += 0.25;
    if (p.contains(RegExp(r'[0-9]'))) s += 0.25;
    if (p.contains(RegExp(r'[!@#\$&*~]'))) s += 0.25;
    return s;
  }

  Color _strengthColor(double s, AppColorScheme c) {
    if (s < 0.5) return Colors.red;
    if (s < 0.75) return Colors.orange;
    return Colors.green;
  }

  String _strengthLabel(double s) {
    if (s < 0.25) return 'Very Weak';
    if (s < 0.5) return 'Weak';
    if (s < 0.75) return 'Good';
    return 'Strong';
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) throw Exception('Not logged in');

      // Re-authenticate
      final cred = EmailAuthProvider.credential(email: user.email!, password: _currentCtrl.text);
      await user.reauthenticateWithCredential(cred);

      // Update password
      await user.updatePassword(_newCtrl.text);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password changed successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg = 'Failed to change password.';
      if (e.code == 'wrong-password') msg = 'Current password is incorrect.';
      if (e.code == 'weak-password') msg = 'New password is too weak.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final strength = _passwordStrength(_newCtrl.text);

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
                  Expanded(child: Center(child: Text('Change Password', style: _titleStyle(c)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Info card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.primary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.shield_outlined, color: c.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Use a strong password with at least 8 characters, including uppercase, numbers and symbols.',
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.primary),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _fieldLabel('Current Password', c),
                      const SizedBox(height: 8),
                      _passwordField(
                        controller: _currentCtrl,
                        hint: 'Enter current password',
                        show: _showCurrent,
                        toggle: () => setState(() => _showCurrent = !_showCurrent),
                        c: c,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 20),

                      _fieldLabel('New Password', c),
                      const SizedBox(height: 8),
                      _passwordField(
                        controller: _newCtrl,
                        hint: 'Enter new password',
                        show: _showNew,
                        toggle: () => setState(() => _showNew = !_showNew),
                        c: c,
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 8) return 'At least 8 characters';
                          return null;
                        },
                      ),

                      // Strength indicator
                      if (_newCtrl.text.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: strength,
                                  backgroundColor: c.border,
                                  valueColor: AlwaysStoppedAnimation(_strengthColor(strength, c)),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _strengthLabel(strength),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12, fontWeight: FontWeight.w600,
                                color: _strengthColor(strength, c),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _requirementRow('At least 8 characters', _newCtrl.text.length >= 8, c),
                        _requirementRow('One uppercase letter', _newCtrl.text.contains(RegExp(r'[A-Z]')), c),
                        _requirementRow('One number', _newCtrl.text.contains(RegExp(r'[0-9]')), c),
                        _requirementRow('One special character (!@#\$)', _newCtrl.text.contains(RegExp(r'[!@#\$&*~]')), c),
                      ],

                      const SizedBox(height: 20),

                      _fieldLabel('Confirm New Password', c),
                      const SizedBox(height: 8),
                      _passwordField(
                        controller: _confirmCtrl,
                        hint: 'Repeat new password',
                        show: _showConfirm,
                        toggle: () => setState(() => _showConfirm = !_showConfirm),
                        c: c,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v != _newCtrl.text) return 'Passwords do not match';
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                              : Text('Update Password', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requirementRow(String label, bool met, AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(met ? Icons.check_circle : Icons.circle_outlined, size: 14, color: met ? Colors.green : c.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: met ? Colors.green : c.textSecondary)),
        ],
      ),
    );
  }
}

Widget _passwordField({
  required TextEditingController controller,
  required String hint,
  required bool show,
  required VoidCallback toggle,
  required AppColorScheme c,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
}) {
  return TextFormField(
    controller: controller,
    obscureText: !show,
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 15, color: c.textHint),
      filled: true,
      fillColor: c.inputBg,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.inputBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.inputBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: IconButton(
        icon: Icon(show ? Icons.visibility_off : Icons.visibility, color: c.textSecondary, size: 20),
        onPressed: toggle,
      ),
    ),
    style: GoogleFonts.plusJakartaSans(fontSize: 15, color: c.textMain),
  );
}

Widget _fieldLabel(String label, AppColorScheme c) => Text(
  label,
  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: c.textLabel),
);

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
