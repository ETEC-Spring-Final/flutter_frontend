import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RentalDateTimeField extends StatelessWidget {
  const RentalDateTimeField({
    super.key,
    required this.value,
    required this.onTap,
    this.isSet = false,
  });

  final String value;
  final VoidCallback onTap;
  final bool isSet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSet
                  ? colors.primary.withValues(alpha: 0.35)
                  : colors.outline,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 15.sp,
                  color: colors.primary,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSet ? colors.onSurface : colors.onSurfaceVariant,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22.sp,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
