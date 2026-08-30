import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  AppDimensions._();

  // ============================================================
  // SPACING
  // ============================================================

  static double get space2 => 2.w;
  static double get space4 => 4.w;
  static double get space6 => 6.w;
  static double get space8 => 8.w;
  static double get space10 => 10.w;
  static double get space12 => 12.w;
  static double get space14 => 14.w;
  static double get space16 => 16.w;
  static double get space20 => 20.w;
  static double get space24 => 24.w;
  static double get space28 => 28.w;
  static double get space32 => 32.w;
  static double get space40 => 40.w;
  static double get space48 => 48.w;
  static double get space56 => 56.w;
  static double get space64 => 64.w;
  static double get space72 => 72.w;
  static double get space80 => 80.w;

  // ============================================================
  // SCREEN
  // ============================================================

  static double get screenHorizontal => 20.w;
  static double get screenVertical => 16.h;

  static EdgeInsets get screenPadding => EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenVertical,
  );

  static EdgeInsets get screenHorizontalPadding =>
      EdgeInsets.symmetric(horizontal: screenHorizontal);

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  static double get radius4 => 4.r;
  static double get radius6 => 6.r;
  static double get radius8 => 8.r;
  static double get radius10 => 10.r;
  static double get radius12 => 12.r;
  static double get radius16 => 16.r;
  static double get radius20 => 20.r;
  static double get radius24 => 24.r;

  static double get radiusCircular => 999.r;

  // ============================================================
  // CARD
  // ============================================================

  static double get cardRadius => 12.r;
  static double get cardPadding => 16.w;

  static EdgeInsets get cardContentPadding => EdgeInsets.all(cardPadding);

  // ============================================================
  // BUTTON
  // ============================================================

  static double get buttonHeight => 48.h;
  static double get buttonSmallHeight => 40.h;
  static double get buttonLargeHeight => 52.h;

  static double get buttonRadius => 8.r;

  static double get buttonHorizontalPadding => 20.w;

  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: buttonHorizontalPadding, vertical: 12.h);

  // ============================================================
  // INPUT
  // ============================================================

  static double get inputHeight => 48.h;
  static double get inputRadius => 8.r;

  static double get inputHorizontalPadding => 16.w;

  static EdgeInsets get inputPadding =>
      EdgeInsets.symmetric(horizontal: inputHorizontalPadding, vertical: 14.h);

  // ============================================================
  // ICON
  // ============================================================

  static double get iconExtraSmall => 14.sp;
  static double get iconSmall => 18.sp;
  static double get iconMedium => 24.sp;
  static double get iconLarge => 32.sp;
  static double get iconExtraLarge => 40.sp;

  // ============================================================
  // AVATAR
  // ============================================================

  static double get avatarSmall => 32.r;
  static double get avatarMedium => 40.r;
  static double get avatarLarge => 48.r;
  static double get avatarExtraLarge => 64.r;

  // ============================================================
  // APP BAR
  // ============================================================

  static double get appBarHeight => 64.h;

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  static double get bottomNavigationHeight => 80.h;

  // ============================================================
  // FAB
  // ============================================================

  static double get fabSmall => 40.r;
  static double get fabMedium => 56.r;
  static double get fabLarge => 64.r;

  // ============================================================
  // ICON BUTTON
  // ============================================================

  static double get iconButtonSize => 48.r;
  static double get iconButtonRadius => 8.r;

  // ============================================================
  // LIST
  // ============================================================

  static double get listItemHeight => 56.h;
  static double get listItemLargeHeight => 72.h;
  static double get listItemSpacing => 12.h;

  // ============================================================
  // IMAGE ASPECT RATIOS
  // ============================================================

  /// 1:1 - Square image
  /// Example: product image, profile image
  static const double aspectRatioSquare = 1.0;

  /// 4:3 - Standard landscape image
  static const double aspectRatioStandard = 4 / 3;

  /// 3:4 - Standard portrait image
  static const double aspectRatioPortrait = 3 / 4;

  /// 16:9 - Wide landscape image
  /// Example: banner, vehicle detail image
  static const double aspectRatioWide = 16 / 9;

  /// 9:16 - Mobile portrait / story image
  static const double aspectRatioVertical = 9 / 16;

  /// 3:2 - Photography / vehicle image
  static const double aspectRatioPhoto = 3 / 2;

  /// 2:3 - Portrait photography
  static const double aspectRatioPhotoPortrait = 2 / 3;

  /// 5:4 - Slightly wide square
  static const double aspectRatioFiveFour = 5 / 4;

  /// 4:5 - Portrait
  static const double aspectRatioFourFive = 4 / 5;

  // ============================================================
  // VEHICLE IMAGES
  // ============================================================

  /// Main vehicle card
  static const double vehicleCardAspectRatio = 16 / 10;

  /// Vehicle detail image
  static const double vehicleDetailAspectRatio = 16 / 9;

  /// Vehicle thumbnail
  static const double vehicleThumbnailAspectRatio = 4 / 3;

  /// Vehicle gallery
  static const double vehicleGalleryAspectRatio = 3 / 2;

  // ============================================================
  // PRODUCT IMAGES
  // ============================================================

  static const double productCardAspectRatio = 1 / 1;
  static const double productDetailAspectRatio = 4 / 3;
  static const double productBannerAspectRatio = 16 / 9;

  // ============================================================
  // IMAGE HEIGHTS
  // ============================================================

  static double get productImageHeight => 180.h;
  static double get vehicleImageHeight => 200.h;
  static double get bannerImageHeight => 180.h;

  // ============================================================
  // DIALOG
  // ============================================================

  static double get dialogRadius => 16.r;
  static double get dialogPadding => 24.w;

  // ============================================================
  // BOTTOM SHEET
  // ============================================================

  static double get bottomSheetRadius => 24.r;
  static double get bottomSheetPadding => 20.w;

  // ============================================================
  // CHIP
  // ============================================================

  static double get chipHeight => 36.h;
  static double get chipRadius => 8.r;
  static double get chipHorizontalPadding => 12.w;

  // ============================================================
  // STATUS DOT
  // ============================================================

  static double get statusDotSmall => 8.r;
  static double get statusDotMedium => 10.r;
  static double get statusDotLarge => 12.r;

  // ============================================================
  // DIVIDER
  // ============================================================

  static double get dividerThickness => 1.h;
}
