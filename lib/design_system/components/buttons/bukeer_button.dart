import 'package:flutter/material.dart';
import '../../tokens/index.dart';

/// Standardized button component for the Bukeer application
/// Replaces FFButtonWidget and inconsistent button implementations
/// 
/// Features:
/// - Consistent styling across button variants
/// - Responsive sizing
/// - Loading states
/// - Icon support
/// - Accessibility compliance
class BukeerButton extends StatelessWidget {
  /// Button text
  final String? text;
  
  /// Button icon (optional)
  final IconData? icon;
  
  /// Button variant style
  final BukeerButtonVariant variant;
  
  /// Button size
  final BukeerButtonSize size;
  
  /// Button width behavior
  final BukeerButtonWidth width;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Whether button is in loading state
  final bool isLoading;
  
  /// Whether button is enabled
  final bool enabled;
  
  /// Custom background color (overrides variant color)
  final Color? backgroundColor;
  
  /// Custom text color (overrides variant color)
  final Color? textColor;
  
  /// Custom border color (for outlined variant)
  final Color? borderColor;
  
  /// Icon position (for buttons with both text and icon)
  final BukeerButtonIconPosition iconPosition;

  const BukeerButton({
    Key? key,
    this.text,
    this.icon,
    this.variant = BukeerButtonVariant.primary,
    this.size = BukeerButtonSize.medium,
    this.width = BukeerButtonWidth.auto,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.iconPosition = BukeerButtonIconPosition.leading,
  }) : assert(text != null || icon != null, 'Button must have either text or icon'),
       super(key: key);

