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

/// Refactored ItineraryDetailsWidget - Modular and maintainable
/// Divided into logical sections for better code organization
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

  // Helper to get itinerary ID
  String? get _itineraryId => widget.id;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItineraryDetailsModel());

    // Initialize tab controllers
    _mainTabController = TabController(length: 4, vsync: this);
    _servicesTabController = TabController(length: 4, vsync: this);

    // Add listener to update UI when tab changes
    _servicesTabController.addListener(() {
      if (_servicesTabController.indexIsChanging) {
        setState(() {});
      }
    });

    // Load itinerary data when page loads
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
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Bar (hidden on mobile)
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
            child: Container(
              color: FlutterFlowTheme.of(context).primaryBackground,
              child: ServiceBuilder<ItineraryService>(
                service: appServices.itinerary,
                loadingWidget: _buildLoadingState(),
                errorBuilder: (error) => _buildErrorState(error),
                builder: (context, itineraryService) {
                  // Validate ID
                  if (widget.id == null || widget.id!.isEmpty) {
                    return _buildNotFoundState();
                  }

                  final itineraryData =
                      itineraryService.getItinerary(widget.id!);

                  if (itineraryData == null) {
                    return _buildNotFoundState();
                  }

                  return _buildContent(itineraryData);
                },
              ),
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
    // TODO: Load transactions from transactions service when implemented
    final transactions = <dynamic>[];

    return Column(
      children: [
        // Top Header Section
        Container(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          padding: EdgeInsets.all(20),
          child: _buildTopHeader(itineraryData),
        ),

        // Main content area
        Expanded(
          child: Container(
            color: FlutterFlowTheme.of(context).primaryBackground,
            child: Column(
              children: [
                // Main Navigation Tabs
                Container(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: TabBar(
                    controller: _mainTabController,
                    indicatorColor: FlutterFlowTheme.of(context).primary,
                    indicatorWeight: 3,
                    labelColor: FlutterFlowTheme.of(context).primary,
                    unselectedLabelColor:
                        FlutterFlowTheme.of(context).secondaryText,
                    labelStyle:
                        FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                    unselectedLabelStyle:
                        FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flight_takeoff, size: 20),
                            SizedBox(width: 8),
                            Text('Servicios'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.payments, size: 20),
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
                            Icon(Icons.people, size: 20),
                            SizedBox(width: 8),
                            Text('Pasajeros'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _mainTabController,
                    children: [
                      // Services Tab with Sub-tabs
                      _buildServicesTab(itineraryItems),

                      // Payments Tab
                      _buildPaymentsTab(transactions, itineraryData),

                      // Preview Tab
                      _buildPreviewTab(),

                      // Passengers Tab
                      _buildPassengersTab(passengers),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              BukeerColors.primary,
            ),
          ),
          SizedBox(height: BukeerSpacing.m),
          Text(
            'Cargando itinerario...',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: BukeerColors.secondaryText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: BukeerColors.error,
              size: 64,
            ),
            SizedBox(height: BukeerSpacing.m),
            Text(
              'Error al cargar el itinerario',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Outfit',
                    color: BukeerColors.error,
                  ),
            ),
            SizedBox(height: BukeerSpacing.s),
            Text(
              error,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: BukeerColors.secondaryText,
                  ),
            ),
            SizedBox(height: BukeerSpacing.l),
            ElevatedButton(
              onPressed: () {
                if (_itineraryId != null) {
                  appServices.itinerary.loadItineraryDetails(_itineraryId!);
                }
              },
              child: Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: BukeerColors.secondaryText,
              size: 64,
            ),
            SizedBox(height: BukeerSpacing.m),
            Text(
              'Itinerario no encontrado',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Outfit',
                    color: BukeerColors.secondaryText,
                  ),
            ),
            SizedBox(height: BukeerSpacing.s),
            Text(
              'El itinerario solicitado no existe o fue eliminado.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: BukeerColors.secondaryText,
                  ),
            ),
            SizedBox(height: BukeerSpacing.l),
            ElevatedButton(
              onPressed: () => context.goNamed(MainItinerariesWidget.routeName),
              child: Text('Volver a Itinerarios'),
            ),
          ],
        ),
      ),
    );
  }

  // Action Handlers
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

  void _handleDeleteItinerary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Está seguro de que desea eliminar este itinerario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // TODO: Add delete functionality to itinerary service
              debugPrint('Delete itinerary: ${widget.id}');
              // context.goNamed(MainItinerariesWidget.routeName);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _handlePreviewItinerary() {
    context.pushNamed(
      'preview_itinerary_URL',
      pathParameters: {'id': widget.id!},
    );
  }

  void _handleGeneratePdf() async {
    try {
      if (_itineraryId == null) return;
      final itineraryData = appServices.itinerary.getItinerary(_itineraryId!);
      final itineraryItems =
          appServices.itinerary.getItineraryItems(_itineraryId!);

      if (itineraryData == null) return;

      // TODO: Get contact and agent data from services
      final contact = {}; // Get from contact service
      final agent = {}; // Get from user service
      final account = {}; // Get from account service

      await actions.createPDF(
        contact,
        agent,
        itineraryData,
        itineraryItems,
        appServices.account.accountId!,
        account,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF generado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar PDF: $e')),
      );
    }
  }

  void _handleAddFlight() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: AddFlightsWidget(
            isEdit: false,
            itineraryId: widget.id,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handleAddHotel() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: AddHotelWidget(
            isEdit: false,
            itineraryId: widget.id,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handleAddActivity() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: AddActivitiesWidget(
            isEdit: false,
            itineraryId: widget.id,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handleAddTransfer() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: AddTransferWidget(
            isEdit: false,
            itineraryId: widget.id,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
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
    final passengerName =
        getJsonField(passenger, r'$.name')?.toString() ?? 'este pasajero';

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
              // TODO: Add delete passenger functionality to service
              debugPrint(
                  'Delete passenger: ${getJsonField(passenger, r'$.id')}');
              safeSetState(() {});
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _handleAddPayment() {
    if (_itineraryId == null) return;
    final passengers =
        appServices.itinerary.getItineraryPassengers(_itineraryId!);

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: PaymentAddWidget(
            idItinerary: widget.id,
            agentName: currentUserEmail,
            agentEmail: currentUserEmail,
            emailProvider: '',
            nameProvider: '',
            fechaReserva: getCurrentTimestamp.toString(),
            producto: '',
            tarifa: '',
            cantidad: passengers.length,
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handleEditTransaction(dynamic transaction) {
    // TODO: Implement edit transaction properly with correct data
    debugPrint('Edit transaction: ${getJsonField(transaction, r'$.id')}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar transacción - Funcionalidad pendiente')),
    );
  }

  Widget _buildTopHeader(dynamic itineraryData) {
    final itineraryName =
        getJsonField(itineraryData, r'$[:].itinerary_name')?.toString() ??
            'Sin nombre';
    final clientName =
        getJsonField(itineraryData, r'$[:].client_name')?.toString() ?? '';
    final startDate =
        getJsonField(itineraryData, r'$[:].start_date')?.toString() ?? '';
    final endDate =
        getJsonField(itineraryData, r'$[:].end_date')?.toString() ?? '';
    final status =
        getJsonField(itineraryData, r'$[:].status')?.toString() ?? 'budget';
    final isConfirmed = status.toLowerCase() == 'confirmed';

    // Travel planner info
    final travelPlannerName =
        getJsonField(itineraryData, r'$[:].travel_planner_name')?.toString() ??
            getJsonField(itineraryData, r'$[:].user_name')?.toString() ??
            'Juan David Alvarez';

    // Calculate totals
    final totalPrice =
        getJsonField(itineraryData, r'$[:].total_price')?.toDouble() ??
            7450100.00;
    final passengers =
        getJsonField(itineraryData, r'$[:].total_passengers')?.toInt() ?? 5;
    final pricePerPerson =
        passengers > 0 ? totalPrice / passengers : totalPrice;
    final margin =
        getJsonField(itineraryData, r'$[:].total_margin')?.toDouble() ??
            1179100.00;

    return Row(
      children: [
        // Left side - Title and info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => context.safePop(),
                    child: Icon(
                      Icons.arrow_back,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            itineraryName,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.flight_takeoff,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Info row
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoChip(Icons.tag,
                      'ID ${getJsonField(itineraryData, r'$[:].id')?.toString() ?? '1-6180'}'),
                  _buildInfoChip(Icons.person, clientName),
                  _buildInfoChip(Icons.calendar_today,
                      '${_formatDate(startDate)} - ${_formatDate(endDate)}'),
                  _buildInfoChip(Icons.people,
                      '$passengers adultos, ${getJsonField(itineraryData, r'$[:].total_children')?.toString() ?? '2'} niños'),
                  _buildInfoChip(Icons.language, 'Español'),
                  _buildInfoChip(Icons.attach_money, 'Econo'),
                  _buildInfoChip(Icons.calendar_month,
                      'Creado: ${_formatDate(getJsonField(itineraryData, r'$[:].created_at')?.toString() ?? '08 Jun 2025')}'),
                  _buildInfoChip(Icons.people_alt, '$passengers Pax'),
                ],
              ),
            ],
          ),
        ),

        // Right side - Status and totals
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Confirmar',
                      style: FlutterFlowTheme.of(context).bodyMedium),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isConfirmed
                          ? FlutterFlowTheme.of(context).success
                          : FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isConfirmed ? 'Confirmado' : 'Presupuesto',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: _handleEditItinerary,
                    child: Icon(Icons.edit, size: 20),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      // Copy functionality
                    },
                    child: Icon(Icons.copy, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Travel planner
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://avatar.iran.liara.run/public'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        travelPlannerName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'Travel Planner',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Totals
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total \$${_formatCurrency(totalPrice)} COP',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Valor por persona \$${_formatCurrency(pricePerPerson)} COP',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                  Text(
                    'Margen \$${_formatCurrency(margin)} COP',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).success,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: FlutterFlowTheme.of(context).secondaryText),
        SizedBox(width: 4),
        Text(
          text,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
        ),
      ],
    );
  }

  Widget _buildServicesTab(List<dynamic> itineraryItems) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Services sub-tabs
          Container(
            height: 48,
            child: Row(
              children: [
                _buildServiceTabButton(
                  icon: Icons.flight,
                  label: 'Vuelos',
                  isActive: _servicesTabController.index == 0,
                  onTap: () => _servicesTabController.animateTo(0),
                ),
                SizedBox(width: 12),
                _buildServiceTabButton(
                  icon: Icons.hotel,
                  label: 'Hoteles',
                  isActive: _servicesTabController.index == 1,
                  onTap: () => _servicesTabController.animateTo(1),
                ),
                SizedBox(width: 12),
                _buildServiceTabButton(
                  icon: Icons.local_activity,
                  label: 'Actividades',
                  isActive: _servicesTabController.index == 2,
                  onTap: () => _servicesTabController.animateTo(2),
                ),
                SizedBox(width: 12),
                _buildServiceTabButton(
                  icon: Icons.directions_car,
                  label: 'Transfer',
                  isActive: _servicesTabController.index == 3,
                  onTap: () => _servicesTabController.animateTo(3),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Services content
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
      ),
    );
  }

  Widget _buildServiceTabButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive
                    ? Colors.white
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      color: isActive
                          ? Colors.white
                          : FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightsTab(List<dynamic> items) {
    final flights = items
        .where((item) => getJsonField(item, r'$.type')?.toString() == 'flight')
        .toList();

    // Add sample data if no flights exist (for demo purposes)
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

    final totalFlights = flights.fold<double>(
        0,
        (sum, item) =>
            sum +
            (getJsonField(item, r'$.total_price')?.toDouble() ??
                (item['total_price'] as double? ?? 0)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total and Add button row
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total vuelos \$${_formatCurrency(totalFlights)}',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              InkWell(
                onTap: _handleAddFlight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Agregar vuelo',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
    );
  }

  Widget _buildHotelsTab(List<dynamic> items) {
    final hotels = items
        .where((item) => getJsonField(item, r'$.type')?.toString() == 'hotel')
        .toList();
    final totalHotels = hotels.fold<double>(
        0,
        (sum, item) =>
            sum + (getJsonField(item, r'$.total_price')?.toDouble() ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total and Add button row
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total hoteles \$${_formatCurrency(totalHotels)}',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              InkWell(
                onTap: _handleAddHotel,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Agregar hotel',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Hotels list
        Expanded(
          child: hotels.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hotel,
                        size: 48,
                        color: FlutterFlowTheme.of(context)
                            .secondaryText
                            .withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay hoteles agregados',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: hotels.length,
                  itemBuilder: (context, index) =>
                      _buildHotelCard(hotels[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildActivitiesTab(List<dynamic> items) {
    final activities = items
        .where(
            (item) => getJsonField(item, r'$.type')?.toString() == 'activity')
        .toList();
    final totalActivities = activities.fold<double>(
        0,
        (sum, item) =>
            sum + (getJsonField(item, r'$.total_price')?.toDouble() ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total and Add button row
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total actividades \$${_formatCurrency(totalActivities)}',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              InkWell(
                onTap: _handleAddActivity,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Agregar actividad',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Activities list
        Expanded(
          child: activities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_activity,
                        size: 48,
                        color: FlutterFlowTheme.of(context)
                            .secondaryText
                            .withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay actividades agregadas',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) =>
                      _buildActivityCard(activities[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildTransfersTab(List<dynamic> items) {
    final transfers = items
        .where(
            (item) => getJsonField(item, r'$.type')?.toString() == 'transfer')
        .toList();
    final totalTransfers = transfers.fold<double>(
        0,
        (sum, item) =>
            sum + (getJsonField(item, r'$.total_price')?.toDouble() ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total and Add button row
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total traslados \$${_formatCurrency(totalTransfers)}',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              InkWell(
                onTap: _handleAddTransfer,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Agregar traslado',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Transfers list
        Expanded(
          child: transfers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 48,
                        color: FlutterFlowTheme.of(context)
                            .secondaryText
                            .withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay traslados agregados',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: transfers.length,
                  itemBuilder: (context, index) =>
                      _buildTransferCard(transfers[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildPaymentsTab(List<dynamic> transactions, dynamic itineraryData) {
    return Center(
      child: Text('Sección de Pagos - Por implementar'),
    );
  }

  Widget _buildPreviewTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.visibility,
              size: 64, color: FlutterFlowTheme.of(context).secondaryText),
          SizedBox(height: 16),
          Text('Vista previa del itinerario',
              style: FlutterFlowTheme.of(context).headlineSmall),
          SizedBox(height: 24),
          FFButtonWidget(
            onPressed: _handlePreviewItinerary,
            text: 'Ver Preview',
            options: FFButtonOptions(
              height: 44,
              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Readex Pro',
                    color: Colors.white,
                  ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengersTab(List<dynamic> passengers) {
    return ItineraryPassengersSection(
      itineraryId: widget.id!,
      passengers: passengers,
      onAddPassenger: _handleAddPassenger,
      onEditPassenger: _handleEditPassenger,
      onDeletePassenger: _handleDeletePassenger,
    );
  }

  Widget _buildFlightCard(dynamic flight) {
    // Handle both real data (getJsonField) and sample data (direct access)
    final flightInfo = getJsonField(flight, r'$.flights') ?? flight['flights'];
    final airline = getJsonField(flightInfo, r'$.airline')?.toString() ??
        (flightInfo is Map ? flightInfo['airline']?.toString() : null) ??
        'JetSmart';
    final origin = getJsonField(flightInfo, r'$.origin')?.toString() ??
        (flightInfo is Map ? flightInfo['origin']?.toString() : null) ??
        'BOG';
    final destination = getJsonField(flightInfo, r'$.destination')
            ?.toString() ??
        (flightInfo is Map ? flightInfo['destination']?.toString() : null) ??
        'MDE';
    final departureTime = getJsonField(flightInfo, r'$.departure_time')
            ?.toString() ??
        (flightInfo is Map ? flightInfo['departure_time']?.toString() : null) ??
        '09:04';
    final arrivalTime = getJsonField(flightInfo, r'$.arrival_time')
            ?.toString() ??
        (flightInfo is Map ? flightInfo['arrival_time']?.toString() : null) ??
        '10:09';
    final date = getJsonField(flight, r'$.departure_date')?.toString() ??
        (flight is Map ? flight['departure_date']?.toString() : null) ??
        '2025-07-07';
    final passengers = getJsonField(flight, r'$.passengers')?.toInt() ??
        (flight is Map ? flight['passengers'] as int? : null) ??
        5;

    final netRate = getJsonField(flight, r'$.net_rate')?.toDouble() ??
        (flight is Map ? flight['net_rate'] as double? : null) ??
        250000.00;
    final markupPercent =
        getJsonField(flight, r'$.markup_percent')?.toDouble() ??
            (flight is Map ? flight['markup_percent'] as double? : null) ??
            18.0;
    final totalPrice = getJsonField(flight, r'$.total_price')?.toDouble() ??
        (flight is Map ? flight['total_price'] as double? : null) ??
        295000.00;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Color(0x0D000000),
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Flight info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // First row - Airline and route
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Airline logo/name
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        airline,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xFF1976D2),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    // Times
                    Row(
                      children: [
                        Text(
                          departureTime,
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward, size: 14),
                        ),
                        Text(
                          arrivalTime,
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Second row - Date and passengers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatDate(date),
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Icon(Icons.person,
                                size: 14,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            SizedBox(width: 4),
                            Text(
                              '$passengers',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '$origin ⟶ $destination',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Financial info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Tarifa neta ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(netRate)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Markup ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${markupPercent.toStringAsFixed(0)}%',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Valor ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(totalPrice)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total \$${_formatCurrency(totalPrice)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(dynamic hotel) {
    // Handle both real data (getJsonField) and sample data (direct access)
    final hotelInfo = getJsonField(hotel, r'$.hotel') ?? hotel['hotel'];
    final hotelName = getJsonField(hotelInfo, r'$.name')?.toString() ??
        (hotelInfo is Map ? hotelInfo['name']?.toString() : null) ??
        'Hotel Ejemplo';
    final location = getJsonField(hotelInfo, r'$.location')?.toString() ??
        (hotelInfo is Map ? hotelInfo['location']?.toString() : null) ??
        'Medellín';
    final checkIn = getJsonField(hotel, r'$.check_in_date')?.toString() ??
        (hotel is Map ? hotel['check_in_date']?.toString() : null) ??
        '2025-07-07';
    final checkOut = getJsonField(hotel, r'$.check_out_date')?.toString() ??
        (hotel is Map ? hotel['check_out_date']?.toString() : null) ??
        '2025-07-11';
    final rooms = getJsonField(hotel, r'$.rooms')?.toInt() ??
        (hotel is Map ? hotel['rooms'] as int? : null) ??
        2;
    final nights = getJsonField(hotel, r'$.nights')?.toInt() ??
        (hotel is Map ? hotel['nights'] as int? : null) ??
        4;

    final netRate = getJsonField(hotel, r'$.net_rate')?.toDouble() ??
        (hotel is Map ? hotel['net_rate'] as double? : null) ??
        1500000.00;
    final markupPercent =
        getJsonField(hotel, r'$.markup_percent')?.toDouble() ??
            (hotel is Map ? hotel['markup_percent'] as double? : null) ??
            20.0;
    final totalPrice = getJsonField(hotel, r'$.total_price')?.toDouble() ??
        (hotel is Map ? hotel['total_price'] as double? : null) ??
        1800000.00;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Color(0x0D000000),
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hotel info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // First row - Hotel name and location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hotel name
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        hotelName,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xFF2E7D32),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    // Dates
                    Row(
                      children: [
                        Text(
                          _formatDate(checkIn),
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward, size: 14),
                        ),
                        Text(
                          _formatDate(checkOut),
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Second row - Location and rooms info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          location,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Icon(Icons.hotel,
                                size: 14,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            SizedBox(width: 4),
                            Text(
                              '$rooms habitaciones',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '$nights noches',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Financial info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Tarifa neta ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(netRate)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Markup ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${markupPercent.toStringAsFixed(0)}%',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Valor ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(totalPrice)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total \$${_formatCurrency(totalPrice)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(dynamic activity) {
    // Handle both real data (getJsonField) and sample data (direct access)
    final activityInfo =
        getJsonField(activity, r'$.activity') ?? activity['activity'];
    final activityName = getJsonField(activityInfo, r'$.name')?.toString() ??
        (activityInfo is Map ? activityInfo['name']?.toString() : null) ??
        'Tour Ciudad';
    final location = getJsonField(activityInfo, r'$.location')?.toString() ??
        (activityInfo is Map ? activityInfo['location']?.toString() : null) ??
        'Medellín';
    final date = getJsonField(activity, r'$.activity_date')?.toString() ??
        (activity is Map ? activity['activity_date']?.toString() : null) ??
        '2025-07-08';
    final duration = getJsonField(activityInfo, r'$.duration')?.toString() ??
        (activityInfo is Map ? activityInfo['duration']?.toString() : null) ??
        '4 horas';
    final participants = getJsonField(activity, r'$.participants')?.toInt() ??
        (activity is Map ? activity['participants'] as int? : null) ??
        5;

    final netRate = getJsonField(activity, r'$.net_rate')?.toDouble() ??
        (activity is Map ? activity['net_rate'] as double? : null) ??
        80000.00;
    final markupPercent =
        getJsonField(activity, r'$.markup_percent')?.toDouble() ??
            (activity is Map ? activity['markup_percent'] as double? : null) ??
            25.0;
    final totalPrice = getJsonField(activity, r'$.total_price')?.toDouble() ??
        (activity is Map ? activity['total_price'] as double? : null) ??
        100000.00;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Color(0x0D000000),
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Activity info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // First row - Activity name and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Activity name
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        activityName,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xFFE65100),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    // Date
                    Text(
                      _formatDate(date),
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Second row - Location and participants
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          location,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            SizedBox(width: 4),
                            Text(
                              duration,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.person,
                            size: 14,
                            color: FlutterFlowTheme.of(context).secondaryText),
                        SizedBox(width: 4),
                        Text(
                          '$participants',
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Financial info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Tarifa neta ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(netRate)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Markup ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${markupPercent.toStringAsFixed(0)}%',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Valor ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(totalPrice)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total \$${_formatCurrency(totalPrice)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferCard(dynamic transfer) {
    // Handle both real data (getJsonField) and sample data (direct access)
    final transferInfo =
        getJsonField(transfer, r'$.transfer') ?? transfer['transfer'];
    final transferType = getJsonField(transferInfo, r'$.type')?.toString() ??
        (transferInfo is Map ? transferInfo['type']?.toString() : null) ??
        'Aeropuerto - Hotel';
    final origin = getJsonField(transferInfo, r'$.origin')?.toString() ??
        (transferInfo is Map ? transferInfo['origin']?.toString() : null) ??
        'Aeropuerto';
    final destination =
        getJsonField(transferInfo, r'$.destination')?.toString() ??
            (transferInfo is Map
                ? transferInfo['destination']?.toString()
                : null) ??
            'Hotel';
    final date = getJsonField(transfer, r'$.transfer_date')?.toString() ??
        (transfer is Map ? transfer['transfer_date']?.toString() : null) ??
        '2025-07-07';
    final time = getJsonField(transfer, r'$.pickup_time')?.toString() ??
        (transfer is Map ? transfer['pickup_time']?.toString() : null) ??
        '10:30';
    final passengers = getJsonField(transfer, r'$.passengers')?.toInt() ??
        (transfer is Map ? transfer['passengers'] as int? : null) ??
        5;

    final netRate = getJsonField(transfer, r'$.net_rate')?.toDouble() ??
        (transfer is Map ? transfer['net_rate'] as double? : null) ??
        50000.00;
    final markupPercent =
        getJsonField(transfer, r'$.markup_percent')?.toDouble() ??
            (transfer is Map ? transfer['markup_percent'] as double? : null) ??
            20.0;
    final totalPrice = getJsonField(transfer, r'$.total_price')?.toDouble() ??
        (transfer is Map ? transfer['total_price'] as double? : null) ??
        60000.00;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Color(0x0D000000),
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Transfer info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // First row - Transfer type and time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Transfer type
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3E5F5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        transferType,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xFF7B1FA2),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    // Time
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 16,
                            color: FlutterFlowTheme.of(context).secondaryText),
                        SizedBox(width: 4),
                        Text(
                          time,
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Second row - Route and passengers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatDate(date),
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Icon(Icons.person,
                                size: 14,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            SizedBox(width: 4),
                            Text(
                              '$passengers',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '$origin ⟶ $destination',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Financial info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Tarifa neta ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(netRate)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Markup ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${markupPercent.toStringAsFixed(0)}%',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Valor ',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '\$${_formatCurrency(totalPrice)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total \$${_formatCurrency(totalPrice)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic'
      ];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatCurrency(double amount) {
    // Format with thousands separator
    final formatter = amount.toStringAsFixed(0);
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return formatter.replaceAllMapped(regex, (Match m) => '${m[1]}.');
  }
}
