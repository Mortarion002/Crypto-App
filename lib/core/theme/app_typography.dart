import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';

class AppTypography {
  static TextStyle displayXl = GoogleFonts.epilogue(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 44 / 48,
    letterSpacing: -0.04 * 48,
    color: AppColors.onSurface,
  );

  static TextStyle headlineLg = GoogleFonts.epilogue(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 32 / 32,
    letterSpacing: -0.02 * 32,
    color: AppColors.onSurface,
  );

  static TextStyle headlineMd = GoogleFonts.epilogue(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 24 / 24,
    letterSpacing: -0.01 * 24,
    color: AppColors.onSurface,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 26 / 18,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    color: AppColors.onSurface,
  );

  static TextStyle numberXl = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 40 / 36,
    letterSpacing: -0.05 * 36,
    color: AppColors.onSurface,
  );

  static TextStyle labelCaps = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0.05 * 12,
    color: AppColors.onSurface,
  );
  
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayXl,
    headlineLarge: headlineLg,
    headlineMedium: headlineMd,
    bodyLarge: bodyLg,
    bodyMedium: bodyMd,
    labelSmall: labelCaps,
  );
}
