import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/widgets/blue_button/blue_button.dart';
import 'package:pfe/features/onboarding/presentation/role_select/role_select.dart';
import 'package:pfe/features/auth/data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final bottomSafePadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: c.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 0, 24, bottomSafePadding + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 🔙 Back
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: Icon(Icons.arrow_back_ios_new, color: c.textMain),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 12),

              // 🖼 Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/login.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                AppStrings.loginTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: c.textMain,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Log in to manage your stays and trips.',
                style: TextStyle(fontSize: 16, color: c.textSecondary),
              ),

              const SizedBox(height: 24),

              // 🔁 Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: c.inputBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.inputBorder),
                ),
                child: Row(
                  children: [
                    _authTab(context, 'Log In', isLogin),
                    _authTab(context, 'Sign Up', !isLogin),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔄 SWITCH CONTENT
              isLogin ? _loginForm(context) : _signUpForm(context),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== LOGIN =====================

  Widget _loginForm(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(AppStrings.emailAddress, c),
        _inputField(
          context: context,
          hint: 'name@example.com',
          icon: Icons.email_outlined,
          controller: _emailController,
        ),

        const SizedBox(height: 16),

        _label(AppStrings.password, c),
        _passwordField(context, _passwordController),

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              AppStrings.forgotPassword,
              style: TextStyle(color: c.primary),
            ),
          ),
        ),

        const SizedBox(height: 8),

        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Bluebutton(
                onPressed: _handleLogin,
                textButton: AppStrings.logIn,
              ),

        _divider(c),
        _socialAuth(context),
        _terms(c),
      ],
    );
  }

  // ===================== SIGN UP =====================

  Widget _signUpForm(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Full Name', c),
        _inputField(
          context: context,
          hint: 'John Doe',
          icon: Icons.person_outline,
          controller: _fullNameController,
        ),

        const SizedBox(height: 16),

        _label(AppStrings.emailAddress, c),
        _inputField(
          context: context,
          hint: 'name@example.com',
          icon: Icons.email_outlined,
          controller: _emailController,
        ),

        const SizedBox(height: 16),

        _label(AppStrings.password, c),
        _passwordField(context, _passwordController),

        const SizedBox(height: 16),

        _label('Confirm Password', c),
        _passwordField(context, _confirmPasswordController),

        const SizedBox(height: 24),

        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Bluebutton(
                onPressed: _handleSignUp,
                textButton: AppStrings.signUp,
              ),

        _divider(c),
        _socialAuth(context),
        _terms(c),
      ],
    );
  }

  // ===================== AUTH LOGIC =====================

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (context) => const RoleSelect()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();
    final name = _fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: name,
      );

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (context) => const RoleSelect()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ===================== REUSABLE =====================

  Widget _authTab(BuildContext context, String text, bool active) {
    final c = context.appColors;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = text == 'Log In'),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: active ? c.card : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active ? c.primary : c.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: c.textLabel,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _passwordField(BuildContext context, [TextEditingController? controller]) {
    return _inputField(
      context: context,
      hint: '••••••••',
      icon: Icons.lock_outline,
      obscure: obscurePassword,
      controller: controller,
      suffix: IconButton(
        icon: Icon(
          obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: context.appColors.textSecondary,
        ),
        onPressed: () {
          setState(() => obscurePassword = !obscurePassword);
        },
      ),
    );
  }

  Widget _inputField({
    required BuildContext context,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextEditingController? controller,
  }) {
    final c = context.appColors;
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: c.textMain),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.textHint),
        prefixIcon: Icon(icon, color: c.textSecondary),
        suffixIcon: suffix,
        filled: true,
        fillColor: c.inputBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _divider(AppColorScheme c) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(child: Divider(color: c.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                AppStrings.orContinueWith,
                style: TextStyle(color: c.textSecondary, fontSize: 13),
              ),
            ),
            Expanded(child: Divider(color: c.border)),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _socialAuth(BuildContext context) {
    return Column(
      children: [
        _socialButton(
          context: context,
          icon: Icons.phone_android,
          text: 'Continue with Phone Number',
        ),
        const SizedBox(height: 12),
        _socialButton(
          context: context,
          icon: Icons.apple,
          text: 'Continue with Apple',
          dark: true,
        ),
        const SizedBox(height: 12),
        _socialButton(
          context: context,
          icon: Icons.public,
          text: 'Continue with Google',
        ),
      ],
    );
  }

  Widget _terms(AppColorScheme c) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text.rich(
          TextSpan(
            text: 'By continuing, you agree to our ',
            style: TextStyle(color: c.textSecondary, fontSize: 13),
            children: [
              TextSpan(
                text: 'Terms of Service',
                style: TextStyle(
                  color: c.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  color: c.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 14, color: c.textSecondary),
            const SizedBox(width: 6),
            Text(
              'Secure encrypted connection',
              style: TextStyle(color: c.textSecondary, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _socialButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    bool dark = false,
  }) {
    final c = context.appColors;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: dark ? AppColors.black : c.card,
          foregroundColor: dark ? AppColors.white : c.textMain,
          side: BorderSide(color: dark ? AppColors.black : c.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {},
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
