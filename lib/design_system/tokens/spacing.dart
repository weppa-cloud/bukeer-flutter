import 'package:flutter/material.dart';

/// Design tokens for spacing in the Bukeer application
/// Replaces hardcoded EdgeInsetsDirectional.fromSTEB values throughout the app
class BukeerSpacing {
  BukeerSpacing._();

  // ================================
  // BASE SPACING VALUES (4px System)
  // ================================
  static const double xxs = 2.0; // spacing-xxs
  static const double xs = 4.0; // spacing-xs
  static const double s = 8.0; // spacing-sm
  static const double sm = 12.0; // spacing-md
  static const double m = 16.0; // spacing-lg
  static const double md = 16.0; // spacing-lg (alias)
  static const double ml = 20.0; // spacing-xl
  static const double l = 24.0; // spacing-2xl
  static const double lg = 24.0; // spacing-2xl (alias)
  static const double xl = 32.0; // spacing-3xl
  static const double xxl = 48.0; // spacing-4xl
  static const double xxxl = 64.0; // spacing-5xl

  // ================================
  // COMPONENT SPACING
  // ================================
  static const double cardPadding = m; // 16px
  static const double containerPadding = ml; // 20px - from itinerary design
  static const double sectionPadding = l; // 24px - from itinerary design
  static const double pagePadding = xl; // 32px - from itinerary design
  static const double modalPadding = l; // 24px
  static const double screenPadding = m; // 16px
  static const double sectionSpacing = xl; // 32px
  static const double itemSpacing = s; // 8px
  static const double buttonPaddingHorizontal =
      m; // 16px - from itinerary design
  static const double buttonPaddingVertical = s; // 8px - from itinerary design
  static const double chipPaddingHorizontal =
      10.0; // 10px - from itinerary design
  static const double chipPaddingVertical = xs; // 4px - from itinerary design

