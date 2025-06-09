import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_itinerary_preview_transfers_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'component_itinerary_preview_transfers_model.dart';

class ComponentItineraryPreviewTransfersWidget extends StatefulWidget {
  const ComponentItineraryPreviewTransfersWidget({
    super.key,
    this.date,
    this.name,
    this.departureTime,
    this.description,
    this.location,
    this.image,
    this.passengers,
    this.personalizedMessage,
  });

  final DateTime? date;
  final String? name;
  final String? departureTime;
  final String? description;
  final String? location;
  final String? image;
  final double? passengers;
  final String? personalizedMessage;

  @override
  State<ComponentItineraryPreviewTransfersWidget> createState() =>
      _ComponentItineraryPreviewTransfersWidgetState();
}

class _ComponentItineraryPreviewTransfersWidgetState
    extends State<ComponentItineraryPreviewTransfersWidget> {
  late ComponentItineraryPreviewTransfersModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => ComponentItineraryPreviewTransfersModel());

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
        constraints: BoxConstraints(
          maxWidth: 900.0,
        ),
        decoration: BoxDecoration(
          color: BukeerColors.getBackground(context, secondary: true),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
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
                      Icons.directions_car,
                      color: BukeerColors.secondaryText,
                      size: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: BukeerSpacing.s),
                      child: Text(
                        'Transfer',
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
                          fontWeight: FontWeight.normal,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelSmallIsCustom,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 1.0,
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 12.0, 12.0, 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          valueOrDefault<String>(
                                            widget!.name,
                                            'Desconocido',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                fontSize: BukeerTypography
                                                    .bodySmallSize,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 1.0,
                                    runSpacing: 0.0,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.antiAlias,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 4.0, 0.0),
                                            child: Icon(
                                              Icons.location_pin,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 16.0,
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 8.0, 0.0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  widget!.location,
                                                  'Ubicación',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 4.0, 0.0),
                                            child: Icon(
                                              Icons.people,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 16.0,
                                            ),
                                          ),
                                          Text(
                                            valueOrDefault<String>(
                                              widget!.passengers?.toString(),
                                              '1',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      widget!.description,
                                      'Descripción',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                          fontSize:
                                              BukeerTypography.bodySmallSize,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyLargeIsCustom,
                                        ),
                                  ),
                                  if (widget!.personalizedMessage != null &&
                                      widget!.personalizedMessage != '')
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 16.0,
                                        ),
                                        Flexible(
                                          child: Text(
                                            valueOrDefault<String>(
                                              widget!.personalizedMessage,
                                              'Sin mensaje',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLargeFamily,
                                                  fontSize: BukeerTypography
                                                      .bodySmallSize,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                      ].divide(
                                          SizedBox(width: BukeerSpacing.xs)),
                                    ),
                                ].divide(SizedBox(height: BukeerSpacing.xs)),
                              ),
                            ),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(BukeerSpacing.s),
                              child: Image.network(
                                valueOrDefault<String>(
                                  widget!.image != null && widget!.image != ''
                                      ? widget!.image
                                      : 'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/transfer.jpeg',
                                  'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/transfer.jpeg',
                                ),
                                width: 80.0,
                                height: 80.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
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
