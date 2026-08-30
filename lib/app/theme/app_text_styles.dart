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


/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ============================================================
  // DISPLAY
  // ============================================================

  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 57.sp,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -1.5.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 45.sp,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -1.0.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5.sp,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // HEADLINE
  // ============================================================

  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // TITLE
  // ============================================================

  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // BODY
  // ============================================================

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // LABEL
  // ============================================================

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.3.sp,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // SPECIAL STYLES
  // ============================================================

  static TextStyle button = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle input = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textTertiary,
  );
}


*/



/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // ============================================================
  // FONT
  // ============================================================

  static TextStyle _font(
    BuildContext context, {
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    double? letterSpacing,
    Color? color,
  }) {
    final locale = Localizations.localeOf(context);

    final TextStyle baseStyle;

    // Use a Khmer-compatible font for Khmer.
    if (locale.languageCode == 'km') {
      baseStyle = GoogleFonts.notoSansKhmer();
    } else {
      baseStyle = GoogleFonts.inter();
    }

    return baseStyle.copyWith(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing?.sp,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  // ============================================================
  // DISPLAY
  // ============================================================

  static TextStyle displayLarge(BuildContext context) {
    return _font(
      context,
      fontSize: 57,
      fontWeight: FontWeight.w700,
      height: 1.12,
      letterSpacing: -1.5,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return _font(
      context,
      fontSize: 45,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -1.0,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return _font(
      context,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  // ============================================================
  // HEADLINE
  // ============================================================

  static TextStyle headlineLarge(BuildContext context) {
    return _font(
      context,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.5,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return _font(
      context,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.3,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return _font(
      context,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.3,
    );
  }

  // ============================================================
  // TITLE
  // ============================================================

  static TextStyle titleLarge(BuildContext context) {
    return _font(
      context,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return _font(
      context,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return _font(
      context,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  static TextStyle bodyLarge(BuildContext context) {
    return _font(
      context,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return _font(
      context,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return _font(
      context,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  static TextStyle labelLarge(BuildContext context) {
    return _font(
      context,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return _font(
      context,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0.2,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return _font(
      context,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0.3,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  // ============================================================
  // SPECIAL STYLES
  // ============================================================

  static TextStyle button(BuildContext context) {
    return _font(
      context,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  static TextStyle input(BuildContext context) {
    return _font(
      context,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  static TextStyle caption(BuildContext context) {
    return _font(
      context,
      fontSize: 11,
      fontWeight: FontWeight.w400,
      height: 1.3,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}

*/