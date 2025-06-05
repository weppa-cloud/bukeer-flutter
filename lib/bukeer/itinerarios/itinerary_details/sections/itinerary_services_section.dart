import 'package:flutter/material.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../preview/component_itinerary_preview_flights/component_itinerary_preview_flights_widget.dart';
import '../../preview/component_itinerary_preview_hotels/component_itinerary_preview_hotels_widget.dart';
import '../../preview/component_itinerary_preview_activities/component_itinerary_preview_activities_widget.dart';
import '../../preview/component_itinerary_preview_transfers/component_itinerary_preview_transfers_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Services section for itinerary details
/// Contains flights, hotels, activities, and transfers in organized tabs
class ItineraryServicesSection extends StatefulWidget {
  final String itineraryId;
  final List<dynamic> itineraryItems;
  final VoidCallback? onAddFlight;
  final VoidCallback? onAddHotel;
  final VoidCallback? onAddActivity;
  final VoidCallback? onAddTransfer;

  const ItineraryServicesSection({
    Key? key,
    required this.itineraryId,
    required this.itineraryItems,
    this.onAddFlight,
    this.onAddHotel,
    this.onAddActivity,
    this.onAddTransfer,
  }) : super(key: key);

  @override
  State<ItineraryServicesSection> createState() =>
      _ItineraryServicesSectionState();
}

class _ItineraryServicesSectionState extends State<ItineraryServicesSection>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x1A000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Servicios del Itinerario',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                _buildServicesStats(),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Readex Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
              unselectedLabelStyle:
                  FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 14,
                      ),
              indicatorColor: FlutterFlowTheme.of(context).primary,
              indicatorWeight: 3,
              labelColor: FlutterFlowTheme.of(context).primary,
              unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
              tabs: [
                Tab(
                  icon: FaIcon(FontAwesomeIcons.plane, size: 18),
                  text: 'Vuelos',
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.bed, size: 18),
                  text: 'Hoteles',
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.mapMarkerAlt, size: 18),
                  text: 'Actividades',
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.car, size: 18),
                  text: 'Traslados',
                ),
              ],
            ),
          ),

          // Tab Content
          Container(
            height: 500, // Fixed height for consistent layout
            child: TabBarView(
              controller: _tabController,
              children: [
                // Flights Tab
                _buildServiceTab(
                  serviceType: 'flight',
                  onAddPressed: widget.onAddFlight,
                  child: ComponentItineraryPreviewFlightsWidget(),
                ),

                // Hotels Tab
                _buildServiceTab(
                  serviceType: 'hotel',
                  onAddPressed: widget.onAddHotel,
                  child: ComponentItineraryPreviewHotelsWidget(),
                ),

                // Activities Tab
                _buildServiceTab(
                  serviceType: 'activity',
                  onAddPressed: widget.onAddActivity,
                  child: ComponentItineraryPreviewActivitiesWidget(),
                ),

                // Transfers Tab
                _buildServiceTab(
                  serviceType: 'transfer',
                  onAddPressed: widget.onAddTransfer,
                  child: ComponentItineraryPreviewTransfersWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTab({
    required String serviceType,
    required Widget child,
    VoidCallback? onAddPressed,
  }) {
    return Column(
      children: [
        // Add Service Button
        if (onAddPressed != null)
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FFButtonWidget(
                  onPressed: onAddPressed,
                  text: 'Agregar ${_getServiceTypeName(serviceType)}',
                  icon: Icon(
                    Icons.add,
                    size: 18,
                  ),
                  options: FFButtonOptions(
                    height: 36,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                    elevation: 2,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),

        // Service Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildServicesStats() {
    final flights = widget.itineraryItems
        .where((item) => getJsonField(item, r'$.type')?.toString() == 'flight')
        .length;
    final hotels = widget.itineraryItems
        .where((item) => getJsonField(item, r'$.type')?.toString() == 'hotel')
        .length;
    final activities = widget.itineraryItems
        .where(
            (item) => getJsonField(item, r'$.type')?.toString() == 'activity')
        .length;
    final transfers = widget.itineraryItems
        .where(
            (item) => getJsonField(item, r'$.type')?.toString() == 'transfer')
        .length;

    return Row(
      children: [
        _buildStatChip('Vuelos', flights, Colors.blue),
        SizedBox(width: 8),
        _buildStatChip('Hoteles', hotels, Colors.green),
        SizedBox(width: 8),
        _buildStatChip('Actividades', activities, Colors.orange),
        SizedBox(width: 8),
        _buildStatChip('Traslados', transfers, Colors.purple),
      ],
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            '$count',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Readex Pro',
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _getServiceTypeName(String serviceType) {
    switch (serviceType) {
      case 'flight':
        return 'Vuelo';
      case 'hotel':
        return 'Hotel';
      case 'activity':
        return 'Actividad';
      case 'transfer':
        return 'Traslado';
      default:
        return 'Servicio';
    }
  }
}
