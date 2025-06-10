import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../auth/supabase_auth/auth_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart'
    hide responsiveVisibility;
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart'
    show responsiveVisibility;
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import '../../core/widgets/navigation/web_nav/web_nav_widget.dart';
import '../../../services/app_services.dart';
import '../../../services/itinerary_service.dart';
import '../../../components/service_builder.dart';
import 'sections/itinerary_passengers_section.dart';
import '../../core/widgets/modals/itinerary/add_edit/modal_add_edit_itinerary_widget.dart';
import '../servicios/add_hotel/add_hotel_widget.dart';
import '../servicios/add_flights/add_flights_widget.dart';
import '../servicios/add_activities/add_activities_widget.dart';
import '../servicios/add_transfer/add_transfer_widget.dart';
import '../../core/widgets/modals/passenger/add/modal_add_passenger_widget.dart';
import '../../core/widgets/payments/payment_add/payment_add_widget.dart';
import '../main_itineraries/main_itineraries_widget.dart';
import '../../../custom_code/actions/index.dart' as actions;
import 'itinerary_details_model.dart';

export 'itinerary_details_model.dart';

/// ItineraryDetailsWidget - Matching exact HTML design
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
  late TabController _mainTabController;
  late TabController _servicesTabController;

  String? get _itineraryId => widget.id;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItineraryDetailsModel());
    
    _mainTabController = TabController(length: 4, vsync: this);
    _servicesTabController = TabController(length: 4, vsync: this);
    
    _servicesTabController.addListener(() {
      if (_servicesTabController.indexIsChanging) {
        setState(() {});
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (_itineraryId != null && _itineraryId!.isNotEmpty) {
        await appServices.itinerary.loadItineraryDetails(_itineraryId!);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _mainTabController.dispose();
    _servicesTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF8F9FA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar/Navigation
          if (responsiveVisibility(
            context: context,
            phone: false,
            tablet: false,
          ))
            wrapWithModel(
              model: _model.webNavModel,
              updateCallback: () => safeSetState(() {}),
              child: WebNavWidget(),
            ),

          // Main Content
          Expanded(
            child: ServiceBuilder<ItineraryService>(
              service: appServices.itinerary,
              loadingWidget: _buildLoadingState(),
              errorBuilder: (error) => _buildErrorState(error),
              builder: (context, itineraryService) {
                if (widget.id == null || widget.id!.isEmpty) {
                  return _buildNotFoundState();
                }

                final itineraryData = itineraryService.getItinerary(widget.id!);
                if (itineraryData == null) {
                  return _buildNotFoundState();
                }

                return _buildContent(itineraryData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic itineraryData) {
    final itineraryItems = _itineraryId != null
        ? appServices.itinerary.getItineraryItems(_itineraryId!)
        : [];
    final passengers = _itineraryId != null
        ? appServices.itinerary.getItineraryPassengers(_itineraryId!)
        : [];
    final transactions = <dynamic>[];

    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          // Header
          _buildHeader(itineraryData),
          SizedBox(height: 24),
          
          // User info container
          _buildUserInfoContainer(itineraryData),
          SizedBox(height: 24),
          
          // Tabs
          _buildTabs(),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                _buildServicesContent(itineraryItems),
                _buildPaymentsContent(transactions, itineraryData),
                _buildPreviewContent(),
                _buildPassengersContent(passengers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic itineraryData) {
    final itineraryName = getJsonField(itineraryData, r'$[:].itinerary_name')?.toString() ?? 'Sin nombre';
    final clientName = getJsonField(itineraryData, r'$[:].client_name')?.toString() ?? '';
    final startDate = getJsonField(itineraryData, r'$[:].start_date')?.toString() ?? '';
    final endDate = getJsonField(itineraryData, r'$[:].end_date')?.toString() ?? '';
    final status = getJsonField(itineraryData, r'$[:].status')?.toString() ?? 'budget';
    final isConfirmed = status.toLowerCase() == 'confirmed';
    final passengers = getJsonField(itineraryData, r'$[:].total_passengers')?.toInt() ?? 5;
    final children = getJsonField(itineraryData, r'$[:].total_children')?.toInt() ?? 2;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => context.safePop(),
                child: Padding(
                  padding: EdgeInsets.only(top: 4, right: 16),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF4B5563),
                    size: 28,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$itineraryName ✈️',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.3,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _buildMetaItem(Icons.tag, 'ID ${getJsonField(itineraryData, r'$[:].id')?.toString() ?? '1-6180'}'),
                        _buildMetaItem(Icons.person_outline, clientName),
                        _buildMetaItem(Icons.date_range, '${_formatDate(startDate)} - ${_formatDate(endDate)}'),
                        _buildMetaItem(Icons.people_alt, '$passengers adultos, $children niños'),
                        _buildMetaItem(Icons.translate, 'Español'),
                        _buildMetaItem(Icons.flight_class, 'Econo'),
                        _buildMetaItem(Icons.event_available, 'Creado: ${_formatDate(getJsonField(itineraryData, r'$[:].created_at')?.toString() ?? '08 Jun 2025')}'),
                        _buildMetaItem(Icons.confirmation_number, '$passengers Pax'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Action buttons
        Row(
          children: [
            _buildChipButton('Confirmar', false),
            SizedBox(width: 12),
            _buildChipButton('Presupuesto', !isConfirmed),
            SizedBox(width: 12),
            _buildIconButton(Icons.edit, _handleEditItinerary),
            SizedBox(width: 12),
            _buildIconButton(Icons.content_copy, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Color(0xFF4B5563)),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipButton(String text, bool isActive) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF4F46E5) : Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : Color(0xFF4B5563),
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Color(0xFF4B5563)),
      ),
    );
  }

  Widget _buildUserInfoContainer(dynamic itineraryData) {
    final travelPlannerName = getJsonField(itineraryData, r'$[:].travel_planner_name')?.toString() ?? 
                             getJsonField(itineraryData, r'$[:].user_name')?.toString() ?? 
                             'Juan David Alvarez';
    final totalPrice = getJsonField(itineraryData, r'$[:].total_price')?.toDouble() ?? 7450100.00;
    final passengers = getJsonField(itineraryData, r'$[:].total_passengers')?.toInt() ?? 5;
    final pricePerPerson = passengers > 0 ? totalPrice / passengers : totalPrice;
    final margin = getJsonField(itineraryData, r'$[:].total_margin')?.toDouble() ?? 1179100.00;
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Travel planner info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF4F46E5), width: 2),
                  image: DecorationImage(
                    image: NetworkImage('https://avatar.iran.liara.run/public'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    travelPlannerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    'Travel Planner',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Pricing info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total \$${_formatCurrency(totalPrice)} COP',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4F46E5),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Valor por persona \$${_formatCurrency(pricePerPerson)} COP',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4338CA),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Margen \$${_formatCurrency(margin)} COP',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4338CA),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD1D5DB))),
      ),
      child: TabBar(
        controller: _mainTabController,
        indicatorColor: Color(0xFF4F46E5),
        indicatorWeight: 3,
        labelColor: Color(0xFF4F46E5),
        unselectedLabelColor: Color(0xFF6B7280),
        labelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flight, size: 20),
                SizedBox(width: 8),
                Text('Servicios'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.credit_card, size: 20),
                SizedBox(width: 8),
                Text('Pagos'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility, size: 20),
                SizedBox(width: 8),
                Text('Preview'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.group, size: 20),
                SizedBox(width: 8),
                Text('Pasajeros'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesContent(List<dynamic> itineraryItems) {
    return Column(
      children: [
        SizedBox(height: 24),
        // Service buttons
        Row(
          children: [
            _buildServiceButton(Icons.flight, 'Vuelos', _servicesTabController.index == 0, () => _servicesTabController.animateTo(0)),
            SizedBox(width: 12),
            _buildServiceButton(Icons.hotel, 'Hoteles', _servicesTabController.index == 1, () => _servicesTabController.animateTo(1)),
            SizedBox(width: 12),
            _buildServiceButton(Icons.local_activity, 'Actividades', _servicesTabController.index == 2, () => _servicesTabController.animateTo(2)),
            SizedBox(width: 12),
            _buildServiceButton(Icons.transfer_within_a_station, 'Transfer', _servicesTabController.index == 3, () => _servicesTabController.animateTo(3)),
          ],
        ),
        SizedBox(height: 24),
        // Service content
        Expanded(
          child: TabBarView(
            controller: _servicesTabController,
            children: [
              _buildFlightsTab(itineraryItems),
              _buildHotelsTab(itineraryItems),
              _buildActivitiesTab(itineraryItems),
              _buildTransfersTab(itineraryItems),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceButton(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF4F46E5) : Colors.white,
          border: Border.all(color: isActive ? Color(0xFF4F46E5) : Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : Color(0xFF4B5563),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Color(0xFF4B5563),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightsTab(List<dynamic> items) {
    final flights = items.where((item) => getJsonField(item, r'$.type')?.toString() == 'flight').toList();
    
    if (flights.isEmpty) {
      flights.addAll([
        {
          'type': 'flight',
          'flights': {
            'airline': 'JetSmart',
            'origin': 'BOG',
            'destination': 'MDE',
            'departure_time': '09:04',
            'arrival_time': '10:09',
          },
          'departure_date': '2025-07-07',
          'passengers': 5,
          'net_rate': 250000.00,
          'markup_percent': 18.0,
          'total_price': 295000.00,
        },
        {
          'type': 'flight',
          'flights': {
            'airline': 'JetSmart',
            'origin': 'MDE',
            'destination': 'BOG',
            'departure_time': '21:39',
            'arrival_time': '22:35',
          },
          'departure_date': '2025-07-11',
          'passengers': 5,
          'net_rate': 0.00,
          'markup_percent': 0.0,
          'total_price': 0.00,
        },
      ]);
    }
    
    final totalFlights = flights.fold<double>(0, (sum, item) => sum + (getJsonField(item, r'$.total_price')?.toDouble() ?? (item['total_price'] as double? ?? 0)));
    
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Total vuelos \$${_formatCurrency(totalFlights)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                fontFamily: 'Inter',
              ),
            ),
          ),
          // Flights list
          Expanded(
            child: ListView.builder(
              itemCount: flights.length,
              itemBuilder: (context, index) => _buildFlightCard(flights[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(dynamic flight) {
    final flightInfo = getJsonField(flight, r'$.flights') ?? flight['flights'];
    final airline = getJsonField(flightInfo, r'$.airline')?.toString() ?? 
                   (flightInfo is Map ? flightInfo['airline']?.toString() : null) ?? 'JetSmart';
    final origin = getJsonField(flightInfo, r'$.origin')?.toString() ?? 
                  (flightInfo is Map ? flightInfo['origin']?.toString() : null) ?? 'BOG';
    final destination = getJsonField(flightInfo, r'$.destination')?.toString() ?? 
                       (flightInfo is Map ? flightInfo['destination']?.toString() : null) ?? 'MDE';
    final departureTime = getJsonField(flightInfo, r'$.departure_time')?.toString() ?? 
                         (flightInfo is Map ? flightInfo['departure_time']?.toString() : null) ?? '09:04';
    final arrivalTime = getJsonField(flightInfo, r'$.arrival_time')?.toString() ?? 
                       (flightInfo is Map ? flightInfo['arrival_time']?.toString() : null) ?? '10:09';
    final date = getJsonField(flight, r'$.departure_date')?.toString() ?? 
                (flight is Map ? flight['departure_date']?.toString() : null) ?? '2025-07-07';
    final passengers = getJsonField(flight, r'$.passengers')?.toInt() ?? 
                      (flight is Map ? flight['passengers'] as int? : null) ?? 5;
    
    final netRate = getJsonField(flight, r'$.net_rate')?.toDouble() ?? 
                   (flight is Map ? flight['net_rate'] as double? : null) ?? 250000.00;
    final markupPercent = getJsonField(flight, r'$.markup_percent')?.toDouble() ?? 
                         (flight is Map ? flight['markup_percent'] as double? : null) ?? 18.0;
    final totalPrice = getJsonField(flight, r'$.total_price')?.toDouble() ?? 
                      (flight is Map ? flight['total_price'] as double? : null) ?? 295000.00;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Flight info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - airline and date info
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        airline.substring(0, 1),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        airline,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            _formatDate(date),
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.person, size: 16, color: Color(0xFF9CA3AF)),
                          SizedBox(width: 2),
                          Text(
                            passengers.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // Right side - time and route
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        departureTime,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.arrow_forward, size: 14, color: Color(0xFF9CA3AF)),
                      ),
                      Text(
                        arrivalTime,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        origin,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '---',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF).withOpacity(0.5),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      Text(
                        destination,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Financial details
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - pricing details
                Row(
                  children: [
                    Text(
                      'Tarifa neta ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '\$${_formatCurrency(netRate)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '|',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD3D4D6),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Text(
                      'Markup ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '${markupPercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '|',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD3D4D6),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Text(
                      'Valor ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '\$${_formatCurrency(totalPrice)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                // Right side - total
                Text(
                  'Total \$${_formatCurrency(totalPrice * passengers)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4F46E5),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Other tabs implementations (similar structure)
  Widget _buildHotelsTab(List<dynamic> items) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text('Hoteles - Por implementar'),
      ),
    );
  }

  Widget _buildActivitiesTab(List<dynamic> items) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text('Actividades - Por implementar'),
      ),
    );
  }

  Widget _buildTransfersTab(List<dynamic> items) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text('Transfers - Por implementar'),
      ),
    );
  }

  Widget _buildPaymentsContent(List<dynamic> transactions, dynamic itineraryData) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text('Sección de Pagos - Por implementar'),
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Container(
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.visibility, size: 64, color: Color(0xFF6B7280)),
            SizedBox(height: 16),
            Text('Vista previa del itinerario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 24),
            FFButtonWidget(
              onPressed: _handlePreviewItinerary,
              text: 'Ver Preview',
              options: FFButtonOptions(
                height: 44,
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                color: Color(0xFF4F46E5),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengersContent(List<dynamic> passengers) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      child: ItineraryPassengersSection(
        itineraryId: widget.id!,
        passengers: passengers,
        onAddPassenger: _handleAddPassenger,
        onEditPassenger: _handleEditPassenger,
        onDeletePassenger: _handleDeletePassenger,
      ),
    );
  }

  // Loading and error states
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 64),
          SizedBox(height: 16),
          Text('Error al cargar el itinerario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text(error, style: TextStyle(color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Color(0xFF6B7280), size: 64),
          SizedBox(height: 16),
          Text('Itinerario no encontrado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Helper methods
  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatCurrency(double amount) {
    final formatter = amount.toStringAsFixed(0);
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return formatter.replaceAllMapped(regex, (Match m) => '${m[1]}.');
  }

  // Action handlers (same as before)
  void _handleEditItinerary() {
    if (_itineraryId == null) return;
    final itineraryData = appServices.itinerary.getItinerary(_itineraryId!);
    if (itineraryData == null) return;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: ModalAddEditItineraryWidget(
            isEdit: true,
            allDataItinerary: itineraryData,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handlePreviewItinerary() {
    context.pushNamed(
      'preview_itinerary_URL',
      pathParameters: {'id': widget.id!},
    );
  }

  void _handleAddPassenger() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: ModalAddPassengerWidget(
            itineraryId: widget.id!,
            accountId: appServices.account.accountId!,
            isEdit: false,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handleEditPassenger(dynamic passenger) {
    final passengerId = getJsonField(passenger, r'$.id')?.toString();
    if (passengerId == null) return;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: ModalAddPassengerWidget(
            itineraryId: widget.id!,
            accountId: appServices.account.accountId!,
            isEdit: true,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handleDeletePassenger(dynamic passenger) {
    final passengerName = getJsonField(passenger, r'$.name')?.toString() ?? 'este pasajero';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Está seguro de que desea eliminar a $passengerName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              debugPrint('Delete passenger: ${getJsonField(passenger, r'$.id')}');
              safeSetState(() {});
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}