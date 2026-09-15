import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageViewerArrow extends StatelessWidget {
  final IconData icon;

  const ImageViewerArrow({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 30.r),
    );
  }
}
