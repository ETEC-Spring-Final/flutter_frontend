import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height = 50,
    this.borderRadius = 12,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonColor = backgroundColor ?? theme.colorScheme.primary;

    final textColor =
        foregroundColor ??
        (isOutlined ? theme.colorScheme.primary : theme.colorScheme.onPrimary);

    final border = borderColor ?? theme.colorScheme.primary;

    Widget child;

    if (isLoading) {
      child = SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: textColor),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(text)],
      );
    } else {
      child = Text(text);
    }

    final button = SizedBox(
      width: width ?? (isFullWidth ? double.infinity : null),
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(color: border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: child,
            ),
    );

    return button;
  }
}
