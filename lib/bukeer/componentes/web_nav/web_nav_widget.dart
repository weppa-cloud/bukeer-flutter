import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../services/ui_state_service.dart';
import '../main_logo_small/main_logo_small_widget.dart';
import '../../itinerarios/dropdown_accounts/dropdown_accounts_widget.dart';
import '../../productos/modal_details_product/modal_details_product_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../design_system/index.dart';
import 'dart:ui';
import '../../../index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'web_nav_model.dart';
export 'web_nav_model.dart';

class WebNavWidget extends StatefulWidget {
  const WebNavWidget({
    super.key,
    this.selectedNav,
  });

  final int? selectedNav;

  @override
  State<WebNavWidget> createState() => _WebNavWidgetState();
}

class _WebNavWidgetState extends State<WebNavWidget> {
  late WebNavModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WebNavModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.responseGetAgent = await GetAgentCall.call(
        authToken: currentJwtToken,
        id: currentUserUid,
        accountIdParam: FFAppState().accountId,
      );

      if ((_model.responseGetAgent?.succeeded ?? true)) {
        FFAppState().agent = (_model.responseGetAgent?.jsonBody ?? '');
        safeSetState(() {});
      }
      _model.apiResponseDataAccount =
          await GetAllDataAccountWithLocationCall.call(
        authToken: currentJwtToken,
        accountId: FFAppState().accountId,
      );

      if ((_model.apiResponseDataAccount?.succeeded ?? true)) {
        FFAppState().allDataAccount =
            (_model.apiResponseDataAccount?.jsonBody ?? '');
        safeSetState(() {});
        FFAppState().accountCurrency = getJsonField(
          (_model.apiResponseDataAccount?.jsonBody ?? ''),
          r'''$[:].currency''',
          true,
        )!
            .toList()
            .cast<dynamic>();
        FFAppState().accountTypesIncrease = getJsonField(
          (_model.apiResponseDataAccount?.jsonBody ?? ''),
          r'''$[:].types_increase''',
          true,
        )!
            .toList()
            .cast<dynamic>();
        FFAppState().accountPaymentMethods = getJsonField(
          (_model.apiResponseDataAccount?.jsonBody ?? ''),
          r'''$[:].payment_methods''',
          true,
        )!
            .toList()
            .cast<dynamic>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Mensaje'),
              content: Text('Error al cargar información de la cuenta'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsets.only(right: BukeerSpacing.xs),
      child: Container(
        width: 270.0,
        height: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 300.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              color: FlutterFlowTheme.of(context).alternate,
              offset: Offset(
                1.0,
                0.0,
              ),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(BukeerSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.m),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(MainHomeWidget.routeName);
                      },
                      child: wrapWithModel(
                        model: _model.mainLogoSmallModel,
                        updateCallback: () => safeSetState(() {}),
                        child: MainLogoSmallWidget(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.l),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: BukeerColors.overlay,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: ModalDetailsProductWidget(),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      MainHomeWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );

                    context.read<UiStateService>().searchQuery = '';
                    context.read<UiStateService>().selectedProductType = 'activities';
                    context.read<UiStateService>().selectedImageUrl = '';
                    safeSetState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget!.selectedNav == 1
                          ? FlutterFlowTheme.of(context).alternate
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(BukeerSpacing.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard_rounded,
                            color: widget!.selectedNav == 1
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 28.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: BukeerSpacing.s),
                            child: Text(
                              'Dashboard',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: widget!.selectedNav == 1
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      MainItinerariesWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );

                    context.read<UiStateService>().searchQuery = '';
                    context.read<UiStateService>().selectedProductType = 'activities';
                    context.read<UiStateService>().selectedImageUrl = '';
                    safeSetState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget!.selectedNav == 2
                          ? FlutterFlowTheme.of(context).alternate
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(BukeerSpacing.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.route,
                            color: widget!.selectedNav == 2
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 28.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: BukeerSpacing.s),
                            child: Text(
                              'Itinerarios',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: widget!.selectedNav == 2
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      MainContactsWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );

                    context.read<UiStateService>().searchQuery = '';
                    context.read<UiStateService>().selectedProductType = 'activities';
                    context.read<UiStateService>().selectedImageUrl = '';
                    safeSetState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget!.selectedNav == 3
                          ? FlutterFlowTheme.of(context).alternate
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(BukeerSpacing.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contacts_sharp,
                            color: widget!.selectedNav == 3
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 28.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: BukeerSpacing.s),
                            child: Text(
                              'Contactos',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: widget!.selectedNav == 3
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      MainProductsWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );

                    context.read<UiStateService>().searchQuery = '';
                    context.read<UiStateService>().selectedProductType = 'activities';
                    context.read<UiStateService>().selectedImageUrl = '';
                    safeSetState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget!.selectedNav == 4
                          ? FlutterFlowTheme.of(context).alternate
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(BukeerSpacing.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.boxes,
                            color: widget!.selectedNav == 4
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 28.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: BukeerSpacing.s),
                            child: Text(
                              'Productos',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: widget!.selectedNav == 4
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      MainAgendaWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );

                    context.read<UiStateService>().searchQuery = '';
                    context.read<UiStateService>().selectedProductType = 'activities';
                    context.read<UiStateService>().selectedImageUrl = '';
                    safeSetState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget!.selectedNav == 8
                          ? FlutterFlowTheme.of(context).alternate
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(BukeerSpacing.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: widget!.selectedNav == 8
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 28.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: BukeerSpacing.s),
                            child: Text(
                              'Agenda',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: widget!.selectedNav == 8
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if ((FFAppState().idRole != 4) && (FFAppState().idRole != 3))
                Padding(
                  padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(
                        MainUsersWidget.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );

                      context.read<UiStateService>().searchQuery = '';
                      context.read<UiStateService>().selectedProductType = 'activities';
                      context.read<UiStateService>().selectedImageUrl = '';
                      safeSetState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: widget!.selectedNav == 5
                            ? FlutterFlowTheme.of(context).alternate
                            : FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(BukeerSpacing.s),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.groups,
                              color: widget!.selectedNav == 5
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).secondaryText,
                              size: 28.0,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Usuarios',
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelLargeFamily,
                                      color: widget!.selectedNav == 5
                                          ? FlutterFlowTheme.of(context)
                                              .primaryText
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelLargeIsCustom,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: BukeerSpacing.m),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Divider(
                        height: BukeerSpacing.s,
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: widget!.selectedNav == 7
                              ? FlutterFlowTheme.of(context).alternate
                              : FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                          borderRadius: BorderRadius.circular(BukeerSpacing.s),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(BukeerSpacing.s),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      MainProfileAccountWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                          duration: Duration(milliseconds: 0),
                                        ),
                                      },
                                    );

