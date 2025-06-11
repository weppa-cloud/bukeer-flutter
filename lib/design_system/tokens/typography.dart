import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Design tokens for typography in the Bukeer application
/// Provides consistent text styles across the entire app
class BukeerTypography {
  BukeerTypography._();

  // ================================
  // FONT FAMILIES
  // ================================
  static const String _primaryFont = 'Outfit';
  static const String _fallbackFont = 'Readex Pro';

  // ================================
  // FONT SIZES (for compatibility)
  // ================================
  static const double displayLargeSize = 57.0;
  static const double displayMediumSize = 45.0;
  static const double displaySmallSize = 36.0;
  static const double headlineLargeSize = 32.0;
  static const double headlineMediumSize =
      24.0; // Updated from itinerary design
  static const double headlineSmallSize = 20.0; // Updated from itinerary design
  static const double titleLargeSize = 22.0;
  static const double titleMediumSize = 18.0; // Updated from itinerary design
  static const double titleSmallSize = 16.0; // Updated from itinerary design
  static const double bodyLargeSize = 16.0;
  static const double bodyMediumSize = 14.0;
  static const double bodySmallSize = 13.0; // Updated from itinerary design
  static const double labelLargeSize = 14.0;
  static const double labelMediumSize = 12.0;
  static const double labelSmallSize = 11.0;
  static const double captionSize = 11.0;

  // ================================
  // HEADING STYLES
  // ================================

