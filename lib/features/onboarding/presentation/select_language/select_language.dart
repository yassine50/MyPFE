import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfe/core/widgets/blue_button/blue_button.dart';
import 'package:pfe/core/widgets/card/language_select.dart';
import 'package:pfe/core/widgets/text/text.dart';
import 'package:pfe/features/onboarding/presentation/select_language/bloc/select_lang_bloc.dart';
import 'package:pfe/features/auth/presentation/login/login.dart';
import 'package:pfe/core/localization/app_strings.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> title = ["English", "română", "français"];
    List<String> desc = ["English", "română", "français"];
    List<String> countryCode = ["US", "RO", "FR"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 🔙 Back + Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 32),
                  Text1(
                    text: AppStrings.selectLanguageTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text1(
                text: AppStrings.selectLanguageSubtitle,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),

              const SizedBox(height: 16),

              BlocBuilder<SelectLangBloc, SelectLangState>(
                builder: (context, state) {
                  final int selectedIndex = state is SelectLangInitial
                      ? state.selectedIndex
                      : 0;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: title.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.read<SelectLangBloc>().add(SelectLanguageEvent(index));
                          },
                          child: SelectLanguage(
                            select: index == selectedIndex,
                            countryCode: countryCode[index],
                            title: title[index],
                            description: desc[index],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // ✅ Button stays at bottom
              Bluebutton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                textButton: 'Continue',
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String nativeName;
  final String englishName;
  final bool isSelected;

  const LanguageTile({
    super.key,
    required this.nativeName,
    required this.englishName,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8F2FF) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF0066CC) : Colors.transparent,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nativeName,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF0066CC) : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                englishName,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected
                      ? const Color(0xFF0066CC)
                      : Colors.grey[700],
                ),
              ),
            ],
          ),

          if (isSelected)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF0066CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
        ],
      ),
    );
  }
}
