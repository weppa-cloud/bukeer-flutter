import 'package:bukeer/backend/supabase/supabase.dart';
import '../../../products/component_inclusion/component_inclusion_widget.dart';
import '../../../../components/itinerary_activity_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_expanded_image_view.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart'
    hide PageTransitionType;
import 'package:page_transition/page_transition.dart' as pt;
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'component_itinerary_preview_activities_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'component_itinerary_preview_activities_model.dart';

class ComponentItineraryPreviewActivitiesWidget extends StatefulWidget {
  const ComponentItineraryPreviewActivitiesWidget({
    super.key,
    String? name,
    String? rateName,
    this.date,
    String? location,
    this.idEntity,
    this.media,
    this.passengers,
    this.personalizedMessage,
  })  : name = name ?? 'Sin nombre',
        rateName = rateName ?? 'Sin nombre',
        location = location ?? 'Sin destino';

  final String name;
  final String rateName;
  final DateTime? date;
  final String location;
  final String? idEntity;
  final List<dynamic>? media;
  final double? passengers;
  final String? personalizedMessage;

  @override
  State<ComponentItineraryPreviewActivitiesWidget> createState() =>
      _ComponentItineraryPreviewActivitiesWidgetState();
}

class _ComponentItineraryPreviewActivitiesWidgetState
    extends State<ComponentItineraryPreviewActivitiesWidget> {
  late ComponentItineraryPreviewActivitiesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => ComponentItineraryPreviewActivitiesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.idEntity != '615a5eda-7560-4506-abf1-67a362dbafba',
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
        child: FutureBuilder<List<ActivitiesRow>>(
          future: ActivitiesTable().querySingleRow(
            queryFn: (q) => q.eqOrNull(
              'id',
              widget.idEntity,
            ),
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
            List<ActivitiesRow> containerActivitiesActivitiesRowList =
                snapshot.data!;

            // Return an empty Container when the item does not exist.
            if (snapshot.data!.isEmpty) {
              return Container();
            }
            final containerActivitiesActivitiesRow =
                containerActivitiesActivitiesRowList.isNotEmpty
                    ? containerActivitiesActivitiesRowList.first
                    : null;

            return Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              decoration: BoxDecoration(
                color: BukeerColors.getBackground(context, secondary: true),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                      indent: 0.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: BukeerColors.primaryAccent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: BukeerColors.primary,
                              width: 2.0,
                            ),
                          ),
                          child: Icon(
                            Icons.volunteer_activism_sharp,
                            color: BukeerColors.secondaryText,
                            size: 20.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Text(
                              valueOrDefault<String>(
                                widget.name,
                                'Sin nombre',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: BukeerTypography.bodyMediumSize,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            dateTimeFormat(
                              "yMMMd",
                              widget.date,
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                            'Fecha',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelSmallFamily,
                                color: BukeerColors.primaryText,
                                fontSize: BukeerTypography.bodySmallSize,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelSmallIsCustom,
                              ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: BukeerSpacing.m),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: BukeerColors.getBackground(context,
                              secondary: true),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0.0,
                              color: BukeerColors.primary,
                              offset: Offset(
                                -2.0,
                                0.0,
                              ),
                            )
                          ],
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 450.0,
                                        ),
                                        decoration: BoxDecoration(),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.media != null &&
                                          widget.media!.isNotEmpty)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: Builder(
                                                builder: (context) {
                                                  final itemMediaProduct =
                                                      widget.media!
                                                          .map((e) =>
                                                              getJsonField(
                                                                e,
                                                                r'''$.image_url''',
                                                              ))
                                                          .toList();

                                                  return SizedBox(
                                                    width: double.infinity,
                                                    height: 200.0,
                                                    child:
                                                        CarouselSlider.builder(
                                                      itemCount:
                                                          itemMediaProduct
                                                              .length,
                                                      itemBuilder: (context,
                                                          itemMediaProductIndex,
                                                          _) {
                                                        final itemMediaProductItem =
                                                            itemMediaProduct[
                                                                itemMediaProductIndex];
                                                        return InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            await Navigator
                                                                .push(
                                                              context,
                                                              PageTransition(
                                                                type: pt
                                                                    .PageTransitionType
                                                                    .fade,
                                                                child:
                                                                    FlutterFlowExpandedImageView(
                                                                  image: Image
                                                                      .network(
                                                                    itemMediaProductItem
                                                                        .toString(),
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                  allowRotation:
                                                                      false,
                                                                  tag: itemMediaProductItem
                                                                      .toString(),
                                                                  useHeroAnimation:
                                                                      true,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Hero(
                                                            tag:
                                                                itemMediaProductItem
                                                                    .toString(),
                                                            transitionOnUserGestures:
                                                                true,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                (itemMediaProductItem?.toString() ??
                                                                                '') !=
                                                                            '' &&
                                                                        itemMediaProductItem !=
                                                                            null
                                                                    ? itemMediaProductItem
                                                                        .toString()
                                                                    : 'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/activity-default.png',
                                                                width: 200.0,
                                                                height: 200.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Container(
                                                                    width:
                                                                        200.0,
                                                                    height:
                                                                        200.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                    child: Icon(
                                                                        Icons
                                                                            .local_activity,
                                                                        size:
                                                                            48,
                                                                        color: Colors
                                                                            .grey),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      carouselController: _model
                                                              .carouselController ??=
                                                          CarouselSliderController(),
                                                      options: CarouselOptions(
                                                        initialPage: max(
                                                            0,
                                                            min(
                                                                0,
                                                                itemMediaProduct
                                                                        .length -
                                                                    1)),
                                                        viewportFraction: 0.5,
                                                        disableCenter: true,
                                                        enlargeCenterPage: true,
                                                        enlargeFactor: 0.25,
                                                        enableInfiniteScroll:
                                                            true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        autoPlay: true,
                                                        autoPlayAnimationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    2000),
                                                        autoPlayInterval:
                                                            Duration(
                                                                milliseconds:
                                                                    (2000 +
                                                                        4000)),
                                                        autoPlayCurve:
                                                            Curves.linear,
                                                        pauseAutoPlayInFiniteScroll:
                                                            true,
                                                        onPageChanged: (index,
                                                                _) =>
                                                            _model.carouselCurrentIndex =
                                                                index,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4.0, 8.0, 4.0, 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              valueOrDefault<String>(
                                                widget.rateName,
                                                'Sin nombre',
                                              ),
                                              textAlign: TextAlign.start,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineMedium
                                                  .override(
                                                    fontFamily: FlutterFlowTheme
                                                            .of(context)
                                                        .headlineMediumFamily,
                                                    fontSize: 15.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMediumIsCustom,
                                                  ),
                                            ),
                                            Wrap(
                                              spacing: 1.0,
                                              runSpacing: 0.0,
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              runAlignment: WrapAlignment.start,
                                              verticalDirection:
                                                  VerticalDirection.down,
                                              clipBehavior: Clip.antiAlias,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  4.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.location_pin,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: Text(
                                                        valueOrDefault<String>(
                                                          widget.location,
                                                          'Ubicación',
                                                        ),
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
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
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
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  4.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.people,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      valueOrDefault<String>(
                                                        widget.passengers
                                                            ?.toString(),
                                                        '1',
                                                      ),
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
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 8.0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  containerActivitiesActivitiesRow
                                                      ?.description,
                                                  'Sin descripción',
                                                ),
                                                maxLines: 3,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      fontSize: BukeerTypography
                                                          .bodySmallSize,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                            ),
                                            if (widget.personalizedMessage !=
                                                    null &&
                                                widget.personalizedMessage !=
                                                    '')
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 16.0,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        widget
                                                            .personalizedMessage,
                                                        'Sin mensaje',
                                                      ),
                                                      maxLines: 3,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize:
                                                                BukeerTypography
                                                                    .bodySmallSize,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(
                                                    width: BukeerSpacing.xs)),
                                              ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, 0.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            ComponentInclusionWidget(
                                                          inclutions:
                                                              containerActivitiesActivitiesRow
                                                                  ?.inclutions,
                                                          exclutions:
                                                              containerActivitiesActivitiesRow
                                                                  ?.exclutions,
                                                          recomendations:
                                                              containerActivitiesActivitiesRow
                                                                  ?.recomendations,
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Ver inclusión',
                                                options: FFButtonOptions(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent1,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                  elevation: 0.0,
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          BukeerSpacing.sm),
                                                  hoverColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  hoverBorderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 2.0,
                                                  ),
                                                  hoverTextColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .info,
                                                  hoverElevation: 3.0,
                                                ),
                                              ),
                                            ),
                                            if (containerActivitiesActivitiesRow
                                                        ?.scheduleData !=
                                                    null &&
                                                containerActivitiesActivitiesRow
                                                    .scheduleData!.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 15.0, 0.0, 15.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.stream,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 22.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Programa',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize:
                                                                BukeerTypography
                                                                    .bodyMediumSize,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Builder(
                                              builder: (context) {
                                                final itemItineraryActivity =
                                                    containerActivitiesActivitiesRow
                                                            ?.scheduleData
                                                            ?.toList() ??
                                                        [];

                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      itemItineraryActivity
                                                          .length,
                                                  itemBuilder: (context,
                                                      itemItineraryActivityIndex) {
                                                    final itemItineraryActivityItem =
                                                        itemItineraryActivity[
                                                            itemItineraryActivityIndex];
                                                    return ItineraryActivityWidget(
                                                      key: Key(
                                                          'Key2au_${itemItineraryActivityIndex}_of_${itemItineraryActivity.length}'),
                                                      title: getJsonField(
                                                        itemItineraryActivityItem,
                                                        r'''$.title''',
                                                      ).toString(),
                                                      description: getJsonField(
                                                        itemItineraryActivityItem,
                                                        r'''$.description''',
                                                      ).toString(),
                                                      image: getJsonField(
                                                        itemItineraryActivityItem,
                                                        r'''$.image''',
                                                      ).toString(),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ].divide(SizedBox(
                                              height: BukeerSpacing.xs)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ].addToEnd(SizedBox(height: BukeerSpacing.s)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
