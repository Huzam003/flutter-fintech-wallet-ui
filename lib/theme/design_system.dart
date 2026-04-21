import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Authoritative Background Gradient Colors
  static const Color gradientTop = Color(0xFF020A17);
  static const Color gradientBottom = Color(0xFF041B2D);

  // Authoritative Accent Colors
  static const Color primaryBlue = Color(0xFF3A96FF); // Primary Accent
  static const Color neonBlue = Color(0xFF2EC5FF); // Secondary Glow / Cyan

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white38;

  // Status Colors
  static const Color error = Color(0xFFFF4D4D);
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);

  // Surface/Border Colors (Legacy/Compat)
  static const Color background = Color(
    0xFF030F1E,
  ); // User specified background
  static const Color surface = Color(0xFF0D1B2A);
  static const Color surfaceLight = Color(0xFF1B263B);
  static const Color border = Color(0xFF2C3E50);

  // Main Background Gradient
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, background],
  );
}

class AppTextStyles {
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

class AppDimensions {
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL =
      24.0; // Rounder corners often seen in dark modern apps
}
