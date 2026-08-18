import 'package:flutter/material.dart';

class AppSize {
  AppSize._();

  /// Screen dimensions
  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// Safe area
  static double topPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).top;
  }

  static double bottomPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom;
  }

  /// Responsive width
  static double w(BuildContext context, double value) {
    return width(context) * (value / 100);
  }

  /// Responsive height
  static double h(BuildContext context, double value) {
    return height(context) * (value / 100);
  }

  /// Responsive horizontal padding
  static double horizontal(BuildContext context, double value) {
    return width(context) * (value / 100);
  }

  /// Responsive vertical padding
  static double vertical(BuildContext context, double value) {
    return height(context) * (value / 100);
  }

  /// Device type
  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= 600 && width(context) < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= 1024;
  }
}
