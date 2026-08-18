import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // ============================================================
  // SPACING
  // ============================================================

  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space28 = 28.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;
  static const double space72 = 72.0;
  static const double space80 = 80.0;

  // ============================================================
  // SCREEN
  // ============================================================

  static const double screenHorizontal = 20.0;
  static const double screenVertical = 16.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenVertical,
  );

  static const EdgeInsets screenHorizontalPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
  );

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  static const double radius4 = 4.0;
  static const double radius6 = 6.0;
  static const double radius8 = 8.0;
  static const double radius10 = 10.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radiusCircular = 999.0;

  // ============================================================
  // CARD
  // ============================================================

  static const double cardRadius = 12.0;
  static const double cardPadding = 16.0;

  static const EdgeInsets cardContentPadding = EdgeInsets.all(cardPadding);

  // ============================================================
  // BUTTON
  // ============================================================

  static const double buttonHeight = 48.0;
  static const double buttonSmallHeight = 40.0;
  static const double buttonLargeHeight = 52.0;

  static const double buttonRadius = 8.0;

  static const double buttonHorizontalPadding = 20.0;

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: buttonHorizontalPadding,
    vertical: 12.0,
  );

  // ============================================================
  // INPUT
  // ============================================================

  static const double inputHeight = 48.0;
  static const double inputRadius = 8.0;
  static const double inputHorizontalPadding = 16.0;

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: inputHorizontalPadding,
    vertical: 14.0,
  );

  // ============================================================
  // ICON
  // ============================================================

  static const double iconExtraSmall = 14.0;
  static const double iconSmall = 18.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 40.0;

  // ============================================================
  // AVATAR
  // ============================================================

  static const double avatarSmall = 32.0;
  static const double avatarMedium = 40.0;
  static const double avatarLarge = 48.0;
  static const double avatarExtraLarge = 64.0;

  // ============================================================
  // APP BAR
  // ============================================================

  static const double appBarHeight = 64.0;

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  static const double bottomNavigationHeight = 80.0;

  // ============================================================
  // FAB
  // ============================================================

  static const double fabSmall = 40.0;
  static const double fabMedium = 56.0;
  static const double fabLarge = 64.0;

  // ============================================================
  // ICON BUTTON
  // ============================================================

  static const double iconButtonSize = 48.0;
  static const double iconButtonRadius = 8.0;

  // ============================================================
  // LIST
  // ============================================================

  static const double listItemHeight = 56.0;
  static const double listItemLargeHeight = 72.0;
  static const double listItemSpacing = 12.0;

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

  static const double productImageHeight = 180.0;

  static const double vehicleImageHeight = 200.0;

  static const double bannerImageHeight = 180.0;

  // ============================================================
  // DIALOG
  // ============================================================

  static const double dialogRadius = 16.0;
  static const double dialogPadding = 24.0;

  // ============================================================
  // BOTTOM SHEET
  // ============================================================

  static const double bottomSheetRadius = 24.0;
  static const double bottomSheetPadding = 20.0;

  // ============================================================
  // CHIP
  // ============================================================

  static const double chipHeight = 36.0;
  static const double chipRadius = 8.0;
  static const double chipHorizontalPadding = 12.0;

  // ============================================================
  // STATUS DOT
  // ============================================================

  static const double statusDotSmall = 8.0;
  static const double statusDotMedium = 10.0;
  static const double statusDotLarge = 12.0;

  // ============================================================
  // DIVIDER
  // ============================================================

  static const double dividerThickness = 1.0;
}