  /// Display Large - Used for hero text and main headlines
  static TextStyle get displayLarge => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 57.0,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.25,
        color: BukeerColors.textPrimary,
      );

  /// Display Medium - Used for important headlines
  static TextStyle get displayMedium => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 45.0,
        fontWeight: FontWeight.w400,
        height: 1.16,
        color: BukeerColors.textPrimary,
      );

  /// Display Small - Used for section headlines
  static TextStyle get displaySmall => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 36.0,
        fontWeight: FontWeight.w400,
        height: 1.22,
        color: BukeerColors.textPrimary,
      );

  /// Headline Large - Primary page titles
  static TextStyle get headlineLarge => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 32.0,
        fontWeight: FontWeight.w700, // Bold - Updated from itinerary design
        height: 1.25,
        color: BukeerColors.textPrimary,
      );

  /// Headline Medium - Secondary page titles
  static TextStyle get headlineMedium => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 24.0, // Updated from itinerary design
        fontWeight: FontWeight.w700, // Bold - Updated from itinerary design
        height: 1.29,
        color: BukeerColors.textPrimary,
      );

  /// Headline Small - Section titles
  static TextStyle get headlineSmall => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 20.0, // Updated from itinerary design
        fontWeight: FontWeight.w700, // Bold - Updated from itinerary design
        height: 1.33,
        color: BukeerColors.textPrimary,
      );

  // ================================
  // TITLE STYLES
  // ================================

  /// Title Large - Card titles, modal headers
  static TextStyle get titleLarge => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 22.0,
        fontWeight: FontWeight.w600, // SemiBold - Updated from itinerary design
        height: 1.27,
        color: BukeerColors.textPrimary,
      );

  /// Title Medium - Subsection titles
  static TextStyle get titleMedium => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 18.0, // Updated from itinerary design
        fontWeight: FontWeight.w600, // SemiBold - Updated from itinerary design
        height: 1.50,
        letterSpacing: 0.15,
        color: BukeerColors.textPrimary,
      );

  /// Title Small - Small section headers
  static TextStyle get titleSmall => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 16.0, // Updated from itinerary design
        fontWeight: FontWeight.w500, // Medium
        height: 1.43,
        letterSpacing: 0.1,
        color: BukeerColors.textPrimary,
      );

  // ================================
  // BODY STYLES
  // ================================

  /// Body Large - Main content text
  static TextStyle get bodyLarge => GoogleFonts.getFont(
        _fallbackFont,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 1.50,
        letterSpacing: 0.5,
        color: BukeerColors.textPrimary,
      );

  /// Body Medium - Secondary content text
  static TextStyle get bodyMedium => GoogleFonts.getFont(
        _fallbackFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: BukeerColors.textPrimary,
      );

  /// Body Small - Supporting text, captions
  static TextStyle get bodySmall => GoogleFonts.getFont(
        _fallbackFont,
        fontSize: 13.0, // Updated from itinerary design
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: BukeerColors.textSecondary,
      );

  // ================================
  // LABEL STYLES
  // ================================

  /// Label Large - Button text, form labels
  static TextStyle get labelLarge => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: BukeerColors.textPrimary,
      );

  /// Label Medium - Small button text
  static TextStyle get labelMedium => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: BukeerColors.textPrimary,
      );

  /// Label Small - Very small labels, badges
  static TextStyle get labelSmall => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
        color: BukeerColors.textSecondary,
      );

  // ================================
  // RESPONSIVE TYPOGRAPHY
  // ================================

  /// Get responsive heading style based on screen size
  static TextStyle getResponsiveHeading(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 479) {
      // Mobile
      return headlineSmall;
    } else if (screenWidth < 991) {
      // Tablet
      return headlineMedium;
    } else {
      // Desktop
      return headlineLarge;
    }
  }

  /// Get responsive body style based on screen size
  static TextStyle getResponsiveBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 479) {
      // Mobile
      return bodyMedium;
    } else {
      // Tablet and Desktop
      return bodyLarge;
    }
  }

  // ================================
  // SEMANTIC STYLES
  // ================================

  /// Error text style
  static TextStyle get error => bodyMedium.copyWith(
        color: BukeerColors.error,
        fontWeight: FontWeight.w500,
      );

  /// Success text style
  static TextStyle get success => bodyMedium.copyWith(
        color: BukeerColors.success,
        fontWeight: FontWeight.w500,
      );

  /// Warning text style
  static TextStyle get warning => bodyMedium.copyWith(
        color: BukeerColors.warning,
        fontWeight: FontWeight.w500,
      );

  /// Info text style
  static TextStyle get info => bodyMedium.copyWith(
        color: BukeerColors.info,
        fontWeight: FontWeight.w500,
      );

  /// Link text style
  static TextStyle get link => bodyMedium.copyWith(
        color: BukeerColors.primary,
        decoration: TextDecoration.underline,
      );

  /// Disabled text style
  static TextStyle get disabled => bodyMedium.copyWith(
        color: BukeerColors.textDisabled,
      );

  // ================================
  // NAVIGATION STYLES
  // ================================

  /// Navigation item text
  static TextStyle get navItem => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: BukeerColors.textSecondary,
      );

  /// Active navigation item text
  static TextStyle get navItemActive => navItem.copyWith(
        color: BukeerColors.primary,
        fontWeight: FontWeight.w600,
      );

  // ================================
  // BUTTON STYLES
  // ================================

  /// Primary button text
  static TextStyle get buttonPrimary => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: BukeerColors.textInverse,
      );

  /// Secondary button text
  static TextStyle get buttonSecondary => buttonPrimary.copyWith(
        color: BukeerColors.primary,
      );

  /// Text button style
  static TextStyle get buttonText => buttonPrimary.copyWith(
        color: BukeerColors.primary,
        fontWeight: FontWeight.w500,
      );

  // ================================
  // FORM STYLES
  // ================================

  /// Form field text
  static TextStyle get formField => GoogleFonts.getFont(
        _fallbackFont,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: BukeerColors.textPrimary,
      );

  /// Form field hint text
  static TextStyle get formFieldHint => formField.copyWith(
        color: BukeerColors.textTertiary,
      );

  /// Form field label
  static TextStyle get formFieldLabel => GoogleFonts.getFont(
        _primaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: BukeerColors.textSecondary,
      );

  // ================================
  // HELPER METHODS
  // ================================

  /// Create custom text style with Outfit font
  static TextStyle outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.getFont(
      _primaryFont,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? BukeerColors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Create custom text style with Readex Pro font
  static TextStyle readexPro({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.getFont(
      _fallbackFont,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? BukeerColors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Get text style by category
  static TextStyle getTextStyle(TextStyleType type) {
    switch (type) {
      case TextStyleType.displayLarge:
        return displayLarge;
      case TextStyleType.displayMedium:
        return displayMedium;
      case TextStyleType.displaySmall:
        return displaySmall;
      case TextStyleType.headlineLarge:
        return headlineLarge;
      case TextStyleType.headlineMedium:
        return headlineMedium;
      case TextStyleType.headlineSmall:
        return headlineSmall;
      case TextStyleType.titleLarge:
        return titleLarge;
      case TextStyleType.titleMedium:
        return titleMedium;
      case TextStyleType.titleSmall:
        return titleSmall;
      case TextStyleType.bodyLarge:
        return bodyLarge;
      case TextStyleType.bodyMedium:
        return bodyMedium;
      case TextStyleType.bodySmall:
        return bodySmall;
      case TextStyleType.labelLarge:
        return labelLarge;
      case TextStyleType.labelMedium:
        return labelMedium;
      case TextStyleType.labelSmall:
        return labelSmall;
    }
  }
}

/// Text style type enumeration
enum TextStyleType {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

/// Extension for easier typography access in widgets
extension BukeerTypographyExtension on BuildContext {
  BukeerTypography get typography => BukeerTypography._();
}
