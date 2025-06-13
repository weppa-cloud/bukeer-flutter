import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../core/widgets/containers/activities/activities_container_widget.dart';
import '../../core/widgets/buttons/btn_mobile_menu/btn_mobile_menu_widget.dart';
import '../../core/widgets/forms/search_box/search_box_widget.dart';
import '../../core/widgets/modals/product/details/modal_details_product_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'main_products_model.dart';
import '../../../services/ui_state_service.dart';
import '../../../services/performance_optimized_service.dart';
export 'main_products_model.dart';

class MainProductsWidget extends StatefulWidget {
  const MainProductsWidget({super.key});

  static String routeName = 'main_products';
  static String routePath = 'mainProducts';

  @override
  State<MainProductsWidget> createState() => _MainProductsWidgetState();
}

class _MainProductsWidgetState extends State<MainProductsWidget> {
  late MainProductsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainProductsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.logRebuild('MainProductsWidget');

    return PerformanceSelector<UiStateService, String>(
      listenable: context.read<UiStateService>(),
      selector: (service) => service.selectedProductType,
      builder: (context, selectedProductType) => FutureBuilder<ApiCallResponse>(
        future: GetLocationsByProductCall.call(
          typeproduct: context.read<UiStateService>().selectedProductType,
          authToken: currentJwtToken,
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: BukeerColors.getBackground(context),
              body: Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      BukeerColors.primary,
                    ),
                  ),
                ),
              ),
            );
          }
          final mainProductsGetLocationsByProductResponse = snapshot.data!;

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: BukeerColors.getBackground(context),
              body: SafeArea(
                top: true,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.sizeOf(context).width * 1.0,
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 8.52,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 8.0),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 852.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        BukeerSpacing.m),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
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
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                if (responsiveVisibility(
                                                                  context:
                                                                      context,
                                                                  tablet: false,
                                                                  tabletLandscape:
                                                                      false,
                                                                  desktop:
                                                                      false,
                                                                ))
                                                                  wrapWithModel(
                                                                    model: _model
                                                                        .btnMobileMenuModel,
                                                                    updateCallback: () =>
                                                                        safeSetState(
                                                                            () {}),
                                                                    child:
                                                                        BtnMobileMenuWidget(),
                                                                  ),
                                                                Text(
                                                                  'Productos',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).headlineMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  1.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
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
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .selectedProductType = 'activities';
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .searchQuery = '';
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .locationState = '';
                                                                    safeSetState(
                                                                        () {});
                                                                    safeSetState(
                                                                        () {
                                                                      _model
                                                                          .dropDownLocationValueController
                                                                          ?.reset();
                                                                    });
                                                                    await Future.delayed(const Duration(
                                                                        milliseconds:
                                                                            1000));
                                                                    safeSetState(() => _model
                                                                        .listViewPagingController
                                                                        ?.refresh());
                                                                    await _model
                                                                        .waitForOnePageForListView();
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .local_activity_outlined,
                                                                        color: context.read<UiStateService>().selectedProductType ==
                                                                                'activities'
                                                                            ? BukeerColors.primary
                                                                            : BukeerColors.secondaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      Text(
                                                                        'Actividades',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: context.read<UiStateService>().selectedProductType == 'activities' ? BukeerColors.primary : BukeerColors.secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width: BukeerSpacing
                                                                            .s)),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .locationState = '';
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .searchQuery = '';
                                                                    safeSetState(
                                                                        () {});
                                                                    safeSetState(
                                                                        () {
                                                                      _model
                                                                          .dropDownLocationValueController
                                                                          ?.reset();
                                                                    });
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .selectedProductType = 'hotels';
                                                                    safeSetState(
                                                                        () {});
                                                                    await Future.delayed(const Duration(
                                                                        milliseconds:
                                                                            1000));
                                                                    safeSetState(() => _model
                                                                        .listViewPagingController
                                                                        ?.refresh());
                                                                    await _model
                                                                        .waitForOnePageForListView();
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .business,
                                                                        color: context.read<UiStateService>().selectedProductType ==
                                                                                'hotels'
                                                                            ? BukeerColors.primary
                                                                            : BukeerColors.secondaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      Text(
                                                                        'Hoteles',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: context.read<UiStateService>().selectedProductType == 'hotels' ? BukeerColors.primary : BukeerColors.secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width: BukeerSpacing
                                                                            .s)),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .selectedProductType = 'transfers';
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .searchQuery = '';
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .locationState = '';
                                                                    safeSetState(
                                                                        () {});
                                                                    safeSetState(
                                                                        () {
                                                                      _model
                                                                          .dropDownLocationValueController
                                                                          ?.reset();
                                                                    });
                                                                    await Future.delayed(const Duration(
                                                                        milliseconds:
                                                                            1000));
                                                                    safeSetState(() => _model
                                                                        .listViewPagingController
                                                                        ?.refresh());
                                                                    await _model
                                                                        .waitForOnePageForListView();
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .directions_car,
                                                                        color: context.read<UiStateService>().selectedProductType ==
                                                                                'transfers'
                                                                            ? BukeerColors.primary
                                                                            : BukeerColors.secondaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      Text(
                                                                        'Transfer',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: context.read<UiStateService>().selectedProductType == 'transfers' ? BukeerColors.primary : BukeerColors.secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width: BukeerSpacing
                                                                            .s)),
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  width: 24.0)),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                width: 160.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    wrapWithModel(
                                                                      model: _model
                                                                          .searchBoxModel,
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          SearchBoxWidget(
                                                                        hintText:
                                                                            'Buscar productos',
                                                                        onSearchChanged:
                                                                            (searchText) async {
                                                                          context
                                                                              .read<UiStateService>()
                                                                              .searchQuery = searchText;
                                                                          safeSetState(
                                                                              () {});
                                                                          await Future.delayed(
                                                                              const Duration(milliseconds: 1000));
                                                                          safeSetState(() => _model
                                                                              .listViewPagingController
                                                                              ?.refresh());
                                                                          await _model
                                                                              .waitForOnePageForListView();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            FlutterFlowDropDown<
                                                                String>(
                                                              controller: _model
                                                                      .dropDownLocationValueController ??=
                                                                  FormFieldController<
                                                                          String>(
                                                                      null),
                                                              options:
                                                                  (getJsonField(
                                                                mainProductsGetLocationsByProductResponse
                                                                    .jsonBody,
                                                                r'''$''',
                                                                true,
                                                              ) as List)
                                                                      .map<String>(
                                                                          (s) =>
                                                                              s.toString())
                                                                      .toList()!,
                                                              onChanged:
                                                                  (val) async {
                                                                safeSetState(() =>
                                                                    _model.dropDownLocationValue =
                                                                        val);
                                                                context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .locationState =
                                                                    _model
                                                                        .dropDownLocationValue!;
                                                                safeSetState(
                                                                    () {});
                                                                await Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            1000));
                                                                safeSetState(
                                                                    () => _model
                                                                        .listViewPagingController
                                                                        ?.refresh());
                                                                await _model
                                                                    .waitForOnePageForListView();
                                                              },
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.108,
                                                              height: 40.0,
                                                              searchHintTextStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).labelMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                      ),
                                                              searchTextStyle:
                                                                  FlutterFlowTheme.of(
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
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
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
                                                              hintText:
                                                                  'Ubicación',
                                                              searchHintText:
                                                                  'Buscar..',
                                                              icon: Icon(
                                                                Icons
                                                                    .location_pin,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 24.0,
                                                              ),
                                                              fillColor: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              elevation: 2.0,
                                                              borderColor: Colors
                                                                  .transparent,
                                                              borderWidth: 0.0,
                                                              borderRadius: 8.0,
                                                              margin:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                              hidesUnderline:
                                                                  true,
                                                              isOverButton:
                                                                  false,
                                                              isSearchable:
                                                                  true,
                                                              isMultiSelect:
                                                                  false,
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                await Future
                                                                    .wait([
                                                                  Future(
                                                                      () async {
                                                                    safeSetState(
                                                                        () {
                                                                      _model
                                                                          .dropDownLocationValueController
                                                                          ?.reset();
                                                                    });
                                                                  }),
                                                                  Future(
                                                                      () async {}),
                                                                ]);
                                                                context
                                                                    .read<
                                                                        UiStateService>()
                                                                    .searchQuery = '';
                                                                context
                                                                    .read<
                                                                        UiStateService>()
                                                                    .locationState = '';
                                                                safeSetState(
                                                                    () {});
                                                                await Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            1000));
                                                                safeSetState(
                                                                    () => _model
                                                                        .listViewPagingController
                                                                        ?.refresh());
                                                                await _model
                                                                    .waitForOnePageForListView();
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .refresh_sharp,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 32.0,
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width:
                                                                  BukeerSpacing
                                                                      .m)),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height:
                                                              BukeerSpacing.s)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 16.0, 0.0, 0.0),
                                        child: Container(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              1.0,
                                          constraints: BoxConstraints(
                                            maxWidth: 852.0,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: PagedListView<ApiPagingParams,
                                              dynamic>(
                                            pagingController:
                                                _model.setListViewController(
                                              (nextPageMarker) =>
                                                  GetProductsFromViewsCall.call(
                                                searchTerm: context
                                                    .read<UiStateService>()
                                                    .searchQuery,
                                                type: context
                                                    .read<UiStateService>()
                                                    .selectedProductType,
                                                pageSize: 5,
                                                pageNumber: nextPageMarker
                                                    .nextPageNumber,
                                                authToken: currentJwtToken,
                                                location: context
                                                    .read<UiStateService>()
                                                    .locationState,
                                              ),
                                            ),
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            reverse: false,
                                            scrollDirection: Axis.vertical,
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
                                                  itemActivityIndex) {
                                                final itemActivityItem = _model
                                                    .listViewPagingController!
                                                    .itemList![itemActivityIndex];
                                                return InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                ModalDetailsProductWidget(
                                                              dataActivity:
                                                                  itemActivityItem,
                                                              isProvider: false,
                                                              isClient: false,
                                                              type: context
                                                                  .read<
                                                                      UiStateService>()
                                                                  .selectedProductType,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  child:
                                                      ActivitiesContainerWidget(
                                                    key: Key(
                                                        'Key7cc_${itemActivityIndex}_of_${_model.listViewPagingController!.itemList!.length}'),
                                                    name: getJsonField(
                                                      itemActivityItem,
                                                      r'''$.name''',
                                                    ).toString(),
                                                    location: getJsonField(
                                                      itemActivityItem,
                                                      r'''$.city''',
                                                    ).toString(),
                                                    descriptionShort:
                                                        getJsonField(
                                                      itemActivityItem,
                                                      r'''$.description''',
                                                    ).toString(),
                                                    image:
                                                        valueOrDefault<String>(
                                                      getJsonField(
                                                        itemActivityItem,
                                                        r'''$.main_image''',
                                                      )?.toString(),
                                                      'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                                    ),
                                                    provider: getJsonField(
                                                      itemActivityItem,
                                                      r'''$.name_provider''',
                                                    ).toString(),
                                                    locationName: getJsonField(
                                                      itemActivityItem,
                                                      r'''$.name_location''',
                                                    ).toString(),
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
        },
      ),
    );
  }
}
