import 'package:flutter/material.dart';
import 'package:pfe/component/blueButton/BlueButton.dart';
import 'package:pfe/view/RoleSelect/RoleSelect.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bottomSafePadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
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
                icon: const Icon(Icons.arrow_back_ios_new),
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

              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              const Text(
                'Log in to manage your stays and trips.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // 🔁 Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _authTab('Log In', isLogin),
                    _authTab('Sign Up', !isLogin),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔄 SWITCH CONTENT
              isLogin ? _loginForm() : _signUpForm(),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== LOGIN =====================

  Widget _loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Email Address'),
        _inputField(hint: 'name@example.com', icon: Icons.email_outlined),

        const SizedBox(height: 16),

        _label('Password'),
        _passwordField(),

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text('Forgot Password?', style: TextStyle(color: Colors.blue)),
          ),
        ),

        const SizedBox(height: 8),

        Bluebutton(
          onPressed: () {
            Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => const RoleSelect(),
    ),
  );
          },
          textButton: 'Log in',
        ),

        _divider(),
        _socialAuth(),
        _terms(),
      ],
    );
  }

  // ===================== SIGN UP =====================

  Widget _signUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Email Address'),
        _inputField(hint: 'name@example.com', icon: Icons.email_outlined),

        const SizedBox(height: 16),

        _label('Password'),
        _passwordField(),

        const SizedBox(height: 16),

        _label('Confirm Password'),
        _passwordField(),

        const SizedBox(height: 24),

        Bluebutton(
          onPressed: () {},
          textButton: 'Create Account',
        ),

        _divider(),
        _socialAuth(),
        _terms(),
      ],
    );
  }

  // ===================== REUSABLE =====================

  Widget _authTab(String text, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = text == 'Log In'),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w500));
  }

  Widget _passwordField() {
    return _inputField(
      hint: '••••••••',
      icon: Icons.lock_outline,
      obscure: obscurePassword,
      suffix: IconButton(
        icon: Icon(
          obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: () {
          setState(() => obscurePassword = !obscurePassword);
        },
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _divider() {
    return Column(
      children: const [
        SizedBox(height: 28),
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Or continue with', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _socialAuth() {
    return Column(
      children: [
        _socialButton(icon: Icons.phone_android, text: 'Continue with Phone Number'),
        const SizedBox(height: 12),
        _socialButton(icon: Icons.apple, text: 'Continue with Apple', dark: true),
        const SizedBox(height: 12),
        _socialButton(icon: Icons.public, text: 'Continue with Google'),
      ],
    );
  }

  Widget _terms() {
    return Column(
      children: const [
        SizedBox(height: 24),
        Text.rich(
          TextSpan(
            text: 'By continuing, you agree to our ',
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(text: 'Terms of Service', style: TextStyle(color: Colors.blue)),
              TextSpan(text: ' and '),
              TextSpan(text: 'Privacy Policy', style: TextStyle(color: Colors.blue)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text('Secure encrypted connection', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String text,
    bool dark = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: dark ? Colors.black : Colors.white,
          foregroundColor: dark ? Colors.white : Colors.black,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {

        },
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
