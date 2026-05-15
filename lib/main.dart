import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/firebase_options.dart';
import 'package:pfe/features/onboarding/presentation/splash_screen/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfe/features/onboarding/presentation/select_language/bloc/select_lang_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('settings');

  // -- TEMP SCRIPT TO ADD MULTIPLE IMAGES TO DATABASE --
  try {
    final db = FirebaseDatabase.instance.ref('properties');
    final snapshot = await db.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (var key in data.keys) {
        final currentProperty = data[key] as Map<dynamic, dynamic>;
        // Get the existing single image if any
        final existingImageUrl = currentProperty['imageUrl'] ?? 'https://lh3.googleusercontent.com/aida-public/AB6AXuBeCMC87Tsokwz7hKE5XyZfMhNyArZDHr0qYa6cV0jQmYQ5r6i3Gf1iBbcbELG3Jepl0EbbZu2fSDBrRyObrr0yFNfBwLx3iVECITsAikIi0wGFirCp_G5kR34OBDI-2Kr3pa2un9p3t9TRfp1qcfXmH7FknSogxe34I4Tugz97jbIsuqbRkayYRlbeOJMWROT5-a2T_M7xDBa-3Vp4XwwCqOx4S-EjIB-kQT00z5uoIMJ2xFvfzr5rlMUuOtgP24VcqFm6xXQ8AvI';
        
        await db.child(key.toString()).update({
          'images': [
            existingImageUrl, // Keep the original as the first image
            'https://hips.hearstapps.com/hmg-prod/images/dutch-colonial-house-style-66956274903da.jpg?crop=1.00xw:0.671xh;0,0.131xh&resize=1120:*',
            'https://images.adsttc.com/media/images/651f/984b/0d63/133d/0812/0329/newsletter/residencia-lago-y-bosque-lucero-taller-de-arquitectura_1.jpg?1696570691',
            'https://media.architecturaldigest.com/photos/571e97c5741fcddb16b559c9/master/pass/modernist-decor-inspiration-01.jpg'
          ],
        });
      }
      debugPrint('=== SUCCESSFULLY ADDED IMAGES TO FIREBASE ===');
    }
  } catch (e) {
    debugPrint('Failed to add images: \$e');
  }
  // ---------------------------------------------------

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
