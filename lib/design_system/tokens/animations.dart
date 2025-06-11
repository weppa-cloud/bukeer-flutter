import 'package:flutter/material.dart';

/// Design tokens for animations and transitions in the Bukeer application
/// Provides consistent timing, curves, and animation patterns throughout the app
class BukeerAnimations {
  BukeerAnimations._();

  // ================================
  // DURATION TOKENS
  // ================================

  /// Instant - no animation
  static const Duration instant = Duration(milliseconds: 0);

  /// Ultra fast - for very quick state changes
  static const Duration ultraFast = Duration(milliseconds: 100);

  /// Fast - for quick state changes
  static const Duration fast = Duration(milliseconds: 200);

  /// Medium - standard transition duration
  static const Duration medium = Duration(milliseconds: 300);

  /// Slow - for page transitions
  static const Duration slow = Duration(milliseconds: 500);

  /// Ultra slow - for dramatic effects
  static const Duration ultraSlow = Duration(milliseconds: 800);

  // ================================
  // CURVE TOKENS
  // ================================

  /// Standard ease - most common curve (from itinerary design)
  static const Curve standard = Curves.easeInOut;

  /// Accelerate - for enter animations (from itinerary design)
  static const Curve accelerate = Curves.easeIn;

  /// Decelerate - for exit animations (from itinerary design)
  static const Curve decelerate = Curves.easeOut;

  /// Smooth ease - for elegant transitions
  static const Curve smooth = Curves.easeInOutCubic;

  /// Sharp ease - for quick, decisive actions
  static const Curve sharp = Curves.easeInOutQuart;

  /// Bounce - for playful interactions
  static const Curve bounce = Curves.bounceOut;

  /// Elastic - for attention-grabbing effects
  static const Curve elastic = Curves.elasticOut;

  /// Linear - for progress indicators
  static const Curve linear = Curves.linear;

  /// Ease - standard Material ease
  static const Curve ease = Curves.ease;

  /// Ease smooth - smoother variant
  static const Curve easeSmooth = Curves.easeInOutCubic;

  /// Ease sharp - sharper variant
  static const Curve easeSharp = Curves.easeInOutQuart;

  // ================================
  // COMPONENT-SPECIFIC ANIMATIONS
  // ================================

  /// Button press animation
  static const Duration buttonPress = fast;
  static const Curve buttonCurve = standard;

  /// Modal animation
  static const Duration modalShow = medium;
  static const Duration modalHide = fast;
  static const Curve modalCurve = smooth;

  /// Page transition
  static const Duration pageTransition = medium;
  static const Curve pageTransitionCurve = standard;

  /// Loading spinner
  static const Duration loadingRotation = Duration(milliseconds: 1200);
  static const Curve loadingCurve = linear;

  /// Form field focus
  static const Duration formFocus = fast;
  static const Curve formFocusCurve = standard;

  /// Snackbar/Toast
  static const Duration snackbarShow = fast;
  static const Duration snackbarHide = fast;
  static const Curve snackbarCurve = standard;

  /// Drawer/Sidebar
  static const Duration drawerAnimation = medium;
  static const Curve drawerCurve = smooth;

  /// Tab switching
  static const Duration tabSwitch = fast;
  static const Curve tabSwitchCurve = standard;

  /// Dropdown animation
  static const Duration dropdownShow = fast;
  static const Duration dropdownHide = ultraFast;
  static const Curve dropdownCurve = standard;

  /// Card hover/focus
  static const Duration cardHover = ultraFast;
  static const Curve cardHoverCurve = standard;

  /// List item animation
  static const Duration listItemAnimation = fast;
  static const Curve listItemCurve = standard;

  // ================================
  // MICRO-INTERACTION ANIMATIONS
  // ================================

  /// Icon rotation (e.g., expand/collapse)
  static const Duration iconRotation = fast;
  static const Curve iconRotationCurve = standard;

  /// Scale on press
  static const Duration scalePress = ultraFast;
  static const Curve scaleCurve = Curves.easeInOutBack;

  /// Fade in/out
  static const Duration fadeIn = medium;
  static const Duration fadeOut = fast;
  static const Curve fadeCurve = standard;

  /// Slide animations
  static const Duration slideIn = medium;
  static const Duration slideOut = fast;
  static const Curve slideCurve = smooth;

  // ================================
  // COMPLEX ANIMATION SEQUENCES
  // ================================

