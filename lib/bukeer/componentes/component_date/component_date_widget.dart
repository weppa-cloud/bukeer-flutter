import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_date_model.dart';
export 'component_date_model.dart';

class ComponentDateWidget extends StatefulWidget {
  const ComponentDateWidget({
    super.key,
    this.date,
    this.label,
  });

  final String? date;
  final String? label;

  @override
  State<ComponentDateWidget> createState() => _ComponentDateWidgetState();
}

class _ComponentDateWidgetState extends State<ComponentDateWidget>
    with TickerProviderStateMixin {
  late ComponentDateModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentDateModel());

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
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        final _datePickedDate = await showDatePicker(
          context: context,
          initialDate: getCurrentTimestamp,
          firstDate: getCurrentTimestamp,
          lastDate: DateTime(2050),
          builder: (context, child) {
            return wrapInMaterialDatePickerTheme(
              context,
              child!,
              headerBackgroundColor: FlutterFlowTheme.of(context).primary,
              headerForegroundColor: FlutterFlowTheme.of(context).info,
              headerTextStyle:
                  FlutterFlowTheme.of(context).headlineLarge.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).headlineLargeFamily,
                        fontSize: BukeerTypography.displaySmallSize,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                      ),
              pickerBackgroundColor:
                  FlutterFlowTheme.of(context).secondaryBackground,
              pickerForegroundColor: FlutterFlowTheme.of(context).primaryText,
              selectedDateTimeBackgroundColor:
                  FlutterFlowTheme.of(context).primary,
              selectedDateTimeForegroundColor:
                  FlutterFlowTheme.of(context).info,
              actionButtonForegroundColor:
                  FlutterFlowTheme.of(context).primaryText,
              iconSize: 24.0,
            );
          },
        );

        if (_datePickedDate != null) {
          safeSetState(() {
            _model.datePicked = DateTime(
              _datePickedDate.year,
              _datePickedDate.month,
              _datePickedDate.day,
            );
          });
        } else if (_model.datePicked != null) {
          safeSetState(() {
            _model.datePicked = getCurrentTimestamp;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: 300.0,
        constraints: BoxConstraints(
          maxWidth: 770.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
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
                        Text(
                          widget!.label!,
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyLargeFamily,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyLargeIsCustom,
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              2.0, 0.0, 0.0, 0.0),
                          child: Text(
                            valueOrDefault<String>(
                              _model.datePicked != null
                                  ? valueOrDefault<String>(
                                      dateTimeFormat(
                                        "d/M/y",
                                        _model.datePicked,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      'd/m/y',
                                    )
                                  : valueOrDefault<String>(
                                      widget!.date,
                                      'd/m/y',
                                    ),
                              'd/m/y',
                            ).maybeHandleOverflow(
                              maxChars: 10,
                              replacement: '…',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyLargeIsCustom,
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
                color: FlutterFlowTheme.of(context).primaryBackground,
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(BukeerSpacing.xs),
                  child: Icon(
                    Icons.calendar_month,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }
}