                                    context.read<UiStateService>().searchQuery = '';
                                    context.read<UiStateService>().selectedProductType = 'activities';
                                    context.read<UiStateService>().selectedImageUrl = '';
                                    safeSetState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.settings_rounded,
                                          color: widget!.selectedNav == 7
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          size: 28.0,
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: BukeerSpacing.s),
                                              child: Text(
                                                'Ajustes ',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      color: widget!
                                                                  .selectedNav ==
                                                              7
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeIsCustom,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 150.0,
                                              ),
                                              decoration: BoxDecoration(),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: BukeerSpacing.s),
                                              child: Text(
                                                getJsonField(
                                                  FFAppState().allDataAccount,
                                                  r'''$[:].name''',
                                                ).toString(),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumIsCustom,
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
                              Padding(
                                padding: EdgeInsets.only(left: 50.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: DropdownAccountsWidget(),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.exchangeAlt,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: BukeerSpacing.s),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              MainProfilePageWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 0),
                                ),
                              },
                            );

                            context.read<UiStateService>().searchQuery = '';
                            context.read<UiStateService>().selectedProductType = 'activities';
                            context.read<UiStateService>().selectedImageUrl = '';
                            safeSetState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).accent1,
                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(BukeerSpacing.xs),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    child: CachedNetworkImage(
                                      fadeInDuration:
                                          Duration(milliseconds: 500),
                                      fadeOutDuration:
                                          Duration(milliseconds: 500),
                                      imageUrl: valueOrDefault<String>(
                                        getJsonField(
                                          FFAppState().agent,
                                          r'''$[:].user_image''',
                                        )?.toString(),
                                        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/profile_default.png',
                                      ),
                                      width: 44.0,
                                      height: 44.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: BukeerSpacing.s),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${getJsonField(
                                          FFAppState().agent,
                                          r'''$[:].name''',
                                        ).toString()} ${getJsonField(
                                          FFAppState().agent,
                                          r'''$[:].last_name''',
                                        ).toString()}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyLargeIsCustom,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: BukeerSpacing.xs),
                                        child: Text(
                                          getJsonField(
                                            FFAppState().agent,
                                            r'''$[:].email''',
                                          ).toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmallFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelSmallIsCustom,
                                              ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
