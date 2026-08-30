import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBookingBottomBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  const AppBookingBottomBar({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 12.h),
        child: SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            onPressed: enabled ? onPressed : null,

            style: ElevatedButton.styleFrom(
              elevation: 0,

              backgroundColor: colors.primary,

              disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.08),

              foregroundColor: Colors.white,

              disabledForegroundColor: colors.onSurface.withValues(alpha: 0.35),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(width: 8.w),

                Icon(icon, size: 18.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
