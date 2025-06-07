import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/index.dart';

/// BukeerIconButton - Botón de icono consistente con el sistema de diseño Bukeer
///
/// Este componente reemplaza FlutterFlowIconButton y usa los design tokens
/// para mantener consistencia visual en toda la aplicación.
///
/// Ejemplo de uso:
/// ```dart
/// BukeerIconButton(
///   icon: Icon(Icons.edit),
///   onPressed: () => print('Editar'),
///   size: BukeerIconButtonSize.medium,
/// )
/// ```
class BukeerIconButton extends StatefulWidget {
  const BukeerIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.size = BukeerIconButtonSize.medium,
    this.variant = BukeerIconButtonVariant.ghost,
    this.fillColor,
    this.borderColor,
    this.iconColor,
    this.hoverColor,
    this.hoverIconColor,
    this.hoverBorderColor,
    this.disabledColor,
    this.disabledIconColor,
    this.borderWidth,
    this.borderRadius,
    this.showLoadingIndicator = false,
    this.tooltip,
  }) : super(key: key);

  /// El icono a mostrar (puede ser Icon o FaIcon)
  final Widget icon;

  /// Callback cuando se presiona el botón
  final VoidCallback? onPressed;

  /// Tamaño predefinido del botón
  final BukeerIconButtonSize size;

  /// Variante visual del botón
  final BukeerIconButtonVariant variant;

  /// Color de fondo personalizado (sobrescribe variant)
  final Color? fillColor;

  /// Color del borde personalizado
  final Color? borderColor;

  /// Color del icono personalizado
  final Color? iconColor;

  /// Color de fondo en hover
  final Color? hoverColor;

  /// Color del icono en hover
  final Color? hoverIconColor;

  /// Color del borde en hover
  final Color? hoverBorderColor;

  /// Color cuando está deshabilitado
  final Color? disabledColor;

  /// Color del icono cuando está deshabilitado
  final Color? disabledIconColor;

  /// Ancho del borde
  final double? borderWidth;

  /// Radio del borde (usa tokens por defecto)
  final double? borderRadius;

  /// Mostrar indicador de carga
  final bool showLoadingIndicator;

  /// Tooltip opcional
  final String? tooltip;

  @override
  State<BukeerIconButton> createState() => _BukeerIconButtonState();
}

class _BukeerIconButtonState extends State<BukeerIconButton> {
  bool loading = false;
  late double? iconSize;
  late Color? iconColor;
  late Widget effectiveIcon;

  @override
  void initState() {
    super.initState();
    _updateIcon();
  }

  @override
  void didUpdateWidget(BukeerIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateIcon();
  }

  void _updateIcon() {
    final isFontAwesome = widget.icon is FaIcon;
    if (isFontAwesome) {
      FaIcon icon = widget.icon as FaIcon;
      effectiveIcon = FaIcon(
        icon.icon,
        size: icon.size ?? widget.size.iconSize,
      );
      iconSize = icon.size ?? widget.size.iconSize;
      iconColor = widget.iconColor ?? icon.color ?? _getDefaultIconColor();
    } else {
      Icon icon = widget.icon as Icon;
      effectiveIcon = Icon(
        icon.icon,
        size: icon.size ?? widget.size.iconSize,
      );
      iconSize = icon.size ?? widget.size.iconSize;
      iconColor = widget.iconColor ?? icon.color ?? _getDefaultIconColor();
    }
  }

  Color _getDefaultIconColor() {
    switch (widget.variant) {
      case BukeerIconButtonVariant.filled:
        return BukeerColors.textInverse;
      case BukeerIconButtonVariant.outlined:
        return BukeerColors.primary;
      case BukeerIconButtonVariant.ghost:
        return BukeerColors.textPrimary;
      case BukeerIconButtonVariant.danger:
        return BukeerColors.error;
    }
  }

