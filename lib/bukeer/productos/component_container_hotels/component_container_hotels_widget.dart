import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_container_hotels_model.dart';
export 'component_container_hotels_model.dart';

class ComponentContainerHotelsWidget extends StatefulWidget {
  const ComponentContainerHotelsWidget({
    super.key,
    required this.name,
    this.location,
    this.descriptionShort,
    this.image,
  });

  final String? name;
  final String? location;
  final String? descriptionShort;
  final String? image;

  @override
  State<ComponentContainerHotelsWidget> createState() =>
      _ComponentContainerHotelsWidgetState();
}

class _ComponentContainerHotelsWidgetState
    extends State<ComponentContainerHotelsWidget> {
  late ComponentContainerHotelsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentContainerHotelsModel());

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
          borderRadius: BorderRadius.circular(BukeerSpacing.m),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: BukeerColors.secondaryBackground,
            borderRadius: BorderRadius.circular(BukeerSpacing.m),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(BukeerSpacing.s),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                        child: Image.network(
                          widget!.image!,
                          width: 88.0,
                          height: 27.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: BukeerSpacing.s),
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
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleLargeIsCustom,
                                  ),
                            ),
                            Text(
                              'Nombre Proveedor',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    color: BukeerColors.primary,
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
                                Text(
                                  valueOrDefault<String>(
                                    widget!.location,
                                    'Desconocida',
                                  ).maybeHandleOverflow(
                                    maxChars: 200,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelMediumIsCustom,
                                      ),
                                ),
                                RatingBar.builder(
                                  onRatingUpdate: (newValue) => safeSetState(
                                      () => _model.ratingBarValue = newValue),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: BukeerColors.primary,
                                  ),
                                  direction: Axis.horizontal,
                                  initialRating: _model.ratingBarValue ??= 5.0,
                                  unratedColor: BukeerColors.primaryAccent,
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  glowColor: BukeerColors.primary,
                                ),
                              ].divide(SizedBox(width: BukeerSpacing.xs)),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    valueOrDefault<String>(
                                      widget!.descriptionShort,
                                      '--',
                                    ).maybeHandleOverflow(
                                      maxChars: 160,
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
                              ].divide(SizedBox(width: BukeerSpacing.xs)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: BukeerColors.primary,
                      size: 16.0,
                    ),
                  ].divide(SizedBox(width: BukeerSpacing.s)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