  /// Primary button - main actions
  const BukeerButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    BukeerButtonWidth width = BukeerButtonWidth.auto,
    bool isLoading = false,
    bool enabled = true,
    IconData? icon,
    BukeerButtonIconPosition iconPosition = BukeerButtonIconPosition.leading,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          variant: BukeerButtonVariant.primary,
          size: size,
          width: width,
          isLoading: isLoading,
          enabled: enabled,
          icon: icon,
          iconPosition: iconPosition,
        );

  /// Secondary button - secondary actions
  const BukeerButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    BukeerButtonWidth width = BukeerButtonWidth.auto,
    bool isLoading = false,
    bool enabled = true,
    IconData? icon,
    BukeerButtonIconPosition iconPosition = BukeerButtonIconPosition.leading,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          variant: BukeerButtonVariant.secondary,
          size: size,
          width: width,
          isLoading: isLoading,
          enabled: enabled,
          icon: icon,
          iconPosition: iconPosition,
        );

  /// Outlined button - secondary actions with border
  const BukeerButton.outlined({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    BukeerButtonWidth width = BukeerButtonWidth.auto,
    bool isLoading = false,
    bool enabled = true,
    IconData? icon,
    BukeerButtonIconPosition iconPosition = BukeerButtonIconPosition.leading,
    Color? borderColor,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          variant: BukeerButtonVariant.outlined,
          size: size,
          width: width,
          isLoading: isLoading,
          enabled: enabled,
          icon: icon,
          iconPosition: iconPosition,
          borderColor: borderColor,
        );

  /// Text button - minimal styling for tertiary actions
  const BukeerButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    BukeerButtonWidth width = BukeerButtonWidth.auto,
    bool isLoading = false,
    bool enabled = true,
    IconData? icon,
    BukeerButtonIconPosition iconPosition = BukeerButtonIconPosition.leading,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          variant: BukeerButtonVariant.text,
          size: size,
          width: width,
          isLoading: isLoading,
          enabled: enabled,
          icon: icon,
          iconPosition: iconPosition,
        );

  /// Icon button - icon only
  const BukeerButton.icon({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    bool isLoading = false,
    bool enabled = true,
    BukeerButtonVariant variant = BukeerButtonVariant.text,
    Color? backgroundColor,
    Color? textColor,
  }) : this(
          key: key,
          icon: icon,
          onPressed: onPressed,
          variant: variant,
          size: size,
          width: BukeerButtonWidth.auto,
          isLoading: isLoading,
          enabled: enabled,
          backgroundColor: backgroundColor,
          textColor: textColor,
        );

  @override
  Widget build(BuildContext context) {
    final isActuallyEnabled = enabled && !isLoading;
    final actualOnPressed = isActuallyEnabled ? onPressed : null;

    return _buildButton(context, actualOnPressed);
  }

  Widget _buildButton(BuildContext context, VoidCallback? actualOnPressed) {
    switch (variant) {
      case BukeerButtonVariant.primary:
        return _buildElevatedButton(context, actualOnPressed);
      case BukeerButtonVariant.secondary:
        return _buildFilledTonalButton(context, actualOnPressed);
      case BukeerButtonVariant.outlined:
        return _buildOutlinedButton(context, actualOnPressed);
      case BukeerButtonVariant.text:
        return _buildTextButton(context, actualOnPressed);
    }
  }

  Widget _buildElevatedButton(BuildContext context, VoidCallback? actualOnPressed) {
    return SizedBox(
      width: _getButtonWidth(context),
      height: _getButtonHeight(),
      child: ElevatedButton(
        onPressed: actualOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? BukeerColors.primary,
          foregroundColor: textColor ?? BukeerColors.textInverse,
          disabledBackgroundColor: BukeerColors.neutral300,
          disabledForegroundColor: BukeerColors.textDisabled,
          elevation: BukeerElevation.level2,
          shadowColor: BukeerColors.shadow33,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
          padding: _getPadding(),
          textStyle: _getTextStyle(),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildFilledTonalButton(BuildContext context, VoidCallback? actualOnPressed) {
    return SizedBox(
      width: _getButtonWidth(context),
      height: _getButtonHeight(),
      child: FilledButton.tonal(
        onPressed: actualOnPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? BukeerColors.primaryLight,
          foregroundColor: textColor ?? BukeerColors.primary,
          disabledBackgroundColor: BukeerColors.neutral300,
          disabledForegroundColor: BukeerColors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
          padding: _getPadding(),
          textStyle: _getTextStyle(),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, VoidCallback? actualOnPressed) {
    return SizedBox(
      width: _getButtonWidth(context),
      height: _getButtonHeight(),
      child: OutlinedButton(
        onPressed: actualOnPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? BukeerColors.primary,
          disabledForegroundColor: BukeerColors.textDisabled,
          side: BorderSide(
            color: borderColor ?? BukeerColors.primary,
            width: enabled ? 1.5 : 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
          padding: _getPadding(),
          textStyle: _getTextStyle(),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, VoidCallback? actualOnPressed) {
    return SizedBox(
      width: _getButtonWidth(context),
      height: _getButtonHeight(),
      child: TextButton(
        onPressed: actualOnPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? BukeerColors.primary,
          disabledForegroundColor: BukeerColors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
          padding: _getPadding(),
          textStyle: _getTextStyle(),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingContent();
    }

    // Icon only button
    if (text == null && icon != null) {
      return Icon(
        icon,
        size: _getIconSize(),
      );
    }

    // Text only button
    if (icon == null && text != null) {
      return Text(text!);
    }

    // Button with both text and icon
    if (icon != null && text != null) {
      return _buildTextWithIcon();
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingContent() {
    return SizedBox(
      width: _getIconSize(),
      height: _getIconSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          variant == BukeerButtonVariant.primary 
            ? BukeerColors.textInverse 
            : BukeerColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextWithIcon() {
    final iconWidget = Icon(
      icon,
      size: _getIconSize(),
    );
    
    final textWidget = Text(text!);
    
    final spacing = SizedBox(width: BukeerSpacing.sm);

    if (iconPosition == BukeerButtonIconPosition.leading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [iconWidget, spacing, textWidget],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [textWidget, spacing, iconWidget],
      );
    }
  }

  // ================================
  // STYLE CALCULATIONS
  // ================================

  double? _getButtonWidth(BuildContext context) {
    switch (width) {
      case BukeerButtonWidth.auto:
        return null;
      case BukeerButtonWidth.full:
        return double.infinity;
      case BukeerButtonWidth.responsive:
        return BukeerBreakpoints.isMobile(context) ? double.infinity : null;
    }
  }

  double _getButtonHeight() {
    switch (size) {
      case BukeerButtonSize.small:
        return 32.0;
      case BukeerButtonSize.medium:
        return 40.0;
      case BukeerButtonSize.large:
        return 48.0;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case BukeerButtonSize.small:
        return BukeerBorderRadius.smallRadius;
      case BukeerButtonSize.medium:
        return BukeerBorderRadius.mediumRadius;
      case BukeerButtonSize.large:
        return BukeerBorderRadius.mediumRadius;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    if (text == null && icon != null) {
      // Icon only button - square padding
      switch (size) {
        case BukeerButtonSize.small:
          return const EdgeInsets.all(8.0);
        case BukeerButtonSize.medium:
          return const EdgeInsets.all(12.0);
        case BukeerButtonSize.large:
          return const EdgeInsets.all(16.0);
      }
    } else {
      // Text or text+icon button - horizontal padding
      switch (size) {
        case BukeerButtonSize.small:
          return BukeerSpacing.fromSTEB(12.0, 6.0, 12.0, 6.0);
        case BukeerButtonSize.medium:
          return BukeerSpacing.fromSTEB(16.0, 8.0, 16.0, 8.0);
        case BukeerButtonSize.large:
          return BukeerSpacing.fromSTEB(20.0, 12.0, 20.0, 12.0);
      }
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BukeerButtonSize.small:
        return BukeerTypography.labelMedium;
      case BukeerButtonSize.medium:
        return BukeerTypography.labelLarge;
      case BukeerButtonSize.large:
        return BukeerTypography.titleMedium;
    }
  }

  double _getIconSize() {
    switch (size) {
      case BukeerButtonSize.small:
        return 16.0;
      case BukeerButtonSize.medium:
        return 18.0;
      case BukeerButtonSize.large:
        return 20.0;
    }
  }
}

/// Button variant types
enum BukeerButtonVariant {
  primary,   // Filled button with primary color
  secondary, // Tonal button with primary color tint
  outlined,  // Outlined button with border
  text,      // Text button with no background
}

/// Button size types
enum BukeerButtonSize {
  small,  // 32px height
  medium, // 40px height  
  large,  // 48px height
}

/// Button width behavior
enum BukeerButtonWidth {
  auto,       // Width fits content
  full,       // Full width of container
  responsive, // Full width on mobile, auto on larger screens
}

/// Icon position in buttons with both text and icon
enum BukeerButtonIconPosition {
  leading,  // Icon before text
  trailing, // Icon after text
}