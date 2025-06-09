import 'package:flutter/material.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import '../../preview/component_itinerary_preview_flights/component_itinerary_preview_flights_widget.dart';
import '../../preview/component_itinerary_preview_hotels/component_itinerary_preview_hotels_widget.dart';
import '../../preview/component_itinerary_preview_activities/component_itinerary_preview_activities_widget.dart';
import '../../preview/component_itinerary_preview_transfers/component_itinerary_preview_transfers_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bukeer/design_system/tokens/index.dart';

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

  Widget _buildFlightsList() {
    // Filter flight items from itinerary items
    final flightItems = widget.itineraryItems
        .where((item) => getJsonField(item, r'$.type') == 'flight')
        .toList();

    if (flightItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flight_takeoff,
              size: 64,
              color:
                  FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'No hay vuelos agregados',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: flightItems.length,
      itemBuilder: (context, index) {
        final flightData = flightItems[index];
        final flightInfo = getJsonField(flightData, r'$.flights');

        if (flightInfo == null) {
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ComponentItineraryPreviewFlightsWidget(
            origen: getJsonField(flightInfo, r'$.origin')?.toString(),
            destination: getJsonField(flightInfo, r'$.destination')?.toString(),
            departureTime:
                getJsonField(flightInfo, r'$.departure_time')?.toString(),
            arrivalTime:
                getJsonField(flightInfo, r'$.arrival_time')?.toString(),
            date: DateTime.tryParse(
              getJsonField(flightInfo, r'$.departure_date')?.toString() ?? '',
            ),
            flightNumber:
                getJsonField(flightInfo, r'$.flight_number')?.toString(),
            image: getJsonField(flightInfo, r'$.airline_logo')?.toString(),
            personalizedMessage:
                getJsonField(flightData, r'$.personalized_message')?.toString(),
          ),
        );
      },
    );
  }

  Widget _buildHotelsList() {
    final hotelItems = widget.itineraryItems
        .where((item) => getJsonField(item, r'$.type') == 'hotel')
        .toList();

    if (hotelItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hotel,
              size: 64,
              color:
                  FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'No hay hoteles agregados',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: hotelItems.length,
      itemBuilder: (context, index) {
        final hotelData = hotelItems[index];
        final hotelInfo = getJsonField(hotelData, r'$.hotels');

        if (hotelInfo == null) {
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ComponentItineraryPreviewHotelsWidget(
            name: getJsonField(hotelInfo, r'$.name')?.toString(),
            rateName: getJsonField(hotelData, r'$.room_type')?.toString(),
            date: DateTime.tryParse(
              getJsonField(hotelData, r'$.check_in')?.toString() ?? '',
            ),
            location: getJsonField(hotelInfo, r'$.address')?.toString(),
            idEntity: getJsonField(hotelInfo, r'$.id')?.toString(),
            media: getJsonField(hotelInfo, r'$.images') as List<dynamic>?,
            passengers:
                getJsonField(hotelData, r'$.total_passengers')?.toDouble(),
            personalizedMessage:
                getJsonField(hotelData, r'$.personalized_message')?.toString(),
          ),
        );
      },
    );
  }

  Widget _buildActivitiesList() {
    final activityItems = widget.itineraryItems
        .where((item) => getJsonField(item, r'$.type') == 'activity')
        .toList();

    if (activityItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_activity,
              size: 64,
              color:
                  FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'No hay actividades agregadas',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: activityItems.length,
      itemBuilder: (context, index) {
        final activityData = activityItems[index];
        final activityInfo = getJsonField(activityData, r'$.activities');

        if (activityInfo == null) {
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ComponentItineraryPreviewActivitiesWidget(
            name: getJsonField(activityInfo, r'$.name')?.toString(),
            rateName: getJsonField(activityData, r'$.rate_name')?.toString(),
            location: getJsonField(activityInfo, r'$.location')?.toString(),
            date: DateTime.tryParse(
              getJsonField(activityData, r'$.date')?.toString() ?? '',
            ),
            idEntity: getJsonField(activityInfo, r'$.id')?.toString(),
            media: getJsonField(activityInfo, r'$.images') as List<dynamic>?,
            passengers: getJsonField(activityData, r'$.passengers')?.toDouble(),
            personalizedMessage:
                getJsonField(activityData, r'$.personalized_message')
                    ?.toString(),
          ),
        );
      },
    );
  }

  Widget _buildTransfersList() {
    final transferItems = widget.itineraryItems
        .where((item) => getJsonField(item, r'$.type') == 'transfer')
        .toList();

    if (transferItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              size: 64,
              color:
                  FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'No hay traslados agregados',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: transferItems.length,
      itemBuilder: (context, index) {
        final transferData = transferItems[index];
        final transferInfo = getJsonField(transferData, r'$.transfers');

        if (transferInfo == null) {
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ComponentItineraryPreviewTransfersWidget(
            name: getJsonField(transferInfo, r'$.name')?.toString(),
            departureTime: getJsonField(transferData, r'$.time')?.toString(),
            description:
                getJsonField(transferInfo, r'$.description')?.toString(),
            location:
                getJsonField(transferData, r'$.pickup_location')?.toString(),
            date: DateTime.tryParse(
              getJsonField(transferData, r'$.date')?.toString() ?? '',
            ),
            image: getJsonField(transferInfo, r'$.image')?.toString(),
            passengers: getJsonField(transferData, r'$.passengers')?.toDouble(),
            personalizedMessage:
                getJsonField(transferData, r'$.personalized_message')
                    ?.toString(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 600),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(BukeerSpacing.sm),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x1A000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.all(BukeerSpacing.l),
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
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Flights Tab
                _buildServiceTab(
                  serviceType: 'flight',
                  onAddPressed: widget.onAddFlight,
                  child: _buildFlightsList(),
                ),

                // Hotels Tab
                _buildServiceTab(
                  serviceType: 'hotel',
                  onAddPressed: widget.onAddHotel,
                  child: _buildHotelsList(),
                ),

                // Activities Tab
                _buildServiceTab(
                  serviceType: 'activity',
                  onAddPressed: widget.onAddActivity,
                  child: _buildActivitiesList(),
                ),

                // Transfers Tab
                _buildServiceTab(
                  serviceType: 'transfer',
                  onAddPressed: widget.onAddTransfer,
                  child: _buildTransfersList(),
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
      mainAxisSize: MainAxisSize.max,
      children: [
        // Add Service Button
        if (onAddPressed != null)
          Padding(
            padding: EdgeInsets.all(BukeerSpacing.m),
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
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  ),
                ),
              ],
            ),
          ),

        // Service Content
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: BukeerSpacing.m),
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
        SizedBox(width: BukeerSpacing.s),
        _buildStatChip('Hoteles', hotels, Colors.green),
        SizedBox(width: BukeerSpacing.s),
        _buildStatChip('Actividades', activities, Colors.orange),
        SizedBox(width: BukeerSpacing.s),
        _buildStatChip('Traslados', transfers, Colors.purple),
      ],
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(BukeerSpacing.sm),
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
