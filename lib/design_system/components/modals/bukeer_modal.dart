import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../buttons/bukeer_button.dart';

/// Standardized modal component for the Bukeer application
/// Replaces inconsistent modal implementations throughout the app
/// 
/// Features:
/// - Consistent sizing and spacing
/// - Responsive behavior
/// - Standardized header, body, and footer layout
/// - Loading states
/// - Custom action buttons
/// - Accessibility compliance
class BukeerModal extends StatelessWidget {
  /// Modal title
  final String? title;
  
  /// Modal subtitle (optional)
  final String? subtitle;
  
  /// Modal body content
  final Widget body;
  
  /// Primary action button
  final BukeerModalAction? primaryAction;
  
  /// Secondary action button  
  final BukeerModalAction? secondaryAction;
  
  /// Additional action buttons
  final List<BukeerModalAction>? additionalActions;
  
  /// Modal size variant
  final BukeerModalSize size;
  
  /// Whether modal can be dismissed by tapping outside
  final bool dismissible;
  
  /// Whether modal is in loading state
  final bool isLoading;
  
  /// Custom header widget (overrides title/subtitle)
  final Widget? customHeader;
  
  /// Custom footer widget (overrides action buttons)
  final Widget? customFooter;
  
  /// Close button callback (optional - shows X button in header)
  final VoidCallback? onClose;

  const BukeerModal({
    Key? key,
    this.title,
    this.subtitle,
    required this.body,
    this.primaryAction,
    this.secondaryAction,
    this.additionalActions,
    this.size = BukeerModalSize.medium,
    this.dismissible = true,
    this.isLoading = false,
    this.customHeader,
    this.customFooter,
    this.onClose,
  }) : super(key: key);

