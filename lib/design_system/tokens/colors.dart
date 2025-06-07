import 'package:flutter/material.dart';

/// Design tokens for colors in the Bukeer application
/// Replaces hardcoded color values throughout the app
class BukeerColors {
  BukeerColors._();

  // ================================
  // PRIMARY COLORS
  // ================================
  static const Color primary = Color(0xFF4B39EF);
  static const Color primaryAccent = Color(0xFF6F61EF);
  static const Color primaryLight = Color(0xFF9A8FF0);
  static const Color primaryDark = Color(0xFF3730C1);

  // ================================
  // SECONDARY COLORS
  // ================================
  static const Color secondary = Color(0xFF39D2C0);
  static const Color secondaryAccent = Color(0xFF4DDAC6);
  static const Color secondaryLight = Color(0xFF9AE6DC);
  static const Color secondaryDark = Color(0xFF26A69A);

  // ================================
  // NEUTRAL COLORS
  // ================================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color neutral100 = Color(0xFFFFFFFF);
  static const Color neutral200 = Color(0xFFF5F5F5);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // ================================
  // SEMANTIC COLORS
  // ================================
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF047857);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // ================================
  // BACKGROUND COLORS
  // ================================
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF8FAFC);
  static const Color backgroundTertiary = Color(0xFFF1F5F9);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundDarkSecondary = Color(0xFF1E293B);

  // FlutterFlow compatibility aliases
  static const Color primaryBackground = backgroundPrimary;
  static const Color secondaryBackground = backgroundSecondary;
  static const Color primaryColor = primary;
  static const Color surfacePrimary = backgroundPrimary;
  static const Color surfaceSecondary = backgroundSecondary;
  static const Color neutralLight = neutral300;
  static const Color neutralMedium = neutral500;
  static const Color neutralDark = neutral700;

  // ================================
  // TEXT COLORS
  // ================================
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // FlutterFlow compatibility aliases
  static const Color primaryText = textPrimary;
  static const Color secondaryText = textSecondary;

  // ================================
  // BORDER COLORS
  // ================================
  static const Color borderPrimary = Color(0xFFE2E8F0);
  static const Color borderSecondary = Color(0xFFCBD5E1);
  static const Color borderFocus = Color(0xFF4B39EF);
  static const Color borderError = Color(0xFFEF4444);

  // ================================
  // OVERLAY COLORS
  // ================================
  static const Color overlay = Color(0x66000000);
  static const Color overlayLight = Color(0x33000000);
  static const Color overlayDark = Color(0x80000000);

  // ================================
  // BRAND SPECIFIC COLORS
  // ================================
  static const Color bukeerBlue = Color(0xFF2563EB);
  static const Color bukeerOrange = Color(0xFFF97316);
  static const Color bukeerGreen = Color(0xFF16A34A);

  // ================================
  // COMMONLY USED HARDCODED COLORS
  // (To replace existing hardcoded values)
  // ================================
  static const Color shadow34 = Color(0x34000000); // Replaces Color(0x34000000)
  static const Color shadow33 = Color(0x33000000); // Replaces Color(0x33000000)
  static const Color shadow4D = Color(0x4D000000); // Replaces Color(0x4D000000)

  // ================================
  // HELPER METHODS
  // ================================

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get appropriate text color for a background
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textInverse;
  }

  /// Get status color by type
  static Color getStatusColor(StatusType type) {
    switch (type) {
      case StatusType.success:
        return success;
      case StatusType.warning:
        return warning;
      case StatusType.error:
        return error;
      case StatusType.info:
        return info;
    }
  }
}

/// Status types for semantic colors
enum StatusType {
  success,
  warning,
  error,
  info,
}

/// Extension for easier color access in widgets
extension BukeerColorsExtension on BuildContext {
  BukeerColors get colors => BukeerColors._();
}