  Color _getDefaultFillColor() {
    switch (widget.variant) {
      case BukeerIconButtonVariant.filled:
        return BukeerColors.primary;
      case BukeerIconButtonVariant.outlined:
        return Colors.transparent;
      case BukeerIconButtonVariant.ghost:
        return Colors.transparent;
      case BukeerIconButtonVariant.danger:
        return Colors.transparent;
    }
  }

  Color _getDefaultBorderColor() {
    switch (widget.variant) {
      case BukeerIconButtonVariant.filled:
        return Colors.transparent;
      case BukeerIconButtonVariant.outlined:
        return BukeerColors.primary;
      case BukeerIconButtonVariant.ghost:
        return Colors.transparent;
      case BukeerIconButtonVariant.danger:
        return Colors.transparent;
    }
  }

  Color _getDefaultHoverColor() {
    switch (widget.variant) {
      case BukeerIconButtonVariant.filled:
        return BukeerColors.primaryDark;
      case BukeerIconButtonVariant.outlined:
        return BukeerColors.primaryLight.withOpacity(0.1);
      case BukeerIconButtonVariant.ghost:
        return BukeerColors.backgroundSecondary;
      case BukeerIconButtonVariant.danger:
        return BukeerColors.errorLight.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double buttonSize = widget.size.buttonSize;
    final double radius = widget.borderRadius ?? BukeerSpacing.s;

    ButtonStyle style = ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(buttonSize, buttonSize)),
      maximumSize: MaterialStateProperty.all(Size(buttonSize, buttonSize)),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
        (states) {
          final borderColor = states.contains(MaterialState.hovered)
              ? (widget.hoverBorderColor ??
                  widget.borderColor ??
                  _getDefaultBorderColor())
              : (widget.borderColor ?? _getDefaultBorderColor());

          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: borderColor,
              width: widget.borderWidth ??
                  (widget.variant == BukeerIconButtonVariant.outlined
                      ? 1.0
                      : 0),
            ),
          );
        },
      ),
      iconColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return widget.disabledIconColor ?? BukeerColors.textDisabled;
          }
          if (states.contains(MaterialState.hovered)) {
            return widget.hoverIconColor ?? iconColor;
          }
          return iconColor;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return widget.disabledColor ?? BukeerColors.backgroundSecondary;
          }
          if (states.contains(MaterialState.hovered)) {
            return widget.hoverColor ?? _getDefaultHoverColor();
          }
          return widget.fillColor ?? _getDefaultFillColor();
        },
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed)) {
          return BukeerColors.overlay;
        }
        return Colors.transparent;
      }),
      elevation: MaterialStateProperty.all(0),
    );

    Widget button = SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: IconButton(
        icon: (widget.showLoadingIndicator && loading)
            ? SizedBox(
                width: iconSize! * 0.8,
                height: iconSize! * 0.8,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    iconColor ?? BukeerColors.primary,
                  ),
                ),
              )
            : effectiveIcon,
        onPressed: widget.onPressed == null
            ? null
            : () {
                if (loading) return;
                if (widget.showLoadingIndicator) {
                  setState(() => loading = true);
                  try {
                    widget.onPressed!();
                  } finally {
                    if (mounted) {
                      setState(() => loading = false);
                    }
                  }
                } else {
                  widget.onPressed!();
                }
              },
        style: style,
      ),
    );

    // Agregar tooltip si está presente
    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Tamaños predefinidos para BukeerIconButton
enum BukeerIconButtonSize {
  small(buttonSize: 32, iconSize: 16),
  medium(buttonSize: 40, iconSize: 20),
  large(buttonSize: 48, iconSize: 24);

  final double buttonSize;
  final double iconSize;

  const BukeerIconButtonSize({
    required this.buttonSize,
    required this.iconSize,
  });
}

/// Variantes visuales para BukeerIconButton
enum BukeerIconButtonVariant {
  /// Botón con fondo sólido
  filled,

  /// Botón con solo borde
  outlined,

  /// Botón sin fondo ni borde (solo hover)
  ghost,

  /// Botón para acciones peligrosas
  danger,
}
