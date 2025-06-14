import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_place_picker.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/place.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'place_picker_model.dart';
export 'place_picker_model.dart';

class PlacePickerWidget extends StatefulWidget {
  const PlacePickerWidget({
    super.key,
    this.location,
    this.locationName,
  });

  final String? location;
  final String? locationName;

  @override
  State<PlacePickerWidget> createState() => _PlacePickerWidgetState();
}

class _PlacePickerWidgetState extends State<PlacePickerWidget>
    with TickerProviderStateMixin {
  late PlacePickerModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlacePickerModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: 295.0,
      height: 55.0,
      constraints: BoxConstraints(
        maxWidth: 770.0,
      ),
      decoration: BoxDecoration(
        color: BukeerColors.getBackground(context, secondary: true),
        boxShadow: [
          BoxShadow(
            blurRadius: 3.0,
            color: BukeerColors.overlay,
            offset: Offset(
              0.0,
              1.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.s),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              2.0, 0.0, 0.0, 0.0),
                          child: Text(
                            valueOrDefault<String>(
                              () {
                                if (_model.placePickerValue.address != null &&
                                    _model.placePickerValue.address != '') {
                                  return _model.placePickerValue.address;
                                } else if (widget!.location != null &&
                                    widget!.location != '') {
                                  return valueOrDefault<String>(
                                    widget!.location,
                                    'Seleccionar ubicación',
                                  );
                                } else if (widget!.locationName != null &&
                                    widget!.locationName != '') {
                                  return widget!.locationName;
                                } else {
                                  return _model.placePickerValue.address;
                                }
                              }(),
                              'Seleccionar ubicación',
                            ).maybeHandleOverflow(
                              maxChars: 25,
                              replacement: '…',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  color: BukeerColors.secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyLargeIsCustom,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: BukeerColors.getBackground(context),
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: FlutterFlowPlacePicker(
                iOSGoogleMapsApiKey: 'AIzaSyDpcq6Y6xuOzDr-kzXaT8Snq-gsSUmqRhs',
                androidGoogleMapsApiKey:
                    'AIzaSyBrl5X9tZR4F2-e0QUCiisA73UhRgcBYdY',
                webGoogleMapsApiKey: 'AIzaSyCTifXS7nsManySBuJw_egOvQd8BhuUmcg',
                onSelect: (place) async {
                  safeSetState(() => _model.placePickerValue = place);
                },
                defaultText: '',
                icon: Icon(
                  Icons.place,
                  color: BukeerColors.info,
                  size: 16.0,
                ),
                buttonOptions: FFButtonOptions(
                  width: 40.0,
                  height: 40.0,
                  color: BukeerColors.primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleSmallFamily,
                        color: BukeerColors.info,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleSmallIsCustom,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }
}
