// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ── NEW CORE COLORS ──────────────────────────────────────────
  static const Color background = Color(0xFF050508);
  static const Color bg2 = Color(0xFF09090F);
  static const Color bg3 = Color(0xFF0E0E1A);
  static const Color glass = Color(0x0AFFFFFF);
  static const Color border = Color(0x14FFFFFF);
  static const Color border2 = Color(0x24FFFFFF);

  static const Color purple = Color(0xFF7C3AED);
  static const Color purple2 = Color(0xFFA855F7);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyan2 = Color(0xFF22D3EE);
  static const Color pink = Color(0xFFEC4899);
  static const Color green = Color(0xFF4ADE80);
  static const Color amber = Color(0xFFFBBF24);

  static const Color white = Color(0xFFF8FAFC);
  static const Color w70 = Color(0xB3F8FAFC);
  static const Color w40 = Color(0x66F8FAFC);
  static const Color w20 = Color(0x33F8FAFC);

  // ── NEW GRADIENTS ────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [purple, Color(0xFF5B21B6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [purple, cyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient textGradient = LinearGradient(
    colors: [purple2, cyan2, pink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient pinkAmberGradient = LinearGradient(
    colors: [pink, amber],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient greenCyanGradient = LinearGradient(
    colors: [green, cyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient purplePinkGradient = LinearGradient(
    colors: [purple, pink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ── LEGACY ALIASES (Keeps your existing UI code compiling) ───
  static const Color surfaceDark = bg2;
  static const Color surface = bg3;
  static const Color cardBg = bg2;

  static const Color neonBlue = cyan;
  static const Color neonBlueMid = cyan2;
  static const Color neonCyan = cyan2;
  static const Color neonPurple = purple;
  static const Color neonViolet = purple2;
  static const Color neonPink = pink;

  static const Color success = green;
  static const Color warning = amber;
  static const Color error = Color(0xFFEF4444); // Standard error red

  static const Color textPrimary = white;
  static const Color textSecondary = w70;
  static const Color textMuted = w40;

  static const LinearGradient heroGradient = accentGradient;
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, bg3, background],
  );

  static const Color deepBlue = cyan;
  static const Color iceBlue = cyan2;
  static const Color purpleLight = purple2;
  static const Color cyanDark = cyan;
  static const Color violet = purple;
  static const Color violetLight = purple2;
  static const Color pinkLight = pink;
  static const Color silver = w70;
  static const Color indigo = purple;
  static const Color softGold = amber;
  static const Color crimson = error;
  static const Color emerald = green;
  static const Color neonGreen = green;
  static const Color neonAmber = amber;

  static const LinearGradient iceBlueGradient = greenCyanGradient;
  static const LinearGradient silverGradient = accentGradient;
  static const LinearGradient indigoGradient = primaryGradient;
  static const LinearGradient goldGradient = pinkAmberGradient;
  static const LinearGradient cardGradient1 = greenCyanGradient;
  static const LinearGradient cardGradient2 = purplePinkGradient;
  static const LinearGradient cardGradient3 = accentGradient;
  static const LinearGradient cardGradient4 = pinkAmberGradient;
}

class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.syne(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.syne(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: -0.3,
  );

  static TextStyle get displaySmall => GoogleFonts.syne(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get headingLarge => GoogleFonts.syne(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get headingMedium => GoogleFonts.syne(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get headingSmall => GoogleFonts.syne(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.w70,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.w70,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.w40,
  );

  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.w70,
    letterSpacing: 0.2,
  );

  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.w40,
    letterSpacing: 0.5,
  );

  static TextStyle get kpiNumber => GoogleFonts.syne(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: -1,
  );

  static TextStyle get captionUppercase => GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.w40,
    letterSpacing: 1.2,
  );
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.purple,
        secondary: AppColors.cyan,
        surface: AppColors.bg2,
        // The parameter 'background' is deprecated in newer Flutter versions,
        // but included here to match your setup.
        background: AppColors.background,
      ),
      // Integrate the new AppTextStyles cleanly
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
}
