import 'dart:ui';
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
  static const String _primaryFont =
      'outfitSemiBold'; // Primary font: Outfit SemiBold (FlutterFlow style)
  static const String _secondaryFont = 'Plus Jakarta Sans'; // Secondary font
  static const String _fallbackFont = 'Inter'; // Fallback font

  // ================================
  // FONT SIZES (Stripe-inspired)
  // ================================
  static const double displayLargeSize = 48.0; // Reduced for cleaner look
  static const double displayMediumSize = 36.0;
  static const double displaySmallSize = 32.0;
  static const double headlineLargeSize = 28.0; // Stripe main headings
  static const double headlineMediumSize = 24.0; // Section headings
  static const double headlineSmallSize = 20.0; // Subsection headings
  static const double titleLargeSize = 18.0; // Card titles
  static const double titleMediumSize = 16.0; // Component titles
  static const double titleSmallSize = 14.0; // Small titles
  static const double bodyLargeSize = 16.0; // Main content
  static const double bodyMediumSize = 14.0; // Standard body text
  static const double bodySmallSize = 12.0; // Small text, captions
  static const double labelLargeSize = 14.0; // Button text, labels
  static const double labelMediumSize = 12.0; // Small labels
  static const double labelSmallSize = 11.0; // Tiny labels
  static const double captionSize = 11.0; // Captions

  // ================================
  // HEADING STYLES
  // ================================

  /// Display Large - Used for hero text and main headlines
  static TextStyle get displayLarge => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: displayLargeSize,
        fontWeight: FontWeight.w600, // SemiBold
        height: 1.1,
        letterSpacing: -0.5,
        color: BukeerColors.textPrimary,
      );

  /// Display Medium - Used for important headlines
  static TextStyle get displayMedium => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: displayMediumSize,
        fontWeight: FontWeight.w600, // Semi-bold
        height: 1.15,
        letterSpacing: -0.3,
        color: BukeerColors.textPrimary,
      );

  /// Display Small - Used for section headlines
  static TextStyle get displaySmall => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: displaySmallSize,
        fontWeight: FontWeight.w600, // Semi-bold
        height: 1.2,
        letterSpacing: -0.2,
        color: BukeerColors.textPrimary,
      );

  /// Headline Large - Primary page titles (Stripe-style)
  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: headlineLargeSize,
        fontWeight: FontWeight.w600, // SemiBold
        height: 1.3,
        letterSpacing: -0.2,
        color: BukeerColors.textPrimary,
      );

  /// Headline Medium - Secondary page titles
  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: headlineMediumSize,
        fontWeight: FontWeight.w600, // Semi-bold for secondary
        height: 1.3,
        letterSpacing: -0.1,
        color: BukeerColors.textPrimary,
      );

  /// Headline Small - Section titles
  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: headlineSmallSize,
        fontWeight: FontWeight.w600, // Semi-bold
        height: 1.35,
        color: BukeerColors.textPrimary,
      );

  // ================================
  // TITLE STYLES
  // ================================

  /// Title Large - Card titles, modal headers
  static TextStyle get titleLarge => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: titleLargeSize,
        fontWeight: FontWeight.w600, // Semi-bold
        height: 1.4,
        color: BukeerColors.textPrimary,
      );

  /// Title Medium - Subsection titles
  static TextStyle get titleMedium => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: titleMediumSize,
        fontWeight: FontWeight.w500, // Medium weight
        height: 1.45,
        color: BukeerColors.textPrimary,
      );

  /// Title Small - Small section headers
  static TextStyle get titleSmall => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: titleSmallSize,
        fontWeight: FontWeight.w500, // Medium
        height: 1.5,
        color: BukeerColors.textPrimary,
      );

  // ================================
  // BODY STYLES
  // ================================

  /// Body Large - Main content text
  static TextStyle get bodyLarge => GoogleFonts.getFont(
        _secondaryFont, // Use secondary font for body text
        fontSize: bodyLargeSize,
        fontWeight: FontWeight.w400, // Regular
        height: 1.5,
        color: BukeerColors.textPrimary,
      );

  /// Body Medium - Secondary content text (Stripe standard)
  static TextStyle get bodyMedium => GoogleFonts.getFont(
        _secondaryFont,
        fontSize: bodyMediumSize,
        fontWeight: FontWeight.w400, // Regular
        height: 1.5,
        color: BukeerColors.textPrimary,
      );

  /// Body Small - Supporting text, captions
  static TextStyle get bodySmall => GoogleFonts.getFont(
        _secondaryFont,
        fontSize: bodySmallSize,
        fontWeight: FontWeight.w400, // Regular
        height: 1.4,
        color: BukeerColors.textSecondary,
      );

  // ================================
  // LABEL STYLES
  // ================================

  /// Label Large - Button text, form labels
  static TextStyle get labelLarge => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: BukeerColors.textPrimary,
      );

  /// Label Medium - Small button text
  static TextStyle get labelMedium => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: BukeerColors.textPrimary,
      );

  /// Label Small - Very small labels, badges
  static TextStyle get labelSmall => const TextStyle(
        fontFamily: _primaryFont,
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
        _secondaryFont,
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

  /// Primary button text (Stripe-style)
  static TextStyle get buttonPrimary => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w600, // SemiBold for buttons
        letterSpacing: 0,
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
        _secondaryFont, // Use secondary font for form fields
        fontSize: 15.0, // Slightly smaller for forms
        fontWeight: FontWeight.w400,
        color: BukeerColors.textPrimary,
      );

  /// Form field hint text
  static TextStyle get formFieldHint => formField.copyWith(
        color: BukeerColors.textTertiary,
      );

  /// Form field label
  static TextStyle get formFieldLabel => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: BukeerColors.textSecondary,
      );

  // ================================
  // STRIPE-INSPIRED STYLES
  // ================================

  /// Large metric display (like Stripe's revenue numbers)
  static TextStyle get metricLarge => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 32.0,
        fontWeight: FontWeight.w600, // SemiBold for metrics
        height: 1.2,
        letterSpacing: -0.5,
        color: BukeerColors.textPrimary,
      );

  /// Medium metric display
  static TextStyle get metricMedium => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 24.0,
        fontWeight: FontWeight.w600, // SemiBold
        height: 1.25,
        letterSpacing: -0.3,
        color: BukeerColors.textPrimary,
      );

  /// Small metric display
  static TextStyle get metricSmall => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 18.0,
        fontWeight: FontWeight.w600, // SemiBold
        height: 1.3,
        color: BukeerColors.textPrimary,
      );

  /// Metric label (like "Gross volume", "Yesterday")
  static TextStyle get metricLabel => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: BukeerColors.textSecondary,
      );

  /// Card header text (like "Your overview")
  static TextStyle get cardHeader => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 20.0,
        fontWeight: FontWeight.w600, // SemiBold
        height: 1.4,
        color: BukeerColors.textPrimary,
      );

  /// Sidebar menu item
  static TextStyle get sidebarItem => GoogleFonts.getFont(
        _secondaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: BukeerColors.textSecondary,
      );

  /// Active sidebar menu item
  static TextStyle get sidebarItemActive => sidebarItem.copyWith(
        fontWeight: FontWeight.w600, // SemiBold for active state
        color: BukeerColors.primary,
      );

  /// Data table header
  static TextStyle get tableHeader => const TextStyle(
        fontFamily: _primaryFont,
        fontSize: 12.0,
        fontWeight: FontWeight.w600, // SemiBold for table headers
        height: 1.5,
        letterSpacing: 0.5,
        color: BukeerColors.textSecondary,
        textBaseline: TextBaseline.alphabetic,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Data table cell
  static TextStyle get tableCell => GoogleFonts.getFont(
        _secondaryFont,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: BukeerColors.textPrimary,
      );

  // ================================
  // HELPER METHODS
  // ================================

  /// Create custom text style with Outfit font (Primary)
  static TextStyle outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _primaryFont,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w600, // Default to SemiBold
      color: color ?? BukeerColors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Create custom text style with Plus Jakarta Sans font (Secondary)
  static TextStyle plusJakartaSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.getFont(
      _secondaryFont,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? BukeerColors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Create custom text style with Inter font (Fallback)
  static TextStyle inter({
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
