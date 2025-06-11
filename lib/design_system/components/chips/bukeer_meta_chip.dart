import 'package:flutter/material.dart';
import '../../tokens/index.dart';

/// A compact chip component for displaying metadata with an icon
class BukeerMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  const BukeerMetaChip({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: BukeerSpacing.s,
        vertical: BukeerSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark
                ? BukeerColors.surfaceSecondaryDark
                : BukeerColors.surfaceSecondary),
        borderRadius: BukeerBorders.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor ?? BukeerColors.textSecondary,
          ),
          SizedBox(width: BukeerSpacing.xs),
          Text(
            text,
            style: BukeerTypography.bodySmall.copyWith(
              color: textColor ?? BukeerColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Predefined styles for common meta chip use cases
class BukeerMetaChipStyles {
  BukeerMetaChipStyles._();

  static BukeerMetaChip person({required String text}) {
    return BukeerMetaChip(
      icon: Icons.person_outline,
      text: text,
      iconColor: BukeerColors.primary,
    );
  }

  static BukeerMetaChip date({required String text}) {
    return BukeerMetaChip(
      icon: Icons.date_range,
      text: text,
      iconColor: BukeerColors.info,
    );
  }

  static BukeerMetaChip location({required String text}) {
    return BukeerMetaChip(
      icon: Icons.location_on_outlined,
      text: text,
      iconColor: BukeerColors.warning,
    );
  }

  static BukeerMetaChip status({required String text, required bool isActive}) {
    return BukeerMetaChip(
      icon: isActive ? Icons.check_circle_outline : Icons.pending_outlined,
      text: text,
      iconColor: isActive ? BukeerColors.success : BukeerColors.warning,
    );
  }
}
