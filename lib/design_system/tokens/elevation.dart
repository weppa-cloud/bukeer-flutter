import 'package:flutter/material.dart';
import 'colors.dart';

/// Design tokens for elevation, shadows, and border radius in the Bukeer application
/// Provides consistent shadow and elevation patterns throughout the app
class BukeerElevation {
  BukeerElevation._();

  // ================================
  // ELEVATION LEVELS
  // ================================
  static const double level0 = 0.0; // No elevation
  static const double level1 = 1.0; // Subtle elevation
  static const double level2 = 3.0; // Card elevation
  static const double level3 = 6.0; // Raised elements
  static const double level4 = 8.0; // Modal/Dialog elevation
  static const double level5 = 12.0; // Navigation elevation
  static const double level6 = 16.0; // FAB elevation
  static const double level7 = 24.0; // Tooltip elevation

  // ================================
  // SHADOW DEFINITIONS
  // ================================

  /// No shadow
  static const List<BoxShadow> shadowNone = [];

  /// Level 1 shadow - Subtle shadow for slightly raised elements
  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity - from itinerary design
      offset: Offset(0, 2),
      blurRadius: 6.0,
      spreadRadius: 0,
    ),
  ];

  /// Level 2 shadow - Cards and containers
  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color(0x25000000), // 15% opacity - from itinerary design
      offset: Offset(0, 4),
      blurRadius: 8.0,
      spreadRadius: 0,
    ),
  ];

  /// Level 3 shadow - Raised buttons, dropdowns
  static const List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Color(0x30000000), // 19% opacity - from itinerary design
      offset: Offset(0, 6),
      blurRadius: 12.0,
      spreadRadius: 0,
    ),
  ];

  /// Level 4 shadow - Modals and dialogs
  static const List<BoxShadow> shadow4 = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      offset: Offset(0, 6),
      blurRadius: 10.0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity
      offset: Offset(0, 2),
      blurRadius: 4.0,
      spreadRadius: 0,
    ),
  ];

  /// Level 5 shadow - Navigation and floating elements
  static const List<BoxShadow> shadow5 = [
    BoxShadow(
      color: Color(0x19000000), // 10% opacity
      offset: Offset(0, 12),
      blurRadius: 17.0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x24000000), // 14% opacity
      offset: Offset(0, 5),
      blurRadius: 22.0,
      spreadRadius: 0,
    ),
  ];

  /// Level 6 shadow - FAB and prominent floating elements
  static const List<BoxShadow> shadow6 = [
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity
      offset: Offset(0, 16),
      blurRadius: 24.0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x29000000), // 16% opacity
      offset: Offset(0, 6),
      blurRadius: 30.0,
      spreadRadius: 0,
    ),
  ];

  // ================================
  // COLORED SHADOWS
  // ================================

  /// Primary colored shadow
  static List<BoxShadow> get shadowPrimary => [
        BoxShadow(
          color: BukeerColors.primary.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12.0,
          spreadRadius: 0,
        ),
      ];

  /// Success colored shadow
  static List<BoxShadow> get shadowSuccess => [
        BoxShadow(
          color: BukeerColors.success.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12.0,
          spreadRadius: 0,
        ),
      ];

  /// Error colored shadow
  static List<BoxShadow> get shadowError => [
        BoxShadow(
          color: BukeerColors.error.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12.0,
          spreadRadius: 0,
        ),
      ];

  // ================================
  // HELPER METHODS
  // ================================

  /// Get shadow by elevation level
  static List<BoxShadow> getShadow(ElevationLevel level) {
    switch (level) {
      case ElevationLevel.none:
        return shadowNone;
      case ElevationLevel.level1:
        return shadow1;
      case ElevationLevel.level2:
        return shadow2;
      case ElevationLevel.level3:
        return shadow3;
      case ElevationLevel.level4:
        return shadow4;
      case ElevationLevel.level5:
        return shadow5;
      case ElevationLevel.level6:
        return shadow6;
    }
  }

  /// Get elevation value by level
  static double getElevation(ElevationLevel level) {
    switch (level) {
      case ElevationLevel.none:
        return level0;
      case ElevationLevel.level1:
        return level1;
      case ElevationLevel.level2:
        return level2;
      case ElevationLevel.level3:
        return level3;
      case ElevationLevel.level4:
        return level4;
      case ElevationLevel.level5:
        return level5;
      case ElevationLevel.level6:
        return level6;
    }
  }
}

/// Border radius design tokens
class BukeerBorderRadius {
  BukeerBorderRadius._();

  // ================================
  // BORDER RADIUS VALUES
  // ================================
  static const double none = 0.0;
  static const double xs = 4.0; // radius-xs - from itinerary design
  static const double sm = 6.0; // radius-sm - from itinerary design
  static const double md = 8.0; // radius-md - from itinerary design
  static const double lg = 12.0; // radius-lg - from itinerary design
  static const double xl = 16.0; // radius-xl - from itinerary design
  static const double xxl = 20.0; // radius-2xl - from itinerary design
  static const double full = 9999.0; // radius-full - for circular elements

  // ================================
  // COMMON BORDER RADIUS PATTERNS
  // ================================

  /// No border radius
  static const BorderRadius noneRadius = BorderRadius.zero;

  /// Small border radius (6.0) - Buttons, chips
  static const BorderRadius smallRadius = BorderRadius.all(Radius.circular(sm));

  /// Medium border radius (8.0) - Cards, containers
  static const BorderRadius mediumRadius =
      BorderRadius.all(Radius.circular(md));

  /// Large border radius (12.0) - Modals, prominent containers
  static const BorderRadius largeRadius = BorderRadius.all(Radius.circular(lg));

  /// Extra large border radius (16.0) - Special containers
  static const BorderRadius extraLargeRadius =
      BorderRadius.all(Radius.circular(xl));

  /// Circular border radius - Avatar, FAB
  static const BorderRadius circularRadius =
      BorderRadius.all(Radius.circular(full));

  // ================================
  // TOP-ONLY BORDER RADIUS
  // ================================

  /// Top-only medium radius - Modal headers
  static const BorderRadius topMediumRadius = BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );

  /// Top-only large radius - Sheet headers
  static const BorderRadius topLargeRadius = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  // ================================
  // HELPER METHODS
  // ================================

  /// Get border radius by size
  static BorderRadius getRadius(BorderRadiusSize size) {
    switch (size) {
      case BorderRadiusSize.none:
        return noneRadius;
      case BorderRadiusSize.small:
        return smallRadius;
      case BorderRadiusSize.medium:
        return mediumRadius;
      case BorderRadiusSize.large:
        return largeRadius;
      case BorderRadiusSize.extraLarge:
        return extraLargeRadius;
      case BorderRadiusSize.circular:
        return circularRadius;
    }
  }

  /// Create custom border radius
  static BorderRadius custom(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  /// Create asymmetric border radius
  static BorderRadius asymmetric({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }
}

/// Elevation level enumeration
enum ElevationLevel {
  none, // 0dp
  level1, // 1dp
  level2, // 3dp
  level3, // 6dp
  level4, // 8dp
  level5, // 12dp
  level6, // 16dp
}

/// Border radius size enumeration
enum BorderRadiusSize {
  none, // 0
  small, // 6dp
  medium, // 8dp
  large, // 12dp
  extraLarge, // 16dp
  circular, // 9999dp
}

/// Extension for easier elevation access in widgets
extension BukeerElevationExtension on BuildContext {
  BukeerElevation get elevation => BukeerElevation._();
  BukeerBorderRadius get borderRadius => BukeerBorderRadius._();
}
