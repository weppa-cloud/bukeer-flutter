import 'package:flutter/material.dart';

/// Design tokens for shadows and depth effects in the Bukeer application
/// Provides consistent elevation system and shadow presets
class BukeerShadows {
  BukeerShadows._();

  // ================================
  // ELEVATION LEVELS
  // ================================
  
  /// No elevation - flat surface
  static const double level0 = 0.0;
  
  /// Subtle elevation - for buttons on press
  static const double level1 = 1.0;
  
  /// Low elevation - for cards and buttons
  static const double level2 = 2.0;
  
  /// Medium elevation - for app bars and raised elements
  static const double level3 = 4.0;
  
  /// High elevation - for navigation drawer
  static const double level4 = 8.0;
  
  /// Very high elevation - for modals and dialogs
  static const double level5 = 16.0;
  
  /// Maximum elevation - for tooltips and overlays
  static const double level6 = 24.0;

  // ================================
  // SHADOW PRESETS
  // ================================
  
  /// No shadow
  static const List<BoxShadow> none = [];
  
  /// Subtle shadow for minimal depth
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      blurRadius: 1.0,
      offset: Offset(0.0, 1.0),
    ),
  ];
  
  /// Small shadow for buttons and cards
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 3.0,
      offset: Offset(0.0, 1.0),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 2.0,
      offset: Offset(0.0, 1.0),
    ),
  ];
  
  /// Medium shadow for raised elements
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 6.0,
      offset: Offset(0.0, 3.0),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 2.0,
      offset: Offset(0.0, 1.0),
    ),
  ];
  
  /// Large shadow for app bars and navigation
  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 10.0,
      offset: Offset(0.0, 4.0),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 5.0,
      offset: Offset(0.0, 2.0),
    ),
  ];
  
  /// Extra large shadow for modals and dialogs
  static const List<BoxShadow> extraLarge = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 25.0,
      offset: Offset(0.0, 10.0),
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      blurRadius: 10.0,
      offset: Offset(0.0, 4.0),
    ),
  ];
  
  /// Maximum shadow for overlays and tooltips
  static const List<BoxShadow> maximum = [
    BoxShadow(
      color: Color(0x26000000), // 15% black
      blurRadius: 50.0,
      offset: Offset(0.0, 20.0),
    ),
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 15.0,
      offset: Offset(0.0, 6.0),
    ),
  ];

  // ================================
  // COMPONENT-SPECIFIC SHADOWS
  // ================================
  
  /// Button shadow (normal state)
  static const List<BoxShadow> button = small;
  
  /// Button shadow (pressed state)
  static const List<BoxShadow> buttonPressed = subtle;
  
  /// Button shadow (elevated/primary)
  static const List<BoxShadow> buttonElevated = medium;
  
  /// Card shadow
  static const List<BoxShadow> card = small;
  
  /// Card shadow (hovered/focused)
  static const List<BoxShadow> cardHovered = medium;
  
  /// App bar shadow
  static const List<BoxShadow> appBar = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 4.0,
      offset: Offset(0.0, 2.0),
    ),
  ];
  
  /// Navigation drawer shadow
  static const List<BoxShadow> navigationDrawer = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 16.0,
      offset: Offset(0.0, 8.0),
    ),
  ];
  
  /// Modal/Dialog shadow
  static const List<BoxShadow> modal = extraLarge;
  
  /// Dropdown shadow
  static const List<BoxShadow> dropdown = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 12.0,
      offset: Offset(0.0, 6.0),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 4.0,
      offset: Offset(0.0, 2.0),
    ),
  ];
  
  /// Tooltip shadow
  static const List<BoxShadow> tooltip = [
    BoxShadow(
      color: Color(0x33000000), // 20% black
      blurRadius: 8.0,
      offset: Offset(0.0, 4.0),
    ),
  ];
  
  /// Floating action button shadow
  static const List<BoxShadow> floatingActionButton = [
    BoxShadow(
      color: Color(0x33000000), // 20% black
      blurRadius: 6.0,
      offset: Offset(0.0, 3.0),
    ),
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 3.0,
      offset: Offset(0.0, 1.0),
    ),
  ];
  
  /// Snackbar shadow
  static const List<BoxShadow> snackbar = [
    BoxShadow(
      color: Color(0x26000000), // 15% black
      blurRadius: 8.0,
      offset: Offset(0.0, 4.0),
    ),
  ];
  
  /// Bottom sheet shadow
  static const List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 10.0,
      offset: Offset(0.0, -4.0), // Upward shadow
    ),
  ];

  // ================================
  // SPECIALIZED SHADOWS
  // ================================
  
  /// Inner shadow effect (for pressed states)
  static const List<BoxShadow> inner = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 4.0,
      offset: Offset(0.0, 2.0),
      spreadRadius: -2.0,
    ),
  ];
  
  /// Focus ring shadow (for accessibility)
  static const List<BoxShadow> focusRing = [
    BoxShadow(
      color: Color(0x4D4B39EF), // 30% primary color
      blurRadius: 0.0,
      offset: Offset(0.0, 0.0),
      spreadRadius: 2.0,
    ),
  ];
  
  /// Error state shadow (red tint)
  static const List<BoxShadow> error = [
    BoxShadow(
      color: Color(0x26E74C3C), // 15% red
      blurRadius: 6.0,
      offset: Offset(0.0, 3.0),
    ),
  ];
  
  /// Success state shadow (green tint)
  static const List<BoxShadow> success = [
    BoxShadow(
      color: Color(0x26249689), // 15% green
      blurRadius: 6.0,
      offset: Offset(0.0, 3.0),
    ),
  ];
  
  /// Warning state shadow (amber tint)
  static const List<BoxShadow> warning = [
    BoxShadow(
      color: Color(0x26FF9500), // 15% amber
      blurRadius: 6.0,
      offset: Offset(0.0, 3.0),
    ),
  ];

  // ================================
  // DIRECTIONAL SHADOWS
  // ================================
  
  /// Top shadow (for bottom sheets, dropdowns)
  static const List<BoxShadow> top = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 8.0,
      offset: Offset(0.0, -4.0),
    ),
  ];
  
  /// Bottom shadow (standard downward)
  static const List<BoxShadow> bottom = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 8.0,
      offset: Offset(0.0, 4.0),
    ),
  ];
  
  /// Left shadow
  static const List<BoxShadow> left = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 8.0,
      offset: Offset(-4.0, 0.0),
    ),
  ];
  
  /// Right shadow
  static const List<BoxShadow> right = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 8.0,
      offset: Offset(4.0, 0.0),
    ),
  ];

  // ================================
  // UTILITY METHODS
  // ================================
  
  /// Get shadow by size category
  static List<BoxShadow> getBySize(ShadowSize size) {
    switch (size) {
      case ShadowSize.none:
        return none;
      case ShadowSize.subtle:
        return subtle;
      case ShadowSize.small:
        return small;
      case ShadowSize.medium:
        return medium;
      case ShadowSize.large:
        return large;
      case ShadowSize.extraLarge:
        return extraLarge;
      case ShadowSize.maximum:
        return maximum;
    }
  }
  
  /// Get shadow by component type
  static List<BoxShadow> getByComponent(ShadowComponent component) {
    switch (component) {
      case ShadowComponent.button:
        return button;
      case ShadowComponent.buttonPressed:
        return buttonPressed;
      case ShadowComponent.buttonElevated:
        return buttonElevated;
      case ShadowComponent.card:
        return card;
      case ShadowComponent.cardHovered:
        return cardHovered;
      case ShadowComponent.appBar:
        return appBar;
      case ShadowComponent.navigationDrawer:
        return navigationDrawer;
      case ShadowComponent.modal:
        return modal;
      case ShadowComponent.dropdown:
        return dropdown;
      case ShadowComponent.tooltip:
        return tooltip;
      case ShadowComponent.floatingActionButton:
        return floatingActionButton;
      case ShadowComponent.snackbar:
        return snackbar;
      case ShadowComponent.bottomSheet:
        return bottomSheet;
    }
  }
  
  /// Get shadow by elevation level
  static List<BoxShadow> getByElevation(double elevation) {
    if (elevation <= 0) return none;
    if (elevation <= 1) return subtle;
    if (elevation <= 2) return small;
    if (elevation <= 4) return medium;
    if (elevation <= 8) return large;
    if (elevation <= 16) return extraLarge;
    return maximum;
  }
  
  /// Create custom shadow with primary color tint
  static List<BoxShadow> createPrimaryTinted({
    double blurRadius = 6.0,
    Offset offset = const Offset(0.0, 3.0),
    double opacity = 0.3,
  }) {
    return [
      BoxShadow(
        color: Color(0xFF4B39EF).withOpacity(opacity), // Primary color with opacity
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }
  
  /// Create custom shadow with secondary color tint
  static List<BoxShadow> createSecondaryTinted({
    double blurRadius = 6.0,
    Offset offset = const Offset(0.0, 3.0),
    double opacity = 0.3,
  }) {
    return [
      BoxShadow(
        color: Color(0xFF39D2C0).withOpacity(opacity), // Secondary color with opacity
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }
  
  /// Create custom colored shadow
  static List<BoxShadow> createColored({
    required Color color,
    double blurRadius = 6.0,
    Offset offset = const Offset(0.0, 3.0),
    double opacity = 0.3,
    double spreadRadius = 0.0,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: spreadRadius,
      ),
    ];
  }
  
  /// Create animated shadow (for hover states)
  static List<BoxShadow> createAnimated({
    required double progress, // 0.0 to 1.0
    List<BoxShadow> startShadow = small,
    List<BoxShadow> endShadow = medium,
  }) {
    if (startShadow.isEmpty || endShadow.isEmpty) return startShadow;
    
    final startShadowFirst = startShadow.first;
    final endShadowFirst = endShadow.first;
    
    return [
      BoxShadow(
        color: Color.lerp(startShadowFirst.color, endShadowFirst.color, progress) ?? startShadowFirst.color,
        blurRadius: startShadowFirst.blurRadius + (endShadowFirst.blurRadius - startShadowFirst.blurRadius) * progress,
        offset: Offset.lerp(startShadowFirst.offset, endShadowFirst.offset, progress) ?? startShadowFirst.offset,
        spreadRadius: startShadowFirst.spreadRadius + (endShadowFirst.spreadRadius - startShadowFirst.spreadRadius) * progress,
      ),
    ];
  }
}

/// Shadow size enumeration
enum ShadowSize {
  none,
  subtle,
  small,
  medium,
  large,
  extraLarge,
  maximum,
}

/// Shadow component enumeration
enum ShadowComponent {
  button,
  buttonPressed,
  buttonElevated,
  card,
  cardHovered,
  appBar,
  navigationDrawer,
  modal,
  dropdown,
  tooltip,
  floatingActionButton,
  snackbar,
  bottomSheet,
}

/// Predefined shadow configurations for common use cases
class BukeerShadowPresets {
  BukeerShadowPresets._();
  
  /// Interactive element shadow configuration
  static const ShadowConfig interactive = ShadowConfig(
    normal: BukeerShadows.small,
    hovered: BukeerShadows.medium,
    pressed: BukeerShadows.subtle,
  );
  
  /// Card shadow configuration
  static const ShadowConfig cardShadow = ShadowConfig(
    normal: BukeerShadows.card,
    hovered: BukeerShadows.cardHovered,
    pressed: BukeerShadows.card,
  );
  
  /// Modal shadow configuration
  static const ShadowConfig modalShadow = ShadowConfig(
    normal: BukeerShadows.modal,
    hovered: BukeerShadows.modal,
    pressed: BukeerShadows.modal,
  );
}

/// Shadow configuration class
class ShadowConfig {
  final List<BoxShadow> normal;
  final List<BoxShadow> hovered;
  final List<BoxShadow> pressed;
  
  const ShadowConfig({
    required this.normal,
    required this.hovered,
    required this.pressed,
  });
}

/// Extension for easier shadow access in widgets
extension BukeerShadowsExtension on BuildContext {
  BukeerShadows get shadows => BukeerShadows._();
}