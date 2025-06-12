import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../buttons/bukeer_icon_button.dart';

/// Base card component for itinerary items with consistent design
/// Provides a unified structure for all itinerary service cards
class BukeerItineraryCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget content;
  final Widget? footer;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final Color? accentColor;
  final bool showDivider;
  final Widget? trailing;

  const BukeerItineraryCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.content,
    this.footer,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
    this.accentColor,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveAccentColor = accentColor ?? BukeerColors.primary;

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: BukeerColors.surfacePrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark ? BukeerColors.borderDark : BukeerColors.border,
          width: BukeerBorders.widthThin,
        ),
        boxShadow: [
          BoxShadow(
            color: BukeerColors.shadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BukeerBorders.radiusMedium,
        child: Row(
          children: [
            // Left accent border
            Container(
              width: 4,
              height: double.infinity,
              color: effectiveAccentColor,
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: BukeerSpacing.all16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        // Icon container
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: effectiveAccentColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconTheme(
                              data: IconThemeData(
                                color: effectiveAccentColor,
                                size: 20,
                              ),
                              child: icon,
                            ),
                          ),
                        ),
                        SizedBox(width: BukeerSpacing.m),
                        // Title and subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: BukeerTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (subtitle != null) ...[
                                SizedBox(height: BukeerSpacing.xxs),
                                Text(
                                  subtitle!,
                                  style: BukeerTypography.bodySmall.copyWith(
                                    color: BukeerColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Trailing widget or actions
                        if (trailing != null) trailing!,
                        if (showActions && trailing == null) ...[
                          BukeerIconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: onEdit,
                            variant: BukeerIconButtonVariant.ghost,
                            size: BukeerIconButtonSize.small,
                          ),
                          SizedBox(width: BukeerSpacing.xs),
                          BukeerIconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: onDelete,
                            variant: BukeerIconButtonVariant.ghost,
                            size: BukeerIconButtonSize.small,
                          ),
                        ],
                      ],
                    ),
                    // Divider
                    if (showDivider) ...[
                      SizedBox(height: BukeerSpacing.m),
                      Divider(
                        color: isDark
                            ? BukeerColors.borderDark
                            : BukeerColors.border,
                        height: 1,
                      ),
                    ],
                    // Main content
                    SizedBox(height: BukeerSpacing.m),
                    content,
                    // Footer
                    if (footer != null) ...[
                      SizedBox(height: BukeerSpacing.m),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BukeerBorders.radiusMedium,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Helper widget for card metrics display
class BukeerCardMetric extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const BukeerCardMetric({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: BukeerTypography.labelSmall.copyWith(
            color: BukeerColors.textTertiary,
          ),
        ),
        SizedBox(height: BukeerSpacing.xxs),
        Text(
          value,
          style: valueStyle ?? BukeerTypography.bodyMedium,
        ),
      ],
    );
  }
}

/// Helper widget for card price display
class BukeerCardPrice extends StatelessWidget {
  final String amount;
  final String? currency;
  final String? label;
  final bool isLarge;

  const BukeerCardPrice({
    super.key,
    required this.amount,
    this.currency = 'USD',
    this.label,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: BukeerTypography.labelSmall.copyWith(
              color: BukeerColors.textSecondary,
            ),
          ),
          SizedBox(width: BukeerSpacing.s),
        ],
        Text(
          '\$$amount',
          style: (isLarge
                  ? BukeerTypography.metricMedium
                  : BukeerTypography.titleMedium)
              .copyWith(
            color: BukeerColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (currency != null && currency != 'USD') ...[
          SizedBox(width: BukeerSpacing.xs),
          Text(
            currency!,
            style: BukeerTypography.labelMedium.copyWith(
              color: BukeerColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Helper widget for card badge/chip display
class BukeerCardBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const BukeerCardBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? BukeerColors.primary.withOpacity(0.1);
    final fgColor = textColor ?? BukeerColors.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: BukeerSpacing.s,
        vertical: BukeerSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BukeerBorders.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fgColor),
            SizedBox(width: BukeerSpacing.xs),
          ],
          Text(
            text,
            style: BukeerTypography.labelSmall.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
