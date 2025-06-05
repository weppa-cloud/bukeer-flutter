import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_container_activities_model.dart';
export 'component_container_activities_model.dart';

class ComponentContainerActivitiesWidget extends StatefulWidget {
  const ComponentContainerActivitiesWidget({
    super.key,
    required this.name,
    this.location,
    this.descriptionShort,
    this.image,
    this.provider,
    this.locationName,
  });

  final String? name;
  final String? location;
  final String? descriptionShort;
  final String? image;
  final String? provider;
  final String? locationName;

  @override
  State<ComponentContainerActivitiesWidget> createState() =>
      _ComponentContainerActivitiesWidgetState();
}

class _ComponentContainerActivitiesWidgetState
    extends State<ComponentContainerActivitiesWidget> {
  late ComponentContainerActivitiesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentContainerActivitiesModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 8.0),
      child: Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          valueOrDefault<String>(
                            widget!.image,
                            'https://images.unsplash.com/photo-1663659506570-067bf9e9937f?w=500&h=500',
                          ),
                          width: 50.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget!.name,
                                'Sin nombre',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleLargeFamily,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    lineHeight: 1.5,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleLargeIsCustom,
                                  ),
                            ),
                            Text(
                              valueOrDefault<String>(
                                widget!.provider,
                                'Proveedor',
                              ).maybeHandleOverflow(
                                maxChars: 200,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 16.0,
                                ),
                                Flexible(
                                  child: Text(
                                    valueOrDefault<String>(
                                      () {
                                        if (widget!.location != null &&
                                            widget!.location != '') {
                                          return widget!.location;
                                        } else if (widget!.location == 'null') {
                                          return 'Desconocida';
                                        } else {
                                          return widget!.locationName;
                                        }
                                      }(),
                                      'Desconocida',
                                    ).maybeHandleOverflow(
                                      maxChars: 200,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelMediumIsCustom,
                                        ),
                                  ),
                                ),
                                RatingBar.builder(
                                  onRatingUpdate: (newValue) => safeSetState(
                                      () => _model.ratingBarValue = newValue),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  direction: Axis.horizontal,
                                  initialRating: _model.ratingBarValue ??= 5.0,
                                  unratedColor:
                                      FlutterFlowTheme.of(context).accent1,
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  glowColor:
                                      FlutterFlowTheme.of(context).primary,
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    (String description) {
                                      return description.replaceAll(
                                          '\\n', '\n');
                                    }(widget!.descriptionShort!)
                                        .maybeHandleOverflow(
                                      maxChars: 160,
                                      replacement: '…',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodySmallIsCustom,
                                        ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 16.0,
                    ),
                  ].divide(SizedBox(width: 12.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