  // ================================
  // COMMONLY USED PADDING COMBINATIONS
  // (Replacing EdgeInsetsDirectional.fromSTEB patterns)
  // ================================

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)
  static const EdgeInsetsDirectional zero = EdgeInsetsDirectional.zero;

  /// Replaces EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16)
  static const EdgeInsetsDirectional all16 = EdgeInsetsDirectional.all(md);

  /// Replaces EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24)
  static const EdgeInsetsDirectional all24 = EdgeInsetsDirectional.all(lg);

  /// Replaces EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)
  static const EdgeInsetsDirectional all8 = EdgeInsetsDirectional.all(s);

  /// Replaces EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12)
  static const EdgeInsetsDirectional all12 = EdgeInsetsDirectional.all(sm);

  // ================================
  // HORIZONTAL PADDING
  // ================================

  /// Replaces EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0)
  static const EdgeInsetsDirectional horizontal16 = EdgeInsetsDirectional.only(
    start: md,
    end: md,
  );

  /// Replaces EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)
  static const EdgeInsetsDirectional horizontal24 = EdgeInsetsDirectional.only(
    start: lg,
    end: lg,
  );

  /// Replaces EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0)
  static const EdgeInsetsDirectional horizontal32 = EdgeInsetsDirectional.only(
    start: xl,
    end: xl,
  );

  // ================================
  // VERTICAL PADDING
  // ================================

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16)
  static const EdgeInsetsDirectional vertical16 = EdgeInsetsDirectional.only(
    top: md,
    bottom: md,
  );

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24)
  static const EdgeInsetsDirectional vertical24 = EdgeInsetsDirectional.only(
    top: lg,
    bottom: lg,
  );

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8)
  static const EdgeInsetsDirectional vertical8 = EdgeInsetsDirectional.only(
    top: s,
    bottom: s,
  );

  // ================================
  // SPECIFIC PATTERNS FOUND IN CODEBASE
  // ================================

  /// Replaces EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0)
  static const EdgeInsetsDirectional startOnly16 =
      EdgeInsetsDirectional.only(start: md);

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0)
  static const EdgeInsetsDirectional topOnly16 =
      EdgeInsetsDirectional.only(top: md);

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0)
  static const EdgeInsetsDirectional endOnly16 =
      EdgeInsetsDirectional.only(end: md);

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16)
  static const EdgeInsetsDirectional bottomOnly16 =
      EdgeInsetsDirectional.only(bottom: md);

  /// Replaces EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0)
  static const EdgeInsetsDirectional startOnly24 =
      EdgeInsetsDirectional.only(start: lg);

  /// Replaces EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0)
  static const EdgeInsetsDirectional topOnly24 =
      EdgeInsetsDirectional.only(top: lg);

  // ================================
  // CARD AND CONTAINER SPACING
  // ================================

  /// Standard card internal padding
  static const EdgeInsetsDirectional cardInternal =
      EdgeInsetsDirectional.all(md); // 16px

  /// Container padding (from itinerary design)
  static const EdgeInsetsDirectional containerInternal =
      EdgeInsetsDirectional.all(ml); // 20px

  /// Section padding (from itinerary design)
  static const EdgeInsetsDirectional sectionInternal =
      EdgeInsetsDirectional.all(lg); // 24px

  /// Page padding (from itinerary design)
  static const EdgeInsetsDirectional pageInternal =
      EdgeInsetsDirectional.all(xl); // 32px

  /// Card external margin
  static const EdgeInsetsDirectional cardExternal =
      EdgeInsetsDirectional.all(s);

  /// Modal content padding
  static const EdgeInsetsDirectional modalContent =
      EdgeInsetsDirectional.all(lg);

  /// Screen edge padding
  static const EdgeInsetsDirectional screenEdges =
      EdgeInsetsDirectional.all(md);

  // ================================
  // FORM SPACING
  // ================================

  /// Space between form fields
  static const double formFieldSpacing = md;

  /// Form section spacing
  static const double formSectionSpacing = lg;

  /// Form field internal padding
  static const EdgeInsetsDirectional formFieldPadding =
      EdgeInsetsDirectional.fromSTEB(md, s, md, s);

  // ================================
  // NAVIGATION SPACING
  // ================================

  /// Navigation item padding
  static const EdgeInsetsDirectional navItemPadding =
      EdgeInsetsDirectional.fromSTEB(md, s, md, s);

  /// Navigation section spacing
  static const double navSectionSpacing = lg;

  // ================================
  // HELPER METHODS
  // ================================

  /// Create custom EdgeInsetsDirectional
  static EdgeInsetsDirectional fromSTEB(
      double start, double top, double end, double bottom) {
    return EdgeInsetsDirectional.fromSTEB(start, top, end, bottom);
  }

  /// Get responsive padding based on screen size
  static EdgeInsetsDirectional getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 479) {
      // Mobile
      return horizontal16;
    } else if (screenWidth < 991) {
      // Tablet
      return horizontal24;
    } else {
      // Desktop
      return horizontal32;
    }
  }

  /// Get spacing value by size
  static double getSpacing(SpacingSize size) {
    switch (size) {
      case SpacingSize.xs:
        return xs;
      case SpacingSize.sm:
        return s;
      case SpacingSize.md:
        return md;
      case SpacingSize.lg:
        return lg;
      case SpacingSize.xl:
        return xl;
      case SpacingSize.xxl:
        return xxl;
      case SpacingSize.xxxl:
        return xxxl;
    }
  }
}

/// Spacing size enumeration
enum SpacingSize {
  xs, // 4.0
  sm, // 8.0 (s)
  md, // 16.0 (m)
  lg, // 24.0 (l)
  xl, // 32.0
  xxl, // 48.0
  xxxl, // 64.0
}

/// Extension for easier spacing access in widgets
extension BukeerSpacingExtension on BuildContext {
  BukeerSpacing get spacing => BukeerSpacing._();
}
