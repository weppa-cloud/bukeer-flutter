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
  final bool showAsOriginalDesign;

  const ItineraryServicesSection({
    Key? key,
    required this.itineraryId,
    required this.itineraryItems,
    this.onAddFlight,
    this.onAddHotel,
    this.onAddActivity,
    this.onAddTransfer,
    this.showAsOriginalDesign = false,
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
    if (!widget.showAsOriginalDesign) {
      return _buildModernDesign();
    }

    // Original design with tabs and financial information
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
          child: Text(
            'SERVICIOS',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),

        // Tab Bar with original style
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: FlutterFlowTheme.of(context).primary,
            unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
            labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Readex Pro',
                  fontSize: 12,
                  letterSpacing: 0,
                ),
            unselectedLabelStyle:
                FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 12,
                      letterSpacing: 0,
                    ),
            indicatorColor: FlutterFlowTheme.of(context).primary,
            tabs: [
              Tab(
                text: 'Vuelos',
                icon: FaIcon(
                  FontAwesomeIcons.plane,
                  size: 20,
                ),
              ),
              Tab(
                text: 'Hoteles',
                icon: FaIcon(
                  FontAwesomeIcons.bed,
                  size: 20,
                ),
              ),
              Tab(
                text: 'Actividades',
                icon: FaIcon(
                  FontAwesomeIcons.mapMarkerAlt,
                  size: 20,
                ),
              ),
              Tab(
                text: 'Transfer',
                icon: FaIcon(
                  FontAwesomeIcons.car,
                  size: 20,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Totals summary
        _buildTotalsSummary(),

        SizedBox(height: 16),

        // Tab content with original card design
        Container(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildServiceTabOriginal('flight', widget.onAddFlight),
              _buildServiceTabOriginal('hotel', widget.onAddHotel),
              _buildServiceTabOriginal('activity', widget.onAddActivity),
              _buildServiceTabOriginal('transfer', widget.onAddTransfer),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernDesign() {
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

  Widget _buildTotalsSummary() {
    // Calculate totals for each service type
    double flightsTotal = 0;
    double hotelsTotal = 0;
    double activitiesTotal = 0;
    double transfersTotal = 0;

    for (var item in widget.itineraryItems) {
      final type = getJsonField(item, r'$.type')?.toString();
      final total = getJsonField(item, r'$.total_price')?.toDouble() ?? 0;

      switch (type) {
        case 'flight':
          flightsTotal += total;
          break;
        case 'hotel':
          hotelsTotal += total;
          break;
        case 'activity':
          activitiesTotal += total;
          break;
        case 'transfer':
          transfersTotal += total;
          break;
      }
    }

    final grandTotal =
        flightsTotal + hotelsTotal + activitiesTotal + transfersTotal;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen de Totales',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
              ),
              Text(
                '\$${grandTotal.toStringAsFixed(2)}',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTotalItem('Vuelos', flightsTotal, Colors.blue),
              _buildTotalItem('Hoteles', hotelsTotal, Colors.green),
              _buildTotalItem('Actividades', activitiesTotal, Colors.orange),
              _buildTotalItem('Traslados', transfersTotal, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 12,
                letterSpacing: 0,
              ),
        ),
        SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
        ),
      ],
    );
  }

  Widget _buildServiceTabOriginal(
      String serviceType, VoidCallback? onAddPressed) {
    final items = widget.itineraryItems
        .where(
            (item) => getJsonField(item, r'$.type')?.toString() == serviceType)
        .toList();

    return Column(
      children: [
        // Add button
        if (onAddPressed != null)
          Padding(
            padding: EdgeInsets.all(16),
            child: FFButtonWidget(
              onPressed: onAddPressed,
              text: 'Agregar ${_getServiceTypeName(serviceType)}',
              icon: Icon(Icons.add, size: 20),
              options: FFButtonOptions(
                width: double.infinity,
                height: 48,
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                elevation: 3,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

        // Service items list
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getServiceIcon(serviceType),
                        size: 64,
                        color: FlutterFlowTheme.of(context)
                            .secondaryText
                            .withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay ${_getServiceTypeName(serviceType).toLowerCase()}s agregados',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildServiceCard(items[index], serviceType);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(dynamic item, String serviceType) {
    // Get common fields
    final netRate = getJsonField(item, r'$.net_rate')?.toDouble() ?? 0;
    final markupPercent =
        getJsonField(item, r'$.markup_percent')?.toDouble() ?? 0;
    final totalPrice = getJsonField(item, r'$.total_price')?.toDouble() ?? 0;
    final quantity = getJsonField(item, r'$.quantity')?.toInt() ??
        getJsonField(item, r'$.passengers')?.toInt() ??
        getJsonField(item, r'$.total_passengers')?.toInt() ??
        1;

    // Get service-specific info
    String title = '';
    String subtitle = '';
    String location = '';
    String date = '';
    String? imageUrl;

    switch (serviceType) {
      case 'flight':
        final flightInfo = getJsonField(item, r'$.flights');
        title =
            '${getJsonField(flightInfo, r'$.origin')} - ${getJsonField(flightInfo, r'$.destination')}';
        subtitle =
            getJsonField(flightInfo, r'$.flight_number')?.toString() ?? '';
        date = getJsonField(item, r'$.departure_date')?.toString() ?? '';
        imageUrl = getJsonField(flightInfo, r'$.airline_logo')?.toString();
        break;
      case 'hotel':
        final hotelInfo = getJsonField(item, r'$.hotels');
        title = getJsonField(hotelInfo, r'$.name')?.toString() ?? 'Hotel';
        subtitle = getJsonField(item, r'$.room_type')?.toString() ?? '';
        location = getJsonField(hotelInfo, r'$.address')?.toString() ?? '';
        date = getJsonField(item, r'$.check_in')?.toString() ?? '';
        final images = getJsonField(hotelInfo, r'$.images') as List<dynamic>?;
        imageUrl = images?.isNotEmpty == true ? images!.first.toString() : null;
        break;
      case 'activity':
        final activityInfo = getJsonField(item, r'$.activities');
        title =
            getJsonField(activityInfo, r'$.name')?.toString() ?? 'Actividad';
        subtitle = getJsonField(item, r'$.rate_name')?.toString() ?? '';
        location = getJsonField(activityInfo, r'$.location')?.toString() ?? '';
        date = getJsonField(item, r'$.date')?.toString() ?? '';
        final images =
            getJsonField(activityInfo, r'$.images') as List<dynamic>?;
        imageUrl = images?.isNotEmpty == true ? images!.first.toString() : null;
        break;
      case 'transfer':
        final transferInfo = getJsonField(item, r'$.transfers');
        title = getJsonField(transferInfo, r'$.name')?.toString() ?? 'Traslado';
        subtitle = getJsonField(item, r'$.pickup_location')?.toString() ?? '';
        date = getJsonField(item, r'$.date')?.toString() ?? '';
        imageUrl = getJsonField(transferInfo, r'$.image')?.toString();
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
          // Service info row
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              _getServiceIcon(serviceType),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 30,
                            ),
                          ),
                        )
                      : Icon(
                          _getServiceIcon(serviceType),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 30,
                        ),
                ),
                SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                            ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14,
                                letterSpacing: 0,
                              ),
                        ),
                      ],
                      if (location.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 12,
                                      letterSpacing: 0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (date.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _formatDate(date),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Actions
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // TODO: Edit action
                      },
                      child: Icon(
                        Icons.edit,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        // TODO: Delete action
                      },
                      child: Icon(
                        Icons.delete,
                        color: FlutterFlowTheme.of(context).error,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Financial info
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarifa Neta',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                    ),
                    Text(
                      '\$${netRate.toStringAsFixed(2)}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Margen',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                    ),
                    Text(
                      '${markupPercent.toStringAsFixed(0)}%',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).success,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Cantidad',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                    ),
                    Text(
                      quantity.toString(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'flight':
        return Icons.flight;
      case 'hotel':
        return Icons.hotel;
      case 'activity':
        return Icons.local_activity;
      case 'transfer':
        return Icons.directions_car;
      default:
        return Icons.room_service;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
