import 'package:flutter/material.dart';
import '../../tokens/index.dart';

/// Container for displaying price information with optional breakdown
class BukeerPriceContainer extends StatelessWidget {
  final double totalPrice;
  final double? pricePerPerson;
  final String currency;
  final String totalLabel;
  final String? perPersonLabel;
  final Axis orientation;
  final bool showCurrency;
  final bool highlighted;

  const BukeerPriceContainer({
    super.key,
    required this.totalPrice,
    this.pricePerPerson,
    this.currency = 'USD',
    this.totalLabel = 'Total',
    this.perPersonLabel = 'Por persona',
    this.orientation = Axis.horizontal,
    this.showCurrency = true,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final content = orientation == Axis.horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildPriceContent(context),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _buildPriceContent(context),
          );

    if (highlighted) {
      return Container(
        padding: EdgeInsets.all(BukeerSpacing.m),
        decoration: BoxDecoration(
          color: BukeerColors.primary.withOpacity(0.1),
          borderRadius: BukeerBorders.radiusMedium,
          border: Border.all(
            color: BukeerColors.primary.withOpacity(0.3),
            width: BukeerBorders.widthThin,
          ),
        ),
        child: content,
      );
    }

    return content;
  }

  List<Widget> _buildPriceContent(BuildContext context) {
    final widgets = <Widget>[];

    // Per person price (if provided)
    if (pricePerPerson != null) {
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              perPersonLabel ?? 'Por persona',
              style: BukeerTypography.labelSmall.copyWith(
                color: BukeerColors.textSecondary,
              ),
            ),
            Text(
              _formatPrice(pricePerPerson!),
              style: BukeerTypography.bodyMedium.copyWith(
                color: BukeerColors.textPrimary,
              ),
            ),
          ],
        ),
      );

      if (orientation == Axis.horizontal) {
        widgets.add(SizedBox(width: BukeerSpacing.l));
      } else {
        widgets.add(SizedBox(height: BukeerSpacing.m));
      }
    }

    // Total price
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            totalLabel,
            style: BukeerTypography.labelSmall.copyWith(
              color: BukeerColors.textSecondary,
            ),
          ),
          Text(
            _formatPrice(totalPrice),
            style: BukeerTypography.titleLarge.copyWith(
              color:
                  highlighted ? BukeerColors.primary : BukeerColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return widgets;
  }

  String _formatPrice(double price) {
    final formattedPrice = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    if (showCurrency) {
      return '\$$formattedPrice $currency';
    }
    return '\$$formattedPrice';
  }
}

/// Predefined price container styles
class BukeerPriceContainerStyles {
  BukeerPriceContainerStyles._();

  static BukeerPriceContainer compact({
    required double totalPrice,
    String currency = 'USD',
  }) {
    return BukeerPriceContainer(
      totalPrice: totalPrice,
      currency: currency,
      showCurrency: false,
    );
  }

  static BukeerPriceContainer detailed({
    required double totalPrice,
    required double pricePerPerson,
    String currency = 'USD',
  }) {
    return BukeerPriceContainer(
      totalPrice: totalPrice,
      pricePerPerson: pricePerPerson,
      currency: currency,
      orientation: Axis.vertical,
    );
  }

  static BukeerPriceContainer highlighted({
    required double totalPrice,
    double? pricePerPerson,
    String currency = 'USD',
  }) {
    return BukeerPriceContainer(
      totalPrice: totalPrice,
      pricePerPerson: pricePerPerson,
      currency: currency,
      highlighted: true,
    );
  }
}
