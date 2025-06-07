import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../services/ui_state_service.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'dropdown_airports_model.dart';
import '../../../../design_system/index.dart';
import '../../../../services/ui_state_service.dart';
export 'dropdown_airports_model.dart';

class DropdownAirportsWidget extends StatefulWidget {
  const DropdownAirportsWidget({
    super.key,
    required this.type,
  });

  final String? type;

  @override
  State<DropdownAirportsWidget> createState() => _DropdownAirportsWidgetState();
}

class _DropdownAirportsWidgetState extends State<DropdownAirportsWidget>
    with TickerProviderStateMixin {
  late DropdownAirportsModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropdownAirportsModel());

    _model.searchFieldTextController ??= TextEditingController();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
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
    context.watch<UiStateService>();

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 400.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(BukeerSpacing.s),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BukeerIconButton(
                      size: BukeerIconButtonSize.medium,
                      variant: BukeerIconButtonVariant.ghost,
                      icon: Icon(
                        Icons.close_rounded,
                        color: BukeerColors.secondaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.read<UiStateService>().searchQuery = '';
                        safeSetState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(BukeerSpacing.s),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 400.0,
                    maxHeight: 400.0,
                  ),
                  decoration: BoxDecoration(
                    color: BukeerColors.secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12.0,
                        color: Color(0x1E000000),
                        offset: Offset(
                          0.0,
                          5.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(BukeerSpacing.m),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(BukeerSpacing.m),
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 4.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Autocomplete<String>(
                                      initialValue: TextEditingValue(),
                                      optionsBuilder: (textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<String>.empty();
                                        }
                                        return ['Option 1'].where((option) {
                                          final lowercaseOption =
                                              option.toLowerCase();
                                          return lowercaseOption.contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      optionsViewBuilder:
                                          (context, onSelected, options) {
                                        return AutocompleteOptionsList(
                                          textFieldKey: _model.searchFieldKey,
                                          textController:
                                              _model.searchFieldTextController!,
                                          options: options.toList(),
                                          onSelected: onSelected,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          textHighlightStyle: TextStyle(),
                                          elevation: 4.0,
                                          optionBackgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                          optionHighlightColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          maxHeight: 200.0,
                                        );
                                      },
                                      onSelected: (String selection) {
                                        safeSetState(() =>
                                            _model.searchFieldSelectedOption =
                                                selection);
                                        FocusScope.of(context).unfocus();
                                      },
                                      fieldViewBuilder: (
                                        context,
                                        textEditingController,
                                        focusNode,
                                        onEditingComplete,
                                      ) {
                                        _model.searchFieldFocusNode = focusNode;

                                        _model.searchFieldTextController =
                                            textEditingController;
                                        return TextFormField(
                                          key: _model.searchFieldKey,
                                          controller: textEditingController,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.searchFieldTextController',
                                            Duration(milliseconds: 2000),
                                            () async {
                                              context
                                                      .read<UiStateService>()
                                                      .searchQuery =
                                                  _model
                                                      .searchFieldTextController
                                                      .text;
                                              safeSetState(() {});
                                              safeSetState(() => _model
                                                  .listViewAirportsPagingController
                                                  ?.refresh());
                                              await _model
                                                  .waitForOnePageForListViewAirports();
                                            },
                                          ),
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            labelText: 'Buscar',
                                            alignLabelWithHint: false,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 8.0),
                                            prefixIcon: Icon(
                                              Icons.search_sharp,
                                              size: 20.0,
                                            ),
                                            suffixIcon: _model
                                                    .searchFieldTextController!
                                                    .text
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      _model
                                                          .searchFieldTextController
                                                          ?.clear();
                                                      context
                                                              .read<
                                                                  UiStateService>()
                                                              .searchQuery =
                                                          _model
                                                              .searchFieldTextController
                                                              .text;
                                                      safeSetState(() {});
                                                      safeSetState(() => _model
                                                          .listViewAirportsPagingController
                                                          ?.refresh());
                                                      await _model
                                                          .waitForOnePageForListViewAirports();
                                                      safeSetState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: BukeerColors
                                                          .textSecondary,
                                                      size: 20.0,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: BukeerTypography
                                                    .bodySmallSize,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .searchFieldTextControllerValidator
                                              .asValidator(context),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ]
                                  .divide(SizedBox(width: BukeerSpacing.xs))
                                  .around(SizedBox(width: BukeerSpacing.xs)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            child: SingleChildScrollView(
                              primary: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  PagedListView<ApiPagingParams, dynamic>(
                                    pagingController:
                                        _model.setListViewAirportsController(
                                      (nextPageMarker) => GetAirportsCall.call(
                                        authToken: currentJwtToken,
                                        search: context
                                            .read<UiStateService>()
                                            .searchQuery,
                                        pageNumber:
                                            nextPageMarker.nextPageNumber,
                                        pageSize: 5,
                                      ),
                                    ),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    reverse: false,
                                    scrollDirection: Axis.vertical,
                                    builderDelegate:
                                        PagedChildBuilderDelegate<dynamic>(
                                      // Customize what your widget looks like when it's loading the first page.
                                      firstPageProgressIndicatorBuilder: (_) =>
                                          Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Customize what your widget looks like when it's loading another page.
                                      newPageProgressIndicatorBuilder: (_) =>
                                          Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),

                                      itemBuilder:
                                          (context, _, airportsItemIndex) {
                                        final airportsItemItem = _model
                                            .listViewAirportsPagingController!
                                            .itemList![airportsItemIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 5.0, 4.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (widget!.type == 'departure') {
                                                context
                                                        .read<UiStateService>()
                                                        .departureState =
                                                    getJsonField(
                                                  airportsItemItem,
                                                  r'''$.name''',
                                                ).toString();
                                                context
                                                    .read<UiStateService>()
                                                    .searchQuery = '';
                                                safeSetState(() {});
                                              } else {
                                                context
                                                        .read<UiStateService>()
                                                        .arrivalState =
                                                    getJsonField(
                                                  airportsItemItem,
                                                  r'''$.name''',
                                                ).toString();
                                                context
                                                    .read<UiStateService>()
                                                    .searchQuery = '';
                                                safeSetState(() {});
                                              }

                                              Navigator.pop(context);
                                            },
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 1.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        BukeerSpacing.m),
                                              ),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1.0,
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      BukeerSpacing.s),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AutoSizeText(
                                                        getJsonField(
                                                          airportsItemItem,
                                                          r'''$.name''',
                                                        ).toString(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmallFamily,
                                                                  fontSize:
                                                                      BukeerTypography
                                                                          .bodyMediumSize,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineSmallIsCustom,
                                                                ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 16.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation']!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
