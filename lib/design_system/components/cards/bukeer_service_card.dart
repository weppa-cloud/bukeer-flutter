import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../buttons/bukeer_icon_button.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart' show getJsonField;

enum ServiceCardType { flight, hotel, activity, transfer }

/// A service card component following the Bukeer design system
/// Used for displaying service information (flights, hotels, activities, transfers)
class BukeerServiceCard extends StatelessWidget {
  final ServiceCardType type;
  final dynamic data;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool showActions;

  const BukeerServiceCard({
    super.key,
    required this.type,
    required this.data,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      padding: BukeerSpacing.all16,
      decoration: BoxDecoration(
        color: BukeerColors.surfacePrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: (isDark ? BukeerColors.alternateDark : BukeerColors.alternate),
          width: BukeerBorders.widthThin,
        ),
        boxShadow: BukeerShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Service icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(context),
                  borderRadius: BukeerBorders.radiusSmall,
                ),
                child: Icon(
                  _getServiceIcon(),
                  size: 24,
                  color: _getIconColor(context),
                ),
              ),
              SizedBox(width: BukeerSpacing.m),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(),
                      style: BukeerTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: BukeerSpacing.xs),
                    Text(
                      _getSubtitle(),
                      style: BukeerTypography.bodySmall.copyWith(
                        color: BukeerColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              if (showActions) ...[
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
          SizedBox(height: BukeerSpacing.m),
          // Service specific content
          _buildServiceContent(context),
          // Price
          if (_hasPrice()) ...[
            SizedBox(height: BukeerSpacing.m),
            _buildPriceSection(context),
          ],
        ],
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

  IconData _getServiceIcon() {
    switch (type) {
      case ServiceCardType.flight:
        return Icons.flight_takeoff;
      case ServiceCardType.hotel:
        return Icons.hotel;
      case ServiceCardType.activity:
        return Icons.local_activity;
      case ServiceCardType.transfer:
        return Icons.directions_car;
    }
  }

  Color _getIconBackgroundColor(BuildContext context) {
    switch (type) {
      case ServiceCardType.flight:
        return BukeerColors.info.withOpacity(0.1);
      case ServiceCardType.hotel:
        return BukeerColors.warning.withOpacity(0.1);
      case ServiceCardType.activity:
        return BukeerColors.success.withOpacity(0.1);
      case ServiceCardType.transfer:
        return BukeerColors.primary.withOpacity(0.1);
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (type) {
      case ServiceCardType.flight:
        return BukeerColors.info;
      case ServiceCardType.hotel:
        return BukeerColors.warning;
      case ServiceCardType.activity:
        return BukeerColors.success;
      case ServiceCardType.transfer:
        return BukeerColors.primary;
    }
  }

  String _getTitle() {
    switch (type) {
      case ServiceCardType.flight:
        final airline =
            getJsonField(data, r'$.airline')?.toString() ?? 'Airline';
        final flightNumber =
            getJsonField(data, r'$.flight_number')?.toString() ?? '';
        return '$airline $flightNumber';
      case ServiceCardType.hotel:
        return getJsonField(data, r'$.name')?.toString() ?? 'Hotel';
      case ServiceCardType.activity:
        return getJsonField(data, r'$.name')?.toString() ?? 'Activity';
      case ServiceCardType.transfer:
        return getJsonField(data, r'$.type')?.toString() ?? 'Transfer';
    }
  }

  String _getSubtitle() {
    switch (type) {
      case ServiceCardType.flight:
        final originCode =
            getJsonField(data, r'$.origin_code')?.toString() ?? '';
        final destCode =
            getJsonField(data, r'$.destination_code')?.toString() ?? '';
        return '$originCode → $destCode';
      case ServiceCardType.hotel:
        return getJsonField(data, r'$.location')?.toString() ?? 'Location';
      case ServiceCardType.activity:
        return getJsonField(data, r'$.location')?.toString() ?? 'Location';
      case ServiceCardType.transfer:
        final from = getJsonField(data, r'$.from')?.toString() ?? '';
        final to = getJsonField(data, r'$.to')?.toString() ?? '';
        return '$from → $to';
    }
  }

  Widget _buildServiceContent(BuildContext context) {
    switch (type) {
      case ServiceCardType.flight:
        return _buildFlightContent(context);
      case ServiceCardType.hotel:
        return _buildHotelContent(context);
      case ServiceCardType.activity:
        return _buildActivityContent(context);
      case ServiceCardType.transfer:
        return _buildTransferContent(context);
    }
  }

  Widget _buildFlightContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final originCity = getJsonField(data, r'$.origin_city')?.toString() ?? '';
    final destCity =
        getJsonField(data, r'$.destination_city')?.toString() ?? '';
    final departureTime =
        getJsonField(data, r'$.departure_time')?.toString() ?? '';
    final arrivalTime = getJsonField(data, r'$.arrival_time')?.toString() ?? '';
    final departureDate =
        getJsonField(data, r'$.departure_date')?.toString() ?? '';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    originCity,
                    style: BukeerTypography.bodyMedium,
                  ),
                  Text(
                    departureTime,
                    style: BukeerTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.flight_takeoff,
                  size: 16,
                  color: BukeerColors.textSecondary,
                ),
                Container(
                  width: 60,
                  height: 1,
                  color: (isDark
                      ? BukeerColors.alternateDark
                      : BukeerColors.alternate),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    destCity,
                    style: BukeerTypography.bodyMedium,
                  ),
                  Text(
                    arrivalTime,
                    style: BukeerTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (departureDate.isNotEmpty) ...[
          SizedBox(height: BukeerSpacing.s),
          Text(
            _formatDate(departureDate),
            style: BukeerTypography.bodySmall.copyWith(
              color: BukeerColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHotelContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final checkIn = getJsonField(data, r'$.check_in')?.toString() ?? '';
    final checkOut = getJsonField(data, r'$.check_out')?.toString() ?? '';
    final nights = getJsonField(data, r'$.nights')?.toInt() ?? 0;
    final roomType =
        getJsonField(data, r'$.room_type')?.toString() ?? 'Standard';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check-in',
                style: BukeerTypography.labelSmall.copyWith(
                  color: BukeerColors.textSecondary,
                ),
              ),
              Text(
                _formatDate(checkIn),
                style: BukeerTypography.bodyMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check-out',
                style: BukeerTypography.labelSmall.copyWith(
                  color: BukeerColors.textSecondary,
                ),
              ),
              Text(
                _formatDate(checkOut),
                style: BukeerTypography.bodyMedium,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$nights ${nights == 1 ? 'noche' : 'noches'}',
              style: BukeerTypography.bodySmall.copyWith(
                color: BukeerColors.textSecondary,
              ),
            ),
            Text(
              roomType,
              style: BukeerTypography.bodySmall.copyWith(
                color: BukeerColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final date = getJsonField(data, r'$.date')?.toString() ?? '';
    final time = getJsonField(data, r'$.time')?.toString() ?? '';
    final duration = getJsonField(data, r'$.duration')?.toString() ?? '';
    final participants = getJsonField(data, r'$.participants')?.toInt() ?? 0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(date),
                style: BukeerTypography.bodyMedium,
              ),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: BukeerTypography.bodySmall.copyWith(
                    color: BukeerColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        if (duration.isNotEmpty)
          Text(
            duration,
            style: BukeerTypography.bodySmall.copyWith(
              color: BukeerColors.textSecondary,
            ),
          ),
        if (participants > 0) ...[
          SizedBox(width: BukeerSpacing.m),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: BukeerSpacing.s,
              vertical: BukeerSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: BukeerColors.primary.withOpacity(0.1),
              borderRadius: BukeerBorders.radiusSmall,
            ),
            child: Text(
              '$participants pax',
              style: BukeerTypography.labelSmall.copyWith(
                color: BukeerColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTransferContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final date = getJsonField(data, r'$.date')?.toString() ?? '';
    final time = getJsonField(data, r'$.time')?.toString() ?? '';
    final vehicleType =
        getJsonField(data, r'$.vehicle_type')?.toString() ?? 'Standard';
    final passengers = getJsonField(data, r'$.passengers')?.toInt() ?? 0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(date),
                style: BukeerTypography.bodyMedium,
              ),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: BukeerTypography.bodySmall.copyWith(
                    color: BukeerColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              vehicleType,
              style: BukeerTypography.bodySmall.copyWith(
                color: BukeerColors.textSecondary,
              ),
            ),
            if (passengers > 0)
              Text(
                '$passengers pasajeros',
                style: BukeerTypography.bodySmall.copyWith(
                  color: BukeerColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  bool _hasPrice() {
    final price = getJsonField(data, r'$.price');
    return price != null &&
        (price is num ? price > 0 : double.tryParse(price.toString()) != null);
  }

  Widget _buildPriceSection(BuildContext context) {
    final price = getJsonField(data, r'$.price')?.toDouble() ?? 0.0;
    final currency = getJsonField(data, r'$.currency')?.toString() ?? 'USD';

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '\$$price $currency',
          style: BukeerTypography.titleMedium.copyWith(
            color: BukeerColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
