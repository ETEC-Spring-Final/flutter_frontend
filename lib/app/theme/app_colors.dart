import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============================================================
  // PRIMARY
  // ============================================================

  /// Main brand color - Navy
  /// Design reference: #1A2B4C
  static const Color primary = Color(0xFF1A2B4C);

  static const Color primary50 = Color(0xFFF1F4F8);
  static const Color primary100 = Color(0xFFDDE4EF);
  static const Color primary200 = Color(0xFFBBC9DE);
  static const Color primary300 = Color(0xFF93A9C9);
  static const Color primary400 = Color(0xFF6B89B5);
  static const Color primary500 = Color(0xFF496F9F);
  static const Color primary600 = Color(0xFF365B86);
  static const Color primary700 = Color(0xFF2B4A6E);
  static const Color primary800 = Color(0xFF223B58);
  static const Color primary900 = Color(0xFF1A2B4C);

  // ============================================================
  // SECONDARY
  // ============================================================

  /// Secondary brand color - Emerald Green
  /// Design reference: #10B981
  static const Color secondary = Color(0xFF10B981);

  static const Color secondary50 = Color(0xFFECFDF5);
  static const Color secondary100 = Color(0xFFD1FAE5);
  static const Color secondary200 = Color(0xFFA7F3D0);
  static const Color secondary300 = Color(0xFF6EE7B7);
  static const Color secondary400 = Color(0xFF34D399);
  static const Color secondary500 = Color(0xFF10B981);
  static const Color secondary600 = Color(0xFF059669);
  static const Color secondary700 = Color(0xFF047857);
  static const Color secondary800 = Color(0xFF065F46);
  static const Color secondary900 = Color(0xFF064E3B);

  // ============================================================
  // TERTIARY
  // ============================================================

  /// Tertiary brand color - Brown
  /// Design reference: #3F2600
  static const Color tertiary = Color(0xFF3F2600);

  static const Color tertiary50 = Color(0xFFFFFBF5);
  static const Color tertiary100 = Color(0xFFF8EEDC);
  static const Color tertiary200 = Color(0xFFEED9B7);
  static const Color tertiary300 = Color(0xFFDDBB88);
  static const Color tertiary400 = Color(0xFFC39A5D);
  static const Color tertiary500 = Color(0xFFA77A3C);
  static const Color tertiary600 = Color(0xFF80591F);
  static const Color tertiary700 = Color(0xFF62400D);
  static const Color tertiary800 = Color(0xFF4C3004);
  static const Color tertiary900 = Color(0xFF3F2600);

  // ============================================================
  // NEUTRAL
  // ============================================================

  /// Main neutral color
  /// Design reference: #F9FAFB
  static const Color neutral = Color(0xFFF9FAFB);

  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);

  // ============================================================
  // BASIC COLORS
  // ============================================================

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF000000);

  static const Color transparent = Colors.transparent;

  // ============================================================
  // LIGHT MODE - BACKGROUND
  // ============================================================

  static const Color background = Color(0xFFF9FAFB);

  static const Color surface = Color(0xFFFFFFFF);

  static const Color surfaceVariant = Color(0xFFF3F4F6);

  static const Color surfaceContainer = Color(0xFFFFFFFF);

  static const Color surfaceContainerLow = Color(0xFFF9FAFB);

  static const Color surfaceContainerHigh = Color(0xFFF3F4F6);

  // ============================================================
  // LIGHT MODE - TEXT
  // ============================================================

  static const Color textPrimary = Color(0xFF1F2937);

  static const Color textSecondary = Color(0xFF6B7280);

  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color textDisabled = Color(0xFFD1D5DB);

  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color textOnSecondary = Color(0xFFFFFFFF);

  static const Color textOnTertiary = Color(0xFFFFFFFF);

  static const Color textOnDark = Color(0xFFF9FAFB);

  // ============================================================
  // LIGHT MODE - BORDER
  // ============================================================

  static const Color border = Color(0xFFE5E7EB);

  static const Color borderLight = Color(0xFFF3F4F6);

  static const Color borderDark = Color(0xFFD1D5DB);

  static const Color divider = Color(0xFFE5E7EB);

  // ============================================================
  // LIGHT MODE - ICON
  // ============================================================

  static const Color iconPrimary = Color(0xFF1F2937);

  static const Color iconSecondary = Color(0xFF6B7280);

  static const Color iconTertiary = Color(0xFF9CA3AF);

  static const Color iconDisabled = Color(0xFFD1D5DB);

  // ============================================================
  // STATUS - SUCCESS
  // ============================================================

  static const Color success = Color(0xFF10B981);

  static const Color successLight = Color(0xFF34D399);

  static const Color successDark = Color(0xFF047857);

  static const Color successBackground = Color(0xFFECFDF5);

  // ============================================================
  // STATUS - WARNING
  // ============================================================

  static const Color warning = Color(0xFFF59E0B);

  static const Color warningLight = Color(0xFFFBBF24);

  static const Color warningDark = Color(0xFFD97706);

  static const Color warningBackground = Color(0xFFFFFBEB);

  // ============================================================
  // STATUS - ERROR
  // ============================================================

  static const Color error = Color(0xFFDC2626);

  static const Color errorLight = Color(0xFFF87171);

  static const Color errorDark = Color(0xFFB91C1C);

  static const Color errorBackground = Color(0xFFFEF2F2);

  // ============================================================
  // STATUS - INFO
  // ============================================================

  static const Color info = Color(0xFF2563EB);

  static const Color infoLight = Color(0xFF60A5FA);

  static const Color infoDark = Color(0xFF1D4ED8);

  static const Color infoBackground = Color(0xFFEFF6FF);

  // ============================================================
  // DARK MODE - PRIMARY
  // ============================================================

  /// Dark-mode primary
  static const Color darkPrimary = Color(0xFF6B89B5);

  static const Color darkPrimaryLight = Color(0xFF93A9C9);

  static const Color darkPrimaryDark = Color(0xFF496F9F);

  static const Color darkOnPrimary = Color(0xFF0F172A);

  // ============================================================
  // DARK MODE - SECONDARY
  // ============================================================

  static const Color darkSecondary = Color(0xFF34D399);

  static const Color darkSecondaryLight = Color(0xFF6EE7B7);

  static const Color darkSecondaryDark = Color(0xFF10B981);

  static const Color darkOnSecondary = Color(0xFF052E1B);

  // ============================================================
  // DARK MODE - TERTIARY
  // ============================================================

  static const Color darkTertiary = Color(0xFFDDBB88);

  static const Color darkTertiaryLight = Color(0xFFEED9B7);

  static const Color darkTertiaryDark = Color(0xFFC39A5D);

  static const Color darkOnTertiary = Color(0xFF2A1700);

  // ============================================================
  // DARK MODE - BACKGROUND
  // ============================================================

  /// Main dark background
  static const Color darkBackground = Color(0xFF0F172A);

  /// Main dark surface
  static const Color darkSurface = Color(0xFF1E293B);

  /// Secondary dark surface
  static const Color darkSurfaceVariant = Color(0xFF273449);

  static const Color darkSurfaceContainer = Color(0xFF1E293B);

  static const Color darkSurfaceContainerLow = Color(0xFF172235);

  static const Color darkSurfaceContainerHigh = Color(0xFF273449);

  // ============================================================
  // DARK MODE - TEXT
  // ============================================================

  static const Color darkTextPrimary = Color(0xFFF9FAFB);

  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  static const Color darkTextTertiary = Color(0xFF94A3B8);

  static const Color darkTextDisabled = Color(0xFF475569);

  static const Color darkTextOnPrimary = Color(0xFF0F172A);

  static const Color darkTextOnSecondary = Color(0xFF052E1B);

  static const Color darkTextOnTertiary = Color(0xFF2A1700);

  // ============================================================
  // DARK MODE - BORDER
  // ============================================================

  static const Color darkBorder = Color(0xFF334155);

  static const Color darkBorderLight = Color(0xFF273449);

  static const Color darkBorderDark = Color(0xFF475569);

  static const Color darkDivider = Color(0xFF334155);

  // ============================================================
  // DARK MODE - ICON
  // ============================================================

  static const Color darkIconPrimary = Color(0xFFF9FAFB);

  static const Color darkIconSecondary = Color(0xFFCBD5E1);

  static const Color darkIconTertiary = Color(0xFF94A3B8);

  static const Color darkIconDisabled = Color(0xFF475569);

  // ============================================================
  // DARK MODE - STATUS
  // ============================================================

  static const Color darkSuccess = Color(0xFF34D399);

  static const Color darkSuccessBackground = Color(0xFF064E3B);

  static const Color darkWarning = Color(0xFFFBBF24);

  static const Color darkWarningBackground = Color(0xFF78350F);

  static const Color darkError = Color(0xFFF87171);

  static const Color darkErrorBackground = Color(0xFF7F1D1D);

  static const Color darkInfo = Color(0xFF60A5FA);

  static const Color darkInfoBackground = Color(0xFF1E3A8A);

  // ============================================================
  // OVERLAY
  // ============================================================

  static const Color overlayLight = Color(0x14000000);

  static const Color overlayMedium = Color(0x33000000);

  static const Color overlayDark = Color(0x66000000);

  // ============================================================
  // SHADOW
  // ============================================================

  static const Color shadowLight = Color(0x14000000);

  static const Color shadowMedium = Color(0x24000000);

  static const Color shadowDark = Color(0x33000000);
}
