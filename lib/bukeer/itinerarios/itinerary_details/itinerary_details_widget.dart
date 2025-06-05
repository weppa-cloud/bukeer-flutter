import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../componentes/web_nav/web_nav_widget.dart';
import '../pagos/component_add_paid/component_add_paid_widget.dart';
import '../pasajeros/modal_add_passenger/modal_add_passenger_widget.dart';
import '../preview/component_itinerary_preview_activities/component_itinerary_preview_activities_widget.dart';
import '../preview/component_itinerary_preview_flights/component_itinerary_preview_flights_widget.dart';
import '../preview/component_itinerary_preview_hotels/component_itinerary_preview_hotels_widget.dart';
import '../preview/component_itinerary_preview_transfers/component_itinerary_preview_transfers_widget.dart';
import '../proveedores/component_provider_payments/component_provider_payments_widget.dart';
import '../proveedores/reservation_message/reservation_message_widget.dart';
import '../proveedores/show_reservation_message/show_reservation_message_widget.dart';
import '../servicios/add_a_i_flights/add_a_i_flights_widget.dart';
import '../travel_planner_section/travel_planner_section_widget.dart';
import '../../modal_add_edit_itinerary/modal_add_edit_itinerary_widget.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '../../../custom_code/actions/index.dart' as actions;
import '../../../flutter_flow/custom_functions.dart' as functions;
import '../../../index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'itinerary_details_model.dart';
import '../../../../services/ui_state_service.dart';
import '../../../../services/product_service.dart';
import '../../../../services/contact_service.dart';
import '../../../../services/itinerary_service.dart';
export 'itinerary_details_model.dart';

class ItineraryDetailsWidget extends StatefulWidget {
  const ItineraryDetailsWidget({
    super.key,
    this.allDateHotel,
    this.id,
  });

  final dynamic allDateHotel;
  final String? id;

  static String routeName = 'itineraryDetails';
  static String routePath = 'itinerary/:id';

  @override
  State<ItineraryDetailsWidget> createState() => _ItineraryDetailsWidgetState();
}

