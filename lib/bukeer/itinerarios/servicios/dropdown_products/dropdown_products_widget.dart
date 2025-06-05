import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../services/ui_state_service.dart';
import '../../../component_container_activities/component_container_activities_widget.dart';
import '../../../productos/component_container_flights/component_container_flights_widget.dart';
import '../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'dropdown_products_model.dart';
import '../../../../design_system/index.dart';
export 'dropdown_products_model.dart';

class DropdownProductsWidget extends StatefulWidget {
  const DropdownProductsWidget({
    super.key,
    this.listHotel,
    this.productType,
  });

  final String? listHotel;
  final String? productType;

  @override
  State<DropdownProductsWidget> createState() => _DropdownProductsWidgetState();
}

class _DropdownProductsWidgetState extends State<DropdownProductsWidget>
    with TickerProviderStateMixin {
  late DropdownProductsModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropdownProductsModel());

    _model.searchFieldTextController ??= TextEditingController();
    _model.searchFieldFocusNode ??= FocusNode();

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

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: FutureBuilder<ApiCallResponse>(
        future: GetLocationsByProductCall.call(
          typeproduct: context.read<UiStateService>().selectedProductType,
          authToken: currentJwtToken,
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }
          final containerGetLocationsByProductResponse = snapshot.data!;

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 1.0,
            ),
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 530.0,
                  ),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.all(BukeerSpacing.s),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 44.0,
                          fillColor: FlutterFlowTheme.of(context).accent4,
                          icon: Icon(
                            Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.read<UiStateService>().searchQuery = '';
                            context.read<UiStateService>().selectedLocationName = '';
                            safeSetState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(BukeerSpacing.s),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 530.0,
                      maxHeight: 700.0,
                    ),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 8.0, 12.0, 12.0),
                            child: Container(
                              width: double.infinity,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
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
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 4.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: TextFormField(
                                          controller:
                                              _model.searchFieldTextController,
                                          focusNode:
                                              _model.searchFieldFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.searchFieldTextController',
                                            Duration(milliseconds: 2000),
                                            () async {
                                              context.read<UiStateService>().searchQuery = _model
                                                      .searchFieldTextController
                                                      .text;
                                              safeSetState(() {});
                                              await Future.wait([
                                                Future(() async {
                                                  safeSetState(() => _model
                                                      .listViewProductsPagingController
                                                      ?.refresh());
                                                  await _model
                                                      .waitForOnePageForListViewProducts();
                                                }),
                                                Future(() async {
                                                  safeSetState(() => _model
                                                      .listViewFlightsPagingController
                                                      ?.refresh());
                                                  await _model
                                                      .waitForOnePageForListViewFlights();
                                                }),
                                              ]);
                                            },
                                          ),
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            labelText: 'Buscar',
                                            alignLabelWithHint: false,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 8.0),
                                            prefixIcon: Icon(
                                              Icons.search_sharp,
                                              size: 20.0,
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: BukeerTypography.bodySmallSize,
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
                                        ),
                                      ),
                                    ),
                                    if (_model.searchFieldTextController.text !=
                                            null &&
                                        _model.searchFieldTextController.text !=
                                            '')
                                      FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30.0,
                                        borderWidth: 1.0,
                                        buttonSize: 32.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .accent4,
                                        icon: Icon(
                                          Icons.close_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 16.0,
                                        ),
                                        onPressed: () async {
                                          await Future.wait([
                                            Future(() async {}),
                                            Future(() async {
                                              safeSetState(() {
                                                _model.searchFieldTextController
                                                    ?.clear();
                                              });
                                            }),
                                          ]);
                                          context.read<UiStateService>().searchQuery = '';
                                          safeSetState(() {});
                                          await Future.wait([
                                            Future(() async {
                                              safeSetState(() => _model
                                                  .listViewProductsPagingController
                                                  ?.refresh());
                                              await _model
                                                  .waitForOnePageForListViewProducts();
                                            }),
                                            Future(() async {
                                              safeSetState(() => _model
                                                  .listViewFlightsPagingController
                                                  ?.refresh());
                                              await _model
                                                  .waitForOnePageForListViewFlights();
                                            }),
                                          ]);
                                        },
                                      ),
                                  ]
                                      .divide(SizedBox(width: BukeerSpacing.xs))
                                      .around(SizedBox(width: BukeerSpacing.xs)),
                                ),
                              ),
                            ),
                          ),
                          if (widget!.productType != 'flights')
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 12.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
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
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4.0, 0.0, 4.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: FaIcon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 18.0,
                                        ),
                                      ),
                                      Flexible(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropDownLocationValueController ??=
                                              FormFieldController<String>(null),
                                          options: (getJsonField(
                                            containerGetLocationsByProductResponse
                                                .jsonBody,
                                            r'''$''',
                                            true,
                                          ) as List)
                                              .map<String>((s) => s.toString())
                                              .toList()!,
                                          onChanged: (val) async {
                                            safeSetState(() => _model
                                                .dropDownLocationValue = val);
                                            context.read<UiStateService>().selectedLocationName = _model.dropDownLocationValue!;
                                            safeSetState(() {});
                                            await Future.wait([
                                              Future(() async {
                                                safeSetState(() => _model
                                                    .listViewProductsPagingController
                                                    ?.refresh());
                                                await _model
                                                    .waitForOnePageForListViewProducts();
                                              }),
                                              Future(() async {
                                                safeSetState(() => _model
                                                    .listViewFlightsPagingController
                                                    ?.refresh());
                                                await _model
                                                    .waitForOnePageForListViewFlights();
                                              }),
                                            ]);
                                          },
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          searchHintTextStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                          searchTextStyle: FlutterFlowTheme.of(
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
                                          hintText: 'Ubicación',
                                          searchHintText: 'Buscar..',
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: true,
                                          isMultiSelect: false,
                                        ),
                                      ),
                                      if (_model.dropDownLocationValue !=
                                              null &&
                                          _model.dropDownLocationValue != '')
                                        FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 30.0,
                                          borderWidth: 1.0,
                                          buttonSize: 32.0,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .accent4,
                                          icon: Icon(
                                            Icons.close_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16.0,
                                          ),
                                          onPressed: () async {
                                            safeSetState(() {
                                              _model
                                                  .dropDownLocationValueController
                                                  ?.reset();
                                            });
                                            context.read<UiStateService>().selectedLocationName = '';
                                            safeSetState(() {});
                                            safeSetState(() => _model
                                                .listViewProductsPagingController
                                                ?.refresh());
                                            await _model
                                                .waitForOnePageForListViewProducts();
                                          },
                                        ),
                                    ]
                                        .divide(SizedBox(width: BukeerSpacing.xs))
                                        .around(SizedBox(width: BukeerSpacing.xs)),
                                  ),
                                ),
                              ),
                            ),
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            indent: 0.0,
                            endIndent: 0.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          if (widget!.productType != 'flights')
                            Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.sizeOf(context).height * 1.0,
                                ),
                                decoration: BoxDecoration(),
                                child: PagedListView<ApiPagingParams, dynamic>(
                                  pagingController:
                                      _model.setListViewProductsController(
                                    (nextPageMarker) =>
                                        GetProductsFromViewsCall.call(
                                      searchTerm:
                                          context.read<UiStateService>().searchQuery,
                                      type: context.read<UiStateService>().selectedProductType,
                                      pageSize: 5,
                                      pageNumber: nextPageMarker.nextPageNumber,
                                      authToken: currentJwtToken,
                                      location: context.read<UiStateService>().selectedLocationName,
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

                                    itemBuilder: (context, _, hotelsItemIndex) {
                                      final hotelsItemItem = _model
                                          .listViewProductsPagingController!
                                          .itemList![hotelsItemIndex];
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.read<UiStateService>().itemsProducts =
                                              hotelsItemItem;
                                          context.read<UiStateService>().searchQuery = '';
                                          context.read<UiStateService>().selectedLocationName = '';
                                          context.read<UiStateService>().selectRates = true;
                                          safeSetState(() {});
                                          context.safePop();
                                        },
                                        child:
                                            ComponentContainerActivitiesWidget(
                                          key: Key(
                                              'Keyz0s_${hotelsItemIndex}_of_${_model.listViewProductsPagingController!.itemList!.length}'),
                                          name: getJsonField(
                                            hotelsItemItem,
                                            r'''$.name''',
                                          ).toString(),
                                          location: getJsonField(
                                            hotelsItemItem,
                                            r'''$.city''',
                                          ).toString(),
                                          descriptionShort: getJsonField(
                                            hotelsItemItem,
                                            r'''$.description''',
                                          ).toString(),
                                          image: valueOrDefault<String>(
                                            getJsonField(
                                              hotelsItemItem,
                                              r'''$.main_image''',
                                            )?.toString(),
                                            'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                          ),
                                          provider: getJsonField(
                                            hotelsItemItem,
                                            r'''$.name_provider''',
                                          ).toString(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          if (widget!.productType == 'flights')
                            Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.sizeOf(context).height * 1.0,
                                ),
                                decoration: BoxDecoration(),
                                child: PagedListView<ApiPagingParams, dynamic>(
                                  pagingController:
                                      _model.setListViewFlightsController(
                                    (nextPageMarker) => GetAirlinesCall.call(
                                      authToken: currentJwtToken,
                                      search: context.read<UiStateService>().searchQuery,
                                      pageSize: 5,
                                      pageNumber: nextPageMarker.nextPageNumber,
                                    ),
                                  ),
                                  padding: EdgeInsets.zero,
                                  primary: false,
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
                                        (context, _, flightsItemIndex) {
                                      final flightsItemItem = _model
                                          .listViewFlightsPagingController!
                                          .itemList![flightsItemIndex];
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.read<UiStateService>().itemsProducts =
                                              flightsItemItem;
                                          context.read<UiStateService>().searchQuery = '';
                                          safeSetState(() {});
                                          context.safePop();
                                        },
                                        child: ComponentContainerFlightsWidget(
                                          key: Key(
                                              'Keyxl5_${flightsItemIndex}_of_${_model.listViewFlightsPagingController!.itemList!.length}'),
                                          name: valueOrDefault<String>(
                                            getJsonField(
                                              flightsItemItem,
                                              r'''$.name''',
                                            )?.toString(),
                                            'Aerolínea',
                                          ),
                                          image: valueOrDefault<String>(
                                            getJsonField(
                                              flightsItemItem,
                                              r'''$.logo_symbol_url''',
                                            )?.toString(),
                                            'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/airline-default.png',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(
                      animationsMap['containerOnPageLoadAnimation']!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