  /// Staggered list animation delay
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Search results animation
  static const Duration searchResults = medium;
  static const Curve searchResultsCurve = smooth;

  /// Loading state transitions
  static const Duration loadingStateChange = fast;
  static const Curve loadingStateCurve = standard;

  // ================================
  // UTILITY METHODS
  // ================================

  /// Get animation duration by speed category
  static Duration getDuration(AnimationSpeed speed) {
    switch (speed) {
      case AnimationSpeed.ultraFast:
        return ultraFast;
      case AnimationSpeed.fast:
        return fast;
      case AnimationSpeed.medium:
        return medium;
      case AnimationSpeed.slow:
        return slow;
      case AnimationSpeed.ultraSlow:
        return ultraSlow;
    }
  }

  /// Get curve by style category
  static Curve getCurve(AnimationStyle style) {
    switch (style) {
      case AnimationStyle.ease:
        return ease;
      case AnimationStyle.easeSmooth:
        return easeSmooth;
      case AnimationStyle.easeSharp:
        return easeSharp;
      case AnimationStyle.bounce:
        return bounce;
      case AnimationStyle.elastic:
        return elastic;
      case AnimationStyle.linear:
        return linear;
    }
  }

  /// Create a standard fade transition
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? fadeCurve,
        ),
      ),
      child: child,
    );
  }

  /// Create a standard slide transition
  static Widget slideTransition({
    required Animation<double> animation,
    required Widget child,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Curve? curve,
  }) {
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? slideCurve,
        ),
      ),
      child: child,
    );
  }

  /// Create a standard scale transition
  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
    double begin = 0.0,
    double end = 1.0,
    Curve? curve,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? scaleCurve,
        ),
      ),
      child: child,
    );
  }

  /// Create a combination fade + scale transition (material design style)
  static Widget materialTransition({
    required Animation<double> animation,
    required Widget child,
    Curve? curve,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve ?? easeSmooth,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
        child: child,
      ),
    );
  }

  /// Create page route with custom animation
  static PageRouteBuilder<T> createPageRoute<T>({
    required Widget page,
    Duration? duration,
    Curve? curve,
    PageTransitionType type = PageTransitionType.slide,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (type) {
          case PageTransitionType.fade:
            return fadeTransition(animation: animation, child: child);
          case PageTransitionType.slide:
            return slideTransition(animation: animation, child: child);
          case PageTransitionType.scale:
            return scaleTransition(animation: animation, child: child);
          case PageTransitionType.material:
            return materialTransition(
                animation: animation, child: child, curve: curve);
        }
      },
    );
  }
}

/// Animation speed categories
enum AnimationSpeed {
  ultraFast,
  fast,
  medium,
  slow,
  ultraSlow,
}

/// Animation style categories
enum AnimationStyle {
  ease,
  easeSmooth,
  easeSharp,
  bounce,
  elastic,
  linear,
}

/// Page transition types
enum PageTransitionType {
  fade,
  slide,
  scale,
  material,
}

/// Predefined animation configurations for common use cases
class BukeerAnimationPresets {
  BukeerAnimationPresets._();

  /// Button tap animation configuration
  static const AnimationConfig buttonTap = AnimationConfig(
    duration: BukeerAnimations.buttonPress,
    curve: BukeerAnimations.buttonCurve,
  );

  /// Modal presentation configuration
  static const AnimationConfig modalPresentation = AnimationConfig(
    duration: BukeerAnimations.modalShow,
    curve: BukeerAnimations.modalCurve,
  );

  /// Form field focus configuration
  static const AnimationConfig formFocus = AnimationConfig(
    duration: BukeerAnimations.formFocus,
    curve: BukeerAnimations.formFocusCurve,
  );

  /// Loading state configuration
  static const AnimationConfig loading = AnimationConfig(
    duration: BukeerAnimations.loadingRotation,
    curve: BukeerAnimations.loadingCurve,
  );

  /// Snackbar configuration
  static const AnimationConfig snackbar = AnimationConfig(
    duration: BukeerAnimations.snackbarShow,
    curve: BukeerAnimations.snackbarCurve,
  );
}

/// Animation configuration class
class AnimationConfig {
  final Duration duration;
  final Curve curve;

  const AnimationConfig({
    required this.duration,
    required this.curve,
  });
}

/// Extension for easier animation access in widgets
extension BukeerAnimationsExtension on BuildContext {
  BukeerAnimations get animations => BukeerAnimations._();
}
