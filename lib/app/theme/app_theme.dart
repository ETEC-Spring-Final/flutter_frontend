import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,

      secondary: AppColors.secondary,
      onSecondary: AppColors.white,

      tertiary: AppColors.tertiary,
      onTertiary: AppColors.white,

      error: AppColors.error,
      onError: AppColors.white,

      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondary,

      outline: AppColors.border,
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,

      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,

      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,

      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,

      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    // ==========================================================
    // APP BAR
    // ==========================================================
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),

    // ==========================================================
    // ELEVATED BUTTON
    // ==========================================================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,

        minimumSize: const Size(0, 48),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: AppTextStyles.button,
      ),
    ),

    // ==========================================================
    // OUTLINED BUTTON
    // ==========================================================
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,

        minimumSize: const Size(0, 48),

        side: const BorderSide(color: AppColors.primary),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: AppTextStyles.button,
      ),
    ),

    // ==========================================================
    // TEXT BUTTON
    // ==========================================================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: AppTextStyles.button,
      ),
    ),

    // ==========================================================
    // INPUT
    // ==========================================================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.neutral100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      hintStyle: AppTextStyles.bodyLarge,
      labelStyle: AppTextStyles.labelMedium,

      prefixIconColor: AppColors.textPrimary,
      suffixIconColor: AppColors.textPrimary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    ),

    // ==========================================================
    // CARD
    // ==========================================================
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

        side: const BorderSide(color: AppColors.border),
      ),
    ),

    // ==========================================================
    // DIVIDER
    // ==========================================================
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),

    // ==========================================================
    // ICON
    // ==========================================================
    iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),

    // ==========================================================
    // NAVIGATION BAR
    // ==========================================================
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,

      indicatorColor: AppColors.primary100,

      elevation: 0,

      labelTextStyle: WidgetStatePropertyAll(AppTextStyles.labelSmall),
    ),

    // ==========================================================
    // FAB
    // ==========================================================
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    ),

    // ==========================================================
    // SNACKBAR
    // ==========================================================
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary,

      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.white,
      ),

      behavior: SnackBarBehavior.floating,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,

      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,

      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,

      error: AppColors.darkError,
      onError: AppColors.white,

      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,

      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkTextSecondary,

      outline: AppColors.darkBorder,
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),

      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkTextSecondary,
      ),

      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    ),

    // ==========================================================
    // APP BAR
    // ==========================================================
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,

      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    ),

    // ==========================================================
    // ELEVATED BUTTON
    // ==========================================================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.white,
        elevation: 0,

        minimumSize: const Size(0, 48),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: AppTextStyles.button,
      ),
    ),

    // ==========================================================
    // OUTLINED BUTTON
    // ==========================================================
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,

        minimumSize: const Size(0, 48),

        side: const BorderSide(color: AppColors.darkPrimary),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: AppTextStyles.button,
      ),
    ),

    // ==========================================================
    // TEXT BUTTON
    // ==========================================================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkSecondary,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: AppTextStyles.button,
      ),
    ),

    // ==========================================================
    // INPUT
    // ==========================================================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      hintStyle: AppTextStyles.titleMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),

      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),

      prefixIconColor: AppColors.darkTextSecondary,
      suffixIconColor: AppColors.darkTextSecondary,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkError),
      ),
    ),

    // ==========================================================
    // CARD
    // ==========================================================
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),

    // ==========================================================
    // DIVIDER
    // ==========================================================
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
    ),

    // ==========================================================
    // ICON
    // ==========================================================
    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary, size: 24),

    // ==========================================================
    // NAVIGATION BAR
    // ==========================================================
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,

      indicatorColor: AppColors.darkPrimary,

      elevation: 0,

      labelTextStyle: WidgetStatePropertyAll(
        AppTextStyles.labelSmall.copyWith(color: AppColors.darkTextPrimary),
      ),
    ),

    // ==========================================================
    // FAB
    // ==========================================================
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.white,
      elevation: 0,
      // focusColor: AppColors.white,
      // extendedTextStyle:
    ),

    // ==========================================================
    // SNACKBAR
    // ==========================================================
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurface,

      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      behavior: SnackBarBehavior.floating,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
