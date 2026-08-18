/*

A reusable text field that supports 
validation, password visibility, 
prefix/suffix icons, keyboard type, 
and controllers.
*/

import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  // text

  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  // input action

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  // enable

  final bool obscureText;
  final bool enabled;
  final bool readOnly;

  final int maxLines;
  final int? maxLength;

  // icon

  final IconData? prefixIcon;
  final Widget? suffixIcon;

  final String? prefixText;
  final String? suffixText;

  // focus

  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,

      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,

      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,

      maxLines: widget.obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,

      focusNode: widget.focusNode,

      //style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,

        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
            : widget.suffixIcon,

        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
      ),
    );
  }
}
