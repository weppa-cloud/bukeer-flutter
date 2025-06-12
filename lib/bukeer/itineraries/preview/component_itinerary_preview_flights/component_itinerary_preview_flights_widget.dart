import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_itinerary_preview_flights_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/design_system/components/index.dart';
export 'component_itinerary_preview_flights_model.dart';

class ComponentItineraryPreviewFlightsWidget extends StatefulWidget {
  const ComponentItineraryPreviewFlightsWidget({
    super.key,
    this.destination,
    this.origen,
    this.departureTime,
    this.arrivalTime,
    this.date,
    this.flightNumber,
    this.image,
    this.personalizedMessage,
  });

  final String? destination;
  final String? origen;
  final String? departureTime;
  final String? arrivalTime;
  final DateTime? date;
  final String? flightNumber;
  final String? image;
  final String? personalizedMessage;

  @override
  State<ComponentItineraryPreviewFlightsWidget> createState() =>
      _ComponentItineraryPreviewFlightsWidgetState();
}

class _ComponentItineraryPreviewFlightsWidgetState
    extends State<ComponentItineraryPreviewFlightsWidget> {
  late ComponentItineraryPreviewFlightsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => ComponentItineraryPreviewFlightsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String _extractIATACode(String? location) {
    if (location == null || location.isEmpty) return '';
    return location.split(' - ')[0];
  }

  String _extractCityName(String? location) {
    if (location == null || location.isEmpty) return '';
    final parts = location.split(' - ');
    return parts.length > 1 ? parts[1] : parts[0];
  }

  @override
  Widget build(BuildContext context) {
    final destinationCode = _extractIATACode(widget.destination);
    final destinationCity = _extractCityName(widget.destination);
    final originCode = _extractIATACode(widget.origen);
    final originCity = _extractCityName(widget.origen);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: BukeerSpacing.xs),
      child: BukeerItineraryCard(
        icon: const Icon(Icons.flight_takeoff),
        title: 'Vuelo a $destinationCity',
        subtitle: widget.flightNumber ?? '',
        accentColor: BukeerColors.info,
        trailing: widget.date != null
            ? Text(
                dateTimeFormat(
                  "yMMMd",
                  widget.date,
                  locale: FFLocalizations.of(context).languageCode,
                ),
                style: BukeerTypography.labelMedium.copyWith(
                  color: BukeerColors.textSecondary,
                ),
              )
            : null,
        content: Column(
          children: [
            // Flight route information
            Row(
              children: [
                // Origin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        originCode.maybeHandleOverflow(maxChars: 3),
                        style: BukeerTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        originCity,
                        style: BukeerTypography.bodySmall.copyWith(
                          color: BukeerColors.textSecondary,
                        ),
                      ),
                      if (widget.departureTime != null) ...[
                        SizedBox(height: BukeerSpacing.xs),
                        Text(
                          widget.departureTime!,
                          style: BukeerTypography.bodyMedium,
                        ),
                        Text(
                          'Salida',
                          style: BukeerTypography.labelSmall.copyWith(
                            color: BukeerColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Flight visual indicator
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.image != null && widget.image!.isNotEmpty)
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(bottom: BukeerSpacing.s),
                          child: ClipRRect(
                            borderRadius: BukeerBorders.radiusSmall,
                            child: Image.network(
                              widget.image!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 1,
                            color: BukeerColors.borderLight,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: BukeerSpacing.xs,
                            ),
                            child: Icon(
                              Icons.flight_takeoff,
                              size: 20,
                              color: BukeerColors.info,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 1,
                            color: BukeerColors.borderLight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Destination
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        destinationCode.maybeHandleOverflow(maxChars: 3),
                        style: BukeerTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        destinationCity,
                        style: BukeerTypography.bodySmall.copyWith(
                          color: BukeerColors.textSecondary,
                        ),
                      ),
                      if (widget.arrivalTime != null) ...[
                        SizedBox(height: BukeerSpacing.xs),
                        Text(
                          widget.arrivalTime!,
                          style: BukeerTypography.bodyMedium,
                        ),
                        Text(
                          'Llegada',
                          style: BukeerTypography.labelSmall.copyWith(
                            color: BukeerColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Personalized message
            if (widget.personalizedMessage != null &&
                widget.personalizedMessage!.isNotEmpty) ...[
              SizedBox(height: BukeerSpacing.m),
              Container(
                width: double.infinity,
                padding: BukeerSpacing.all12,
                decoration: BoxDecoration(
                  color: BukeerColors.info.withOpacity(0.1),
                  borderRadius: BukeerBorders.radiusSmall,
                  border: Border.all(
                    color: BukeerColors.info.withOpacity(0.3),
                    width: BukeerBorders.widthThin,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: BukeerColors.info,
                    ),
                    SizedBox(width: BukeerSpacing.s),
                    Expanded(
                      child: Text(
                        widget.personalizedMessage!,
                        style: BukeerTypography.bodySmall.copyWith(
                          color: BukeerColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
