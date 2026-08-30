import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_system/app/theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.iconSize = 18,
    this.fontWeight = FontWeight.w700,
    this.horizontalPadding = 13,
    this.verticalPadding = 7,
    this.borderRadius = 30,
    this.iconSpacing = 5,
  });

  final String label;
  final IconData? icon;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  final double iconSize;
  final FontWeight fontWeight;

  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double iconSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 28.h,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        //vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor?.withValues(alpha: 0.80) ??
            Colors.white.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize, color: iconColor ?? AppColors.primary),
              SizedBox(width: iconSpacing),
            ],

            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: textColor ?? AppColors.primary,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
