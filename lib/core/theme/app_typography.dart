import 'package:flutter/material.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';

class AppTypography {
  static const String fontFamilyHeading = 'Epilogue';
  static const String fontFamilyBody = 'Inter';

  static const TextStyle displayXl = TextStyle(
    fontFamily: fontFamilyHeading,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 44 / 48,
    letterSpacing: -0.04 * 48,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontFamilyHeading,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 32 / 32,
    letterSpacing: -0.02 * 32,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontFamilyHeading,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 24 / 24,
    letterSpacing: -0.01 * 24,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 26 / 18,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    color: AppColors.onSurface,
  );

  static const TextStyle numberXl = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 40 / 36,
    letterSpacing: -0.05 * 36,
    color: AppColors.onSurface,
  );

  static const TextStyle labelCaps = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0.05 * 12,
    color: AppColors.onSurface,
  );
  
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayXl,
    headlineLarge: headlineLg,
    headlineMedium: headlineMd,
    bodyLarge: bodyLg,
    bodyMedium: bodyMd,
    labelSmall: labelCaps,
  );
}
