import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final double iconSize;

  const AppCircleBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
    this.backgroundColor = const Color(0x59000000),
    this.size = 35,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Center(
          child: Icon(
            icon,
            size: iconSize.sp,
            color: iconColor,
            fontWeight: .bold,
          ),
        ),
      ),
    );
  }
}
