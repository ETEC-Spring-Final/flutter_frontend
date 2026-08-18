import 'package:flutter/material.dart';
import 'package:vehicle_rental_system/app/theme/app_dimensions.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final double elevation;
  final IconData icon;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.size = 45,
    this.iconSize = AppDimensions.iconSmall,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.elevation = 2,
    this.icon = Icons.arrow_back,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      child: AspectRatio(
        aspectRatio: AppDimensions.aspectRatioSquare,
        child: ElevatedButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.surface,
            foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
            elevation: elevation,
            shadowColor: shadowColor ?? theme.shadowColor,
            padding: EdgeInsets.zero,
            // Makes the button circular
            shape: const CircleBorder(),
          ),
          child: Icon(icon, size: iconSize),
        ),
      ),
    );
  }
}
