/*
A reusable text field that supports
validation, password visibility,
prefix/suffix icons, keyboard type,
controllers, focus, and custom styling.
*/

import 'package:flutter/material.dart';

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

    final borderColor = colorScheme.outline.withValues(alpha: 0.25);

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
      // DECORATION
      // ==========================================================
      decoration: InputDecoration(
        // Text
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,

        // Fill
        filled: widget.filled,
        fillColor:
            widget.fillColor ??
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),

        // Prefix
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.prefixIconColor ?? colorScheme.onSurfaceVariant,
              )
            : null,

        prefixText: widget.prefixText,

        // Suffix
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
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        // ========================================================
        // BORDER
        // ========================================================
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}