  /// Show modal as a dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required BukeerModal modal,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible && modal.dismissible,
      builder: (context) => modal,
    );
  }

  /// Show modal as a bottom sheet (mobile-friendly)
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required BukeerModal modal,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible && modal.dismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BottomSheetWrapper(child: modal),
    );
  }

  /// Show responsive modal (dialog on desktop, bottom sheet on mobile)
  static Future<T?> showResponsive<T>({
    required BuildContext context,
    required BukeerModal modal,
    bool barrierDismissible = true,
  }) {
    if (BukeerBreakpoints.isMobile(context)) {
      return showBottomSheet<T>(
        context: context,
        modal: modal,
        isDismissible: barrierDismissible,
      );
    } else {
      return show<T>(
        context: context,
        modal: modal,
        barrierDismissible: barrierDismissible,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: _getDialogPadding(context),
      child: _buildModalContainer(context),
    );
  }

  Widget _buildModalContainer(BuildContext context) {
    return Container(
      width: _getModalWidth(context),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        maxWidth: _getMaxWidth(),
      ),
      decoration: BoxDecoration(
        color: BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorderRadius.largeRadius,
        boxShadow: BukeerElevation.shadow4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          if (customHeader != null || title != null)
            _buildHeader(context),
          
          // Body
          Flexible(
            child: _buildBody(context),
          ),
          
          // Footer
          if (customFooter != null || _hasActions())
            _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (customHeader != null) {
      return customHeader!;
    }

    return Container(
      padding: BukeerSpacing.fromSTEB(24.0, 24.0, 24.0, 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BukeerColors.borderPrimary,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: BukeerTypography.titleLarge,
                  ),
                if (subtitle != null) ...[
                  SizedBox(height: BukeerSpacing.xs),
                  Text(
                    subtitle!,
                    style: BukeerTypography.bodyMedium.copyWith(
                      color: BukeerColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close,
                color: BukeerColors.textSecondary,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(
                minWidth: 32.0,
                minHeight: 32.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget bodyContent = Container(
      padding: BukeerSpacing.all24,
      child: body,
    );

    if (isLoading) {
      bodyContent = Stack(
        children: [
          bodyContent,
          Positioned.fill(
            child: Container(
              color: BukeerColors.overlay,
              child: Center(
                child: Container(
                  padding: BukeerSpacing.all24,
                  decoration: BoxDecoration(
                    color: BukeerColors.backgroundPrimary,
                    borderRadius: BukeerBorderRadius.mediumRadius,
                    boxShadow: BukeerElevation.shadow2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          BukeerColors.primary,
                        ),
                      ),
                      SizedBox(height: BukeerSpacing.md),
                      Text(
                        'Cargando...',
                        style: BukeerTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return bodyContent;
  }

  Widget _buildFooter(BuildContext context) {
    if (customFooter != null) {
      return customFooter!;
    }

    final actions = <BukeerModalAction>[
      if (secondaryAction != null) secondaryAction!,
      if (additionalActions != null) ...additionalActions!,
      if (primaryAction != null) primaryAction!,
    ];

    return Container(
      padding: BukeerSpacing.fromSTEB(24.0, 16.0, 24.0, 24.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: BukeerColors.borderPrimary,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions.map((action) {
          final index = actions.indexOf(action);
          return Padding(
            padding: EdgeInsets.only(
              left: index > 0 ? BukeerSpacing.sm : 0,
            ),
            child: _buildActionButton(action),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButton(BukeerModalAction action) {
    return BukeerButton(
      text: action.text,
      onPressed: isLoading ? null : action.onPressed,
      variant: action.variant,
      size: action.size,
      isLoading: action.isLoading,
      icon: action.icon,
    );
  }

  // ================================
  // SIZING AND LAYOUT HELPERS
  // ================================

  EdgeInsets _getDialogPadding(BuildContext context) {
    if (BukeerBreakpoints.isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (BukeerBreakpoints.isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  double? _getModalWidth(BuildContext context) {
    if (BukeerBreakpoints.isMobile(context)) {
      return double.infinity;
    }
    return null; // Let constraints handle it
  }

  double _getMaxWidth() {
    switch (size) {
      case BukeerModalSize.small:
        return 400.0;
      case BukeerModalSize.medium:
        return 600.0;
      case BukeerModalSize.large:
        return 800.0;
      case BukeerModalSize.extraLarge:
        return 1000.0;
    }
  }

  bool _hasActions() {
    return primaryAction != null || 
           secondaryAction != null || 
           (additionalActions != null && additionalActions!.isNotEmpty);
  }
}

/// Bottom sheet wrapper for mobile modal display
class _BottomSheetWrapper extends StatelessWidget {
  final Widget child;

  const _BottomSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorderRadius.topLargeRadius,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: child,
    );
  }
}

/// Modal action button configuration
class BukeerModalAction {
  /// Button text
  final String text;
  
  /// Button callback
  final VoidCallback? onPressed;
  
  /// Button variant
  final BukeerButtonVariant variant;
  
  /// Button size
  final BukeerButtonSize size;
  
  /// Button loading state
  final bool isLoading;
  
  /// Button icon (optional)
  final IconData? icon;

  const BukeerModalAction({
    required this.text,
    required this.onPressed,
    this.variant = BukeerButtonVariant.primary,
    this.size = BukeerButtonSize.medium,
    this.isLoading = false,
    this.icon,
  });

  /// Create primary action button
  const BukeerModalAction.primary({
    required String text,
    required VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
  }) : this(
          text: text,
          onPressed: onPressed,
          variant: BukeerButtonVariant.primary,
          size: size,
          isLoading: isLoading,
          icon: icon,
        );

  /// Create secondary action button
  const BukeerModalAction.secondary({
    required String text,
    required VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
  }) : this(
          text: text,
          onPressed: onPressed,
          variant: BukeerButtonVariant.outlined,
          size: size,
          isLoading: isLoading,
          icon: icon,
        );

  /// Create text action button
  const BukeerModalAction.text({
    required String text,
    required VoidCallback? onPressed,
    BukeerButtonSize size = BukeerButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
  }) : this(
          text: text,
          onPressed: onPressed,
          variant: BukeerButtonVariant.text,
          size: size,
          isLoading: isLoading,
          icon: icon,
        );
}

/// Modal size variants
enum BukeerModalSize {
  small,      // 400px max width
  medium,     // 600px max width
  large,      // 800px max width
  extraLarge, // 1000px max width
}