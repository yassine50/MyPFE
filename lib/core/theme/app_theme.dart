import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// Usage:  final c = context.appColors;
//         Container(color: c.card)
// ─────────────────────────────────────────────────────────────────
extension AppThemeExtension on BuildContext {
  AppColorScheme get appColors {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? AppColorScheme.dark() : AppColorScheme.light();
  }
}

/// Typed semantic color scheme — replaces the copy-pasted _getColors() map.
class AppColorScheme {
  final Color primary;
  final Color background;
  final Color card;
  final Color textMain;
  final Color textSecondary;
  final Color textLabel;
  final Color textHint;
  final Color border;
  final Color divider;
  final Color inputBg;
  final Color inputBorder;
  final Color sliderTrack;
  final Color hover;
  final Color segmentBg;
  final Color counterBg;
  final Color buttonBg;
  final Color statsBg;
  final Color statsBorder;
  final Color settingsIconBg;
  final Color settingsIcon;
  final Color buttonBorder;
  final Color logoutBg;
  final Color logoutText;
  final Color star;
  final Color red;
  final Color verifiedBg;
  final Color verifiedText;

  const AppColorScheme._({
    required this.primary,
    required this.background,
    required this.card,
    required this.textMain,
    required this.textSecondary,
    required this.textLabel,
    required this.textHint,
    required this.border,
    required this.divider,
    required this.inputBg,
    required this.inputBorder,
    required this.sliderTrack,
    required this.hover,
    required this.segmentBg,
    required this.counterBg,
    required this.buttonBg,
    required this.statsBg,
    required this.statsBorder,
    required this.settingsIconBg,
    required this.settingsIcon,
    required this.buttonBorder,
    required this.logoutBg,
    required this.logoutText,
    required this.star,
    required this.red,
    required this.verifiedBg,
    required this.verifiedText,
  });

  factory AppColorScheme.light() => const AppColorScheme._(
        primary: AppColors.primaryBlue,
        background: AppColors.lightBackground,
        card: AppColors.lightCard,
        textMain: AppColors.lightTextMain,
        textSecondary: AppColors.lightTextSecondary,
        textLabel: AppColors.lightTextMain,
        textHint: AppColors.lightTextSecondary,
        border: AppColors.lightBorder,
        divider: AppColors.lightDivider,
        inputBg: AppColors.lightInputBg,
        inputBorder: AppColors.lightInputBorder,
        sliderTrack: AppColors.lightSliderTrack,
        hover: AppColors.lightHover,
        segmentBg: AppColors.lightSegmentBg,
        counterBg: AppColors.lightCounterBg,
        buttonBg: AppColors.lightButtonBg,
        statsBg: AppColors.lightStatsBg,
        statsBorder: AppColors.lightStatsBorder,
        settingsIconBg: AppColors.lightSettingsIconBg,
        settingsIcon: AppColors.lightSettingsIcon,
        buttonBorder: AppColors.lightButtonBorder,
        logoutBg: AppColors.lightLogoutBg,
        logoutText: AppColors.lightLogoutText,
        star: AppColors.star,
        red: AppColors.redLight,
        verifiedBg: AppColors.verifiedBgLight,
        verifiedText: AppColors.verifiedTextLight,
      );

  factory AppColorScheme.dark() => const AppColorScheme._(
        primary: AppColors.primaryBlue,
        background: AppColors.darkBackground,
        card: AppColors.darkCard,
        textMain: AppColors.darkTextMain,
        textSecondary: AppColors.darkTextSecondary,
        textLabel: AppColors.darkTextSecondary,
        textHint: AppColors.darkInputBorder,
        border: AppColors.darkBorder,
        divider: AppColors.darkDivider,
        inputBg: AppColors.darkInputBg,
        inputBorder: AppColors.darkInputBorder,
        sliderTrack: AppColors.darkSliderTrack,
        hover: AppColors.darkHover,
        segmentBg: AppColors.darkSegmentBg,
        counterBg: AppColors.darkCounterBg,
        buttonBg: AppColors.darkButtonBg,
        statsBg: AppColors.darkStatsBg,
        statsBorder: AppColors.darkStatsBorder,
        settingsIconBg: AppColors.darkSettingsIconBg,
        settingsIcon: AppColors.darkSettingsIcon,
        buttonBorder: AppColors.darkButtonBorder,
        logoutBg: AppColors.darkLogoutBg,
        logoutText: AppColors.darkLogoutText,
        star: AppColors.star,
        red: AppColors.redDark,
        verifiedBg: AppColors.verifiedBgDark,
        verifiedText: AppColors.verifiedTextDark,
      );
}
