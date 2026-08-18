import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ============================================================
  // DISPLAY
  // ============================================================

  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -1.0,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // HEADLINE
  // ============================================================

  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // TITLE
  // ============================================================

  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // BODY
  // ============================================================

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // LABEL
  // ============================================================

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.3,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // SPECIAL STYLES
  // ============================================================

  static TextStyle button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle input = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textTertiary,
  );
}