class _ItineraryDetailsWidgetState extends State<ItineraryDetailsWidget>
    with TickerProviderStateMixin {
  late ItineraryDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItineraryDetailsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      safeSetState(
          () => _model.listViewItemsItineraryPagingController?.refresh());
      await _model.waitForOnePageForListViewItemsItinerary();
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<ApiCallResponse>(
      future: GetitIneraryDetailsCall.call(
        authToken: currentJwtToken,
        itineraryId: widget!.id,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        final itineraryDetailsGetitIneraryDetailsResponse = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
                        if (responsiveVisibility(
                          context: context,
                          phone: false,
                          tablet: false,
                        ))
                          wrapWithModel(
                            model: _model.webNavModel,
                            updateCallback: () => safeSetState(() {}),
                            child: WebNavWidget(
                              selectedNav: 2,
                            ),
                          ),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.sizeOf(context).width * 1.0,
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * 8.52,
                                maxHeight: 900.0,
                              ),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 850.0,
                                              ),
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                0.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        topRight:
                                                            Radius.circular(
                                                                0.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(BukeerSpacing.m),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
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
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          FlutterFlowIconButton(
                                                                            borderColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            borderRadius:
                                                                                12.0,
                                                                            borderWidth:
                                                                                2.0,
                                                                            buttonSize:
                                                                                40.0,
                                                                            fillColor:
                                                                                FlutterFlowTheme.of(context).accent1,
                                                                            icon:
                                                                                Icon(
                                                                              Icons.arrow_back_outlined,
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              context.read<ContactService>().allDataContact = null;
                                                                              context.read<ItineraryService>().allDataItinerary = null;
                                                                              context.read<UiStateService>().searchQuery = '';
                                                                              safeSetState(() {});

                                                                              context.pushNamed(MainItinerariesWidget.routeName);
                                                                            },
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(left: BukeerSpacing.s),
                                                                                    child: Text(
                                                                                      getJsonField(
                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                        r'''$[:].name''',
                                                                                      ).toString(),
                                                                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            letterSpacing: 0.0,
                                                                                            lineHeight: 1.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                if (('${getJsonField(
                                                                                          FFAppState().agent,
                                                                                          r'''$[:].role_id''',
                                                                                        ).toString()}' ==
                                                                                        '1') ||
                                                                                    (('${getJsonField(
                                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                              r'''$[:].status''',
                                                                                            ).toString()}' ==
                                                                                            'Presupuesto') &&
                                                                                        ('${getJsonField(
                                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                              r'''$[:].paid''',
                                                                                            ).toString()}' !=
                                                                                            '0')))
                                                                                  Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Text(
                                                                                            'Confirmar',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                          Switch.adaptive(
                                                                                            value: _model.switchConfirmarValue ??= '${getJsonField(
                                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                      r'''$[:].status''',
                                                                                                    ).toString()}' ==
                                                                                                    'Presupuesto'
                                                                                                ? false
                                                                                                : true,
                                                                                            onChanged: (newValue) async {
                                                                                              safeSetState(() => _model.switchConfirmarValue = newValue!);
                                                                                              if (newValue!) {
                                                                                                _model.apiResponseChangeStatus = await UpdateItineraryStatusCall.call(
                                                                                                  authToken: currentJwtToken,
                                                                                                  id: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].id''',
                                                                                                  ).toString(),
                                                                                                  status: 'Confirmado',
                                                                                                );

                                                                                                if ((_model.apiResponseChangeStatus?.succeeded ?? true)) {
                                                                                                  context.goNamed(
                                                                                                    ItineraryDetailsWidget.routeName,
                                                                                                    pathParameters: {
                                                                                                      'id': serializeParam(
                                                                                                        getJsonField(
                                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                          r'''$[:].id''',
                                                                                                        ).toString(),
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                    }.withoutNulls,
                                                                                                  );
                                                                                                } else {
                                                                                                  await showDialog(
                                                                                                    context: context,
                                                                                                    builder: (alertDialogContext) {
                                                                                                      return AlertDialog(
                                                                                                        title: Text('Mensaje'),
                                                                                                        content: Text('Hubo un error al cambiar el estado a confirmado'),
                                                                                                        actions: [
                                                                                                          TextButton(
                                                                                                            onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                            child: Text('Ok'),
                                                                                                          ),
                                                                                                        ],
                                                                                                      );
                                                                                                    },
                                                                                                  );
                                                                                                  await showDialog(
                                                                                                    context: context,
                                                                                                    builder: (alertDialogContext) {
                                                                                                      return AlertDialog(
                                                                                                        title: Text('Mensaje 2'),
                                                                                                        content: Text((_model.apiResponseChangeStatus?.jsonBody ?? '').toString()),
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

                                                                                                safeSetState(() {});
                                                                                              } else {
                                                                                                _model.apiResponseChangeStatusCopy = await UpdateItineraryStatusCall.call(
                                                                                                  authToken: currentJwtToken,
                                                                                                  id: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].id''',
                                                                                                  ).toString(),
                                                                                                  status: 'Presupuesto',
                                                                                                );

                                                                                                if ((_model.apiResponseChangeStatusCopy?.succeeded ?? true)) {
                                                                                                  context.goNamed(
                                                                                                    ItineraryDetailsWidget.routeName,
                                                                                                    pathParameters: {
                                                                                                      'id': serializeParam(
                                                                                                        getJsonField(
                                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                          r'''$[:].id''',
                                                                                                        ).toString(),
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                    }.withoutNulls,
                                                                                                  );
                                                                                                } else {
                                                                                                  await showDialog(
                                                                                                    context: context,
                                                                                                    builder: (alertDialogContext) {
                                                                                                      return AlertDialog(
                                                                                                        title: Text('Mensaje'),
                                                                                                        content: Text('Hubo un error al cambiar el estado a presupuesto'),
                                                                                                        actions: [
                                                                                                          TextButton(
                                                                                                            onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                            child: Text('Ok'),
                                                                                                          ),
                                                                                                        ],
                                                                                                      );
                                                                                                    },
                                                                                                  );
                                                                                                  await showDialog(
                                                                                                    context: context,
                                                                                                    builder: (alertDialogContext) {
                                                                                                      return AlertDialog(
                                                                                                        title: Text('Mensaje 2'),
                                                                                                        content: Text((_model.apiResponseChangeStatusCopy?.jsonBody ?? '').toString()),
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

                                                                                                safeSetState(() {});
                                                                                              }
                                                                                            },
                                                                                            activeColor: FlutterFlowTheme.of(context).primary,
                                                                                            activeTrackColor: FlutterFlowTheme.of(context).primary,
                                                                                            inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                                                                                            inactiveThumbColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                              ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                8.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              height: 32.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).accent1,
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                border: Border.all(
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                              ),
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                child: Text(
                                                                                  getJsonField(
                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                    r'''$[:].status''',
                                                                                  ).toString(),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Wrap(
                                                                      spacing:
                                                                          0.0,
                                                                      runSpacing:
                                                                          0.0,
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          WrapCrossAlignment
                                                                              .start,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      runAlignment:
                                                                          WrapAlignment
                                                                              .start,
                                                                      verticalDirection:
                                                                          VerticalDirection
                                                                              .down,
                                                                      clipBehavior:
                                                                          Clip.none,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 8.0, 0.0),
                                                                              child: Text(
                                                                                'ID',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                              child: Text(
                                                                                getJsonField(
                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  r'''$[:].id_fm''',
                                                                                ).toString(),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                              child: Icon(
                                                                                Icons.person,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 2.0, 0.0),
                                                                                  child: Text(
                                                                                    getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].contact_name''',
                                                                                    ).toString(),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                if (getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].contact_lastname''',
                                                                                    ) !=
                                                                                    null)
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                    child: Text(
                                                                                      getJsonField(
                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                        r'''$[:].contact_lastname''',
                                                                                      ).toString(),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                              child: Icon(
                                                                                Icons.date_range,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                              child: Text(
                                                                                '${(String var1) {
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
                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  r'''$[:].start_date''',
                                                                                ).toString())} - ${(String var1) {
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
                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  r'''$[:].end_date''',
                                                                                ).toString())}',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        if ('${getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].currency_type''',
                                                                            ).toString()}' !=
                                                                            'COP')
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                child: Icon(
                                                                                  Icons.currency_exchange,
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  size: 16.0,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                child: Text(
                                                                                  '1 ${getJsonField(
                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                    r'''$[:].currency_type''',
                                                                                  ).toString()} ≈${formatNumber(
                                                                                    double.parse((functions.getExchangeRate(
                                                                                            getJsonField(
                                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                              r'''$[:].currency''',
                                                                                              true,
                                                                                            ),
                                                                                            getJsonField(
                                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                              r'''$[:].currency_type''',
                                                                                            ).toString())!)
                                                                                        .toStringAsFixed(1)),
                                                                                    formatType: FormatType.decimal,
                                                                                    decimalType: DecimalType.commaDecimal,
                                                                                  )}',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                              child: Icon(
                                                                                Icons.language_sharp,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  GetitIneraryDetailsCall.language(
                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  ),
                                                                                  'language',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                              child: Icon(
                                                                                Icons.auto_graph,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  GetitIneraryDetailsCall.requestType(
                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  ),
                                                                                  'tipo de itenerario',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                              child: Icon(
                                                                                Icons.hourglass_top,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.s),
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
                                                                                }(GetitIneraryDetailsCall.validUntil(
                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                )!),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                              child: Icon(
                                                                                Icons.people,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              getJsonField(
                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                r'''$[:].passenger_count''',
                                                                              ).toString(),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
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
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  if (('${getJsonField(
                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                            r'''$[:].status''',
                                                                          ).toString()}' !=
                                                                          'Confirmado') &&
                                                                      (('${getJsonField(
                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                r'''$[:].id_created_by''',
                                                                              ).toString()}' ==
                                                                              currentUserUid) ||
                                                                          ('${getJsonField(
                                                                                FFAppState().agent,
                                                                                r'''$[:].role_id''',
                                                                              ).toString()}' ==
                                                                              '1')))
                                                                    FlutterFlowIconButton(
                                                                      borderColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .alternate,
                                                                      borderRadius:
                                                                          12.0,
                                                                      borderWidth:
                                                                          2.0,
                                                                      buttonSize:
                                                                          40.0,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .accent4,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .edit_outlined,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        context.read<ItineraryService>().allDataItinerary =
                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                        context.read<UiStateService>().selectedImageUrl =
                                                                            getJsonField(
                                                                          itineraryDetailsGetitIneraryDetailsResponse
                                                                              .jsonBody,
                                                                          r'''$[:].main_image''',
                                                                        ).toString();
                                                                        safeSetState(
                                                                            () {});
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: ModalAddEditItineraryWidget(
                                                                                  isEdit: true,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));
                                                                      },
                                                                    ),
                                                                  if (false)
                                                                    FlutterFlowIconButton(
                                                                      borderColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .alternate,
                                                                      borderRadius:
                                                                          12.0,
                                                                      borderWidth:
                                                                          2.0,
                                                                      buttonSize:
                                                                          40.0,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .accent4,
                                                                      icon:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .trashAlt,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: ModalAddEditItineraryWidget(
                                                                                  isEdit: true,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));
                                                                      },
                                                                    ),
                                                                  FlutterFlowIconButton(
                                                                    borderColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                    borderRadius:
                                                                        12.0,
                                                                    borderWidth:
                                                                        2.0,
                                                                    buttonSize:
                                                                        40.0,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .accent4,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .content_copy,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      var confirmDialogResponse = await showDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Mensaje'),
                                                                                content: Text('¿Estas seguro que vas a realizar una copia de este itinerario y sus items?'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                    child: Text('Cancel'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                    child: Text('Confirm'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) ??
                                                                          false;
                                                                      if (confirmDialogResponse) {
                                                                        _model.apiResponseDuplicateItinerary =
                                                                            await DuplicateItineraryCall.call(
                                                                          authToken:
                                                                              currentJwtToken,
                                                                          originalId:
                                                                              getJsonField(
                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                            r'''$[:].id''',
                                                                          ).toString(),
                                                                          newIdFm:
                                                                              '${FFAppState().accountIdFm}-',
                                                                        );

                                                                        if ((_model.apiResponseDuplicateItinerary?.succeeded ??
                                                                            true)) {
                                                                          context.read<ContactService>().allDataContact =
                                                                              (_model.apiResponseDuplicateItinerary?.jsonBody ?? '');
                                                                          safeSetState(
                                                                              () {});

                                                                          context
                                                                              .pushNamed(
                                                                            ItineraryDetailsWidget.routeName,
                                                                            pathParameters:
                                                                                {
                                                                              'id': serializeParam(
                                                                                getJsonField(
                                                                                  (_model.apiResponseDuplicateItinerary?.jsonBody ?? ''),
                                                                                  r'''$.itinerary_id''',
                                                                                ).toString(),
                                                                                ParamType.String,
                                                                              ),
                                                                            }.withoutNulls,
                                                                          );
                                                                        } else {
                                                                          await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Mensaje'),
                                                                                content: Text('Hubo un error al duplicar itinerario'),
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
                                                                      }

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        4.0)),
                                                              ),
                                                            ],
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
                                                                    .end,
                                                            children: [
                                                              wrapWithModel(
                                                                model: _model.travelPlannerSectionModel,
                                                                updateCallback: () => safeSetState(() {}),
                                                                child: TravelPlannerSectionWidget(
                                                                  itineraryId: widget.id!,
                                                                  currentAgentId: getJsonField(
                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                    r'$[:].agent',
                                                                  )?.toString(),
                                                                  travelPlannerName: getJsonField(
                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                    r'$[:].travel_planner_name',
                                                                  )?.toString(),
                                                                  travelPlannerLastName: getJsonField(
                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                    r'$[:].travel_planner_last_name',
                                                                  )?.toString(),
                                                                  isEditable: false, // Deshabilitado - solo lectura
                                                                  onUpdated: () async {
                                                                    // Recargar datos del itinerario - recargar la página
                                                                    safeSetState(() {});
                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0x0D4B39EF),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            'Total ${valueOrDefault<String>(
                                                                              formatNumber(
                                                                                double.parse((functions.costMultiCurrenty(
                                                                                        getJsonField(
                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                          r'''$[:].currency''',
                                                                                          true,
                                                                                        ),
                                                                                        getJsonField(
                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                          r'''$[:].currency_type''',
                                                                                        ).toString(),
                                                                                        getJsonField(
                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                          r'''$[:].total_amount''',
                                                                                        ))!)
                                                                                    .toStringAsFixed(1)),
                                                                                formatType: FormatType.decimal,
                                                                                decimalType: DecimalType.commaDecimal,
                                                                                currency: '',
                                                                              ),
                                                                              '0',
                                                                            )} ${getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].currency_type''',
                                                                            ).toString()}',
                                                                            '0',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineSmall
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                              ),
                                                                        ),
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            'Valor por persona ${valueOrDefault<String>(
                                                                              formatNumber(
                                                                                double.parse(((functions.costMultiCurrenty(
                                                                                            getJsonField(
                                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                              r'''$[:].currency''',
                                                                                              true,
                                                                                            ),
                                                                                            getJsonField(
                                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                              r'''$[:].currency_type''',
                                                                                            ).toString(),
                                                                                            getJsonField(
                                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                              r'''$[:].total_amount''',
                                                                                            ))!) /
                                                                                        getJsonField(
                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                          r'''$[:].passenger_count''',
                                                                                        ))
                                                                                    .toStringAsFixed(1)),
                                                                                formatType: FormatType.decimal,
                                                                                decimalType: DecimalType.commaDecimal,
                                                                                currency: '',
                                                                              ),
                                                                              '0',
                                                                            )} ${getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].currency_type''',
                                                                            ).toString()}',
                                                                            '0',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineSmall
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                fontSize: BukeerTypography.bodyLargeSize,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                              ),
                                                                        ),
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            'Margen ${valueOrDefault<String>(
                                                                              formatNumber(
                                                                                double.parse(getJsonField(
                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  r'''$[:].total_markup''',
                                                                                ).toStringAsFixed(1)),
                                                                                formatType: FormatType.decimal,
                                                                                decimalType: DecimalType.commaDecimal,
                                                                                currency: '',
                                                                              ),
                                                                              '0',
                                                                            )} ${getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].currency[0].name''',
                                                                            ).toString()}',
                                                                            '0',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .titleLarge
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 12.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  8.0,
                                                                  8.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1.0,
                                                        height: 15.0,
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
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      16.0,
                                                                      0.0),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
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
                                                                    _model.typeProduct =
                                                                        1;
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .push_pin,
                                                                        color: _model.typeProduct ==
                                                                                1
                                                                            ? FlutterFlowTheme.of(context).primary
                                                                            : FlutterFlowTheme.of(context).secondaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      Text(
                                                                        'Services',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: _model.typeProduct == 1 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width:
                                                                            8.0)),
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
                                                                    _model.typeProduct =
                                                                        2;
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .paid,
                                                                        color: _model.typeProduct ==
                                                                                2
                                                                            ? FlutterFlowTheme.of(context).primary
                                                                            : FlutterFlowTheme.of(context).secondaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      Text(
                                                                        'Pagos',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: _model.typeProduct == 2 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width:
                                                                            8.0)),
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
                                                                    _model.itemsItinerary =
                                                                        await ItineraryItemsTable()
                                                                            .queryRows(
                                                                      queryFn:
                                                                          (q) =>
                                                                              q.eqOrNull(
                                                                        'id_itinerary',
                                                                        widget!
                                                                            .id,
                                                                      ),
                                                                    );
                                                                    if (_model.itemsItinerary !=
                                                                            null &&
                                                                        (_model.itemsItinerary)!
                                                                            .isNotEmpty) {
                                                                      _model.typeProduct =
                                                                          3;
                                                                      safeSetState(
                                                                          () {});
                                                                    } else {
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (alertDialogContext) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('Mensaje'),
                                                                            content:
                                                                                Text('Itinerario vacío, agrega ítems para continuar'),
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

                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .remove_red_eye,
                                                                        color: _model.typeProduct ==
                                                                                3
                                                                            ? FlutterFlowTheme.of(context).primary
                                                                            : FlutterFlowTheme.of(context).secondaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      Text(
                                                                        'Preview',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: _model.typeProduct == 3 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width:
                                                                            8.0)),
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
                                                                    _model.typeProduct =
                                                                        4;
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .family_restroom,
                                                                        color: _model.typeProduct ==
                                                                                4
                                                                            ? FlutterFlowTheme.of(context).primary
                                                                            : FlutterFlowTheme.of(context).secondaryText,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      Text(
                                                                        'Pasajeros',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: _model.typeProduct == 4 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width:
                                                                            8.0)),
                                                                  ),
                                                                ),
                                                                if (GetitIneraryDetailsCall
                                                                        .status(
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody,
                                                                    ) ==
                                                                    'Confirmado')
                                                                  InkWell(
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
                                                                      _model.typeProduct =
                                                                          5;
                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children:
                                                                          [
                                                                        Icon(
                                                                          Icons
                                                                              .paypal_sharp,
                                                                          color: _model.typeProduct == 5
                                                                              ? FlutterFlowTheme.of(context).primary
                                                                              : FlutterFlowTheme.of(context).secondaryText,
                                                                          size:
                                                                              20.0,
                                                                        ),
                                                                        Text(
                                                                          'Proveedores',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: _model.typeProduct == 5 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 8.0)),
                                                                    ),
                                                                  ),
                                                              ].divide(SizedBox(
                                                                  width: 24.0)),
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
                                        ],
                                      ),
                                    ),
                                    if (_model.typeProduct == 1)
                                      Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.9,
                                        constraints: BoxConstraints(
                                          maxWidth: 852.0,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 1.0, 0.0, 0.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                0.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        topRight:
                                                            Radius.circular(
                                                                0.0),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment(
                                                              -1.0, 0),
                                                          child: TabBar(
                                                            isScrollable: true,
                                                            tabAlignment:
                                                                TabAlignment
                                                                    .start,
                                                            labelColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            unselectedLabelColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                            labelPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        20.0,
                                                                        0.0,
                                                                        20.0,
                                                                        0.0),
                                                            labelStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleMediumFamily,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleMediumIsCustom,
                                                                    ),
                                                            unselectedLabelStyle:
                                                                TextStyle(),
                                                            indicatorColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            tabs: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .flight_rounded,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Vuelos',
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .hotel,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Hoteles',
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .volunteer_activism,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Actividades',
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .directions_car,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Transfer',
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                            controller: _model
                                                                .tabBarController,
                                                            onTap: (i) async {
                                                              [
                                                                () async {
                                                                  // Set flight tab as active
                                                                  _model.typeProduct = 1;
                                                                  context.read<ContactService>()
                                                                          .allDataContact =
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody;
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                () async {
                                                                  // Set hotel tab as active
                                                                  _model.typeProduct = 2;
                                                                  context.read<ContactService>()
                                                                          .allDataContact =
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody;
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                () async {
                                                                  // Set activity tab as active
                                                                  _model.typeProduct = 3;
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                () async {
                                                                  // Set transfer tab as active
                                                                  _model.typeProduct = 4;
                                                                  context.read<ContactService>()
                                                                          .allDataContact =
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                              ][i]();
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TabBarView(
                                                            controller: _model
                                                                .tabBarController,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(BukeerSpacing.s),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            await showModalBottomSheet(
                                                                              isScrollControlled: true,
                                                                              backgroundColor: Colors.transparent,
                                                                              enableDrag: false,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    FocusScope.of(context).unfocus();
                                                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                    child: AddAIFlightsWidget(
                                                                                      idItinerary: widget!.id!,
                                                                                      idaccount: FFAppState().accountId,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ).then((value) =>
                                                                                safeSetState(() {}));
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  'Total  vuelos ${valueOrDefault<String>(
                                                                                    formatNumber(
                                                                                      getJsonField(
                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                        r'''$[:].total_flights''',
                                                                                      ),
                                                                                      formatType: FormatType.decimal,
                                                                                      decimalType: DecimalType.commaDecimal,
                                                                                      currency: '',
                                                                                    ),
                                                                                    '0',
                                                                                  )}',
                                                                                  '0',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                      fontSize: BukeerTypography.bodyMediumSize,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                    ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  if (('${getJsonField(
                                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                            r'''$[:].status''',
                                                                                          ).toString()}' !=
                                                                                          'Confirmado') &&
                                                                                      ('${getJsonField(
                                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                            r'''$[:].id_created_by''',
                                                                                          ).toString()}' ==
                                                                                          currentUserUid))
                                                                                    FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        await showModalBottomSheet(
                                                                                          isScrollControlled: true,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          enableDrag: false,
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return GestureDetector(
                                                                                              onTap: () {
                                                                                                FocusScope.of(context).unfocus();
                                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                                child: AddAIFlightsWidget(
                                                                                                  idItinerary: widget!.id!,
                                                                                                  idaccount: FFAppState().accountId,
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ).then((value) => safeSetState(() {}));
                                                                                      },
                                                                                      text: 'Agregar con IA',
                                                                                      icon: Icon(
                                                                                        Icons.add_sharp,
                                                                                        size: 24.0,
                                                                                      ),
                                                                                      options: FFButtonOptions(
                                                                                        height: 36.0,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                        iconAlignment: IconAlignment.end,
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        iconColor: FlutterFlowTheme.of(context).info,
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                              color: FlutterFlowTheme.of(context).info,
                                                                                              letterSpacing: 0.0,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                            ),
                                                                                        elevation: 3.0,
                                                                                        borderSide: BorderSide(
                                                                                          color: Colors.transparent,
                                                                                          width: 1.0,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                        hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                        hoverBorderSide: BorderSide(
                                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                                          width: 1.0,
                                                                                        ),
                                                                                        hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                        hoverElevation: 0.0,
                                                                                      ),
                                                                                    ),
                                                                                  if (('${getJsonField(
                                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                            r'''$[:].status''',
                                                                                          ).toString()}' !=
                                                                                          'Confirmado') &&
                                                                                      ('${getJsonField(
                                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                            r'''$[:].id_created_by''',
                                                                                          ).toString()}' ==
                                                                                          currentUserUid))
                                                                                    FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        context.read<UiStateService>().itemsProducts = null;
                                                                                        context.read<ProductService>().allDataFlight = null;
                                                                                        context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                        safeSetState(() {});

                                                                                        context.pushNamed(
                                                                                          AddFlightsWidget.routeName,
                                                                                          queryParameters: {
                                                                                            'isEdit': serializeParam(
                                                                                              false,
                                                                                              ParamType.bool,
                                                                                            ),
                                                                                            'itineraryId': serializeParam(
                                                                                              widget!.id,
                                                                                              ParamType.String,
                                                                                            ),
                                                                                          }.withoutNulls,
                                                                                        );
                                                                                      },
                                                                                      text: 'Agregar vuelos',
                                                                                      icon: Icon(
                                                                                        Icons.add_sharp,
                                                                                        size: 24.0,
                                                                                      ),
                                                                                      options: FFButtonOptions(
                                                                                        height: 36.0,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                        iconAlignment: IconAlignment.end,
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        iconColor: FlutterFlowTheme.of(context).info,
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                              color: FlutterFlowTheme.of(context).info,
                                                                                              letterSpacing: 0.0,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                            ),
                                                                                        elevation: 3.0,
                                                                                        borderSide: BorderSide(
                                                                                          color: Colors.transparent,
                                                                                          width: 1.0,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                        hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                        hoverBorderSide: BorderSide(
                                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                                          width: 1.0,
                                                                                        ),
                                                                                        hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                        hoverElevation: 0.0,
                                                                                      ),
                                                                                    ),
                                                                                ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      FutureBuilder<
                                                                          ApiCallResponse>(
                                                                        future:
                                                                            GetProductsItineraryItemsCall.call(
                                                                          pIdItinerary:
                                                                              widget!.id,
                                                                          pProductType:
                                                                              'Vuelos',
                                                                          authToken:
                                                                              currentJwtToken,
                                                                        ),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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
                                                                          final listViewGetProductsItineraryItemsResponse =
                                                                              snapshot.data!;

                                                                          return Builder(
                                                                            builder:
                                                                                (context) {
                                                                              final flightItineraryItem = listViewGetProductsItineraryItemsResponse.jsonBody.toList();

                                                                              return ListView.separated(
                                                                                padding: EdgeInsets.zero,
                                                                                primary: false,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemCount: flightItineraryItem.length,
                                                                                separatorBuilder: (_, __) => SizedBox(height: BukeerSpacing.m),
                                                                                itemBuilder: (context, flightItineraryItemIndex) {
                                                                                  final flightItineraryItemItem = flightItineraryItem[flightItineraryItemIndex];
                                                                                  return Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                                                                                    child: Material(
                                                                                      color: Colors.transparent,
                                                                                      elevation: 1.0,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(BukeerSpacing.s),
                                                                                          child: InkWell(
                                                                                            splashColor: Colors.transparent,
                                                                                            focusColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            highlightColor: Colors.transparent,
                                                                                            onTap: () async {
                                                                                              _model.responseValidateUserToFlights = await actions.userAdminSupeardminValidate(
                                                                                                getJsonField(
                                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                  r'''$[:].id_created_by''',
                                                                                                ).toString(),
                                                                                                currentUserUid,
                                                                                              );
                                                                                              if ((_model.responseValidateUserToFlights == true) &&
                                                                                                  ('${getJsonField(
                                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                        r'''$[:].status''',
                                                                                                      ).toString()}' !=
                                                                                                      'Confirmado')) {
                                                                                                context.read<ProductService>().allDataFlight = flightItineraryItemItem;
                                                                                                context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                                safeSetState(() {});

                                                                                                context.pushNamed(
                                                                                                  AddFlightsWidget.routeName,
                                                                                                  queryParameters: {
                                                                                                    'isEdit': serializeParam(
                                                                                                      true,
                                                                                                      ParamType.bool,
                                                                                                    ),
                                                                                                  }.withoutNulls,
                                                                                                );
                                                                                              } else {
                                                                                                await showDialog(
                                                                                                  context: context,
                                                                                                  builder: (alertDialogContext) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text('Mensaje'),
                                                                                                      content: Text('Este elemento no puede ser editado. Para solicitar modificaciones, comuníquese con su administrador.'),
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

                                                                                              safeSetState(() {});
                                                                                            },
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Wrap(
                                                                                                        spacing: 20.0,
                                                                                                        runSpacing: 12.0,
                                                                                                        alignment: WrapAlignment.spaceBetween,
                                                                                                        crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                        direction: Axis.horizontal,
                                                                                                        runAlignment: WrapAlignment.start,
                                                                                                        verticalDirection: VerticalDirection.down,
                                                                                                        clipBehavior: Clip.none,
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                children: [
                                                                                                                  Container(
                                                                                                                    width: 32.0,
                                                                                                                    height: 32.0,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                                                                    ),
                                                                                                                    child: ClipRRect(
                                                                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                                                                      child: Image.network(
                                                                                                                        valueOrDefault<String>(
                                                                                                                          getJsonField(
                                                                                                                            flightItineraryItemItem,
                                                                                                                            r'''$.logo_symbol_url''',
                                                                                                                          )?.toString(),
                                                                                                                          'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/airline-default.png',
                                                                                                                        ),
                                                                                                                        width: 200.0,
                                                                                                                        height: 200.0,
                                                                                                                        fit: BoxFit.cover,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    getJsonField(
                                                                                                                      flightItineraryItemItem,
                                                                                                                      r'''$.product_name''',
                                                                                                                    ).toString(),
                                                                                                                    maxLines: 2,
                                                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                          fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: 5.0)),
                                                                                                              ),
                                                                                                              Wrap(
                                                                                                                spacing: 8.0,
                                                                                                                runSpacing: 0.0,
                                                                                                                alignment: WrapAlignment.start,
                                                                                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                                                                                direction: Axis.horizontal,
                                                                                                                runAlignment: WrapAlignment.center,
                                                                                                                verticalDirection: VerticalDirection.down,
                                                                                                                clipBehavior: Clip.none,
                                                                                                                children: [
                                                                                                                  Row(
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    children: [
                                                                                                                      Padding(
                                                                                                                        padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                        child: Icon(
                                                                                                                          Icons.date_range,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          size: 16.0,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      Padding(
                                                                                                                        padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                        child: Text(
                                                                                                                          valueOrDefault<String>(
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
                                                                                                                              flightItineraryItemItem,
                                                                                                                              r'''$.date''',
                                                                                                                            ).toString()),
                                                                                                                            'Fecha',
                                                                                                                          ),
                                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                letterSpacing: 0.0,
                                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                              ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                  Row(
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    children: [
                                                                                                                      Padding(
                                                                                                                        padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                        child: Icon(
                                                                                                                          Icons.people,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          size: 16.0,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      Text(
                                                                                                                        valueOrDefault<String>(
                                                                                                                          getJsonField(
                                                                                                                            flightItineraryItemItem,
                                                                                                                            r'''$.quantity''',
                                                                                                                          )?.toString(),
                                                                                                                          '1',
                                                                                                                        ),
                                                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                              letterSpacing: 0.0,
                                                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                            ),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ].divide(SizedBox(height: BukeerSpacing.xs)),
                                                                                                          ),
                                                                                                          Padding(
                                                                                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                                                                                                            child: Row(
                                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                                              children: [
                                                                                                                Column(
                                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    Text(
                                                                                                                      getJsonField(
                                                                                                                        flightItineraryItemItem,
                                                                                                                        r'''$.departure_time''',
                                                                                                                      ).toString().maybeHandleOverflow(
                                                                                                                            maxChars: 5,
                                                                                                                          ),
                                                                                                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                            fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                            fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                            letterSpacing: 0.0,
                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                                          ),
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      valueOrDefault<String>(
                                                                                                                        (String city) {
                                                                                                                          return city.split('-')[0].trim();
                                                                                                                        }(getJsonField(
                                                                                                                          flightItineraryItemItem,
                                                                                                                          r'''$.flight_departure''',
                                                                                                                        ).toString()),
                                                                                                                        'Salida',
                                                                                                                      ),
                                                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            letterSpacing: 0.0,
                                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                          ),
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: AlignmentDirectional(1.0, 0.0),
                                                                                                                  child: FaIcon(
                                                                                                                    FontAwesomeIcons.arrowRight,
                                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                                    size: 16.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Column(
                                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    Text(
                                                                                                                      getJsonField(
                                                                                                                        flightItineraryItemItem,
                                                                                                                        r'''$.arrival_time''',
                                                                                                                      ).toString().maybeHandleOverflow(
                                                                                                                            maxChars: 5,
                                                                                                                          ),
                                                                                                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                            fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                            fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                            letterSpacing: 0.0,
                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                                          ),
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      valueOrDefault<String>(
                                                                                                                        (String city) {
                                                                                                                          return city.split('-')[0].trim();
                                                                                                                        }(getJsonField(
                                                                                                                          flightItineraryItemItem,
                                                                                                                          r'''$.flight_arrival''',
                                                                                                                        ).toString()),
                                                                                                                        'Llegada',
                                                                                                                      ),
                                                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            letterSpacing: 0.0,
                                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                          ),
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Opacity(
                                                                                                  opacity: 0.9,
                                                                                                  child: Divider(
                                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                                  ),
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Flexible(
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        children: [
                                                                                                          Wrap(
                                                                                                            spacing: 12.0,
                                                                                                            runSpacing: 0.0,
                                                                                                            alignment: WrapAlignment.start,
                                                                                                            crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                            direction: Axis.horizontal,
                                                                                                            runAlignment: WrapAlignment.start,
                                                                                                            verticalDirection: VerticalDirection.down,
                                                                                                            clipBehavior: Clip.none,
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Tarifa neta',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        getJsonField(
                                                                                                                          flightItineraryItemItem,
                                                                                                                          r'''$.unit_cost''',
                                                                                                                        ),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Markup',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    '${formatNumber(
                                                                                                                      (String valor) {
                                                                                                                        return double.tryParse(valor ?? '') ?? 0.0;
                                                                                                                      }(getJsonField(
                                                                                                                        flightItineraryItemItem,
                                                                                                                        r'''$.profit_percentage''',
                                                                                                                      ).toString()),
                                                                                                                      formatType: FormatType.decimal,
                                                                                                                      decimalType: DecimalType.commaDecimal,
                                                                                                                    )}%',
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Valor',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        double.parse((getJsonField(
                                                                                                                                  flightItineraryItemItem,
                                                                                                                                  r'''$.unit_cost''',
                                                                                                                                ) *
                                                                                                                                (1 +
                                                                                                                                    getJsonField(
                                                                                                                                          flightItineraryItemItem,
                                                                                                                                          r'''$.profit_percentage''',
                                                                                                                                        ) /
                                                                                                                                        100))
                                                                                                                            .toStringAsFixed(2)),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Row(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'Total',
                                                                                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          valueOrDefault<String>(
                                                                                                            formatNumber(
                                                                                                              double.parse(getJsonField(
                                                                                                                flightItineraryItemItem,
                                                                                                                r'''$.total_price''',
                                                                                                              ).toStringAsFixed(2)),
                                                                                                              formatType: FormatType.decimal,
                                                                                                              decimalType: DecimalType.commaDecimal,
                                                                                                              currency: '',
                                                                                                            ),
                                                                                                            '0',
                                                                                                          ),
                                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                    ),
                                                                                                  ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(BukeerSpacing.s),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  'Total hoteles ${valueOrDefault<String>(
                                                                                    formatNumber(
                                                                                      getJsonField(
                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                        r'''$[:].total_hotels''',
                                                                                      ),
                                                                                      formatType: FormatType.decimal,
                                                                                      decimalType: DecimalType.commaDecimal,
                                                                                      currency: '',
                                                                                    ),
                                                                                    '0',
                                                                                  )}',
                                                                                  '0',
                                                                                ),
                                                                                maxLines: 2,
                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                      fontSize: BukeerTypography.bodyMediumSize,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            if (('${getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].status''',
                                                                                    ).toString()}' !=
                                                                                    'Confirmado') &&
                                                                                ('${getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].id_created_by''',
                                                                                    ).toString()}' ==
                                                                                    currentUserUid))
                                                                              FFButtonWidget(
                                                                                onPressed: () async {
                                                                                  context.read<UiStateService>().itemsProducts = null;
                                                                                  context.read<ProductService>().allDataHotel = null;
                                                                                  context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                  context.read<UiStateService>().selectRates = false;
                                                                                  safeSetState(() {});

                                                                                  context.pushNamed(
                                                                                    AddHotelWidget.routeName,
                                                                                    queryParameters: {
                                                                                      'isEdit': serializeParam(
                                                                                        false,
                                                                                        ParamType.bool,
                                                                                      ),
                                                                                      'itineraryId': serializeParam(
                                                                                        widget!.id,
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                },
                                                                                text: 'Agregar hotel',
                                                                                icon: Icon(
                                                                                  Icons.add_sharp,
                                                                                  size: 24.0,
                                                                                ),
                                                                                options: FFButtonOptions(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                  iconAlignment: IconAlignment.end,
                                                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                  iconColor: FlutterFlowTheme.of(context).info,
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                  elevation: 3.0,
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.transparent,
                                                                                    width: 1.0,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                  hoverBorderSide: BorderSide(
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    width: 1.0,
                                                                                  ),
                                                                                  hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                  hoverElevation: 0.0,
                                                                                ),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      FutureBuilder<
                                                                          ApiCallResponse>(
                                                                        future:
                                                                            GetProductsItineraryItemsCall.call(
                                                                          pIdItinerary:
                                                                              widget!.id,
                                                                          pProductType:
                                                                              'Hoteles',
                                                                          authToken:
                                                                              currentJwtToken,
                                                                        ),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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
                                                                          final listViewGetProductsItineraryItemsResponse =
                                                                              snapshot.data!;

                                                                          return Builder(
                                                                            builder:
                                                                                (context) {
                                                                              final hotelItineraryItem = listViewGetProductsItineraryItemsResponse.jsonBody.toList();

                                                                              return ListView.separated(
                                                                                padding: EdgeInsets.zero,
                                                                                primary: false,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemCount: hotelItineraryItem.length,
                                                                                separatorBuilder: (_, __) => SizedBox(height: BukeerSpacing.s),
                                                                                itemBuilder: (context, hotelItineraryItemIndex) {
                                                                                  final hotelItineraryItemItem = hotelItineraryItem[hotelItineraryItemIndex];
                                                                                  return Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                                                                                    child: Material(
                                                                                      color: Colors.transparent,
                                                                                      elevation: 1.0,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(BukeerSpacing.s),
                                                                                          child: InkWell(
                                                                                            splashColor: Colors.transparent,
                                                                                            focusColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            highlightColor: Colors.transparent,
                                                                                            onTap: () async {
                                                                                              _model.responseValidateUserToHotels = await actions.userAdminSupeardminValidate(
                                                                                                getJsonField(
                                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                  r'''$[:].id_created_by''',
                                                                                                ).toString(),
                                                                                                currentUserUid,
                                                                                              );
                                                                                              if ((_model.responseValidateUserToHotels == true) &&
                                                                                                  ('${getJsonField(
                                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                        r'''$[:].status''',
                                                                                                      ).toString()}' !=
                                                                                                      'Confirmado')) {
                                                                                                context.read<ProductService>().allDataHotel = hotelItineraryItemItem;
                                                                                                context.read<UiStateService>().selectRates = true;
                                                                                                context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                                safeSetState(() {});

                                                                                                context.pushNamed(
                                                                                                  AddHotelWidget.routeName,
                                                                                                  queryParameters: {
                                                                                                    'isEdit': serializeParam(
                                                                                                      true,
                                                                                                      ParamType.bool,
                                                                                                    ),
                                                                                                  }.withoutNulls,
                                                                                                );
                                                                                              } else {
                                                                                                await showDialog(
                                                                                                  context: context,
                                                                                                  builder: (alertDialogContext) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text('Mensaje'),
                                                                                                      content: Text('Este elemento no puede ser editado. Para solicitar modificaciones, comuníquese con su administrador.'),
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

                                                                                              safeSetState(() {});
                                                                                            },
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Wrap(
                                                                                                          spacing: 0.0,
                                                                                                          runSpacing: 0.0,
                                                                                                          alignment: WrapAlignment.start,
                                                                                                          crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                          direction: Axis.horizontal,
                                                                                                          runAlignment: WrapAlignment.start,
                                                                                                          verticalDirection: VerticalDirection.down,
                                                                                                          clipBehavior: Clip.none,
                                                                                                          children: [
                                                                                                            Column(
                                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      hotelItineraryItemItem,
                                                                                                                      r'''$.product_name''',
                                                                                                                    )?.toString(),
                                                                                                                    'Nombre del hotel',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                        fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      hotelItineraryItemItem,
                                                                                                                      r'''$.name_provider''',
                                                                                                                    )?.toString(),
                                                                                                                    'Proveedor',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                                                        fontSize: BukeerTypography.bodySmallSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      hotelItineraryItemItem,
                                                                                                                      r'''$.rate_name''',
                                                                                                                    )?.toString(),
                                                                                                                    'Nombre de la tarifa',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                        fontSize: BukeerTypography.bodySmallSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Wrap(
                                                                                                                  spacing: 1.0,
                                                                                                                  runSpacing: 0.0,
                                                                                                                  alignment: WrapAlignment.start,
                                                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                                  direction: Axis.horizontal,
                                                                                                                  runAlignment: WrapAlignment.start,
                                                                                                                  verticalDirection: VerticalDirection.down,
                                                                                                                  clipBehavior: Clip.antiAlias,
                                                                                                                  children: [
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.date_range,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                          child: Text(
                                                                                                                            valueOrDefault<String>(
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
                                                                                                                                hotelItineraryItemItem,
                                                                                                                                r'''$.date''',
                                                                                                                              ).toString()),
                                                                                                                              'Fecha',
                                                                                                                            ),
                                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                  letterSpacing: 0.0,
                                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.location_pin,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                          child: Text(
                                                                                                                            valueOrDefault<String>(
                                                                                                                              getJsonField(
                                                                                                                                hotelItineraryItemItem,
                                                                                                                                r'''$.destination''',
                                                                                                                              )?.toString(),
                                                                                                                              'Destino',
                                                                                                                            ),
                                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                  letterSpacing: 0.0,
                                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.nightlight,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                          child: Text(
                                                                                                                            valueOrDefault<String>(
                                                                                                                              getJsonField(
                                                                                                                                hotelItineraryItemItem,
                                                                                                                                r'''$.hotel_nights''',
                                                                                                                              )?.toString(),
                                                                                                                              'Noches',
                                                                                                                            ),
                                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                  letterSpacing: 0.0,
                                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.people,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          valueOrDefault<String>(
                                                                                                                            getJsonField(
                                                                                                                              hotelItineraryItemItem,
                                                                                                                              r'''$.quantity''',
                                                                                                                            )?.toString(),
                                                                                                                            '1',
                                                                                                                          ),
                                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                letterSpacing: 0.0,
                                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                              ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ].divide(SizedBox(height: BukeerSpacing.xs)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 90.0,
                                                                                                      height: 90.0,
                                                                                                      decoration: BoxDecoration(
                                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                      ),
                                                                                                      alignment: AlignmentDirectional(0.0, -1.0),
                                                                                                      child: ClipRRect(
                                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                        child: Image.network(
                                                                                                          valueOrDefault<String>(
                                                                                                            getJsonField(
                                                                                                              hotelItineraryItemItem,
                                                                                                              r'''$.main_image''',
                                                                                                            )?.toString(),
                                                                                                            'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/hotel-default.jpg',
                                                                                                          ),
                                                                                                          fit: BoxFit.cover,
                                                                                                          alignment: Alignment(-1.0, -1.0),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Opacity(
                                                                                                  opacity: 0.8,
                                                                                                  child: Divider(
                                                                                                    thickness: 1.0,
                                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                                  ),
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                  children: [
                                                                                                    Flexible(
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        children: [
                                                                                                          Wrap(
                                                                                                            spacing: 12.0,
                                                                                                            runSpacing: 0.0,
                                                                                                            alignment: WrapAlignment.start,
                                                                                                            crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                            direction: Axis.horizontal,
                                                                                                            runAlignment: WrapAlignment.start,
                                                                                                            verticalDirection: VerticalDirection.down,
                                                                                                            clipBehavior: Clip.none,
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Tarifa neta',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        getJsonField(
                                                                                                                          hotelItineraryItemItem,
                                                                                                                          r'''$.unit_cost''',
                                                                                                                        ),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '\$',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Markup',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    '${formatNumber(
                                                                                                                      (String valor) {
                                                                                                                        return double.tryParse(valor ?? '') ?? 0.0;
                                                                                                                      }(valueOrDefault<String>(
                                                                                                                        getJsonField(
                                                                                                                          hotelItineraryItemItem,
                                                                                                                          r'''$.profit_percentage''',
                                                                                                                        )?.toString(),
                                                                                                                        'Margen',
                                                                                                                      )),
                                                                                                                      formatType: FormatType.decimal,
                                                                                                                      decimalType: DecimalType.commaDecimal,
                                                                                                                    )}%',
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Valor',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        double.parse((getJsonField(
                                                                                                                                  hotelItineraryItemItem,
                                                                                                                                  r'''$.unit_cost''',
                                                                                                                                ) *
                                                                                                                                (1 +
                                                                                                                                    getJsonField(
                                                                                                                                          hotelItineraryItemItem,
                                                                                                                                          r'''$.profit_percentage''',
                                                                                                                                        ) /
                                                                                                                                        100))
                                                                                                                            .toStringAsFixed(2)),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Row(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'Total',
                                                                                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          valueOrDefault<String>(
                                                                                                            formatNumber(
                                                                                                              double.parse(getJsonField(
                                                                                                                hotelItineraryItemItem,
                                                                                                                r'''$.total_price''',
                                                                                                              ).toStringAsFixed(2)),
                                                                                                              formatType: FormatType.decimal,
                                                                                                              decimalType: DecimalType.commaDecimal,
                                                                                                              currency: '',
                                                                                                            ),
                                                                                                            '0',
                                                                                                          ),
                                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(BukeerSpacing.s),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              valueOrDefault<String>(
                                                                                'Total  actividades ${valueOrDefault<String>(
                                                                                  formatNumber(
                                                                                    getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].total_activities''',
                                                                                    ),
                                                                                    formatType: FormatType.decimal,
                                                                                    decimalType: DecimalType.commaDecimal,
                                                                                    currency: '',
                                                                                  ),
                                                                                  '0',
                                                                                )}',
                                                                                '0',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                    fontSize: BukeerTypography.bodyMediumSize,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                  ),
                                                                            ),
                                                                            if (('${getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].status''',
                                                                                    ).toString()}' !=
                                                                                    'Confirmado') &&
                                                                                ('${getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].id_created_by''',
                                                                                    ).toString()}' ==
                                                                                    currentUserUid))
                                                                              FFButtonWidget(
                                                                                onPressed: () async {
                                                                                  context.read<UiStateService>().itemsProducts = null;
                                                                                  context.read<ProductService>().allDataActivity = null;
                                                                                  context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                  context.read<UiStateService>().selectRates = false;
                                                                                  safeSetState(() {});

                                                                                  context.pushNamed(
                                                                                    AddActivitiesWidget.routeName,
                                                                                    queryParameters: {
                                                                                      'isEdit': serializeParam(
                                                                                        false,
                                                                                        ParamType.bool,
                                                                                      ),
                                                                                      'itineraryId': serializeParam(
                                                                                        widget!.id,
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                },
                                                                                text: 'Agregar Actividad',
                                                                                icon: Icon(
                                                                                  Icons.add_sharp,
                                                                                  size: 24.0,
                                                                                ),
                                                                                options: FFButtonOptions(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                  iconAlignment: IconAlignment.end,
                                                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                  iconColor: FlutterFlowTheme.of(context).info,
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                  elevation: 3.0,
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.transparent,
                                                                                    width: 1.0,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                  hoverBorderSide: BorderSide(
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    width: 1.0,
                                                                                  ),
                                                                                  hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                  hoverElevation: 0.0,
                                                                                ),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      FutureBuilder<
                                                                          ApiCallResponse>(
                                                                        future:
                                                                            GetProductsItineraryItemsCall.call(
                                                                          pIdItinerary:
                                                                              widget!.id,
                                                                          pProductType:
                                                                              'Servicios',
                                                                          authToken:
                                                                              currentJwtToken,
                                                                        ),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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
                                                                          final listViewGetProductsItineraryItemsResponse =
                                                                              snapshot.data!;

                                                                          return Builder(
                                                                            builder:
                                                                                (context) {
                                                                              final activityItineraryItem = listViewGetProductsItineraryItemsResponse.jsonBody.toList();

                                                                              return ListView.separated(
                                                                                padding: EdgeInsets.zero,
                                                                                primary: false,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemCount: activityItineraryItem.length,
                                                                                separatorBuilder: (_, __) => SizedBox(height: BukeerSpacing.s),
                                                                                itemBuilder: (context, activityItineraryItemIndex) {
                                                                                  final activityItineraryItemItem = activityItineraryItem[activityItineraryItemIndex];
                                                                                  return Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                                                                                    child: Material(
                                                                                      color: Colors.transparent,
                                                                                      elevation: 1.0,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(BukeerSpacing.s),
                                                                                          child: InkWell(
                                                                                            splashColor: Colors.transparent,
                                                                                            focusColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            highlightColor: Colors.transparent,
                                                                                            onTap: () async {
                                                                                              _model.responseValidateUserToActivities = await actions.userAdminSupeardminValidate(
                                                                                                getJsonField(
                                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                  r'''$[:].id_created_by''',
                                                                                                ).toString(),
                                                                                                currentUserUid,
                                                                                              );
                                                                                              if ((_model.responseValidateUserToActivities == true) &&
                                                                                                  ('${getJsonField(
                                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                        r'''$[:].status''',
                                                                                                      ).toString()}' !=
                                                                                                      'Confirmado')) {
                                                                                                context.read<ProductService>().allDataActivity = activityItineraryItemItem;
                                                                                                context.read<UiStateService>().selectRates = true;
                                                                                                context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                                safeSetState(() {});

                                                                                                context.pushNamed(
                                                                                                  AddActivitiesWidget.routeName,
                                                                                                  queryParameters: {
                                                                                                    'isEdit': serializeParam(
                                                                                                      true,
                                                                                                      ParamType.bool,
                                                                                                    ),
                                                                                                  }.withoutNulls,
                                                                                                );
                                                                                              } else {
                                                                                                await showDialog(
                                                                                                  context: context,
                                                                                                  builder: (alertDialogContext) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text('Mensaje'),
                                                                                                      content: Text('Este elemento no puede ser editado. Para solicitar modificaciones, comuníquese con su administrador.'),
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

                                                                                              safeSetState(() {});
                                                                                            },
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Wrap(
                                                                                                          spacing: 0.0,
                                                                                                          runSpacing: 0.0,
                                                                                                          alignment: WrapAlignment.start,
                                                                                                          crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                          direction: Axis.horizontal,
                                                                                                          runAlignment: WrapAlignment.start,
                                                                                                          verticalDirection: VerticalDirection.down,
                                                                                                          clipBehavior: Clip.none,
                                                                                                          children: [
                                                                                                            Column(
                                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      activityItineraryItemItem,
                                                                                                                      r'''$.product_name''',
                                                                                                                    )?.toString(),
                                                                                                                    'Nombre del hotel',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                        fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      activityItineraryItemItem,
                                                                                                                      r'''$.name_provider''',
                                                                                                                    )?.toString(),
                                                                                                                    'Proveedor',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                                                        fontSize: BukeerTypography.bodySmallSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      activityItineraryItemItem,
                                                                                                                      r'''$.rate_name''',
                                                                                                                    )?.toString(),
                                                                                                                    'Nombre de la tarifa',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                        fontSize: BukeerTypography.bodySmallSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Wrap(
                                                                                                                  spacing: 1.0,
                                                                                                                  runSpacing: 0.0,
                                                                                                                  alignment: WrapAlignment.start,
                                                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                                  direction: Axis.horizontal,
                                                                                                                  runAlignment: WrapAlignment.start,
                                                                                                                  verticalDirection: VerticalDirection.down,
                                                                                                                  clipBehavior: Clip.antiAlias,
                                                                                                                  children: [
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.date_range,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                          child: Text(
                                                                                                                            valueOrDefault<String>(
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
                                                                                                                                activityItineraryItemItem,
                                                                                                                                r'''$.date''',
                                                                                                                              ).toString()),
                                                                                                                              'Fecha',
                                                                                                                            ),
                                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                  letterSpacing: 0.0,
                                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.location_pin,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                          child: Text(
                                                                                                                            valueOrDefault<String>(
                                                                                                                              getJsonField(
                                                                                                                                activityItineraryItemItem,
                                                                                                                                r'''$.destination''',
                                                                                                                              )?.toString(),
                                                                                                                              'Destino',
                                                                                                                            ),
                                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                  letterSpacing: 0.0,
                                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.people,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          valueOrDefault<String>(
                                                                                                                            getJsonField(
                                                                                                                              activityItineraryItemItem,
                                                                                                                              r'''$.quantity''',
                                                                                                                            )?.toString(),
                                                                                                                            '1',
                                                                                                                          ),
                                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                letterSpacing: 0.0,
                                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                              ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ].divide(SizedBox(height: BukeerSpacing.xs)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 90.0,
                                                                                                      height: 90.0,
                                                                                                      decoration: BoxDecoration(
                                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                      ),
                                                                                                      alignment: AlignmentDirectional(0.0, -1.0),
                                                                                                      child: ClipRRect(
                                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                        child: Image.network(
                                                                                                          valueOrDefault<String>(
                                                                                                            getJsonField(
                                                                                                              activityItineraryItemItem,
                                                                                                              r'''$.main_image''',
                                                                                                            )?.toString(),
                                                                                                            'https://picsum.photos/seed/284/600',
                                                                                                          ),
                                                                                                          fit: BoxFit.cover,
                                                                                                          alignment: Alignment(-1.0, -1.0),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Opacity(
                                                                                                  opacity: 0.8,
                                                                                                  child: Divider(
                                                                                                    thickness: 1.0,
                                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                                  ),
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                  children: [
                                                                                                    Flexible(
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        children: [
                                                                                                          Wrap(
                                                                                                            spacing: 12.0,
                                                                                                            runSpacing: 0.0,
                                                                                                            alignment: WrapAlignment.start,
                                                                                                            crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                            direction: Axis.horizontal,
                                                                                                            runAlignment: WrapAlignment.start,
                                                                                                            verticalDirection: VerticalDirection.down,
                                                                                                            clipBehavior: Clip.none,
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Tarifa neta',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        getJsonField(
                                                                                                                          activityItineraryItemItem,
                                                                                                                          r'''$.unit_cost''',
                                                                                                                        ),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Markup',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    '${formatNumber(
                                                                                                                      (String valor) {
                                                                                                                        return double.tryParse(valor ?? '') ?? 0.0;
                                                                                                                      }(valueOrDefault<String>(
                                                                                                                        getJsonField(
                                                                                                                          activityItineraryItemItem,
                                                                                                                          r'''$.profit_percentage''',
                                                                                                                        )?.toString(),
                                                                                                                        'Margen',
                                                                                                                      )),
                                                                                                                      formatType: FormatType.decimal,
                                                                                                                      decimalType: DecimalType.commaDecimal,
                                                                                                                    )}%',
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Valor',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        double.parse((getJsonField(
                                                                                                                                  activityItineraryItemItem,
                                                                                                                                  r'''$.unit_cost''',
                                                                                                                                ) *
                                                                                                                                (1 +
                                                                                                                                    getJsonField(
                                                                                                                                          activityItineraryItemItem,
                                                                                                                                          r'''$.profit_percentage''',
                                                                                                                                        ) /
                                                                                                                                        100))
                                                                                                                            .toStringAsFixed(2)),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Row(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'Total',
                                                                                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          valueOrDefault<String>(
                                                                                                            formatNumber(
                                                                                                              double.parse(getJsonField(
                                                                                                                activityItineraryItemItem,
                                                                                                                r'''$.total_price''',
                                                                                                              ).toStringAsFixed(2)),
                                                                                                              formatType: FormatType.decimal,
                                                                                                              decimalType: DecimalType.commaDecimal,
                                                                                                              currency: '',
                                                                                                            ),
                                                                                                            '0',
                                                                                                          ),
                                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(BukeerSpacing.s),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              valueOrDefault<String>(
                                                                                'Total  transfer ${formatNumber(
                                                                                  getJsonField(
                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                    r'''$[:].total_transfer''',
                                                                                  ),
                                                                                  formatType: FormatType.decimal,
                                                                                  decimalType: DecimalType.commaDecimal,
                                                                                  currency: '',
                                                                                )}',
                                                                                '0',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                    fontSize: BukeerTypography.bodyMediumSize,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                  ),
                                                                            ),
                                                                            if (('${getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].status''',
                                                                                    ).toString()}' !=
                                                                                    'Confirmado') &&
                                                                                ('${getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].id_created_by''',
                                                                                    ).toString()}' ==
                                                                                    currentUserUid))
                                                                              FFButtonWidget(
                                                                                onPressed: () async {
                                                                                  context.read<UiStateService>().itemsProducts = null;
                                                                                  context.read<ProductService>().allDataTransfer = null;
                                                                                  context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                  context.read<UiStateService>().selectRates = false;
                                                                                  safeSetState(() {});

                                                                                  context.pushNamed(
                                                                                    AddTransferWidget.routeName,
                                                                                    queryParameters: {
                                                                                      'isEdit': serializeParam(
                                                                                        false,
                                                                                        ParamType.bool,
                                                                                      ),
                                                                                      'itineraryId': serializeParam(
                                                                                        widget!.id,
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                },
                                                                                text: 'Agregar Transfer',
                                                                                icon: Icon(
                                                                                  Icons.add_sharp,
                                                                                  size: 24.0,
                                                                                ),
                                                                                options: FFButtonOptions(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                  iconAlignment: IconAlignment.end,
                                                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                  iconColor: FlutterFlowTheme.of(context).info,
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                  elevation: 3.0,
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.transparent,
                                                                                    width: 1.0,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                  hoverBorderSide: BorderSide(
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    width: 1.0,
                                                                                  ),
                                                                                  hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                  hoverElevation: 0.0,
                                                                                ),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      FutureBuilder<
                                                                          ApiCallResponse>(
                                                                        future:
                                                                            GetProductsItineraryItemsCall.call(
                                                                          pIdItinerary:
                                                                              widget!.id,
                                                                          pProductType:
                                                                              'Transporte',
                                                                          authToken:
                                                                              currentJwtToken,
                                                                        ),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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
                                                                          final listViewGetProductsItineraryItemsResponse =
                                                                              snapshot.data!;

                                                                          return Builder(
                                                                            builder:
                                                                                (context) {
                                                                              final transferItineraryItem = listViewGetProductsItineraryItemsResponse.jsonBody.toList();

                                                                              return ListView.separated(
                                                                                padding: EdgeInsets.zero,
                                                                                primary: false,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemCount: transferItineraryItem.length,
                                                                                separatorBuilder: (_, __) => SizedBox(height: BukeerSpacing.s),
                                                                                itemBuilder: (context, transferItineraryItemIndex) {
                                                                                  final transferItineraryItemItem = transferItineraryItem[transferItineraryItemIndex];
                                                                                  return Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                                                                                    child: Material(
                                                                                      color: Colors.transparent,
                                                                                      elevation: 1.0,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(BukeerSpacing.s),
                                                                                          child: InkWell(
                                                                                            splashColor: Colors.transparent,
                                                                                            focusColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            highlightColor: Colors.transparent,
                                                                                            onTap: () async {
                                                                                              _model.responseValidateUserToTransfer = await actions.userAdminSupeardminValidate(
                                                                                                getJsonField(
                                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                  r'''$[:].id_created_by''',
                                                                                                ).toString(),
                                                                                                currentUserUid,
                                                                                              );
                                                                                              if ((_model.responseValidateUserToTransfer == true) &&
                                                                                                  ('${getJsonField(
                                                                                                        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                        r'''$[:].status''',
                                                                                                      ).toString()}' !=
                                                                                                      'Confirmado')) {
                                                                                                context.read<ProductService>().allDataTransfer = transferItineraryItemItem;
                                                                                                context.read<UiStateService>().selectRates = true;
                                                                                                context.read<ContactService>().allDataContact = itineraryDetailsGetitIneraryDetailsResponse.jsonBody;
                                                                                                safeSetState(() {});

                                                                                                context.pushNamed(
                                                                                                  AddTransferWidget.routeName,
                                                                                                  queryParameters: {
                                                                                                    'isEdit': serializeParam(
                                                                                                      true,
                                                                                                      ParamType.bool,
                                                                                                    ),
                                                                                                  }.withoutNulls,
                                                                                                );
                                                                                              } else {
                                                                                                await showDialog(
                                                                                                  context: context,
                                                                                                  builder: (alertDialogContext) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text('Mensaje'),
                                                                                                      content: Text('Este elemento no puede ser editado. Para solicitar modificaciones, comuníquese con su administrador.'),
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

                                                                                              safeSetState(() {});
                                                                                            },
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Wrap(
                                                                                                          spacing: 0.0,
                                                                                                          runSpacing: 0.0,
                                                                                                          alignment: WrapAlignment.start,
                                                                                                          crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                          direction: Axis.horizontal,
                                                                                                          runAlignment: WrapAlignment.start,
                                                                                                          verticalDirection: VerticalDirection.down,
                                                                                                          clipBehavior: Clip.none,
                                                                                                          children: [
                                                                                                            Column(
                                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      transferItineraryItemItem,
                                                                                                                      r'''$.product_name''',
                                                                                                                    )?.toString(),
                                                                                                                    'Nombre del transfer',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                        fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      transferItineraryItemItem,
                                                                                                                      r'''$.name_provider''',
                                                                                                                    )?.toString(),
                                                                                                                    'Proveedor',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                                                        fontSize: BukeerTypography.bodySmallSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  valueOrDefault<String>(
                                                                                                                    getJsonField(
                                                                                                                      transferItineraryItemItem,
                                                                                                                      r'''$.rate_name''',
                                                                                                                    )?.toString(),
                                                                                                                    'Nombre de la tarifa',
                                                                                                                  ),
                                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                        fontSize: BukeerTypography.bodySmallSize,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                      ),
                                                                                                                ),
                                                                                                                Wrap(
                                                                                                                  spacing: 1.0,
                                                                                                                  runSpacing: 0.0,
                                                                                                                  alignment: WrapAlignment.start,
                                                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                                  direction: Axis.horizontal,
                                                                                                                  runAlignment: WrapAlignment.start,
                                                                                                                  verticalDirection: VerticalDirection.down,
                                                                                                                  clipBehavior: Clip.antiAlias,
                                                                                                                  children: [
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.date_range,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                          child: Text(
                                                                                                                            valueOrDefault<String>(
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
                                                                                                                                transferItineraryItemItem,
                                                                                                                                r'''$.date''',
                                                                                                                              ).toString()),
                                                                                                                              'Fecha',
                                                                                                                            ),
                                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                  letterSpacing: 0.0,
                                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.location_pin,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.s),
                                                                                                                          child: Text(
                                                                                                                            valueOrDefault<String>(
                                                                                                                              getJsonField(
                                                                                                                                transferItineraryItemItem,
                                                                                                                                r'''$.destination''',
                                                                                                                              )?.toString(),
                                                                                                                              'Destino',
                                                                                                                            ),
                                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                  letterSpacing: 0.0,
                                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    Row(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: [
                                                                                                                        Padding(
                                                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                                                          child: Icon(
                                                                                                                            Icons.people,
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                            size: 16.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          valueOrDefault<String>(
                                                                                                                            getJsonField(
                                                                                                                              transferItineraryItemItem,
                                                                                                                              r'''$.quantity''',
                                                                                                                            )?.toString(),
                                                                                                                            '1',
                                                                                                                          ),
                                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                                letterSpacing: 0.0,
                                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                              ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ].divide(SizedBox(height: BukeerSpacing.xs)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 90.0,
                                                                                                      height: 90.0,
                                                                                                      decoration: BoxDecoration(
                                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                      ),
                                                                                                      alignment: AlignmentDirectional(0.0, -1.0),
                                                                                                      child: ClipRRect(
                                                                                                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                        child: Image.network(
                                                                                                          valueOrDefault<String>(
                                                                                                            getJsonField(
                                                                                                              transferItineraryItemItem,
                                                                                                              r'''$.main_image''',
                                                                                                            )?.toString(),
                                                                                                            'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/transfer.jpeg',
                                                                                                          ),
                                                                                                          fit: BoxFit.cover,
                                                                                                          alignment: Alignment(-1.0, -1.0),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Opacity(
                                                                                                  opacity: 0.8,
                                                                                                  child: Divider(
                                                                                                    thickness: 1.0,
                                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                                  ),
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                  children: [
                                                                                                    Flexible(
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        children: [
                                                                                                          Wrap(
                                                                                                            spacing: 12.0,
                                                                                                            runSpacing: 0.0,
                                                                                                            alignment: WrapAlignment.start,
                                                                                                            crossAxisAlignment: WrapCrossAlignment.start,
                                                                                                            direction: Axis.horizontal,
                                                                                                            runAlignment: WrapAlignment.start,
                                                                                                            verticalDirection: VerticalDirection.down,
                                                                                                            clipBehavior: Clip.none,
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Tarifa neta',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        getJsonField(
                                                                                                                          transferItineraryItemItem,
                                                                                                                          r'''$.unit_cost''',
                                                                                                                        ),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Markup',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    '${formatNumber(
                                                                                                                      (String valor) {
                                                                                                                        return double.tryParse(valor ?? '') ?? 0.0;
                                                                                                                      }(valueOrDefault<String>(
                                                                                                                        getJsonField(
                                                                                                                          transferItineraryItemItem,
                                                                                                                          r'''$.profit_percentage''',
                                                                                                                        )?.toString(),
                                                                                                                        'Margen',
                                                                                                                      )),
                                                                                                                      formatType: FormatType.decimal,
                                                                                                                      decimalType: DecimalType.commaDecimal,
                                                                                                                    )}%',
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'Valor',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    valueOrDefault<String>(
                                                                                                                      formatNumber(
                                                                                                                        double.parse((getJsonField(
                                                                                                                                  transferItineraryItemItem,
                                                                                                                                  r'''$.unit_cost''',
                                                                                                                                ) *
                                                                                                                                (1 +
                                                                                                                                    getJsonField(
                                                                                                                                          transferItineraryItemItem,
                                                                                                                                          r'''$.profit_percentage''',
                                                                                                                                        ) /
                                                                                                                                        100))
                                                                                                                            .toStringAsFixed(2)),
                                                                                                                        formatType: FormatType.decimal,
                                                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                                                        currency: '',
                                                                                                                      ),
                                                                                                                      '0',
                                                                                                                    ),
                                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                          letterSpacing: 0.0,
                                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Row(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          'Total',
                                                                                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          valueOrDefault<String>(
                                                                                                            formatNumber(
                                                                                                              double.parse(getJsonField(
                                                                                                                transferItineraryItemItem,
                                                                                                                r'''$.total_price''',
                                                                                                              ).toStringAsFixed(2)),
                                                                                                              formatType: FormatType.decimal,
                                                                                                              decimalType: DecimalType.commaDecimal,
                                                                                                              currency: '',
                                                                                                            ),
                                                                                                            '0',
                                                                                                          ),
                                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                fontSize: BukeerTypography.bodyMediumSize,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (_model.typeProduct == 2)
                                      Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.9,
                                        constraints: BoxConstraints(
                                          maxWidth: 852.0,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            8.0,
                                                                            8.0,
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0x0D4B39EF),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            12.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children:
                                                                          [
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Text(
                                                                                  formatNumber(
                                                                                    (String valor) {
                                                                                      return double.tryParse(valor ?? '') ?? 0.0;
                                                                                    }(valueOrDefault<String>(
                                                                                      functions
                                                                                          .convertCurrencyBaseToOpt(
                                                                                              getJsonField(
                                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                r'''$[:].paid''',
                                                                                              ),
                                                                                              getJsonField(
                                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                r'''$[:].currency_type''',
                                                                                              ).toString(),
                                                                                              getJsonField(
                                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                r'''$[:].currency''',
                                                                                                true,
                                                                                              ))
                                                                                          ?.toString(),
                                                                                      '-',
                                                                                    )),
                                                                                    formatType: FormatType.decimal,
                                                                                    decimalType: DecimalType.commaDecimal,
                                                                                    currency: '',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].currency_type''',
                                                                                    ).toString(),
                                                                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              'Total pagado',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Text(
                                                                                  formatNumber(
                                                                                    (String valor) {
                                                                                      return double.tryParse(valor ?? '') ?? 0.0;
                                                                                    }(valueOrDefault<String>(
                                                                                      functions
                                                                                          .convertCurrencyBaseToOpt(
                                                                                              getJsonField(
                                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                r'''$[:].pending_paid''',
                                                                                              ),
                                                                                              getJsonField(
                                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                r'''$[:].currency_type''',
                                                                                              ).toString(),
                                                                                              getJsonField(
                                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                r'''$[:].currency''',
                                                                                                true,
                                                                                              ))
                                                                                          ?.toString(),
                                                                                      '-',
                                                                                    )),
                                                                                    formatType: FormatType.decimal,
                                                                                    decimalType: DecimalType.commaDecimal,
                                                                                    currency: '',
                                                                                  ),
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    getJsonField(
                                                                                      itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                      r'''$[:].currency_type''',
                                                                                    ).toString(),
                                                                                    textAlign: TextAlign.start,
                                                                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              'Saldo pendiente',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 16.0)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        12.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                if ('${getJsonField(
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody,
                                                                      r'''$[:].status''',
                                                                    ).toString()}' !=
                                                                    'Presupuesto')
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.0,
                                                                            0.0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          1.0,
                                                                          0.0),
                                                                      child:
                                                                          FFButtonWidget(
                                                                        onPressed:
                                                                            () async {
                                                                          _model.responseJson =
                                                                              await actions.createJSONToPDFVoucher(
                                                                            getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].id''',
                                                                            ).toString(),
                                                                            getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].id_contact''',
                                                                            ).toString(),
                                                                            FFAppState().accountId,
                                                                          );
                                                                          await Future
                                                                              .wait([
                                                                            Future(() async {
                                                                              await actions.createVoucherPDF(
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.customer_name''',
                                                                                ).toString(),
                                                                                'ColombiaTours',
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.start_date''',
                                                                                ).toString(),
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.end_date''',
                                                                                ).toString(),
                                                                                2,
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.passenger_count''',
                                                                                ),
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.itinerary_id''',
                                                                                ).toString(),
                                                                                'COP',
                                                                                FFAppState().accountId,
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.gross_total''',
                                                                                ),
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.transactions''',
                                                                                ),
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.passengers''',
                                                                                ),
                                                                                _model.responseJson!,
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.items''',
                                                                                ),
                                                                                getJsonField(
                                                                                  _model.responseJson,
                                                                                  r'''$.customer_lastname''',
                                                                                ).toString(),
                                                                              );
                                                                            }),
                                                                            Future(() async {}),
                                                                          ]);

                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                        text:
                                                                            'Voucher',
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .picture_as_pdf,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                        options:
                                                                            FFButtonOptions(
                                                                          height:
                                                                              36.0,
                                                                          padding:
                                                                              EdgeInsets.all(BukeerSpacing.s),
                                                                          iconAlignment:
                                                                              IconAlignment.end,
                                                                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          iconColor:
                                                                              Colors.white,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          textStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                color: Colors.white,
                                                                                fontSize: BukeerTypography.bodySmallSize,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                              ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(BukeerSpacing.s),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(context).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: ComponentAddPaidWidget(
                                                                                typeTransaction: 'ingreso',
                                                                                idItinerary: widget!.id,
                                                                                idItemProduct: null,
                                                                                agentName: '',
                                                                                agentEmail: '',
                                                                                emailProvider: '',
                                                                                nameProvider: '',
                                                                                fechaReserva: '',
                                                                                producto: '',
                                                                                tarifa: '',
                                                                                cantidad: 0,
                                                                                currencyType: getJsonField(
                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  r'''$[:].currency_type''',
                                                                                ).toString(),
                                                                                rates: getJsonField(
                                                                                  itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                  r'''$[:].currency''',
                                                                                  true,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    text:
                                                                        'Agregar Pago',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .add_sharp,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      height:
                                                                          36.0,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          12.0,
                                                                          8.0,
                                                                          12.0),
                                                                      iconAlignment:
                                                                          IconAlignment
                                                                              .end,
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      iconColor:
                                                                          Colors
                                                                              .white,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).info,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                      hoverColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .accent1,
                                                                      hoverBorderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      hoverTextColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primaryText,
                                                                      hoverElevation:
                                                                          0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height: 4.0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    FutureBuilder<
                                                        List<TransactionsRow>>(
                                                      future:
                                                          TransactionsTable()
                                                              .queryRows(
                                                        queryFn: (q) => q
                                                            .eqOrNull(
                                                              'id_itinerary',
                                                              widget!.id,
                                                            )
                                                            .eqOrNull(
                                                              'type',
                                                              'ingreso',
                                                            )
                                                            .order(
                                                                'created_at'),
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
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
                                                          );
                                                        }
                                                        List<TransactionsRow>
                                                            listViewTransactionsRowList =
                                                            snapshot.data!;

                                                        return ListView
                                                            .separated(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              listViewTransactionsRowList
                                                                  .length,
                                                          separatorBuilder: (_,
                                                                  __) =>
                                                              SizedBox(
                                                                  height: 8.0),
                                                          itemBuilder: (context,
                                                              listViewIndex) {
                                                            final listViewTransactionsRow =
                                                                listViewTransactionsRowList[
                                                                    listViewIndex];
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 1.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      1.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            12.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children:
                                                                              [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: 48.0,
                                                                                  height: 48.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).accent1,
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.credit_card_rounded,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    size: 24.0,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        listViewTransactionsRow.paymentMethod,
                                                                                        '--',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.date_range,
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          size: 16.0,
                                                                                        ),
                                                                                        Text(
                                                                                          dateTimeFormat(
                                                                                            "yMMMd",
                                                                                            listViewTransactionsRow.createdAt,
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                            ),
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      formatNumber(
                                                                                        (String valor) {
                                                                                          return double.tryParse(valor ?? '') ?? 0.0;
                                                                                        }(valueOrDefault<String>(
                                                                                          functions
                                                                                              .convertCurrencyBaseToOpt(
                                                                                                  listViewTransactionsRow.value!,
                                                                                                  getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].currency_type''',
                                                                                                  ).toString(),
                                                                                                  getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].currency''',
                                                                                                    true,
                                                                                                  ))
                                                                                              ?.toString(),
                                                                                          '-',
                                                                                        )),
                                                                                        formatType: FormatType.decimal,
                                                                                        decimalType: DecimalType.commaDecimal,
                                                                                        currency: '',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                      child: Text(
                                                                                        getJsonField(
                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                          r'''$[:].currency_type''',
                                                                                        ).toString(),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                              letterSpacing: 0.0,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Text(
                                                                                  'Completado',
                                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                                                                                        color: FlutterFlowTheme.of(context).success,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                        ),
                                                                      ),
                                                                    ],
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (_model.typeProduct == 3)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 1.0, 0.0, 10.0),
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
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    15.0, 0.0, 0.0, 0.0),
                                            child: SingleChildScrollView(
                                              primary: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 10.0),
                                                    child: Wrap(
                                                      spacing: 12.0,
                                                      runSpacing: 12.0,
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .start,
                                                      direction:
                                                          Axis.horizontal,
                                                      runAlignment:
                                                          WrapAlignment.start,
                                                      verticalDirection:
                                                          VerticalDirection
                                                              .down,
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            _model.responseJsonItinerary =
                                                                await actions
                                                                    .createJSONToPDF(
                                                              widget!.id!,
                                                              getJsonField(
                                                                itineraryDetailsGetitIneraryDetailsResponse
                                                                    .jsonBody,
                                                                r'''$[:].id_contact''',
                                                              ).toString(),
                                                              currentJwtToken!,
                                                              FFAppState()
                                                                  .accountId,
                                                            );
                                                            unawaited(
                                                              () async {
                                                                await actions
                                                                    .createPDF(
                                                                  getJsonField(
                                                                    _model
                                                                        .responseJsonItinerary,
                                                                    r'''$.contact''',
                                                                  ),
                                                                  getJsonField(
                                                                    _model
                                                                        .responseJsonItinerary,
                                                                    r'''$.agent''',
                                                                  ),
                                                                  getJsonField(
                                                                    _model
                                                                        .responseJsonItinerary,
                                                                    r'''$.itinerary''',
                                                                  ),
                                                                  getJsonField(
                                                                    _model
                                                                        .responseJsonItinerary,
                                                                    r'''$.items''',
                                                                  ),
                                                                  FFAppState()
                                                                      .accountId,
                                                                  getJsonField(
                                                                    _model
                                                                        .responseJsonItinerary,
                                                                    r'''$.account''',
                                                                  ),
                                                                );
                                                              }(),
                                                            );
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Generando PDF'),
                                                                  content: Text(
                                                                      'Esto puede tardar unos minutos.  El documento se abrirá automáticamente cuando esté listo.'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          text: 'Cotizacion',
                                                          icon: Icon(
                                                            Icons
                                                                .picture_as_pdf,
                                                            size: 20.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            height: 36.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            iconColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleSmallIsCustom,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                        ),
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            _model.apiResult7dk =
                                                                await ItineraryProposalPdfCall
                                                                    .call(
                                                              itineraryId:
                                                                  widget!.id,
                                                              authToken:
                                                                  currentJwtToken,
                                                            );

                                                            if ((_model
                                                                    .apiResult7dk
                                                                    ?.succeeded ??
                                                                true)) {
                                                              await launchURL(
                                                                  ItineraryProposalPdfCall
                                                                      .urlPDF(
                                                                (_model.apiResult7dk
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )!);
                                                            } else {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Error'),
                                                                    content: Text((_model
                                                                            .apiResult7dk
                                                                            ?.exceptionMessage ??
                                                                        '')),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }

                                                            safeSetState(() {});
                                                          },
                                                          text: 'Cotizacion v2',
                                                          icon: Icon(
                                                            Icons
                                                                .picture_as_pdf,
                                                            size: 20.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            height: 36.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            iconColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleSmallIsCustom,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Ver valores en URL',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            Switch.adaptive(
                                                              value: _model
                                                                      .verValoresUrlValue ??=
                                                                  getJsonField(
                                                                itineraryDetailsGetitIneraryDetailsResponse
                                                                    .jsonBody,
                                                                r'''$[:].rates_visibility''',
                                                              ),
                                                              onChanged:
                                                                  (newValue) async {
                                                                safeSetState(() =>
                                                                    _model.verValoresUrlValue =
                                                                        newValue!);
                                                                if (newValue!) {
                                                                  _model.apiResponseRatesVisibility =
                                                                      await UpdateItineraryRatesVisibilityCall
                                                                          .call(
                                                                    authToken:
                                                                        currentJwtToken,
                                                                    visibility:
                                                                        true.toString(),
                                                                    id: getJsonField(
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody,
                                                                      r'''$[:].id''',
                                                                    ).toString(),
                                                                  );

                                                                  if ((_model
                                                                          .apiResponseRatesVisibility
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    context
                                                                        .goNamed(
                                                                      ItineraryDetailsWidget
                                                                          .routeName,
                                                                      pathParameters:
                                                                          {
                                                                        'id':
                                                                            serializeParam(
                                                                          getJsonField(
                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                            r'''$[:].id''',
                                                                          ).toString(),
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Mensaje'),
                                                                          content:
                                                                              Text('Hubo un error inesperado.'),
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

                                                                  safeSetState(
                                                                      () {});
                                                                } else {
                                                                  _model.apiResponseRatesVisibilityFalse =
                                                                      await UpdateItineraryRatesVisibilityCall
                                                                          .call(
                                                                    authToken:
                                                                        currentJwtToken,
                                                                    visibility:
                                                                        false
                                                                            .toString(),
                                                                    id: getJsonField(
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody,
                                                                      r'''$[:].id''',
                                                                    ).toString(),
                                                                  );

                                                                  if ((_model
                                                                          .apiResponseRatesVisibilityFalse
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    context
                                                                        .goNamed(
                                                                      ItineraryDetailsWidget
                                                                          .routeName,
                                                                      pathParameters:
                                                                          {
                                                                        'id':
                                                                            serializeParam(
                                                                          getJsonField(
                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                            r'''$[:].id''',
                                                                          ).toString(),
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Mensaje'),
                                                                          content:
                                                                              Text('Hubo un error inesperado.'),
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

                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                              },
                                                              activeColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              activeTrackColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              inactiveTrackColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                              inactiveThumbColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Publicar URL',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            Switch.adaptive(
                                                              value: _model
                                                                      .publicarUrlValue ??=
                                                                  getJsonField(
                                                                itineraryDetailsGetitIneraryDetailsResponse
                                                                    .jsonBody,
                                                                r'''$[:].itinerary_visibility''',
                                                              ),
                                                              onChanged:
                                                                  (newValue) async {
                                                                safeSetState(() =>
                                                                    _model.publicarUrlValue =
                                                                        newValue!);
                                                                if (newValue!) {
                                                                  _model.apiResponseChangeItineraryVisibility =
                                                                      await UpdateItineraryVisibilityCall
                                                                          .call(
                                                                    authToken:
                                                                        currentJwtToken,
                                                                    visibility:
                                                                        true.toString(),
                                                                    id: getJsonField(
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody,
                                                                      r'''$[:].id''',
                                                                    ).toString(),
                                                                  );

                                                                  if ((_model
                                                                          .apiResponseChangeItineraryVisibility
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    context
                                                                        .goNamed(
                                                                      ItineraryDetailsWidget
                                                                          .routeName,
                                                                      pathParameters:
                                                                          {
                                                                        'id':
                                                                            serializeParam(
                                                                          getJsonField(
                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                            r'''$[:].id''',
                                                                          ).toString(),
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Mensaje'),
                                                                          content:
                                                                              Text('Hubo un error inesperado.'),
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

                                                                  safeSetState(
                                                                      () {});
                                                                } else {
                                                                  _model.apiResponseChangeItineraryVisibilityFalse =
                                                                      await UpdateItineraryVisibilityCall
                                                                          .call(
                                                                    authToken:
                                                                        currentJwtToken,
                                                                    visibility:
                                                                        false
                                                                            .toString(),
                                                                    id: getJsonField(
                                                                      itineraryDetailsGetitIneraryDetailsResponse
                                                                          .jsonBody,
                                                                      r'''$[:].id''',
                                                                    ).toString(),
                                                                  );

                                                                  if ((_model
                                                                          .apiResponseChangeItineraryVisibilityFalse
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    context
                                                                        .goNamed(
                                                                      ItineraryDetailsWidget
                                                                          .routeName,
                                                                      pathParameters:
                                                                          {
                                                                        'id':
                                                                            serializeParam(
                                                                          getJsonField(
                                                                            itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                            r'''$[:].id''',
                                                                          ).toString(),
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Mensaje'),
                                                                          content:
                                                                              Text('Hubo un error inesperado.'),
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

                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                              },
                                                              activeColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              activeTrackColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              inactiveTrackColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                              inactiveThumbColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                            ),
                                                          ],
                                                        ),
                                                        if (responsiveVisibility(
                                                          context: context,
                                                          phone: false,
                                                          tablet: false,
                                                          tabletLandscape:
                                                              false,
                                                          desktop: false,
                                                        ))
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    1.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          15.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await Clipboard.setData(
                                                                      ClipboardData(
                                                                          text:
                                                                              'https://bukeer.flutterflow.app/previewitinerary2/${getJsonField(
                                                                    FFAppState()
                                                                        .allDataContact,
                                                                    r'''$.itinerary_id''',
                                                                  ).toString()}'));
                                                                  _model.botonCopyURL =
                                                                      'Copiado';
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  _model
                                                                      .botonCopyURL,
                                                                  'No tocar',
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 40.0,
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                  iconAlignment:
                                                                      IconAlignment
                                                                          .start,
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).titleSmallFamily,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                      ),
                                                                  elevation:
                                                                      0.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            await Clipboard.setData(
                                                                ClipboardData(
                                                                    text:
                                                                        'https://platform.bukeer.com/previewitinerary/${widget!.id}'));
                                                            _model.botonCopyURL =
                                                                'Copiado';
                                                            safeSetState(() {});
                                                          },
                                                          text: _model
                                                              .botonCopyURL,
                                                          icon: Icon(
                                                            Icons.link,
                                                            size: 20.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            height: 36.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        0.0,
                                                                        12.0,
                                                                        0.0),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            iconColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleSmallIsCustom,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  FutureBuilder<
                                                      List<ItineraryItemsRow>>(
                                                    future:
                                                        ItineraryItemsTable()
                                                            .queryRows(
                                                      queryFn: (q) => q
                                                          .eqOrNull(
                                                            'id_itinerary',
                                                            widget!.id,
                                                          )
                                                          .order('date',
                                                              ascending: true),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
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
                                                        );
                                                      }
                                                      List<ItineraryItemsRow>
                                                          listViewItineraryItemsRowList =
                                                          snapshot.data!;

                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        primary: false,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            listViewItineraryItemsRowList
                                                                .length,
                                                        itemBuilder: (context,
                                                            listViewIndex) {
                                                          final listViewItineraryItemsRow =
                                                              listViewItineraryItemsRowList[
                                                                  listViewIndex];
                                                          return SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                if (listViewItineraryItemsRow
                                                                        .productType ==
                                                                    'Vuelos')
                                                                  FutureBuilder<
                                                                      List<
                                                                          AirlinesRow>>(
                                                                    future: AirlinesTable()
                                                                        .querySingleRow(
                                                                      queryFn:
                                                                          (q) =>
                                                                              q.eqOrNull(
                                                                        'id',
                                                                        listViewItineraryItemsRow
                                                                            .airline,
                                                                      ),
                                                                    ),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                50.0,
                                                                            height:
                                                                                50.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                FlutterFlowTheme.of(context).primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      List<AirlinesRow>
                                                                          componentItineraryPreviewFlightsAirlinesRowList =
                                                                          snapshot
                                                                              .data!;

                                                                      final componentItineraryPreviewFlightsAirlinesRow = componentItineraryPreviewFlightsAirlinesRowList
                                                                              .isNotEmpty
                                                                          ? componentItineraryPreviewFlightsAirlinesRowList
                                                                              .first
                                                                          : null;

                                                                      return ComponentItineraryPreviewFlightsWidget(
                                                                        key: Key(
                                                                            'Keyogo_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                                                        destination:
                                                                            listViewItineraryItemsRow.flightArrival,
                                                                        origen:
                                                                            listViewItineraryItemsRow.flightDeparture,
                                                                        flightNumber:
                                                                            listViewItineraryItemsRow.flightNumber,
                                                                        departureTime:
                                                                            listViewItineraryItemsRow.departureTime,
                                                                        arrivalTime:
                                                                            listViewItineraryItemsRow.arrivalTime,
                                                                        date: listViewItineraryItemsRow
                                                                            .date,
                                                                        image: componentItineraryPreviewFlightsAirlinesRow
                                                                            ?.logoLockupUrl,
                                                                        personalizedMessage:
                                                                            listViewItineraryItemsRow.personalizedMessage,
                                                                      );
                                                                    },
                                                                  ),
                                                                if (listViewItineraryItemsRow
                                                                        .productType ==
                                                                    'Hoteles')
                                                                  FutureBuilder<
                                                                      ApiCallResponse>(
                                                                    future:
                                                                        GetImagesAndMainImageCall
                                                                            .call(
                                                                      entityId:
                                                                          listViewItineraryItemsRow
                                                                              .idProduct,
                                                                      authToken:
                                                                          currentJwtToken,
                                                                    ),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                50.0,
                                                                            height:
                                                                                50.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                FlutterFlowTheme.of(context).primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final componentItineraryPreviewHotelsGetImagesAndMainImageResponse =
                                                                          snapshot
                                                                              .data!;

                                                                      return ComponentItineraryPreviewHotelsWidget(
                                                                        key: Key(
                                                                            'Key34l_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                                                        name: listViewItineraryItemsRow
                                                                            .productName,
                                                                        rateName:
                                                                            listViewItineraryItemsRow.rateName,
                                                                        location:
                                                                            listViewItineraryItemsRow.destination,
                                                                        idEntity:
                                                                            listViewItineraryItemsRow.idProduct,
                                                                        date: listViewItineraryItemsRow
                                                                            .date,
                                                                        media: componentItineraryPreviewHotelsGetImagesAndMainImageResponse
                                                                            .jsonBody,
                                                                        passengers:
                                                                            listViewItineraryItemsRow.quantity,
                                                                        personalizedMessage:
                                                                            listViewItineraryItemsRow.personalizedMessage,
                                                                      );
                                                                    },
                                                                  ),
                                                                if (listViewItineraryItemsRow
                                                                        .productType ==
                                                                    'Transporte')
                                                                  FutureBuilder<
                                                                      List<
                                                                          TransfersViewRow>>(
                                                                    future: TransfersViewTable()
                                                                        .queryRows(
                                                                      queryFn:
                                                                          (q) =>
                                                                              q.eqOrNull(
                                                                        'id',
                                                                        listViewItineraryItemsRow
                                                                            .idProduct,
                                                                      ),
                                                                    ),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                50.0,
                                                                            height:
                                                                                50.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                FlutterFlowTheme.of(context).primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      List<TransfersViewRow>
                                                                          componentItineraryPreviewTransfersTransfersViewRowList =
                                                                          snapshot
                                                                              .data!;

                                                                      return ComponentItineraryPreviewTransfersWidget(
                                                                        key: Key(
                                                                            'Keysdk_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                                                        name: listViewItineraryItemsRow
                                                                            .rateName,
                                                                        departureTime:
                                                                            listViewItineraryItemsRow.departureTime,
                                                                        date: listViewItineraryItemsRow
                                                                            .date,
                                                                        description: componentItineraryPreviewTransfersTransfersViewRowList
                                                                            .firstOrNull
                                                                            ?.description,
                                                                        location: componentItineraryPreviewTransfersTransfersViewRowList
                                                                            .firstOrNull
                                                                            ?.city,
                                                                        image: componentItineraryPreviewTransfersTransfersViewRowList
                                                                            .firstOrNull
                                                                            ?.mainImage,
                                                                        passengers:
                                                                            listViewItineraryItemsRow.quantity,
                                                                        personalizedMessage:
                                                                            listViewItineraryItemsRow.personalizedMessage,
                                                                      );
                                                                    },
                                                                  ),
                                                                if (listViewItineraryItemsRow
                                                                        .productType ==
                                                                    'Servicios')
                                                                  FutureBuilder<
                                                                      ApiCallResponse>(
                                                                    future:
                                                                        GetImagesAndMainImageCall
                                                                            .call(
                                                                      entityId:
                                                                          listViewItineraryItemsRow
                                                                              .idProduct,
                                                                      authToken:
                                                                          currentJwtToken,
                                                                    ),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                50.0,
                                                                            height:
                                                                                50.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                FlutterFlowTheme.of(context).primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final componentItineraryPreviewActivitiesGetImagesAndMainImageResponse =
                                                                          snapshot
                                                                              .data!;

                                                                      return ComponentItineraryPreviewActivitiesWidget(
                                                                        key: Key(
                                                                            'Key9qt_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                                                        name: listViewItineraryItemsRow
                                                                            .productName,
                                                                        rateName:
                                                                            listViewItineraryItemsRow.rateName,
                                                                        location:
                                                                            listViewItineraryItemsRow.destination,
                                                                        idEntity:
                                                                            listViewItineraryItemsRow.idProduct,
                                                                        date: listViewItineraryItemsRow
                                                                            .date,
                                                                        media: componentItineraryPreviewActivitiesGetImagesAndMainImageResponse
                                                                            .jsonBody,
                                                                        passengers:
                                                                            listViewItineraryItemsRow.quantity,
                                                                        personalizedMessage:
                                                                            listViewItineraryItemsRow.personalizedMessage,
                                                                      );
                                                                    },
                                                                  ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (_model.typeProduct == 4)
                                      Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.9,
                                        constraints: BoxConstraints(
                                          maxWidth: 852.0,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          8.0,
                                                                          8.0,
                                                                          8.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              ModalAddPassengerWidget(
                                                                            itineraryId:
                                                                                getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].id''',
                                                                            ).toString(),
                                                                            accountId:
                                                                                getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].account_id''',
                                                                            ).toString(),
                                                                            passengers:
                                                                                getJsonField(
                                                                              itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                              r'''$[:].passenger_count''',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text:
                                                                    'Agregar Pasajero',
                                                                icon: Icon(
                                                                  Icons
                                                                      .add_sharp,
                                                                  size: 24.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          12.0,
                                                                          8.0,
                                                                          12.0),
                                                                  iconAlignment:
                                                                      IconAlignment
                                                                          .end,
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  elevation:
                                                                      3.0,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                  hoverColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent1,
                                                                  hoverBorderSide:
                                                                      BorderSide(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    width: 1.0,
                                                                  ),
                                                                  hoverTextColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  hoverElevation:
                                                                      0.0,
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
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 16.0, 0.0, 0.0),
                                                child: Container(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          1.0,
                                                  constraints: BoxConstraints(
                                                    maxWidth: 852.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: FutureBuilder<
                                                      ApiCallResponse>(
                                                    future:
                                                        GetPassengersByItineraryIdCall
                                                            .call(
                                                      itineraryId: widget!.id,
                                                      authToken:
                                                          currentJwtToken,
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
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
                                                        );
                                                      }
                                                      final listViewSearchGetPassengersByItineraryIdResponse =
                                                          snapshot.data!;

                                                      return Builder(
                                                        builder: (context) {
                                                          final passengerItem =
                                                              listViewSearchGetPassengersByItineraryIdResponse
                                                                  .jsonBody
                                                                  .toList();

                                                          return ListView
                                                              .separated(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount:
                                                                passengerItem
                                                                    .length,
                                                            separatorBuilder:
                                                                (_, __) =>
                                                                    SizedBox(
                                                                        height:
                                                                            8.0),
                                                            itemBuilder: (context,
                                                                passengerItemIndex) {
                                                              final passengerItemItem =
                                                                  passengerItem[
                                                                      passengerItemIndex];
                                                              return Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                                child: InkWell(
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
                                                                    context.read<ItineraryService>()
                                                                            .allDataPassenger =
                                                                        passengerItemItem;
                                                                    safeSetState(
                                                                        () {});
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(context).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                ModalAddPassengerWidget(
                                                                              itineraryId: getJsonField(
                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                r'''$[:].id''',
                                                                              ).toString(),
                                                                              accountId: getJsonField(
                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                r'''$[:].account_id''',
                                                                              ).toString(),
                                                                              passengers: getJsonField(
                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                r'''$[:].passenger_count''',
                                                                              ),
                                                                              isEdit: true,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  child:
                                                                      AnimatedContainer(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            100),
                                                                    curve: Curves
                                                                        .easeInOut,
                                                                    width: 45.0,
                                                                    constraints:
                                                                        BoxConstraints(
                                                                      minHeight:
                                                                          70.0,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          blurRadius:
                                                                              3.0,
                                                                          color:
                                                                              BukeerColors.overlay,
                                                                          offset:
                                                                              Offset(
                                                                            0.0,
                                                                            1.0,
                                                                          ),
                                                                        )
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          16.0,
                                                                          16.0,
                                                                          16.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Container(
                                                                            width:
                                                                                50.0,
                                                                            height:
                                                                                50.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).accent1,
                                                                              borderRadius: BorderRadius.circular(25.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.all(BukeerSpacing.s),
                                                                              child: Text(
                                                                                'JD',
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        '${getJsonField(
                                                                                          passengerItemItem,
                                                                                          r'''$.name''',
                                                                                        ).toString()} ${getJsonField(
                                                                                          passengerItemItem,
                                                                                          r'''$.last_name''',
                                                                                        ).toString()}',
                                                                                        'Nombre Completo',
                                                                                      ),
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        await Clipboard.setData(ClipboardData(
                                                                                            text: valueOrDefault<String>(
                                                                                          '${getJsonField(
                                                                                            passengerItemItem,
                                                                                            r'''$.name''',
                                                                                          ).toString()} ${getJsonField(
                                                                                            passengerItemItem,
                                                                                            r'''$.last_name''',
                                                                                          ).toString()}',
                                                                                          'Nombre Completo',
                                                                                        )));
                                                                                        ScaffoldMessenger.of(context).clearSnackBars();
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              'Nombre y apellido copiado',
                                                                                              style: TextStyle(
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                              ),
                                                                                            ),
                                                                                            duration: Duration(milliseconds: 2000),
                                                                                            backgroundColor: FlutterFlowTheme.of(context).success,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.content_paste,
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        size: 20.0,
                                                                                      ),
                                                                                    ),
                                                                                  ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${getJsonField(
                                                                                        passengerItemItem,
                                                                                        r'''$.type_id''',
                                                                                      ).toString()} ${getJsonField(
                                                                                        passengerItemItem,
                                                                                        r'''$.number_id''',
                                                                                      ).toString()}',
                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        await Clipboard.setData(ClipboardData(
                                                                                            text: getJsonField(
                                                                                          passengerItemItem,
                                                                                          r'''$.number_id''',
                                                                                        ).toString()));
                                                                                        ScaffoldMessenger.of(context).clearSnackBars();
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              'Numero de documento copiado',
                                                                                              style: TextStyle(
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                              ),
                                                                                            ),
                                                                                            duration: Duration(milliseconds: 2000),
                                                                                            backgroundColor: FlutterFlowTheme.of(context).success,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.content_paste,
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        size: 20.0,
                                                                                      ),
                                                                                    ),
                                                                                  ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Fecha de nacimiento: ${(String var1) {
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
                                                                                        passengerItemItem,
                                                                                        r'''$.birth_date''',
                                                                                      ).toString())}',
                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        await Clipboard.setData(ClipboardData(
                                                                                            text: (String var1) {
                                                                                          return '${var1.split('-')[2]}/${var1.split('-')[1]}/${var1.split('-')[0]}';
                                                                                        }(getJsonField(
                                                                                          passengerItemItem,
                                                                                          r'''$.birth_date''',
                                                                                        ).toString())));
                                                                                        ScaffoldMessenger.of(context).clearSnackBars();
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              'Fecha de nacimiento copiada',
                                                                                              style: TextStyle(
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                              ),
                                                                                            ),
                                                                                            duration: Duration(milliseconds: 2000),
                                                                                            backgroundColor: FlutterFlowTheme.of(context).success,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.content_paste,
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        size: 20.0,
                                                                                      ),
                                                                                    ),
                                                                                  ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                                ),
                                                                                Text(
                                                                                  'Nacionalidad: ${getJsonField(
                                                                                    passengerItemItem,
                                                                                    r'''$.nationality''',
                                                                                  ).toString()}',
                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Text(
                                                                                'Manager',
                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                    ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets.all(BukeerSpacing.xs),
                                                                                    child: Icon(
                                                                                      Icons.call,
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      size: 20.0,
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.all(BukeerSpacing.xs),
                                                                                    child: Icon(
                                                                                      Icons.email,
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      size: 20.0,
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {},
                                                                                    child: Icon(
                                                                                      Icons.more_vert,
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      size: 20.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ].divide(SizedBox(width: BukeerSpacing.m)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (_model.typeProduct == 5)
                                      Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.9,
                                        constraints: BoxConstraints(
                                          maxWidth: 852.0,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: FutureBuilder<ApiCallResponse>(
                                          future: GetAllItemsItineraryCall.call(
                                            authToken: currentJwtToken,
                                            search: '',
                                            pageNumber: 0,
                                            pageSize: 100,
                                            id: widget!.id,
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
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
                                              );
                                            }
                                            final columnGetAllItemsItineraryResponse =
                                                snapshot.data!;

                                            return SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Wrap(
                                                        spacing: 0.0,
                                                        runSpacing: 0.0,
                                                        alignment:
                                                            WrapAlignment.start,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                        direction:
                                                            Axis.horizontal,
                                                        runAlignment:
                                                            WrapAlignment.start,
                                                        verticalDirection:
                                                            VerticalDirection
                                                                .down,
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Container(
                                                              height: 30.0,
                                                              constraints:
                                                                  BoxConstraints(
                                                                minWidth: 180.0,
                                                                maxWidth: 284.0,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  'Total a pagar:  ${formatNumber(
                                                                    functions.jsonArraySummation(
                                                                        getJsonField(
                                                                          columnGetAllItemsItineraryResponse
                                                                              .jsonBody,
                                                                          r'''$''',
                                                                          true,
                                                                        )!,
                                                                        'total_cost'),
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        '',
                                                                  )}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: FlutterFlowTheme.of(
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
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Container(
                                                              height: 30.0,
                                                              constraints:
                                                                  BoxConstraints(
                                                                minWidth: 180.0,
                                                                maxWidth: 284.0,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  'Total pagado:  ${formatNumber(
                                                                    functions.jsonArraySummation(
                                                                        getJsonField(
                                                                          columnGetAllItemsItineraryResponse
                                                                              .jsonBody,
                                                                          r'''$''',
                                                                          true,
                                                                        )!,
                                                                        'paid_cost'),
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        '',
                                                                  )}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: FlutterFlowTheme.of(
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
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Container(
                                                              height: 30.0,
                                                              constraints:
                                                                  BoxConstraints(
                                                                minWidth: 180.0,
                                                                maxWidth: 284.0,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  'Pendiente:  ${formatNumber(
                                                                    functions.jsonArraySummation(
                                                                        getJsonField(
                                                                          columnGetAllItemsItineraryResponse
                                                                              .jsonBody,
                                                                          r'''$''',
                                                                          true,
                                                                        )!,
                                                                        'pending_paid_cost'),
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        '',
                                                                  )}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: FlutterFlowTheme.of(
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
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  PagedListView<ApiPagingParams,
                                                      dynamic>.separated(
                                                    pagingController: _model
                                                        .setListViewItemsItineraryController(
                                                      (nextPageMarker) =>
                                                          GetAllItemsItineraryCall
                                                              .call(
                                                        authToken:
                                                            currentJwtToken,
                                                        search: FFAppState()
                                                            .searchStringState,
                                                        pageNumber:
                                                            nextPageMarker
                                                                .nextPageNumber,
                                                        pageSize: 5,
                                                        id: widget!.id,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    reverse: false,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    separatorBuilder: (_, __) =>
                                                        SizedBox(height: BukeerSpacing.m),
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
                                                          itemItineraryIndex) {
                                                        final itemItineraryItem =
                                                            _model.listViewItemsItineraryPagingController!
                                                                    .itemList![
                                                                itemItineraryIndex];
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 1.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      1.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            12.0,
                                                                            8.0,
                                                                            12.0,
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.provider_name''',
                                                                                    ).toString(),
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                          fontSize: BukeerTypography.bodyMediumSize,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.product_name''',
                                                                                    ).toString(),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.date_range,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            size: 16.0,
                                                                                          ),
                                                                                          Text(
                                                                                            getJsonField(
                                                                                              itemItineraryItem,
                                                                                              r'''$.date''',
                                                                                            ).toString(),
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.people,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            size: 16.0,
                                                                                          ),
                                                                                          Text(
                                                                                            getJsonField(
                                                                                              itemItineraryItem,
                                                                                              r'''$.quantity''',
                                                                                            ).toString(),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.attach_money_sharp,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            size: 16.0,
                                                                                          ),
                                                                                          Text(
                                                                                            getJsonField(
                                                                                              itemItineraryItem,
                                                                                              r'''$.unit_cost''',
                                                                                            ).toString(),
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                if ((bool reservationStatus, String productType) {
                                                                                  return reservationStatus == true && productType != "Vuelos";
                                                                                }(
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.reservation_status''',
                                                                                    ),
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.product_type''',
                                                                                    ).toString()))
                                                                                  InkWell(
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
                                                                                          return GestureDetector(
                                                                                            onTap: () {
                                                                                              FocusScope.of(context).unfocus();
                                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                                              child: ShowReservationMessageWidget(
                                                                                                messages: getJsonField(
                                                                                                  itemItineraryItem,
                                                                                                  r'''$.reservation_messages''',
                                                                                                  true,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ).then((value) => safeSetState(() {}));
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Confirmado',
                                                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                                                                                                color: FlutterFlowTheme.of(context).success,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.message,
                                                                                          color: FlutterFlowTheme.of(context).success,
                                                                                          size: 20.0,
                                                                                        ),
                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                    ),
                                                                                  ),
                                                                                if ((bool reservationStatus, String productType) {
                                                                                  return reservationStatus == false && productType != "Vuelos";
                                                                                }(
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.reservation_status''',
                                                                                    ),
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.product_type''',
                                                                                    ).toString()))
                                                                                  FFButtonWidget(
                                                                                    onPressed: () async {
                                                                                      _model.responseValidatePassengers = await actions.validatePassengers(
                                                                                        getJsonField(
                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                          r'''$[:].id''',
                                                                                        ).toString(),
                                                                                      );
                                                                                      if (_model.responseValidatePassengers!) {
                                                                                        await showModalBottomSheet(
                                                                                          isScrollControlled: true,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          enableDrag: false,
                                                                                          useSafeArea: true,
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return GestureDetector(
                                                                                              onTap: () {
                                                                                                FocusScope.of(context).unfocus();
                                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                                child: ReservationMessageWidget(
                                                                                                  idItinerary: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].id''',
                                                                                                  ).toString(),
                                                                                                  agentName: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].travel_planner_name''',
                                                                                                  ).toString(),
                                                                                                  agentEmail: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].travel_planner_email''',
                                                                                                  ).toString(),
                                                                                                  emailProvider: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.provider_email_related''',
                                                                                                  ).toString(),
                                                                                                  nameProvider: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.provider_name''',
                                                                                                  ).toString(),
                                                                                                  passengers: 'Prueba',
                                                                                                  fecha: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.date''',
                                                                                                  ).toString(),
                                                                                                  producto: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.product_name''',
                                                                                                  ).toString(),
                                                                                                  tarifa: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.rate_name''',
                                                                                                  ).toString(),
                                                                                                  cantidad: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.quantity''',
                                                                                                  ),
                                                                                                  idItemProduct: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.id''',
                                                                                                  ).toString(),
                                                                                                  idFm: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].id_fm''',
                                                                                                  ).toString(),
                                                                                                  tipoEmal: 'reserva',
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ).then((value) => safeSetState(() {}));

                                                                                        safeSetState(() => _model.listViewItemsItineraryPagingController?.refresh());
                                                                                        await _model.waitForOnePageForListViewItemsItinerary();
                                                                                      } else {
                                                                                        await showDialog(
                                                                                          context: context,
                                                                                          builder: (alertDialogContext) {
                                                                                            return AlertDialog(
                                                                                              title: Text('Mensaje'),
                                                                                              content: Text('Debes agregar la información de los pasajeros antes de continuar.'),
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

                                                                                      safeSetState(() {});
                                                                                    },
                                                                                    text: 'Confirmar',
                                                                                    icon: Icon(
                                                                                      Icons.notifications_active,
                                                                                      size: 15.0,
                                                                                    ),
                                                                                    options: FFButtonOptions(
                                                                                      width: 120.0,
                                                                                      height: 32.0,
                                                                                      padding: EdgeInsets.all(BukeerSpacing.s),
                                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                            color: FlutterFlowTheme.of(context).info,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                          ),
                                                                                      elevation: 0.0,
                                                                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                    ),
                                                                                  ),
                                                                                if ((bool reservationStatus, String productType) {
                                                                                  return reservationStatus == true && productType != "Vuelos";
                                                                                }(
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.reservation_status''',
                                                                                    ),
                                                                                    getJsonField(
                                                                                      itemItineraryItem,
                                                                                      r'''$.product_type''',
                                                                                    ).toString()))
                                                                                  InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {
                                                                                      _model.responseValidatePassengersUpdate = await actions.validatePassengers(
                                                                                        getJsonField(
                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                          r'''$[:].id''',
                                                                                        ).toString(),
                                                                                      );
                                                                                      if (_model.responseValidatePassengersUpdate!) {
                                                                                        await showModalBottomSheet(
                                                                                          isScrollControlled: true,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          enableDrag: false,
                                                                                          useSafeArea: true,
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return GestureDetector(
                                                                                              onTap: () {
                                                                                                FocusScope.of(context).unfocus();
                                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                                child: ReservationMessageWidget(
                                                                                                  idItinerary: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].id''',
                                                                                                  ).toString(),
                                                                                                  agentName: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].travel_planner_name''',
                                                                                                  ).toString(),
                                                                                                  agentEmail: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].travel_planner_email''',
                                                                                                  ).toString(),
                                                                                                  emailProvider: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.provider_email''',
                                                                                                  ).toString(),
                                                                                                  nameProvider: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.provider_name''',
                                                                                                  ).toString(),
                                                                                                  passengers: 'Prueba',
                                                                                                  fecha: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.date''',
                                                                                                  ).toString(),
                                                                                                  producto: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.product_name''',
                                                                                                  ).toString(),
                                                                                                  tarifa: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.rate_name''',
                                                                                                  ).toString(),
                                                                                                  cantidad: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.quantity''',
                                                                                                  ),
                                                                                                  idItemProduct: getJsonField(
                                                                                                    itemItineraryItem,
                                                                                                    r'''$.id''',
                                                                                                  ).toString(),
                                                                                                  idFm: getJsonField(
                                                                                                    itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                    r'''$[:].id_fm''',
                                                                                                  ).toString(),
                                                                                                  tipoEmal: 'update',
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ).then((value) => safeSetState(() {}));

                                                                                        safeSetState(() => _model.listViewItemsItineraryPagingController?.refresh());
                                                                                        await _model.waitForOnePageForListViewItemsItinerary();
                                                                                      } else {
                                                                                        await showDialog(
                                                                                          context: context,
                                                                                          builder: (alertDialogContext) {
                                                                                            return AlertDialog(
                                                                                              title: Text('Mensaje'),
                                                                                              content: Text('Debes agregar la información de los pasajeros antes de continuar.'),
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

                                                                                      safeSetState(() {});
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Enviar mensaje',
                                                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                                                                                                color: FlutterFlowTheme.of(context).success,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.email_outlined,
                                                                                          color: FlutterFlowTheme.of(context).success,
                                                                                          size: 20.0,
                                                                                        ),
                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                    ),
                                                                                  ),
                                                                              ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Opacity(
                                                                          opacity:
                                                                              0.9,
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).alternate,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              4.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Flexible(
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Costo total:',
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                        Text(
                                                                                          formatNumber(
                                                                                            (String valor) {
                                                                                              return double.tryParse(valor ?? '') ?? 0.0;
                                                                                            }(valueOrDefault<String>(
                                                                                              getJsonField(
                                                                                                itemItineraryItem,
                                                                                                r'''$.total_cost''',
                                                                                              )?.toString(),
                                                                                              '0',
                                                                                            )),
                                                                                            formatType: FormatType.decimal,
                                                                                            decimalType: DecimalType.commaDecimal,
                                                                                            currency: '',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                      ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Total pagado:',
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                        Text(
                                                                                          formatNumber(
                                                                                            (String valor) {
                                                                                              return double.tryParse(valor ?? '') ?? 0.0;
                                                                                            }(valueOrDefault<String>(
                                                                                              getJsonField(
                                                                                                itemItineraryItem,
                                                                                                r'''$.paid_cost''',
                                                                                              )?.toString(),
                                                                                              '0',
                                                                                            )),
                                                                                            formatType: FormatType.decimal,
                                                                                            decimalType: DecimalType.commaDecimal,
                                                                                            currency: '',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                      ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Pendiente:',
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                        Text(
                                                                                          formatNumber(
                                                                                            (String valor) {
                                                                                              return double.tryParse(valor ?? '') ?? 0.0;
                                                                                            }(getJsonField(
                                                                                              itemItineraryItem,
                                                                                              r'''$.pending_paid_cost''',
                                                                                            ).toString()),
                                                                                            formatType: FormatType.decimal,
                                                                                            decimalType: DecimalType.commaDecimal,
                                                                                            currency: '',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  FlutterFlowIconButton(
                                                                                    borderColor: FlutterFlowTheme.of(context).primary,
                                                                                    borderRadius: 8.0,
                                                                                    borderWidth: 1.0,
                                                                                    buttonSize: 36.0,
                                                                                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    icon: Icon(
                                                                                      Icons.list_alt,
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      size: 20.0,
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      await showModalBottomSheet(
                                                                                        isScrollControlled: true,
                                                                                        backgroundColor: Colors.transparent,
                                                                                        enableDrag: false,
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return GestureDetector(
                                                                                            onTap: () {
                                                                                              FocusScope.of(context).unfocus();
                                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                                              child: ComponentProviderPaymentsWidget(
                                                                                                idItem: getJsonField(
                                                                                                  itemItineraryItem,
                                                                                                  r'''$.id''',
                                                                                                ).toString(),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ).then((value) => safeSetState(() {}));
                                                                                    },
                                                                                  ),
                                                                                  FFButtonWidget(
                                                                                    onPressed: functions.showBtnRegistrarPago(itemItineraryItem)
                                                                                        ? null
                                                                                        : () async {
                                                                                            _model.responseValidatePassengersPaid = await actions.validatePassengers(
                                                                                              getJsonField(
                                                                                                itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                r'''$[:].id''',
                                                                                              ).toString(),
                                                                                            );
                                                                                            if (_model.responseValidatePassengersPaid!) {
                                                                                              await showModalBottomSheet(
                                                                                                isScrollControlled: true,
                                                                                                backgroundColor: Colors.transparent,
                                                                                                enableDrag: false,
                                                                                                context: context,
                                                                                                builder: (context) {
                                                                                                  return GestureDetector(
                                                                                                    onTap: () {
                                                                                                      FocusScope.of(context).unfocus();
                                                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                                                    },
                                                                                                    child: Padding(
                                                                                                      padding: MediaQuery.viewInsetsOf(context),
                                                                                                      child: ComponentAddPaidWidget(
                                                                                                        idItemProduct: getJsonField(
                                                                                                          itemItineraryItem,
                                                                                                          r'''$.id''',
                                                                                                        ).toString(),
                                                                                                        idItinerary: getJsonField(
                                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                          r'''$[:].id''',
                                                                                                        ).toString(),
                                                                                                        typeTransaction: 'egreso',
                                                                                                        agentName: getJsonField(
                                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                          r'''$[:].travel_planner_name''',
                                                                                                        ).toString(),
                                                                                                        agentEmail: getJsonField(
                                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                          r'''$[:].travel_planner_email''',
                                                                                                        ).toString(),
                                                                                                        emailProvider: getJsonField(
                                                                                                          itemItineraryItem,
                                                                                                          r'''$.provider_email_related''',
                                                                                                        ).toString(),
                                                                                                        nameProvider: getJsonField(
                                                                                                          itemItineraryItem,
                                                                                                          r'''$.provider_name''',
                                                                                                        ).toString(),
                                                                                                        fechaReserva: getJsonField(
                                                                                                          itemItineraryItem,
                                                                                                          r'''$.date''',
                                                                                                        ).toString(),
                                                                                                        producto: getJsonField(
                                                                                                          itemItineraryItem,
                                                                                                          r'''$.product_name''',
                                                                                                        ).toString(),
                                                                                                        tarifa: getJsonField(
                                                                                                          itemItineraryItem,
                                                                                                          r'''$.rate_name''',
                                                                                                        ).toString(),
                                                                                                        cantidad: getJsonField(
                                                                                                          itemItineraryItem,
                                                                                                          r'''$.quantity''',
                                                                                                        ),
                                                                                                        idFm: getJsonField(
                                                                                                          itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
                                                                                                          r'''$[:].id_fm''',
                                                                                                        ).toString(),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                              ).then((value) => safeSetState(() {}));

                                                                                              safeSetState(() => _model.listViewItemsItineraryPagingController?.refresh());
                                                                                              await _model.waitForOnePageForListViewItemsItinerary();
                                                                                              await Future.delayed(const Duration(milliseconds: 1000));
                                                                                            } else {
                                                                                              await showDialog(
                                                                                                context: context,
                                                                                                builder: (alertDialogContext) {
                                                                                                  return AlertDialog(
                                                                                                    title: Text('Mensaje'),
                                                                                                    content: Text('Debes agregar la información de los pasajeros antes de continuar.'),
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

                                                                                            safeSetState(() {});
                                                                                          },
                                                                                    text: 'Registrar pago',
                                                                                    icon: Icon(
                                                                                      Icons.add,
                                                                                      size: 20.0,
                                                                                    ),
                                                                                    options: FFButtonOptions(
                                                                                      width: 140.0,
                                                                                      height: 32.0,
                                                                                      padding: EdgeInsets.all(BukeerSpacing.s),
                                                                                      iconAlignment: IconAlignment.end,
                                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                            color: FlutterFlowTheme.of(context).info,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                          ),
                                                                                      elevation: 0.0,
                                                                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                      disabledColor: FlutterFlowTheme.of(context).alternate,
                                                                                      disabledTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                    ),
                                                                                  ),
                                                                                ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: BukeerSpacing.s)),
                                              ),
                                            );
                                          },
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
    );
  }
}
