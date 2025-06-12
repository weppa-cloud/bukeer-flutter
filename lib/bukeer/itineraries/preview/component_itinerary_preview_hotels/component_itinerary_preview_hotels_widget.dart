import 'package:bukeer/backend/supabase/supabase.dart';
import '../../../products/component_inclusion/component_inclusion_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_expanded_image_view.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:page_transition/page_transition.dart' as pt;
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'component_itinerary_preview_hotels_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/design_system/components/index.dart';
export 'component_itinerary_preview_hotels_model.dart';

class ComponentItineraryPreviewHotelsWidget extends StatefulWidget {
  const ComponentItineraryPreviewHotelsWidget({
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
  State<ComponentItineraryPreviewHotelsWidget> createState() =>
      _ComponentItineraryPreviewHotelsWidgetState();
}

class _ComponentItineraryPreviewHotelsWidgetState
    extends State<ComponentItineraryPreviewHotelsWidget> {
  late ComponentItineraryPreviewHotelsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentItineraryPreviewHotelsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: BukeerSpacing.xs),
      child: FutureBuilder<List<HotelsRow>>(
        future: HotelsTable().querySingleRow(
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
          List<HotelsRow> containerHotelsHotelsRowList = snapshot.data!;

          // Return an empty Container when the item does not exist.
          if (snapshot.data!.isEmpty) {
            return Container();
          }
          final containerHotelsHotelsRow =
              containerHotelsHotelsRowList.isNotEmpty
                  ? containerHotelsHotelsRowList.first
                  : null;

          return BukeerItineraryCard(
            icon: const FaIcon(FontAwesomeIcons.hotel),
            title: widget.name,
            subtitle: widget.rateName,
            accentColor: BukeerColors.warning,
            trailing: widget.date != null
                ? Text(
                    dateTimeFormat(
                      "yMMMd",
                      widget.date,
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                    style: BukeerTypography.labelMedium.copyWith(
                      color: BukeerColors.textSecondary,
                    ),
                  )
                : null,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel images carousel
                if (widget.media != null && widget.media!.isNotEmpty)
                  Container(
                    height: 180,
                    margin: EdgeInsets.only(bottom: BukeerSpacing.m),
                    child: ClipRRect(
                      borderRadius: BukeerBorders.radiusSmall,
                      child: CarouselSlider.builder(
                        itemCount: widget.media!.length,
                        itemBuilder: (context, itemIndex, realIndex) {
                          final mediaItem = widget.media![itemIndex];
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                pt.PageTransition(
                                  type: pt.PageTransitionType.fade,
                                  child: FlutterFlowExpandedImageView(
                                    image: Image.network(
                                      mediaItem.toString(),
                                      fit: BoxFit.contain,
                                    ),
                                    allowRotation: false,
                                    tag: mediaItem.toString(),
                                    useHeroAnimation: true,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: mediaItem.toString(),
                              transitionOnUserGestures: true,
                              child: ClipRRect(
                                borderRadius: BukeerBorders.radiusSmall,
                                child: Image.network(
                                  mediaItem.toString(),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: BukeerColors.surfaceSecondary,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: BukeerColors.textTertiary,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        carouselController: _model.carouselController ??=
                            CarouselSliderController(),
                        options: CarouselOptions(
                          initialPage: 0,
                          viewportFraction: 1.0,
                          disableCenter: true,
                          enlargeCenterPage: false,
                          enlargeFactor: 0.0,
                          enableInfiniteScroll: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          onPageChanged: (index, _) =>
                              _model.carouselCurrentIndex = index,
                        ),
                      ),
                    ),
                  ),

                // Hotel information
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: BukeerColors.textSecondary,
                              ),
                              SizedBox(width: BukeerSpacing.xs),
                              Expanded(
                                child: Text(
                                  widget.location,
                                  style: BukeerTypography.bodyMedium.copyWith(
                                    color: BukeerColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (widget.passengers != null &&
                              widget.passengers! > 0) ...[
                            SizedBox(height: BukeerSpacing.xs),
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 16,
                                  color: BukeerColors.textSecondary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  '${widget.passengers!.toStringAsFixed(0)} pasajeros',
                                  style: BukeerTypography.bodyMedium.copyWith(
                                    color: BukeerColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                // Action button
                // TODO: Uncomment when inclusionExclusion and programation fields are added to HotelsRow
                /*
                if ((containerHotelsHotelsRow?.inclusionExclusion != null &&
                        containerHotelsHotelsRow!
                            .inclusionExclusion!.isNotEmpty) ||
                    (containerHotelsHotelsRow?.programation != null &&
                        containerHotelsHotelsRow!
                            .programation!.isNotEmpty)) ...[
                  SizedBox(height: BukeerSpacing.m),
                  SizedBox(
                    width: double.infinity,
                    child: BukeerButton.outlined(
                      text: 'Ver inclusión',
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () => FocusScope.of(context).unfocus(),
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: ComponentInclusionWidget(
                                  name: widget.name,
                                  inclusions: containerHotelsHotelsRow!
                                          .inclusionExclusion ??
                                      '',
                                  program:
                                      containerHotelsHotelsRow.programation ??
                                          '',
                                ),
                              ),
                            );
                          },
                        );
                      },
                      size: BukeerButtonSize.small,
                    ),
                  ),
                ],
                */

                // Personalized message
                if (widget.personalizedMessage != null &&
                    widget.personalizedMessage!.isNotEmpty) ...[
                  SizedBox(height: BukeerSpacing.m),
                  Container(
                    width: double.infinity,
                    padding: BukeerSpacing.all12,
                    decoration: BoxDecoration(
                      color: BukeerColors.warning.withOpacity(0.1),
                      borderRadius: BukeerBorders.radiusSmall,
                      border: Border.all(
                        color: BukeerColors.warning.withOpacity(0.3),
                        width: BukeerBorders.widthThin,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: BukeerColors.warning,
                        ),
                        SizedBox(width: BukeerSpacing.s),
                        Expanded(
                          child: Text(
                            widget.personalizedMessage!,
                            style: BukeerTypography.bodySmall.copyWith(
                              color: BukeerColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
