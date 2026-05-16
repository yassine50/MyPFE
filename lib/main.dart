import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/firebase_options.dart';
import 'package:pfe/features/onboarding/presentation/splash_screen/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfe/features/onboarding/presentation/select_language/bloc/select_lang_bloc.dart';

import 'package:pfe/core/utils/currency_formatter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('settings');

  CurrencyFormatter.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectLangBloc(),
      child: BlocBuilder<SelectLangBloc, SelectLangState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF136DEC),
                brightness: Brightness.light,
                surface: const Color(0xFFF6F7F8),
              ),
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
              appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
              dividerTheme: const DividerThemeData(space: 1),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF136DEC),
                brightness: Brightness.dark,
                surface: const Color(0xFF101822),
              ),
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
              appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
              dividerTheme: const DividerThemeData(space: 1),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
