import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pfe/view/Onbording/onbording1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _fade;
  late Animation<Offset> _slideUp;

  int _activeDot = 0;
  Timer? _dotTimer;

  @override
  void initState() {
    super.initState();

    /// Main animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    /// Loading dots animation
    _dotTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _activeDot = (_activeDot + 1) % 3;
      });
    });

    /// Navigate after few seconds
    Future.delayed(const Duration(seconds: 3), () {
      _dotTimer?.cancel();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>  Onbording1(), // 🔁 Change this
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            children: [
              const Spacer(flex: 2),

              /// Logo
              ScaleTransition(
                scale: _logoScale,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E6BF1),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Text
              SlideTransition(
                position: _slideUp,
                child: Column(
                  children: const [
                    Text(
                      'RoRent',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Co-living made simple in\nRomania',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              /// Loading Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: index == _activeDot ? 10 : 8,
                    height: index == _activeDot ? 10 : 8,
                    decoration: BoxDecoration(
                      color: index == _activeDot
                          ? const Color(0xFF1E6BF1)
                          : Colors.blueGrey.shade300,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              const Text(
                'v1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
