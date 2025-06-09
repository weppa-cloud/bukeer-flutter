import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_itinerary_preview_flights_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        decoration: BoxDecoration(
          color: BukeerColors.getBackground(context, secondary: true),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: BukeerColors.primaryAccent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: BukeerColors.primary,
                        width: 2.0,
                      ),
                    ),
                    child: Icon(
                      Icons.flight,
                      color: BukeerColors.secondaryText,
                      size: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      child: Text(
                        'Vuelo a ${valueOrDefault<String>(
                          (String destino) {
                            return destino.split(' - ')[1];
                          }(widget!.destination!),
                          'Destino',
                        )}',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineSmallFamily,
                                  fontSize: BukeerTypography.bodyMediumSize,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineSmallIsCustom,
                                ),
                      ),
                    ),
                  ),
                  Text(
                    dateTimeFormat(
                      "yMMMd",
                      widget!.date,
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelSmallFamily,
                          color: BukeerColors.primaryText,
                          fontSize: BukeerTypography.bodySmallSize,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelSmallIsCustom,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: BukeerColors.getBackground(context, secondary: true),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0.0,
                        color: BukeerColors.primary,
                        offset: Offset(
                          -2.0,
                          0.0,
                        ),
                      )
                    ],
                    border: Border.all(
                      color:
                          BukeerColors.getBackground(context, secondary: true),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 8.0, 12.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    (String origen) {
                                      return origen.split(' - ')[0];
                                    }(widget!.origen!),
                                    'Código IATA ',
                                  ).maybeHandleOverflow(
                                    maxChars: 3,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .headlineSmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize:
                                            BukeerTypography.bodySmallSize,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .headlineSmallIsCustom,
                                      ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    (String origen) {
                                      return origen.split(' - ')[1];
                                    }(widget!.origen!),
                                    'Origen',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    widget!.departureTime,
                                    'Desconocido',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyLargeFamily,
                                        fontSize:
                                            BukeerTypography.bodySmallSize,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyLargeIsCustom,
                                      ),
                                ),
                                Text(
                                  'Salida',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(BukeerSpacing.l),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(BukeerSpacing.s),
                                    child: Image.network(
                                      valueOrDefault<String>(
                                        widget!.image,
                                        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/airline-default.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.flight_takeoff_sharp,
                                  color: BukeerColors.primary,
                                  size: 24.0,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    (String destination) {
                                      return destination.split(' - ')[0];
                                    }(widget!.destination!),
                                    'Código IATA ',
                                  ).maybeHandleOverflow(
                                    maxChars: 3,
                                  ),
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .headlineSmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize:
                                            BukeerTypography.bodySmallSize,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .headlineSmallIsCustom,
                                      ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    (String destino) {
                                      return destino.split(' - ')[1];
                                    }(widget!.destination!),
                                    'Destino',
                                  ),
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    widget!.arrivalTime,
                                    'Desconocido',
                                  ),
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyLargeFamily,
                                        fontSize:
                                            BukeerTypography.bodySmallSize,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyLargeIsCustom,
                                      ),
                                ),
                                Text(
                                  'Llegada',
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (widget!.personalizedMessage != null &&
                          widget!.personalizedMessage != '')
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: BukeerColors.secondaryText,
                                size: 16.0,
                              ),
                              Flexible(
                                child: Text(
                                  valueOrDefault<String>(
                                    widget!.personalizedMessage,
                                    'Sin mensaje',
                                  ),
                                  maxLines: 3,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize:
                                            BukeerTypography.bodySmallSize,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(width: BukeerSpacing.xs)),
                          ),
                        ),
                    ].addToEnd(SizedBox(height: BukeerSpacing.s)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
