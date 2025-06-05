import 'package:flutter/material.dart';
import '../../tokens/index.dart';

/// Floating Action Button component for the Bukeer application
/// Standardized FAB implementation with consistent styling
class BukeerFAB extends StatelessWidget {
  /// FAB icon
  final IconData icon;
  
  /// Callback when FAB is pressed
  final VoidCallback? onPressed;
  
  /// FAB size variant
  final BukeerFABSize size;
  
  /// Background color (optional override)
  final Color? backgroundColor;
  
  /// Icon color (optional override)
  final Color? iconColor;
  
  /// Whether FAB is in loading state
  final bool isLoading;
  
  /// Tooltip text
  final String? tooltip;

  const BukeerFAB({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = BukeerFABSize.regular,
    this.backgroundColor,
    this.iconColor,
    this.isLoading = false,
    this.tooltip,
  }) : super(key: key);

  /// Standard FAB - most common use case
  const BukeerFAB.standard({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? iconColor,
    bool isLoading = false,
    String? tooltip,
  }) : this(
          key: key,
          icon: icon,
          onPressed: onPressed,
          size: BukeerFABSize.regular,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          isLoading: isLoading,
          tooltip: tooltip,
        );

  /// Small FAB - for compact layouts
  const BukeerFAB.small({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? iconColor,
    bool isLoading = false,
    String? tooltip,
  }) : this(
          key: key,
          icon: icon,
          onPressed: onPressed,
          size: BukeerFABSize.small,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          isLoading: isLoading,
          tooltip: tooltip,
        );

  /// Large FAB - for prominent actions
  const BukeerFAB.large({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? iconColor,
    bool isLoading = false,
    String? tooltip,
  }) : this(
          key: key,
          icon: icon,
          onPressed: onPressed,
          size: BukeerFABSize.large,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          isLoading: isLoading,
          tooltip: tooltip,
        );

  @override
  Widget build(BuildContext context) {
    final actualOnPressed = isLoading ? null : onPressed;
    final actualBackgroundColor = backgroundColor ?? BukeerColors.primary;
    final actualIconColor = iconColor ?? BukeerColors.textInverse;

    return FloatingActionButton(
      onPressed: actualOnPressed,
      backgroundColor: actualBackgroundColor,
      foregroundColor: actualIconColor,
      elevation: BukeerElevation.level6,
      highlightElevation: BukeerElevation.level6 + 2,
      tooltip: tooltip,
      mini: size == BukeerFABSize.small,
      child: _buildFABContent(),
    );
  }

  Widget _buildFABContent() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            iconColor ?? BukeerColors.textInverse,
          ),
        ),
      );
    }

    return Icon(
      icon,
      size: _getIconSize(),
    );
  }

  double _getIconSize() {
    switch (size) {
      case BukeerFABSize.small:
        return 20.0;
      case BukeerFABSize.regular:
        return 24.0;
      case BukeerFABSize.large:
        return 28.0;
    }
  }
}

/// Extended FAB for actions with text
class BukeerExtendedFAB extends StatelessWidget {
  /// FAB icon
  final IconData icon;
  
  /// FAB text label
  final String label;
  
  /// Callback when FAB is pressed
  final VoidCallback? onPressed;
  
  /// Background color (optional override)
  final Color? backgroundColor;
  
  /// Foreground color (optional override)
  final Color? foregroundColor;
  
  /// Whether FAB is in loading state
  final bool isLoading;
  
  /// Tooltip text
  final String? tooltip;

  const BukeerExtendedFAB({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actualOnPressed = isLoading ? null : onPressed;
    final actualBackgroundColor = backgroundColor ?? BukeerColors.primary;
    final actualForegroundColor = foregroundColor ?? BukeerColors.textInverse;

    return FloatingActionButton.extended(
      onPressed: actualOnPressed,
      backgroundColor: actualBackgroundColor,
      foregroundColor: actualForegroundColor,
      elevation: BukeerElevation.level6,
      highlightElevation: BukeerElevation.level6 + 2,
      tooltip: tooltip,
      icon: _buildFABIcon(),
      label: Text(
        label,
        style: BukeerTypography.labelLarge.copyWith(
          color: actualForegroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFABIcon() {
    if (isLoading) {
      return SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? BukeerColors.textInverse,
          ),
        ),
      );
    }

    return Icon(icon, size: 20.0);
  }
}

/// FAB size variants
enum BukeerFABSize {
  small,   // Mini FAB
  regular, // Standard FAB
  large,   // Large FAB (custom implementation)
}