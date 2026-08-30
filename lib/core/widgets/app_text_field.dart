/*
A reusable responsive text field that supports
validation, password visibility,
prefix/suffix icons, keyboard type,
controllers, focus, and custom styling.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  // ============================================================
  // TEXT
  // ============================================================

  final String? label;
  final String? hint;
  final String? helperText;

  final TextEditingController? controller;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  // ============================================================
  // INPUT
  // ============================================================

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  // ============================================================
  // ENABLE
  // ============================================================

  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool showCursor;

  // ============================================================
  // LINES
  // ============================================================

  final int maxLines;
  final int? maxLength;

  // ============================================================
  // ICON
  // ============================================================

  final IconData? prefixIcon;
  final Widget? suffixIcon;

  final String? prefixText;
  final String? suffixText;

  final Color? prefixIconColor;
  final Color? suffixIconColor;

  // ============================================================
  // FOCUS
  // ============================================================

  final FocusNode? focusNode;

  // ============================================================
  // STYLE
  // ============================================================

  final bool filled;
  final Color? fillColor;

  /// Base radius from the design.
  /// ScreenUtil scales it automatically.
  final double borderRadius;

  final EdgeInsetsGeometry? contentPadding;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const AppTextField({
    super.key,

    // Text
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,

    // Input
    this.keyboardType,
    this.textInputAction,

    // Enable
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.showCursor = true,

    // Lines
    this.maxLines = 1,
    this.maxLength,

    // Icon
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.prefixIconColor,
    this.suffixIconColor,

    // Focus
    this.focusNode,

    // Style
    this.filled = false,
    this.fillColor,
    this.borderRadius = 12,
    this.contentPadding,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderColor = colorScheme.outline.withValues(alpha: 0.5);

    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface,
    );

    return TextFormField(
      // ==========================================================
      // CONTROLLER
      // ==========================================================
      controller: widget.controller,

      // ==========================================================
      // VALIDATION
      // ==========================================================
      validator: widget.validator,

      // ==========================================================
      // CALLBACK
      // ==========================================================
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,

      // ==========================================================
      // INPUT
      // ==========================================================
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,

      // ==========================================================
      // PASSWORD
      // ==========================================================
      obscureText: _obscureText,

      // ==========================================================
      // ENABLE
      // ==========================================================
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      showCursor: widget.showCursor,

      // ==========================================================
      // LINES
      // ==========================================================
      maxLines: widget.obscureText ? 1 : widget.maxLines,

      maxLength: widget.maxLength,

      // ==========================================================
      // FOCUS
      // ==========================================================
      focusNode: widget.focusNode,

      // ==========================================================
      // TEXT STYLE
      // ==========================================================
      style: textStyle,

      //TextStyle(fontSize: 16.sp, color: colorScheme.onSurface),

      // ==========================================================
      // DECORATION
      // ==========================================================
      decoration: InputDecoration(
        isDense: true,

        constraints: BoxConstraints(minHeight: 42.h, maxHeight: 42.h),
        // ========================================================
        // TEXT
        // ========================================================
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,

        hintStyle: textStyle,

        // ========================================================
        // FILL
        // ========================================================
        filled: widget.filled,

        fillColor:
            widget.fillColor ??
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),

        // ========================================================
        // PREFIX
        // ========================================================
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: 22.r,
                color: widget.prefixIconColor ?? colorScheme.onSurfaceVariant,
              )
            : null,

        prefixText: widget.prefixText,

        // ========================================================
        // SUFFIX
        // ========================================================
        suffixIcon: widget.obscureText
            ? IconButton(
                tooltip: _obscureText ? 'Show password' : 'Hide password',

                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },

                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,

                  size: 20.r,

                  color: widget.suffixIconColor ?? colorScheme.onSurfaceVariant,
                ),
              )
            : widget.suffixIcon,

        suffixText: widget.suffixText,

        // ========================================================
        // PADDING
        // ========================================================
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

        // ========================================================
        // BORDER
        // ========================================================
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(color: borderColor, width: 1.r),
        ),

        // ========================================================
        // ENABLED BORDER
        // ========================================================
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(color: borderColor, width: 1.r),
        ),

        // ========================================================
        // FOCUSED BORDER
        // ========================================================
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5.r),
        ),

        // ========================================================
        // ERROR BORDER
        // ========================================================
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(color: colorScheme.error, width: 1.r),
        ),

        // ========================================================
        // FOCUSED ERROR BORDER
        // ========================================================
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5.r),
        ),

        // ========================================================
        // DISABLED BORDER
        // ========================================================
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(
            color: borderColor.withValues(alpha: 0.5),
            width: 1.r,
          ),
        ),
      ),
    );
  }
}
