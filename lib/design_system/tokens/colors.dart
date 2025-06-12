import 'package:flutter/material.dart';

/// Design tokens for colors in the Bukeer application
/// Replaces hardcoded color values throughout the app
class BukeerColors {
  BukeerColors._();

  // ================================
  // PRIMARY COLORS
  // ================================
  static const Color primary = Color(0xFF7c57b3); // Bukeer primary purple
  static const Color primaryAccent = Color(0xFF9A7DC7);
  static const Color primaryLight = Color(0xFFB8A3DB);
  static const Color primaryDark = Color(0xFF5E3F8F);

  // ================================
  // SECONDARY COLORS
  // ================================
  static const Color secondary =
      Color(0xFF102877); // Bukeer secondary blue (light mode)
  static const Color secondaryAccent = Color(0xFF1A3A99);
  static const Color secondaryLight = Color(0xFF102877); // Light mode
  static const Color secondaryDark = Color(0xFF68e0f8); // Dark mode cyan

  // ================================
  // FLUTTERFLOW ADDITIONAL COLORS
  // ================================
  static const Color tertiary = Color(0xFF4098f8); // Bukeer tertiary blue
  static const Color tertiaryDark = Color(0xFF4098f8);
  static const Color alternate =
      Color(0xFFb7bac3); // Light gray for borders (light mode)
  static const Color alternateDark = Color(0xFF313442); // Dark mode borders
  static const Color accent1 = Color(0x4D9489F5);
  static const Color accent2 = Color(0x4C39D2C0);
  static const Color accent3 = Color(0x4CEE8B60);
  static const Color accent4 = Color(0x9AFFFFFF);
  static const Color accent4Dark = Color(0xFF2A2F3C);
  static const Color overlayFF = Color(0x9A1D2428); // FlutterFlow overlay
  static const Color overlay0 = Color(0x00FFFFFF);
  static const Color overlay0Dark = Color(0x000B191E);
  static const Color background = Color(0xFF1A1D24); // FlutterFlow background

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
  static const Color success = Color(0xFF04A24C);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF047857);

  static const Color warning = Color(0xFFF9CF58);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFFF5963);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color info = Color(0xFF7c57b3);
  static const Color infoLight = Color(0xFF9A7DC7);
  static const Color infoDark = Color(0xFF5E3F8F);

  // ================================
  // BACKGROUND COLORS
  // ================================
  static const Color backgroundPrimary =
      Color(0xFFF1F4F8); // Light mode primary background
  static const Color backgroundSecondary =
      Color(0xFFFFFFFF); // Light mode cards
  static const Color backgroundTertiary = Color(0xFFF8FAFC);
  static const Color backgroundDark =
      Color(0xFF1A1F24); // Dark mode primary background
  static const Color backgroundDarkSecondary =
      Color(0xFF2B2F33); // Dark mode cards
  static const Color backgroundDarkTertiary = Color(0xFF2A2F3C);

  // Form field specific colors for dark mode
  static const Color formFieldBackgroundLight = Color(0xFFF8FAFC);
  static const Color formFieldBackgroundDark = Color(0xFF2A2F3C);

  // FlutterFlow compatibility aliases
  static const Color primaryBackground = backgroundPrimary;
  static const Color secondaryBackground = backgroundSecondary;
  static const Color primaryColor = primary;
  static const Color surfacePrimary = backgroundPrimary;
  static const Color surfaceSecondary = backgroundSecondary;
  static const Color surfacePrimaryDark = backgroundDark;
  static const Color surfaceSecondaryDark = backgroundDarkSecondary;
  static const Color neutralLight = neutral300;
  static const Color neutralMedium = neutral500;
  static const Color neutralDark = neutral700;

  // ================================
  // TEXT COLORS
  // ================================
  static const Color textPrimary = Color(0xFF14181B); // Light mode primary text
  static const Color textSecondary =
      Color(0xFF57636C); // Light mode secondary text
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // Dark mode text colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB4BDC4);
  static const Color textTertiaryDark = Color(0xFF8B95A1);

  // FlutterFlow compatibility aliases
  static const Color primaryText = textPrimary;
  static const Color secondaryText = textSecondary;

  // ================================
  // BORDER COLORS
  // ================================
  static const Color borderPrimary = Color(0xFFE2E8F0);
  static const Color borderSecondary = Color(0xFFCBD5E1);
  static const Color borderFocus =
      Color(0xFF7C57B3); // Updated to match primary
  static const Color borderError = Color(0xFFEF4444);

  // Dark mode border colors (FlutterFlow compatible)
  static const Color borderPrimaryDark = Color(0xFF313442);
  static const Color borderSecondaryDark = Color(0xFF475569);

  // Divider colors
  static const Color divider = borderPrimary;
  static const Color dividerDark = borderPrimaryDark;

  // Additional border aliases
  static const Color border = borderPrimary;
  static const Color borderDark = borderPrimaryDark;
  static const Color borderLight = Color(0xFFE2E8F0);

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
  static const Color shadowColor = Color(0x1A000000); // Default shadow color

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

  /// Get appropriate form field background color based on theme
  static Color getFormFieldBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? formFieldBackgroundDark
        : formFieldBackgroundLight;
  }

  /// Get appropriate background color based on theme
  static Color getBackground(BuildContext context, {bool secondary = false}) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return secondary ? backgroundDarkSecondary : backgroundDark;
    }
    return secondary ? backgroundSecondary : backgroundPrimary;
  }

  /// Get appropriate text color based on theme
  static Color getTextColor(BuildContext context,
      {TextColorType type = TextColorType.primary}) {
    if (Theme.of(context).brightness == Brightness.dark) {
      switch (type) {
        case TextColorType.primary:
          return textPrimaryDark;
        case TextColorType.secondary:
          return textSecondaryDark;
        case TextColorType.tertiary:
          return textTertiaryDark;
      }
    }
    switch (type) {
      case TextColorType.primary:
        return textPrimary;
      case TextColorType.secondary:
        return textSecondary;
      case TextColorType.tertiary:
        return textTertiary;
    }
  }

  /// Get appropriate border color based on theme
  static Color getBorderColor(BuildContext context, {bool secondary = false}) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return secondary ? borderSecondaryDark : borderPrimaryDark;
    }
    return secondary ? borderSecondary : borderPrimary;
  }
}

/// Status types for semantic colors
enum StatusType {
  success,
  warning,
  error,
  info,
}

/// Text color types for dynamic text color selection
enum TextColorType {
  primary,
  secondary,
  tertiary,
}

/// Extension for easier color access in widgets
extension BukeerColorsExtension on BuildContext {
  BukeerColors get colors => BukeerColors._();
}
