/// UI-related constants for the Bukeer application
/// These constants define common UI values used throughout the app
///
/// Usage:
/// ```dart
/// import 'package:bukeer/bukeer/core/constants/ui_constants.dart';
///
/// Container(
///   constraints: BoxConstraints(maxWidth: UIConstants.maxContentWidth),
///   padding: EdgeInsets.all(UIConstants.paddingMedium),
/// )
/// ```

import 'package:flutter/material.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';

class UIConstants {
  // Prevent instantiation
  UIConstants._();

  // Layout breakpoints (responsive design)
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  static const double largeDesktopBreakpoint = 1800.0;

  // Content widths
  static const double maxContentWidth = 1200.0;
  static const double maxFormWidth = 600.0;
  static const double maxModalWidth = 800.0;
  static const double maxDrawerWidth = 300.0;
  static const double minCardWidth = 280.0;
  static const double maxCardWidth = 400.0;

  // Spacing values
  static const double spacingXxs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;
  static const double spacingXxxl = 48.0;

  // Padding values
  static const double paddingXxs = 2.0;
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 12.0;
  static const double paddingLg = 16.0;
  static const double paddingXl = 24.0;
  static const double paddingXxl = 32.0;
  static const double paddingXxxl = 48.0;

  // Common paddings
  static const EdgeInsets screenPadding = EdgeInsets.all(BukeerSpacing.m);
  static const EdgeInsets cardPadding = EdgeInsets.all(BukeerSpacing.m);
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
  static const EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

  // Border radius values
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 32.0;
  static const double radiusCircle = 9999.0;

  // Common border radius
  static const BorderRadius borderRadiusXs =
      BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));

  // Icon sizes
  static const double iconSizeXs = 16.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 40.0;
  static const double iconSizeXxl = 48.0;

  // Button heights
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double buttonHeightXl = 56.0;

  // Text field heights
  static const double inputHeightSm = 36.0;
  static const double inputHeightMd = 44.0;
  static const double inputHeightLg = 52.0;

  // AppBar heights
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;
  static const double bottomNavHeight = 56.0;

  // Drawer widths
  static const double drawerWidthMobile = 280.0;
  static const double drawerWidthTablet = 320.0;
  static const double drawerWidthDesktop = 360.0;

  // Modal sizes
  static const Size modalSizeSm = Size(400, 300);
  static const Size modalSizeMd = Size(600, 400);
  static const Size modalSizeLg = Size(800, 600);
  static const Size modalSizeXl = Size(1000, 800);

  // Grid configurations
  static const int gridColumnsMobile = 1;
  static const int gridColumnsTablet = 2;
  static const int gridColumnsDesktop = 3;
  static const int gridColumnsLargeDesktop = 4;
  static const double gridSpacing = 16.0;
  static const double gridAspectRatio = 1.5;

  // Animation durations (milliseconds)
  static const Duration animationFast = UiConstants.animationDurationFast;
  static const Duration animationNormal = UiConstants.animationDuration;
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 1000);

  // Animation curves
  static const Curve animationCurveDefault = Curves.easeInOut;
  static const Curve animationCurveSharp = Curves.easeOut;
  static const Curve animationCurveSmooth = Curves.fastOutSlowIn;
  static const Curve animationCurveBounce = Curves.bounceOut;

  // Elevation values
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  static const double elevationXxl = 24.0;

  // Opacity values
  static const double opacityDisabled = 0.38;
  static const double opacityLow = 0.54;
  static const double opacityMedium = 0.74;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;

  // Z-index values (for Stack widgets)
  static const double zIndexDefault = 0.0;
  static const double zIndexDropdown = 1000.0;
  static const double zIndexSticky = 1020.0;
  static const double zIndexFixed = 1030.0;
  static const double zIndexModalBackdrop = 1040.0;
  static const double zIndexModal = 1050.0;
  static const double zIndexPopover = 1060.0;
  static const double zIndexTooltip = 1070.0;

  // Shimmer/Loading placeholder dimensions
  static const double shimmerLineHeight = 12.0;
  static const double shimmerTitleHeight = 20.0;
  static const double shimmerButtonHeight = 40.0;
  static const double shimmerCardHeight = 120.0;

  // FAB (Floating Action Button) positions
  static const double fabMargin = 16.0;
  static const double fabMiniSize = 40.0;
  static const double fabNormalSize = 56.0;
  static const double fabExtendedHeight = 48.0;

  // Divider thickness
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 0.0;
  static const double dividerEndIndent = 0.0;

  // BottomSheet configurations
  static const double bottomSheetMinHeight = 200.0;
  static const double bottomSheetMaxHeightRatio = 0.9;
  static const double bottomSheetDragHandleHeight = 4.0;
  static const double bottomSheetDragHandleWidth = 32.0;

  // Tooltip configurations
  static const double tooltipMaxWidth = 200.0;
  static const Duration tooltipShowDuration = Duration(seconds: 2);
  static const Duration tooltipWaitDuration = Duration(milliseconds: 500);

  // Tab configurations
  static const double tabHeight = 46.0;
  static const double tabMinWidth = 72.0;
  static const double tabLabelPadding = 12.0;

  // Badge configurations
  static const double badgeSize = 20.0;
  static const double badgeMiniSize = 16.0;
  static const double badgeLargeSize = 24.0;
  static const EdgeInsets badgePadding =
      EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0);

  // Progress indicators
  static const double progressHeight = 4.0;
  static const double progressHeightLarge = 8.0;
  static const double circularProgressSize = 36.0;
  static const double circularProgressSizeLarge = 48.0;
  static const double circularProgressStrokeWidth = 3.0;

  // Switch/Toggle dimensions
  static const double switchWidth = 48.0;
  static const double switchHeight = 24.0;
  static const double switchThumbSize = 20.0;

  // Checkbox/Radio dimensions
  static const double checkboxSize = 18.0;
  static const double checkboxSizeLarge = 24.0;
  static const double radioSize = 20.0;
  static const double radioSizeLarge = 24.0;

  // Chip dimensions
  static const double chipHeight = 32.0;
  static const double chipHeightSmall = 24.0;
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets chipLabelPadding =
      EdgeInsets.symmetric(horizontal: 8.0);

  // Avatar sizes
  static const double avatarSizeXs = 24.0;
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 40.0;
  static const double avatarSizeLg = 56.0;
  static const double avatarSizeXl = 72.0;
  static const double avatarSizeXxl = 96.0;

  // List tile configurations
  static const double listTileMinHeight = 48.0;
  static const double listTileMinLeadingWidth = 40.0;
  static const double listTileHorizontalTitleGap = 16.0;

  // Snackbar configurations
  static const double snackbarMaxWidth = 600.0;
  static const EdgeInsets snackbarMargin = EdgeInsets.all(BukeerSpacing.m);
  static const Duration snackbarDuration = Duration(seconds: 3);
}
