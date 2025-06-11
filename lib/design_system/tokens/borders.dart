import 'package:flutter/material.dart';
import 'colors.dart';

/// Design tokens for borders in the Bukeer application
/// Provides consistent border styles throughout the app
class BukeerBorders {
  BukeerBorders._();

  // ================================
  // BORDER WIDTH VALUES
  // ================================
  static const double widthThin = 1.0; // border-thin
  static const double widthMedium = 2.0; // border-medium
  static const double widthThick = 3.0; // border-thick

  // Legacy aliases
  static const double thin = widthThin;
  static const double medium = widthMedium;
  static const double thick = widthThick;

  // ================================
  // BORDER RADIUS VALUES
  // ================================
  static BorderRadius radiusNone = BorderRadius.zero;
  static BorderRadius radiusSmall = BorderRadius.circular(4.0);
  static BorderRadius radiusMedium = BorderRadius.circular(8.0);
  static BorderRadius radiusLarge = BorderRadius.circular(12.0);
  static BorderRadius radiusExtraLarge = BorderRadius.circular(16.0);
  static BorderRadius radiusFull = BorderRadius.circular(9999.0);

  // ================================
  // BORDER STYLES
  // ================================

  /// Default border - thin with alternate color
  static Border get defaultBorder => Border.all(
        width: thin,
        color: BukeerColors.alternate,
      );

  /// Primary border - medium with primary color
  static Border get primaryBorder => Border.all(
        width: medium,
        color: BukeerColors.primary,
      );

  /// Error border - thin with error color
  static Border get errorBorder => Border.all(
        width: thin,
        color: BukeerColors.error,
      );

  /// Focus border - medium with primary color
  static Border get focusBorder => Border.all(
        width: medium,
        color: BukeerColors.primary,
      );

  // ================================
  // BORDER SIDE STYLES
  // ================================

  /// Default border side
  static const BorderSide defaultSide = BorderSide(
    width: thin,
    color: BukeerColors.alternate,
  );

  /// Primary border side
  static const BorderSide primarySide = BorderSide(
    width: medium,
    color: BukeerColors.primary,
  );

  /// Bottom border only (for tabs, etc.)
  static const BorderSide bottomSide = BorderSide(
    width: thin,
    color: BukeerColors.alternate,
  );

  // ================================
  // HELPER METHODS
  // ================================

  /// Create custom border
  static Border custom({
    double width = thin,
    required Color color,
  }) {
    return Border.all(
      width: width,
      color: color,
    );
  }

  /// Create border with only specific sides
  static Border only({
    BorderSide? top,
    BorderSide? right,
    BorderSide? bottom,
    BorderSide? left,
  }) {
    return Border(
      top: top ?? BorderSide.none,
      right: right ?? BorderSide.none,
      bottom: bottom ?? BorderSide.none,
      left: left ?? BorderSide.none,
    );
  }

  /// Get appropriate border color based on theme
  static Color getBorderColor(BuildContext context, {bool isPrimary = false}) {
    if (isPrimary) {
      return BukeerColors.primary;
    }
    return Theme.of(context).brightness == Brightness.dark
        ? BukeerColors.alternateDark
        : BukeerColors.alternate;
  }
}

/// Extension for easier border access in widgets
extension BukeerBordersExtension on BuildContext {
  BukeerBorders get borders => BukeerBorders._();
}
