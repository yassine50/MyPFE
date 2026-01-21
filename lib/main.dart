import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/firebase_options.dart';
import 'package:pfe/view/SplashScreen/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF136DEC),
          brightness: Brightness.light,
          background: const Color(0xFFF6F7F8),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF136DEC),
          brightness: Brightness.dark,
          background: const Color(0xFF101822),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      home:  SplashScreen(),
    );
    
  }
}