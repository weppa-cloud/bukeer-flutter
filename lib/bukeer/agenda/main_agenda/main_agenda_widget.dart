import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../core/widgets/navigation/web_nav/web_nav_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../services/ui_state_service.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '../../../index.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../services/ui_state_service.dart';
import 'main_agenda_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
export 'main_agenda_model.dart';

class MainAgendaWidget extends StatefulWidget {
  const MainAgendaWidget({super.key});

  static String routeName = 'main_agenda';
  static String routePath = 'agenda';

  @override
  State<MainAgendaWidget> createState() => _MainAgendaWidgetState();
}

class _MainAgendaWidgetState extends State<MainAgendaWidget>
    with TickerProviderStateMixin {
  late MainAgendaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainAgendaModel());

    _model.textController ??= TextEditingController();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
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
      'containerOnPageLoadAnimation2': AnimationInfo(
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
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<UiStateService>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: BukeerColors.getBackground(context, secondary: true),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (responsiveVisibility(
                      context: context,
                      phone: false,
                      tablet: false,
                    ))
                      wrapWithModel(
                        model: _model.webNavModel,
                        updateCallback: () => safeSetState(() {}),
                        updateOnChange: true,
                        child: WebNavWidget(
                          selectedNav: 8,
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.sizeOf(context).width * 1.0,
                            maxWidth: MediaQuery.sizeOf(context).width * 8.52,
                            maxHeight: 2000.0,
                          ),
                          decoration: BoxDecoration(
                            color: BukeerColors.getBackground(context),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 852.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 16.0, 16.0, 4.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Agenda',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMediumIsCustom,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          1.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            BukeerSpacing.s),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16.0,
                                                                16.0,
                                                                16.0,
                                                                16.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Autocomplete<
                                                                String>(
                                                              initialValue:
                                                                  TextEditingValue(),
                                                              optionsBuilder:
                                                                  (textEditingValue) {
                                                                if (textEditingValue
                                                                        .text ==
                                                                    '') {
                                                                  return const Iterable<
                                                                      String>.empty();
                                                                }
                                                                return [
                                                                  'Option 1'
                                                                ].where(
                                                                    (option) {
                                                                  final lowercaseOption =
                                                                      option
                                                                          .toLowerCase();
                                                                  return lowercaseOption.contains(
                                                                      textEditingValue
                                                                          .text
                                                                          .toLowerCase());
                                                                });
                                                              },
                                                              optionsViewBuilder:
                                                                  (context,
                                                                      onSelected,
                                                                      options) {
                                                                return AutocompleteOptionsList(
                                                                  textFieldKey:
                                                                      _model
                                                                          .textFieldKey,
                                                                  textController:
                                                                      _model
                                                                          .textController!,
                                                                  options: options
                                                                      .toList(),
                                                                  onSelected:
                                                                      onSelected,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  textHighlightStyle:
                                                                      TextStyle(),
                                                                  elevation:
                                                                      4.0,
                                                                  optionBackgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                  optionHighlightColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                  maxHeight:
                                                                      200.0,
                                                                );
                                                              },
                                                              onSelected: (String
                                                                  selection) {
                                                                safeSetState(() =>
                                                                    _model.textFieldSelectedOption =
                                                                        selection);
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                              },
                                                              fieldViewBuilder:
                                                                  (
                                                                context,
                                                                textEditingController,
                                                                focusNode,
                                                                onEditingComplete,
                                                              ) {
                                                                _model.textFieldFocusNode =
                                                                    focusNode;

                                                                _model.textController =
                                                                    textEditingController;
                                                                return TextFormField(
                                                                  key: _model
                                                                      .textFieldKey,
                                                                  controller:
                                                                      textEditingController,
                                                                  focusNode:
                                                                      focusNode,
                                                                  onEditingComplete:
                                                                      onEditingComplete,
                                                                  onChanged: (_) =>
                                                                      EasyDebounce
                                                                          .debounce(
                                                                    '_model.textController',
                                                                    Duration(
                                                                        milliseconds:
                                                                            2000),
                                                                    () async {
                                                                      context.read<UiStateService>().searchQuery = _model
                                                                          .textController
                                                                          .text;
                                                                      safeSetState(() => _model
                                                                          .listViewAgendaPagingController
                                                                          ?.refresh());
                                                                      await _model
                                                                          .waitForOnePageForListViewAgenda();
                                                                    },
                                                                  ),
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        false,
                                                                    labelText:
                                                                        'Buscar',
                                                                    alignLabelWithHint:
                                                                        false,
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              BukeerSpacing.sm),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              BukeerSpacing.sm),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              BukeerSpacing.sm),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              BukeerSpacing.sm),
                                                                    ),
                                                                    contentPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            8.0),
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .search_sharp,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                    suffixIcon: _model
                                                                            .textController!
                                                                            .text
                                                                            .isNotEmpty
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              _model.textController?.clear();
                                                                              context.read<UiStateService>().searchQuery = _model.textController.text;
                                                                              safeSetState(() => _model.listViewAgendaPagingController?.refresh());
                                                                              await _model.waitForOnePageForListViewAgenda();
                                                                              safeSetState(() {});
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.clear,
                                                                              color: BukeerColors.textSecondary,
                                                                              size: 20.0,
                                                                            ),
                                                                          )
                                                                        : null,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  validator: _model
                                                                      .textControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            final _datePicked1Date =
                                                                await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  getCurrentTimestamp,
                                                              firstDate:
                                                                  getCurrentTimestamp,
                                                              lastDate:
                                                                  DateTime(
                                                                      2050),
                                                              builder: (context,
                                                                  child) {
                                                                return wrapInMaterialDatePickerTheme(
                                                                  context,
                                                                  child!,
                                                                  headerBackgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  headerForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                  headerTextStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLarge
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).headlineLargeFamily,
                                                                        fontSize:
                                                                            32.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                                                                      ),
                                                                  pickerBackgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                  pickerForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  selectedDateTimeBackgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  selectedDateTimeForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                  actionButtonForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  iconSize:
                                                                      24.0,
                                                                );
                                                              },
                                                            );

                                                            if (_datePicked1Date !=
                                                                null) {
                                                              safeSetState(() {
                                                                _model.datePicked1 =
                                                                    DateTime(
                                                                  _datePicked1Date
                                                                      .year,
                                                                  _datePicked1Date
                                                                      .month,
                                                                  _datePicked1Date
                                                                      .day,
                                                                );
                                                              });
                                                            } else if (_model
                                                                    .datePicked1 !=
                                                                null) {
                                                              safeSetState(() {
                                                                _model.datePicked1 =
                                                                    getCurrentTimestamp;
                                                              });
                                                            }
                                                            safeSetState(() => _model
                                                                .listViewAgendaPagingController
                                                                ?.refresh());
                                                            await _model
                                                                .waitForOnePageForListViewAgenda();
                                                          },
                                                          child:
                                                              AnimatedContainer(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    100),
                                                            curve: Curves
                                                                .easeInOut,
                                                            width: 250.0,
                                                            height: 50.0,
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: 770.0,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius:
                                                                      3.0,
                                                                  color: Color(
                                                                      0x33000000),
                                                                  offset:
                                                                      Offset(
                                                                    0.0,
                                                                    1.0,
                                                                  ),
                                                                )
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Text(
                                                                              'Desde:  ',
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                    color: BukeerColors.secondaryText,
                                                                                    fontSize: BukeerTypography.bodySmallSize,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  _model.datePicked1 != null
                                                                                      ? valueOrDefault<String>(
                                                                                          dateTimeFormat(
                                                                                            "d/M/y",
                                                                                            _model.datePicked1,
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          ),
                                                                                          'd/m/y',
                                                                                        )
                                                                                      : null,
                                                                                  'd/m/y',
                                                                                ).maybeHandleOverflow(
                                                                                  maxChars: 10,
                                                                                  replacement: '…',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                      color: BukeerColors.secondaryText,
                                                                                      fontSize: BukeerTypography.bodySmallSize,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Card(
                                                                    clipBehavior:
                                                                        Clip.antiAliasWithSaveLayer,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                    elevation:
                                                                        1.0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.all(
                                                                          BukeerSpacing
                                                                              .xs),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        size:
                                                                            22.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ).animateOnPageLoad(
                                                            animationsMap[
                                                                'containerOnPageLoadAnimation1']!),
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            final _datePicked2Date =
                                                                await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  getCurrentTimestamp,
                                                              firstDate:
                                                                  getCurrentTimestamp,
                                                              lastDate:
                                                                  DateTime(
                                                                      2050),
                                                              builder: (context,
                                                                  child) {
                                                                return wrapInMaterialDatePickerTheme(
                                                                  context,
                                                                  child!,
                                                                  headerBackgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  headerForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                  headerTextStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLarge
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).headlineLargeFamily,
                                                                        fontSize:
                                                                            32.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                                                                      ),
                                                                  pickerBackgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                  pickerForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  selectedDateTimeBackgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  selectedDateTimeForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                  actionButtonForegroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  iconSize:
                                                                      24.0,
                                                                );
                                                              },
                                                            );

                                                            if (_datePicked2Date !=
                                                                null) {
                                                              safeSetState(() {
                                                                _model.datePicked2 =
                                                                    DateTime(
                                                                  _datePicked2Date
                                                                      .year,
                                                                  _datePicked2Date
                                                                      .month,
                                                                  _datePicked2Date
                                                                      .day,
                                                                );
                                                              });
                                                            } else if (_model
                                                                    .datePicked2 !=
                                                                null) {
                                                              safeSetState(() {
                                                                _model.datePicked2 =
                                                                    getCurrentTimestamp;
                                                              });
                                                            }
                                                            safeSetState(() => _model
                                                                .listViewAgendaPagingController
                                                                ?.refresh());
                                                            await _model
                                                                .waitForOnePageForListViewAgenda();
                                                          },
                                                          child:
                                                              AnimatedContainer(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    100),
                                                            curve: Curves
                                                                .easeInOut,
                                                            width: 250.0,
                                                            height: 50.0,
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: 770.0,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius:
                                                                      3.0,
                                                                  color: Color(
                                                                      0x33000000),
                                                                  offset:
                                                                      Offset(
                                                                    0.0,
                                                                    1.0,
                                                                  ),
                                                                )
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Text(
                                                                              'Hasta:  ',
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                    color: BukeerColors.secondaryText,
                                                                                    fontSize: BukeerTypography.bodySmallSize,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  _model.datePicked2 != null
                                                                                      ? valueOrDefault<String>(
                                                                                          dateTimeFormat(
                                                                                            "d/M/y",
                                                                                            _model.datePicked2,
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          ),
                                                                                          'd/m/y',
                                                                                        )
                                                                                      : null,
                                                                                  'd/m/y',
                                                                                ).maybeHandleOverflow(
                                                                                  maxChars: 10,
                                                                                  replacement: '…',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                      color: BukeerColors.secondaryText,
                                                                                      fontSize: BukeerTypography.bodySmallSize,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Card(
                                                                    clipBehavior:
                                                                        Clip.antiAliasWithSaveLayer,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                    elevation:
                                                                        1.0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.all(
                                                                          BukeerSpacing
                                                                              .xs),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        size:
                                                                            22.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ).animateOnPageLoad(
                                                            animationsMap[
                                                                'containerOnPageLoadAnimation2']!),
                                                      ].divide(SizedBox(
                                                          width: 12.0)),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(
                                                  height: BukeerSpacing.s)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 8.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 852.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 16.0, 16.0, 4.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RefreshIndicator(
                                              onRefresh: () async {
                                                safeSetState(() => _model
                                                    .listViewAgendaPagingController
                                                    ?.refresh());
                                              },
                                              child: PagedListView<
                                                  ApiPagingParams,
                                                  dynamic>.separated(
                                                pagingController: _model
                                                    .setListViewAgendaController(
                                                  (nextPageMarker) =>
                                                      GetAgendaByDateCall.call(
                                                    authToken: currentJwtToken,
                                                    fechaInicial:
                                                        dateTimeFormat(
                                                      "y/M/d",
                                                      _model.datePicked1,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    fechaFinal: dateTimeFormat(
                                                      "y/M/d",
                                                      _model.datePicked2,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    search: context
                                                        .read<UiStateService>()
                                                        .searchQuery,
                                                    pageNumber: nextPageMarker
                                                        .nextPageNumber,
                                                    pageSize: 5,
                                                  ),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                  0,
                                                  8.0,
                                                  0,
                                                  0,
                                                ),
                                                shrinkWrap: true,
                                                reverse: false,
                                                scrollDirection: Axis.vertical,
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(
                                                        height:
                                                            BukeerSpacing.s),
                                                builderDelegate:
                                                    PagedChildBuilderDelegate<
                                                        dynamic>(
                                                  // Customize what your widget looks like when it's loading the first page.
                                                  firstPageProgressIndicatorBuilder:
                                                      (_) => Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Customize what your widget looks like when it's loading another page.
                                                  newPageProgressIndicatorBuilder:
                                                      (_) => Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  itemBuilder: (context, _,
                                                      getAgendaDateIndex) {
                                                    final getAgendaDateItem =
                                                        _model.listViewAgendaPagingController!
                                                                .itemList![
                                                            getAgendaDateIndex];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        12.0,
                                                                        12.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .today_outlined,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  size: 32.0,
                                                                ),
                                                                Text(
                                                                  (String
                                                                      var1) {
                                                                    return '${var1.split('-')[2]} ${[
                                                                      "Ene",
                                                                      "Feb",
                                                                      "Mar",
                                                                      "Abr",
                                                                      "May",
                                                                      "Jun",
                                                                      "Jul",
                                                                      "Aug",
                                                                      "Sep",
                                                                      "Oct",
                                                                      "Nov",
                                                                      "Dec"
                                                                    ][int.parse(var1.split('-')[1]) - 1]} ${var1.split('-')[0]}';
                                                                  }(getJsonField(
                                                                    getAgendaDateItem,
                                                                    r'''$.agenda_date''',
                                                                  ).toString()),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).titleMediumFamily,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  width: 12.0)),
                                                            ),
                                                          ),
                                                          Builder(
                                                            builder: (context) {
                                                              final getAgendaItem =
                                                                  getJsonField(
                                                                getAgendaDateItem,
                                                                r'''$.items''',
                                                              ).toList();

                                                              return ListView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    getAgendaItem
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        getAgendaItemIndex) {
                                                                  final getAgendaItemItem =
                                                                      getAgendaItem[
                                                                          getAgendaItemIndex];
                                                                  return InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      context
                                                                          .pushNamed(
                                                                        ItineraryDetailsWidget
                                                                            .routeName,
                                                                        pathParameters:
                                                                            {
                                                                          'id':
                                                                              serializeParam(
                                                                            getJsonField(
                                                                              getAgendaItemItem,
                                                                              r'''$.id_itinerary''',
                                                                            ).toString(),
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(BukeerSpacing.s),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children:
                                                                              [
                                                                            Flexible(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      if ('${getJsonField(
                                                                                            getAgendaItemItem,
                                                                                            r'''$.product_type''',
                                                                                          ).toString()}' ==
                                                                                          'Transporte')
                                                                                        Icon(
                                                                                          Icons.directions_car,
                                                                                          color: BukeerColors.secondaryText,
                                                                                          size: 20.0,
                                                                                        ),
                                                                                      if ('${getJsonField(
                                                                                            getAgendaItemItem,
                                                                                            r'''$.product_type''',
                                                                                          ).toString()}' ==
                                                                                          'Servicios')
                                                                                        Icon(
                                                                                          Icons.volunteer_activism_sharp,
                                                                                          color: BukeerColors.secondaryText,
                                                                                          size: 20.0,
                                                                                        ),
                                                                                      if ('${getJsonField(
                                                                                            getAgendaItemItem,
                                                                                            r'''$.product_type''',
                                                                                          ).toString()}' ==
                                                                                          'Vuelos')
                                                                                        Icon(
                                                                                          Icons.flight,
                                                                                          color: BukeerColors.secondaryText,
                                                                                          size: 20.0,
                                                                                        ),
                                                                                      if ('${getJsonField(
                                                                                            getAgendaItemItem,
                                                                                            r'''$.product_type''',
                                                                                          ).toString()}' ==
                                                                                          'Hoteles')
                                                                                        Icon(
                                                                                          Icons.home_work_sharp,
                                                                                          color: BukeerColors.secondaryText,
                                                                                          size: 20.0,
                                                                                        ),
                                                                                      Flexible(
                                                                                        child: Wrap(
                                                                                          spacing: 8.0,
                                                                                          runSpacing: 0.0,
                                                                                          alignment: WrapAlignment.start,
                                                                                          crossAxisAlignment: WrapCrossAlignment.center,
                                                                                          direction: Axis.horizontal,
                                                                                          runAlignment: WrapAlignment.center,
                                                                                          verticalDirection: VerticalDirection.down,
                                                                                          clipBehavior: Clip.none,
                                                                                          children: [
                                                                                            Text(
                                                                                              getJsonField(
                                                                                                getAgendaItemItem,
                                                                                                r'''$.product_name''',
                                                                                              ).toString(),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                  ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                  ),
                                                                                  Text(
                                                                                    getJsonField(
                                                                                      getAgendaItemItem,
                                                                                      r'''$.contact_name''',
                                                                                    ).toString().maybeHandleOverflow(
                                                                                          maxChars: 20,
                                                                                          replacement: '…',
                                                                                        ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: BukeerColors.primary,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                  Wrap(
                                                                                    spacing: 8.0,
                                                                                    runSpacing: 0.0,
                                                                                    alignment: WrapAlignment.start,
                                                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                                                    direction: Axis.horizontal,
                                                                                    runAlignment: WrapAlignment.start,
                                                                                    verticalDirection: VerticalDirection.down,
                                                                                    clipBehavior: Clip.none,
                                                                                    children: [
                                                                                      Text(
                                                                                        getJsonField(
                                                                                          getAgendaItemItem,
                                                                                          r'''$.total_cost''',
                                                                                        ).toString(),
                                                                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                              letterSpacing: 0.0,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                            ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Text(
                                                                                            'ID',
                                                                                            textAlign: TextAlign.start,
                                                                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                          Text(
                                                                                            getJsonField(
                                                                                              getAgendaItemItem,
                                                                                              r'''$.id_fm''',
                                                                                            ).toString(),
                                                                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.calendar_today,
                                                                                            color: BukeerColors.secondaryText,
                                                                                            size: 16.0,
                                                                                          ),
                                                                                          Flexible(
                                                                                            flex: 2,
                                                                                            child: Text(
                                                                                              (String var1) {
                                                                                                return '${var1.split('-')[2]} ${[
                                                                                                  "Ene",
                                                                                                  "Feb",
                                                                                                  "Mar",
                                                                                                  "Abr",
                                                                                                  "May",
                                                                                                  "Jun",
                                                                                                  "Jul",
                                                                                                  "Aug",
                                                                                                  "Sep",
                                                                                                  "Oct",
                                                                                                  "Nov",
                                                                                                  "Dec"
                                                                                                ][int.parse(var1.split('-')[1]) - 1]} ${var1.split('-')[0]}';
                                                                                              }(getJsonField(
                                                                                                getAgendaItemItem,
                                                                                                r'''$.date''',
                                                                                              ).toString()),
                                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                    letterSpacing: 0.0,
                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.person,
                                                                                            color: BukeerColors.secondaryText,
                                                                                            size: 16.0,
                                                                                          ),
                                                                                          Flexible(
                                                                                            flex: 2,
                                                                                            child: Text(
                                                                                              getJsonField(
                                                                                                getAgendaItemItem,
                                                                                                r'''$.client_name''',
                                                                                              ).toString().maybeHandleOverflow(
                                                                                                    maxChars: 16,
                                                                                                    replacement: '…',
                                                                                                  ),
                                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                    letterSpacing: 0.0,
                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(bottom: BukeerSpacing.xs),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      AnimatedContainer(
                                                                                        duration: UiConstants.animationDurationFast,
                                                                                        curve: Curves.easeInOut,
                                                                                        width: 30.0,
                                                                                        height: 30.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: BukeerColors.primaryAccent,
                                                                                          shape: BoxShape.circle,
                                                                                          border: Border.all(
                                                                                            color: BukeerColors.error,
                                                                                            width: 2.0,
                                                                                          ),
                                                                                        ),
                                                                                        alignment: AlignmentDirectional(0.0, 0.0),
                                                                                        child: Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                          child: Text(
                                                                                            'C',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      AnimatedContainer(
                                                                                        duration: UiConstants.animationDurationFast,
                                                                                        curve: Curves.easeInOut,
                                                                                        width: 30.0,
                                                                                        height: 30.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: BukeerColors.primaryAccent,
                                                                                          shape: BoxShape.circle,
                                                                                          border: Border.all(
                                                                                            color: BukeerColors.success,
                                                                                            width: 2.0,
                                                                                          ),
                                                                                        ),
                                                                                        alignment: AlignmentDirectional(0.0, 0.0),
                                                                                        child: Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                          child: Text(
                                                                                            'P',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      AnimatedContainer(
                                                                                        duration: UiConstants.animationDurationFast,
                                                                                        curve: Curves.easeInOut,
                                                                                        width: 30.0,
                                                                                        height: 30.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: BukeerColors.primaryAccent,
                                                                                          shape: BoxShape.circle,
                                                                                          border: Border.all(
                                                                                            color: BukeerColors.warning,
                                                                                            width: 2.0,
                                                                                          ),
                                                                                        ),
                                                                                        alignment: AlignmentDirectional(0.0, 0.0),
                                                                                        child: Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                          child: Text(
                                                                                            'NP',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                                  fontSize: BukeerTypography.captionSize,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(
                                              height: BukeerSpacing.s)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
