import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import '../component_itinerary_preview_activities/component_itinerary_preview_activities_widget.dart';
import '../component_itinerary_preview_flights/component_itinerary_preview_flights_widget.dart';
import '../component_itinerary_preview_hotels/component_itinerary_preview_hotels_widget.dart';
import '../component_itinerary_preview_transfers/component_itinerary_preview_transfers_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/components/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart' as functions;
import '../../../../index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'preview_itinerary_u_r_l_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'preview_itinerary_u_r_l_model.dart';

class PreviewItineraryURLWidget extends StatefulWidget {
  const PreviewItineraryURLWidget({
    super.key,
    required this.id,
  });

  final String? id;

  static String routeName = 'preview_itinerary_URL';
  static String routePath = 'previewitinerary/:id';

  @override
  State<PreviewItineraryURLWidget> createState() =>
      _PreviewItineraryURLWidgetState();
}

class _PreviewItineraryURLWidgetState extends State<PreviewItineraryURLWidget> {
  late PreviewItineraryURLModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PreviewItineraryURLModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: FutureBuilder<ApiCallResponse>(
            future: GetClientItineraryCall.call(
              authToken: currentJwtToken,
              id: widget!.id,
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
                        BukeerColors.primary,
                      ),
                    ),
                  ),
                );
              }
              final columnGetClientItineraryResponse = snapshot.data!;

              return SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if ('${getJsonField(
                          columnGetClientItineraryResponse.jsonBody,
                          r'''$[:].itinerary_visibility''',
                        ).toString()}' ==
                        '${true.toString()}')
                      Container(
                        decoration: BoxDecoration(
                          color: BukeerColors.getBackground(context,
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
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 850.0,
                                ),
                                decoration: BoxDecoration(),
                                child: Padding(
                                  padding: EdgeInsets.all(BukeerSpacing.s),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            getJsonField(
                                                              columnGetClientItineraryResponse
                                                                  .jsonBody,
                                                              r'''$[:].itinerary_name''',
                                                            ).toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmallFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      20.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  lineHeight:
                                                                      1.2,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineSmallIsCustom,
                                                                ),
                                                          ),
                                                          Wrap(
                                                            spacing: 0.0,
                                                            runSpacing: 0.0,
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
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            4.0,
                                                                            0.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          16.0,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      getJsonField(
                                                                        columnGetClientItineraryResponse
                                                                            .jsonBody,
                                                                        r'''$[:].contact_name''',
                                                                      ).toString(),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  if (getJsonField(
                                                                        columnGetClientItineraryResponse
                                                                            .jsonBody,
                                                                        r'''$[:].contact_last_name''',
                                                                      ) !=
                                                                      null)
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        getJsonField(
                                                                          columnGetClientItineraryResponse
                                                                              .jsonBody,
                                                                          r'''$[:].contact_last_name''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelLarge
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            2.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      'ID',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                BukeerColors.secondaryText,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      getJsonField(
                                                                        columnGetClientItineraryResponse
                                                                            .jsonBody,
                                                                        r'''$[:].id_fm''',
                                                                      ).toString(),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            4.0,
                                                                            0.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .date_range,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          16.0,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
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
                                                                        columnGetClientItineraryResponse
                                                                            .jsonBody,
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
                                                                        columnGetClientItineraryResponse
                                                                            .jsonBody,
                                                                        r'''$[:].end_date''',
                                                                      ).toString())}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            4.0,
                                                                            0.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .people,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          16.0,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    getJsonField(
                                                                      columnGetClientItineraryResponse
                                                                          .jsonBody,
                                                                      r'''$[:].passenger_count''',
                                                                    ).toString(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelLargeFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.s),
                                                      child: Image.network(
                                                        getJsonField(
                                                                  columnGetClientItineraryResponse
                                                                      .jsonBody,
                                                                  r'''$[:].logo_image''',
                                                                ) !=
                                                                null
                                                            ? getJsonField(
                                                                columnGetClientItineraryResponse
                                                                    .jsonBody,
                                                                r'''$[:].logo_image''',
                                                              ).toString()
                                                            : 'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                                        width: 120.0,
                                                        height: 57.0,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 4.0, 0.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40.0),
                                                    child: Image.network(
                                                      getJsonField(
                                                        columnGetClientItineraryResponse
                                                            .jsonBody,
                                                        r'''$[:].travel_planner_user_image''',
                                                      ).toString(),
                                                      width: 45.0,
                                                      height: 45.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${getJsonField(
                                                          columnGetClientItineraryResponse
                                                              .jsonBody,
                                                          r'''$[:].travel_planner_name''',
                                                        ).toString()} ${getJsonField(
                                                          columnGetClientItineraryResponse
                                                              .jsonBody,
                                                          r'''$[:].travel_planner_last_name''',
                                                        ).toString()}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  fontSize:
                                                                      BukeerTypography
                                                                          .bodyMediumSize,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Travel Planner',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      if ('${getJsonField(
                                                                columnGetClientItineraryResponse
                                                                    .jsonBody,
                                                                r'''$[:].personalized_message''',
                                                              ).toString()}' !=
                                                              null &&
                                                          '${getJsonField(
                                                                columnGetClientItineraryResponse
                                                                    .jsonBody,
                                                                r'''$[:].personalized_message''',
                                                              ).toString()}' !=
                                                              '')
                                                        Text(
                                                          getJsonField(
                                                            columnGetClientItineraryResponse
                                                                .jsonBody,
                                                            r'''$[:].personalized_message''',
                                                          ).toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize:
                                                                    BukeerTypography
                                                                        .captionSize,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      if (responsiveVisibility(
                                                        context: context,
                                                        phone: false,
                                                        tablet: false,
                                                        tabletLandscape: false,
                                                        desktop: false,
                                                      ))
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (getJsonField(
                                                                  columnGetClientItineraryResponse
                                                                      .jsonBody,
                                                                  r'''$[:].travel_planner_email''',
                                                                ) !=
                                                                null)
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            4.0,
                                                                            0.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .email_outlined,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          16.0,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      getJsonField(
                                                                        columnGetClientItineraryResponse
                                                                            .jsonBody,
                                                                        r'''$[:].travel_planner_email''',
                                                                      ).toString(),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            if (getJsonField(
                                                                  columnGetClientItineraryResponse
                                                                      .jsonBody,
                                                                  r'''$[:].travel_planner_phone''',
                                                                ) !=
                                                                null)
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            4.0,
                                                                            0.0),
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .whatsapp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          16.0,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      getJsonField(
                                                                        columnGetClientItineraryResponse
                                                                            .jsonBody,
                                                                        r'''$[:].travel_planner_phone''',
                                                                      ).toString(),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                                          ),
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
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  BukeerSpacing.s),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  if (getJsonField(
                                                    columnGetClientItineraryResponse
                                                        .jsonBody,
                                                    r'''$[:].rates_visibility''',
                                                  ))
                                                    Text(
                                                      valueOrDefault<String>(
                                                        'Total ${valueOrDefault<String>(
                                                          formatNumber(
                                                            double.parse((functions.costMultiCurrenty(
                                                                    getJsonField(
                                                                      columnGetClientItineraryResponse
                                                                          .jsonBody,
                                                                      r'''$[:].currency''',
                                                                      true,
                                                                    ),
                                                                    getJsonField(
                                                                      columnGetClientItineraryResponse
                                                                          .jsonBody,
                                                                      r'''$[:].currency_type''',
                                                                    ).toString(),
                                                                    getJsonField(
                                                                      columnGetClientItineraryResponse
                                                                          .jsonBody,
                                                                      r'''$[:].total_amount''',
                                                                    ))!)
                                                                .toStringAsFixed(1)),
                                                            formatType:
                                                                FormatType
                                                                    .decimal,
                                                            decimalType:
                                                                DecimalType
                                                                    .commaDecimal,
                                                          ),
                                                          '0',
                                                        )} ${getJsonField(
                                                          columnGetClientItineraryResponse
                                                              .jsonBody,
                                                          r'''$[:].currency_type''',
                                                        ).toString()}',
                                                        '0',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            fontSize:
                                                                BukeerTypography
                                                                    .bodyLargeSize,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallIsCustom,
                                                          ),
                                                    ),
                                                  if (getJsonField(
                                                    columnGetClientItineraryResponse
                                                        .jsonBody,
                                                    r'''$[:].rates_visibility''',
                                                  ))
                                                    Text(
                                                      valueOrDefault<String>(
                                                        'Valor por persona  ${valueOrDefault<String>(
                                                          formatNumber(
                                                            double.parse(((functions.costMultiCurrenty(
                                                                        getJsonField(
                                                                          columnGetClientItineraryResponse
                                                                              .jsonBody,
                                                                          r'''$[:].currency''',
                                                                          true,
                                                                        ),
                                                                        getJsonField(
                                                                          columnGetClientItineraryResponse
                                                                              .jsonBody,
                                                                          r'''$[:].currency_type''',
                                                                        ).toString(),
                                                                        getJsonField(
                                                                          columnGetClientItineraryResponse
                                                                              .jsonBody,
                                                                          r'''$[:].total_amount''',
                                                                        ))!) /
                                                                    getJsonField(
                                                                      columnGetClientItineraryResponse
                                                                          .jsonBody,
                                                                      r'''$[:].passenger_count''',
                                                                    ))
                                                                .toStringAsFixed(1)),
                                                            formatType:
                                                                FormatType
                                                                    .decimal,
                                                            decimalType:
                                                                DecimalType
                                                                    .commaDecimal,
                                                          ),
                                                          '0',
                                                        )} ${getJsonField(
                                                          columnGetClientItineraryResponse
                                                              .jsonBody,
                                                          r'''$[:].currency_type''',
                                                        ).toString()}',
                                                        '0',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            fontSize:
                                                                BukeerTypography
                                                                    .bodyLargeSize,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallIsCustom,
                                                          ),
                                                    ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    4.0),
                                                        child: Text(
                                                          'Valido hasta ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineSmall
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize:
                                                                    BukeerTypography
                                                                        .bodyMediumSize,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmallIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    4.0),
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
                                                            columnGetClientItineraryResponse
                                                                .jsonBody,
                                                            r'''$[:].valid_until''',
                                                          ).toString()),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineSmall
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmallFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize:
                                                                    BukeerTypography
                                                                        .bodyMediumSize,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmallIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 8.0, 0.0, 8.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  context.pushNamed(
                                                    AddPassengersItineraryWidget
                                                        .routeName,
                                                    pathParameters: {
                                                      'id': serializeParam(
                                                        widget!.id,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                text: 'Registrar pasajeros',
                                                icon: Icon(
                                                  Icons.add_sharp,
                                                  size: 24.0,
                                                ),
                                                options: FFButtonOptions(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(12.0, 12.0, 8.0,
                                                          12.0),
                                                  iconAlignment:
                                                      IconAlignment.end,
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  iconColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .info,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          BukeerSpacing.sm),
                                                  hoverColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .accent1,
                                                  hoverBorderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 1.0,
                                                  ),
                                                  hoverTextColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  hoverElevation: 0.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (responsiveVisibility(
                                            context: context,
                                            phone: false,
                                            tablet: false,
                                            tabletLandscape: false,
                                            desktop: false,
                                          ))
                                            BukeerIconButton(
                                              onPressed: () {
                                                print('IconButton pressed ...');
                                              },
                                              icon: Icon(
                                                Icons.picture_as_pdf,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 24.0,
                                              ),
                                              size: BukeerIconButtonSize.medium,
                                              variant: BukeerIconButtonVariant
                                                  .filled,
                                            ),
                                        ].divide(
                                            SizedBox(width: BukeerSpacing.s)),
                                      ),
                                    ].divide(SizedBox(height: BukeerSpacing.s)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if ('${getJsonField(
                          columnGetClientItineraryResponse.jsonBody,
                          r'''$[:].itinerary_visibility''',
                        ).toString()}' ==
                        '${false.toString()}')
                      Container(
                        decoration: BoxDecoration(
                          color: BukeerColors.getBackground(context,
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
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 850.0,
                                ),
                                decoration: BoxDecoration(),
                                child: Padding(
                                  padding: EdgeInsets.all(BukeerSpacing.s),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Itinerario no disponible',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmallFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      20.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  lineHeight:
                                                                      1.2,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineSmallIsCustom,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.s),
                                                      child: Image.network(
                                                        getJsonField(
                                                                  columnGetClientItineraryResponse
                                                                      .jsonBody,
                                                                  r'''$[:].logo_image''',
                                                                ) !=
                                                                null
                                                            ? getJsonField(
                                                                columnGetClientItineraryResponse
                                                                    .jsonBody,
                                                                r'''$[:].logo_image''',
                                                              ).toString()
                                                            : 'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                                        width: 120.0,
                                                        height: 57.0,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(height: BukeerSpacing.s)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      height: 180.0,
                      constraints: BoxConstraints(
                        minWidth: 843.0,
                      ),
                      decoration: BoxDecoration(
                        color: BukeerColors.getBackground(context,
                            secondary: true),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                        ),
                        child: Image.network(
                          '${getJsonField(
                                        columnGetClientItineraryResponse
                                            .jsonBody,
                                        r'''$[:].main_image''',
                                      ).toString()}' !=
                                      null &&
                                  '${getJsonField(
                                        columnGetClientItineraryResponse
                                            .jsonBody,
                                        r'''$[:].main_image''',
                                      ).toString()}' !=
                                      ''
                              ? getJsonField(
                                  columnGetClientItineraryResponse.jsonBody,
                                  r'''$[:].main_image''',
                                ).toString()
                              : 'https://images.unsplash.com/photo-1533699224246-6dc3b3ed3304?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxjb2xvbWJpYXxlbnwwfHx8fDE3Mzc0MjQxNzF8MA&ixlib=rb-4.0.3&q=80&w=1080',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if ('${getJsonField(
                          columnGetClientItineraryResponse.jsonBody,
                          r'''$[:].itinerary_visibility''',
                        ).toString()}' ==
                        '${true.toString()}')
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 852.0,
                        ),
                        decoration: BoxDecoration(),
                        child: FutureBuilder<List<ItineraryItemsRow>>(
                          future: ItineraryItemsTable().queryRows(
                            queryFn: (q) => q
                                .eqOrNull(
                                  'id_itinerary',
                                  widget!.id,
                                )
                                .order('date', ascending: true),
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
                                      BukeerColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<ItineraryItemsRow>
                                listViewItineraryItemsRowList = snapshot.data!;

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listViewItineraryItemsRowList.length,
                              itemBuilder: (context, listViewIndex) {
                                final listViewItineraryItemsRow =
                                    listViewItineraryItemsRowList[
                                        listViewIndex];
                                return Container(
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      if (listViewItineraryItemsRow
                                              .productType ==
                                          'Vuelos')
                                        FutureBuilder<List<AirlinesRow>>(
                                          future:
                                              AirlinesTable().querySingleRow(
                                            queryFn: (q) => q.eqOrNull(
                                              'id',
                                              listViewItineraryItemsRow.airline,
                                            ),
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
                                            List<AirlinesRow>
                                                componentItineraryPreviewFlightsAirlinesRowList =
                                                snapshot.data!;

                                            final componentItineraryPreviewFlightsAirlinesRow =
                                                componentItineraryPreviewFlightsAirlinesRowList
                                                        .isNotEmpty
                                                    ? componentItineraryPreviewFlightsAirlinesRowList
                                                        .first
                                                    : null;

                                            return ComponentItineraryPreviewFlightsWidget(
                                              key: Key(
                                                  'Keyppj_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                              destination:
                                                  listViewItineraryItemsRow
                                                      .flightArrival,
                                              origen: listViewItineraryItemsRow
                                                  .flightDeparture,
                                              flightNumber:
                                                  listViewItineraryItemsRow
                                                      .flightNumber,
                                              departureTime:
                                                  listViewItineraryItemsRow
                                                      .departureTime,
                                              arrivalTime:
                                                  listViewItineraryItemsRow
                                                      .arrivalTime,
                                              date: listViewItineraryItemsRow
                                                  .date,
                                              image: valueOrDefault<String>(
                                                componentItineraryPreviewFlightsAirlinesRow
                                                    ?.logoLockupUrl,
                                                'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/airline-default.png',
                                              ),
                                              personalizedMessage:
                                                  listViewItineraryItemsRow
                                                      .personalizedMessage,
                                            );
                                          },
                                        ),
                                      if (listViewItineraryItemsRow
                                              .productType ==
                                          'Hoteles')
                                        FutureBuilder<ApiCallResponse>(
                                          future:
                                              GetImagesAndMainImageCall.call(
                                            entityId: listViewItineraryItemsRow
                                                .idProduct,
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
                                            final componentItineraryPreviewHotelsGetImagesAndMainImageResponse =
                                                snapshot.data!;

                                            return ComponentItineraryPreviewHotelsWidget(
                                              key: Key(
                                                  'Keyf0h_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                              name: listViewItineraryItemsRow
                                                  .productName,
                                              rateName:
                                                  listViewItineraryItemsRow
                                                      .rateName,
                                              location: valueOrDefault<String>(
                                                listViewItineraryItemsRow
                                                    .destination,
                                                'Ubicación',
                                              ),
                                              idEntity:
                                                  listViewItineraryItemsRow
                                                      .idProduct,
                                              date: listViewItineraryItemsRow
                                                  .date,
                                              media:
                                                  componentItineraryPreviewHotelsGetImagesAndMainImageResponse
                                                      .jsonBody,
                                              passengers:
                                                  listViewItineraryItemsRow
                                                      .quantity,
                                              personalizedMessage:
                                                  listViewItineraryItemsRow
                                                      .personalizedMessage,
                                            );
                                          },
                                        ),
                                      if (listViewItineraryItemsRow
                                              .productType ==
                                          'Transporte')
                                        FutureBuilder<List<TransfersViewRow>>(
                                          future:
                                              TransfersViewTable().queryRows(
                                            queryFn: (q) => q.eqOrNull(
                                              'id',
                                              listViewItineraryItemsRow
                                                  .idProduct,
                                            ),
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
                                            List<TransfersViewRow>
                                                componentItineraryPreviewTransfersTransfersViewRowList =
                                                snapshot.data!;

                                            return ComponentItineraryPreviewTransfersWidget(
                                              key: Key(
                                                  'Keyum2_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                              name: listViewItineraryItemsRow
                                                  .rateName,
                                              departureTime:
                                                  listViewItineraryItemsRow
                                                      .departureTime,
                                              date: listViewItineraryItemsRow
                                                  .date,
                                              description:
                                                  componentItineraryPreviewTransfersTransfersViewRowList
                                                      .firstOrNull?.description,
                                              location:
                                                  componentItineraryPreviewTransfersTransfersViewRowList
                                                      .firstOrNull?.city,
                                              image:
                                                  componentItineraryPreviewTransfersTransfersViewRowList
                                                      .firstOrNull?.mainImage,
                                              passengers:
                                                  listViewItineraryItemsRow
                                                      .quantity,
                                              personalizedMessage:
                                                  listViewItineraryItemsRow
                                                      .personalizedMessage,
                                            );
                                          },
                                        ),
                                      if (listViewItineraryItemsRow
                                              .productType ==
                                          'Servicios')
                                        FutureBuilder<ApiCallResponse>(
                                          future:
                                              GetImagesAndMainImageCall.call(
                                            entityId: listViewItineraryItemsRow
                                                .idProduct,
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
                                            final componentItineraryPreviewActivitiesGetImagesAndMainImageResponse =
                                                snapshot.data!;

                                            return ComponentItineraryPreviewActivitiesWidget(
                                              key: Key(
                                                  'Keyhtj_${listViewIndex}_of_${listViewItineraryItemsRowList.length}'),
                                              name: listViewItineraryItemsRow
                                                  .productName,
                                              rateName:
                                                  listViewItineraryItemsRow
                                                      .rateName,
                                              location:
                                                  listViewItineraryItemsRow
                                                      .destination,
                                              idEntity:
                                                  listViewItineraryItemsRow
                                                      .idProduct,
                                              date: listViewItineraryItemsRow
                                                  .date,
                                              media:
                                                  componentItineraryPreviewActivitiesGetImagesAndMainImageResponse
                                                      .jsonBody,
                                              passengers:
                                                  listViewItineraryItemsRow
                                                      .quantity,
                                              personalizedMessage:
                                                  listViewItineraryItemsRow
                                                      .personalizedMessage,
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
                      ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      decoration: BoxDecoration(
                        color: BukeerColors.getBackground(context,
                            secondary: true),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: BukeerColors.overlay,
                            offset: Offset(
                              0.0,
                              -2.0,
                            ),
                          )
                        ],
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(BukeerSpacing.s),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                getJsonField(
                                  columnGetClientItineraryResponse.jsonBody,
                                  r'''$[:].account_name''',
                                )?.toString(),
                                'Empresa',
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: BukeerTypography.bodyMediumSize,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                            Text(
                              'Términos y condiciones  Política de cancelacion',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: BukeerColors.primary,
                                    fontSize: BukeerTypography.bodySmallSize,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
