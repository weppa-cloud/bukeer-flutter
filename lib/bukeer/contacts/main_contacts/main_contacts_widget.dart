import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../core/widgets/buttons/btn_create/btn_create_widget.dart';
import '../../core/widgets/modals/contact/add_edit/modal_add_edit_contact_widget.dart';
import '../../core/widgets/modals/contact/details/modal_details_contact_widget.dart';
import '../../core/widgets/forms/search_box/search_box_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import '../../../services/ui_state_service.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'main_contacts_model.dart';
import '../../../services/ui_state_service.dart';
import '../../../services/contact_service.dart';
export 'main_contacts_model.dart';

class MainContactsWidget extends StatefulWidget {
  const MainContactsWidget({super.key});

  static String routeName = 'main_contacts';
  static String routePath = 'contacts';

  @override
  State<MainContactsWidget> createState() => _MainContactsWidgetState();
}

class _MainContactsWidgetState extends State<MainContactsWidget> {
  late MainContactsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainContactsModel());

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
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.sizeOf(context).width * 1.0,
                            maxWidth: MediaQuery.sizeOf(context).width * 8.52,
                            maxHeight: 900.0,
                          ),
                          decoration: BoxDecoration(
                            color: BukeerColors.getBackground(context),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: BukeerColors.getBackground(context,
                                      secondary: true),
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
                                            color: BukeerColors.getBackground(
                                                context,
                                                secondary: true),
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
                                                          'Contactos',
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
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        context
                                                            .read<
                                                                ContactService>()
                                                            .allDataContact = null;
                                                        safeSetState(() {});
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
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
                                                                    ModalAddEditContactWidget(
                                                                  isEdit: false,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                      child: wrapWithModel(
                                                        model: _model
                                                            .btnCreateModel,
                                                        updateCallback: () =>
                                                            safeSetState(() {}),
                                                        child:
                                                            BtnCreateWidget(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          1.0,
                                                  decoration: BoxDecoration(
                                                    color: BukeerColors
                                                        .getBackground(context),
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
                                                            _model.isProviderClientState =
                                                                'provider';
                                                            safeSetState(() {});
                                                            safeSetState(() => _model
                                                                .listViewSearchPagingController
                                                                ?.refresh());
                                                            await _model
                                                                .waitForOnePageForListViewSearch();
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Icon(
                                                                Icons.list,
                                                                color: _model
                                                                            .isProviderClientState ==
                                                                        'provider'
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                size: 20.0,
                                                              ),
                                                              Text(
                                                                'Proveedores',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: _model.isProviderClientState ==
                                                                              'provider'
                                                                          ? FlutterFlowTheme.of(context)
                                                                              .primary
                                                                          : FlutterFlowTheme.of(context)
                                                                              .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width:
                                                                    BukeerSpacing
                                                                        .s)),
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
                                                            _model.isProviderClientState =
                                                                'client';
                                                            safeSetState(() {});
                                                            safeSetState(() => _model
                                                                .listViewSearchPagingController
                                                                ?.refresh());
                                                            await _model
                                                                .waitForOnePageForListViewSearch();
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Icon(
                                                                Icons.grid_view,
                                                                color: _model
                                                                            .isProviderClientState ==
                                                                        'client'
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                size: 20.0,
                                                              ),
                                                              Text(
                                                                'Clientes',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: _model.isProviderClientState ==
                                                                              'client'
                                                                          ? FlutterFlowTheme.of(context)
                                                                              .primary
                                                                          : FlutterFlowTheme.of(context)
                                                                              .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width:
                                                                    BukeerSpacing
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
                                                        width: 180.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: BukeerColors
                                                              .getBackground(
                                                                  context),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            wrapWithModel(
                                                              model: _model
                                                                  .searchBoxModel,
                                                              updateCallback: () =>
                                                                  safeSetState(
                                                                      () {}),
                                                              child:
                                                                  SearchBoxWidget(
                                                                hintText:
                                                                    'Buscar contactos',
                                                                onSearchChanged:
                                                                    (searchText) async {
                                                                  context
                                                                          .read<
                                                                              UiStateService>()
                                                                          .searchQuery =
                                                                      searchText;
                                                                  safeSetState(
                                                                      () => _model
                                                                          .listViewSearchPagingController
                                                                          ?.refresh());
                                                                  await _model
                                                                      .waitForOnePageForListViewSearch();
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(
                                                      width: BukeerSpacing.m)),
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
                              Flexible(
                                child: Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 1.0,
                                  constraints: BoxConstraints(
                                    maxWidth: 852.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      safeSetState(() => _model
                                          .listViewSearchPagingController
                                          ?.refresh());
                                    },
                                    child: PagedListView<ApiPagingParams,
                                        dynamic>.separated(
                                      pagingController:
                                          _model.setListViewSearchController(
                                        (nextPageMarker) =>
                                            GetContactSearchCall.call(
                                          search: context
                                              .read<UiStateService>()
                                              .searchQuery,
                                          authToken: currentJwtToken,
                                          pageNumber:
                                              nextPageMarker.nextPageNumber,
                                          pageSize: 10,
                                          type: _model.isProviderClientState,
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
                                          SizedBox(height: BukeerSpacing.s),
                                      builderDelegate:
                                          PagedChildBuilderDelegate<dynamic>(
                                        // Customize what your widget looks like when it's loading the first page.
                                        firstPageProgressIndicatorBuilder:
                                            (_) => Center(
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
                                            (context, _, contactItemIndex) {
                                          final contactItemItem = _model
                                              .listViewSearchPagingController!
                                              .itemList![contactItemIndex];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 100),
                                              curve: Curves.easeInOut,
                                              width: 45.0,
                                              constraints: BoxConstraints(
                                                minHeight: 70.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    BukeerColors.getBackground(
                                                        context,
                                                        secondary: true),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        BukeerSpacing.s),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context
                                                          .read<ContactService>()
                                                          .allDataContact =
                                                      contactItemItem;
                                                  safeSetState(() {});
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              ModalDetailsContactWidget(
                                                            idContact:
                                                                getJsonField(
                                                              contactItemItem,
                                                              r'''$.id''',
                                                            ).toString(),
                                                            dataContact:
                                                                contactItemItem,
                                                            isProvider:
                                                                getJsonField(
                                                              contactItemItem,
                                                              r'''$.is_provider''',
                                                            ),
                                                            isClient:
                                                                getJsonField(
                                                              contactItemItem,
                                                              r'''$.is_client''',
                                                            ),
                                                            isCompany:
                                                                getJsonField(
                                                              contactItemItem,
                                                              r'''$.is_company''',
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
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
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            4.0),
                                                                        child:
                                                                            Text(
                                                                          getJsonField(
                                                                            contactItemItem,
                                                                            r'''$.name''',
                                                                          ).toString(),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineSmall
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                color: BukeerColors.primaryText,
                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.bold,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    if (getJsonField(
                                                                      contactItemItem,
                                                                      r'''$.is_company''',
                                                                    ))
                                                                      Icon(
                                                                        Icons
                                                                            .business,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            16.0,
                                                                      ),
                                                                  ].divide(SizedBox(
                                                                      width: BukeerSpacing
                                                                          .s)),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Wrap(
                                                                            spacing:
                                                                                0.0,
                                                                            runSpacing:
                                                                                0.0,
                                                                            alignment:
                                                                                WrapAlignment.start,
                                                                            crossAxisAlignment:
                                                                                WrapCrossAlignment.start,
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            runAlignment:
                                                                                WrapAlignment.start,
                                                                            verticalDirection:
                                                                                VerticalDirection.down,
                                                                            clipBehavior:
                                                                                Clip.none,
                                                                            children: [
                                                                              if (getJsonField(
                                                                                    contactItemItem,
                                                                                    r'''$.email''',
                                                                                  ) !=
                                                                                  null)
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                      child: Icon(
                                                                                        Icons.email_sharp,
                                                                                        color: BukeerColors.secondaryText,
                                                                                        size: 16.0,
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                      child: Text(
                                                                                        getJsonField(
                                                                                          contactItemItem,
                                                                                          r'''$.email''',
                                                                                        ).toString(),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                              color: BukeerColors.secondaryText,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              if (getJsonField(
                                                                                    contactItemItem,
                                                                                    r'''$.phone''',
                                                                                  ) !=
                                                                                  null)
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                      child: Icon(
                                                                                        Icons.phone_iphone,
                                                                                        color: BukeerColors.secondaryText,
                                                                                        size: 16.0,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      getJsonField(
                                                                                        contactItemItem,
                                                                                        r'''$.phone''',
                                                                                      ).toString(),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: BukeerColors.secondaryText,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent1,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              child:
                                                                  Image.network(
                                                                valueOrDefault<
                                                                    String>(
                                                                  getJsonField(
                                                                    contactItemItem,
                                                                    r'''$.user_image''',
                                                                  )?.toString(),
                                                                  'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/profile_default.png',
                                                                ),
                                                                width: 200.0,
                                                                height: 200.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: BukeerSpacing
                                                                .m)),
                                                      ),
                                                    ),
                                                  ].addToStart(SizedBox(
                                                      height: BukeerSpacing.s)),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
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
