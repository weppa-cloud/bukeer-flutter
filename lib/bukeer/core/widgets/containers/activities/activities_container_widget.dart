import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'activities_container_model.dart';
export 'activities_container_model.dart';

class ActivitiesContainerWidget extends StatefulWidget {
  const ActivitiesContainerWidget({
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
  State<ActivitiesContainerWidget> createState() =>
      _ActivitiesContainerWidgetState();
}

class _ActivitiesContainerWidgetState extends State<ActivitiesContainerWidget> {
  late ActivitiesContainerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivitiesContainerModel());

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
            color: BukeerColors.getBackground(context, secondary: true),
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
                                    fontSize: BukeerTypography.bodyMediumSize,
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
