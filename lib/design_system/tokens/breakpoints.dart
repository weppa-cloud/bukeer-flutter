import 'package:flutter/material.dart';

/// Design tokens for responsive breakpoints in the Bukeer application
/// Defines screen size categories and responsive behavior patterns
class BukeerBreakpoints {
  BukeerBreakpoints._();

  // ================================
  // BREAKPOINT VALUES
  // ================================
  
  /// Mobile breakpoint (phones)
  static const double mobile = 479.0;
  
  /// Tablet breakpoint (tablets in portrait)
  static const double tablet = 991.0;
  
  /// Desktop breakpoint (desktop screens)
  static const double desktop = 1200.0;
  
  /// Large desktop breakpoint (large screens)
  static const double largeDesktop = 1440.0;

  // ================================
  // SCREEN SIZE DETECTION
  // ================================
  
  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobile;
  }
  
  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobile && width <= tablet;
  }
  
  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > tablet;
  }
  
  /// Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > largeDesktop;
  }

  /// Check if current screen is mobile or tablet
  static bool isMobileOrTablet(BuildContext context) {
    return MediaQuery.of(context).size.width <= tablet;
  }

  /// Check if current screen is tablet or desktop
  static bool isTabletOrDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > mobile;
  }

  // ================================
  // RESPONSIVE VALUES
  // ================================
  
  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width <= BukeerBreakpoints.mobile) {
      return mobile;
    } else if (width <= BukeerBreakpoints.tablet) {
      return tablet ?? mobile;
    } else if (width <= BukeerBreakpoints.largeDesktop) {
      return desktop ?? tablet ?? mobile;
    } else {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive integer value
  static int getResponsiveInt(
    BuildContext context, {
    required int mobile,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return getResponsiveValue<int>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive double value
  static double getResponsiveDouble(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return getResponsiveValue<double>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  // ================================
  // LAYOUT CONSTANTS
  // ================================
  
  /// Maximum content width for different screen sizes
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity; // Full width on mobile
    } else if (isTablet(context)) {
      return 768.0; // Constrained width on tablet
    } else if (isDesktop(context)) {
      return 1024.0; // Constrained width on desktop
    } else {
      return 1200.0; // Max width on large desktop
    }
  }

  /// Number of columns for grid layouts
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else if (isDesktop(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Sidebar width for different screen sizes
  static double getSidebarWidth(BuildContext context) {
    if (isMobile(context)) {
      return MediaQuery.of(context).size.width * 0.85; // 85% on mobile
    } else if (isTablet(context)) {
      return 300.0; // Fixed width on tablet
    } else {
      return 270.0; // Fixed width on desktop (matches current web_nav)
    }
  }

  // ================================
  // RESPONSIVE UTILITIES
  // ================================
  
  /// Get current device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width <= mobile) {
      return DeviceType.mobile;
    } else if (width <= tablet) {
      return DeviceType.tablet;
    } else if (width <= largeDesktop) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  /// Check if navigation should be drawer style (mobile/tablet)
  static bool shouldUseDrawer(BuildContext context) {
    return isMobileOrTablet(context);
  }

  /// Check if navigation should be persistent (desktop)
  static bool shouldUsePersistentNav(BuildContext context) {
    return isDesktop(context);
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(8.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }
}

/// Device type enumeration
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Responsive layout configuration
class ResponsiveLayoutConfig {
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double mobileSpacing;
  final double tabletSpacing;
  final double desktopSpacing;

  const ResponsiveLayoutConfig({
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.mobileSpacing = 16.0,
    this.tabletSpacing = 24.0,
    this.desktopSpacing = 32.0,
  });

  /// Get columns for current screen size
  int getColumns(BuildContext context) {
    return BukeerBreakpoints.getResponsiveInt(
      context,
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );
  }

  /// Get spacing for current screen size
  double getSpacing(BuildContext context) {
    return BukeerBreakpoints.getResponsiveDouble(
      context,
      mobile: mobileSpacing,
      tablet: tabletSpacing,
      desktop: desktopSpacing,
    );
  }
}

/// Extension for easier breakpoint access in widgets
extension BukeerBreakpointsExtension on BuildContext {
  BukeerBreakpoints get breakpoints => BukeerBreakpoints._();
  
  /// Quick access to device type
  DeviceType get deviceType => BukeerBreakpoints.getDeviceType(this);
  
  /// Quick access to device checks
  bool get isMobile => BukeerBreakpoints.isMobile(this);
  bool get isTablet => BukeerBreakpoints.isTablet(this);
  bool get isDesktop => BukeerBreakpoints.isDesktop(this);
  bool get isLargeDesktop => BukeerBreakpoints.isLargeDesktop(this);
  bool get isMobileOrTablet => BukeerBreakpoints.isMobileOrTablet(this);
  bool get isTabletOrDesktop => BukeerBreakpoints.isTabletOrDesktop(this);
}