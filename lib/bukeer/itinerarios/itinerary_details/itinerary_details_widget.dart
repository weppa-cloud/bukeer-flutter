import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../auth/supabase_auth/auth_util.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../componentes/web_nav/web_nav_widget.dart';
import '../../../services/app_services.dart';
import '../../../services/itinerary_service.dart';
import '../../../components/service_builder.dart';
import 'sections/itinerary_header_section.dart';
import 'sections/itinerary_services_section.dart';
import 'sections/itinerary_passengers_section.dart';
import 'sections/itinerary_payments_section.dart';
import '../../modal_add_edit_itinerary/modal_add_edit_itinerary_widget.dart';
import '../servicios/add_hotel/add_hotel_widget.dart';
import '../servicios/add_flights/add_flights_widget.dart';
import '../servicios/add_activities/add_activities_widget.dart';
import '../servicios/add_transfer/add_transfer_widget.dart';
import '../pasajeros/modal_add_passenger/modal_add_passenger_widget.dart';
import '../pagos/component_add_paid/component_add_paid_widget.dart';
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

class _ItineraryDetailsWidgetState extends State<ItineraryDetailsWidget> {
  late ItineraryDetailsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItineraryDetailsModel());

    // Load itinerary data when page loads
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.id != null) {
        await appServices.itinerary.loadItineraryDetails(int.parse(widget.id!));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Navigation Bar
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
                  final itineraryData = widget.id != null
                      ? itineraryService.getItinerary(int.parse(widget.id!))
                      : null;

                  if (itineraryData == null) {
                    return _buildNotFoundState();
                  }

                  return _buildContent(itineraryData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(dynamic itineraryData) {
    final itineraryItems =
        appServices.itinerary.getItineraryItems(int.parse(widget.id!));
    final passengers =
        appServices.itinerary.getItineraryPassengers(int.parse(widget.id!));
    // TODO: Load transactions from transactions service when implemented
    final transactions = <dynamic>[];

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          ItineraryHeaderSection(
            itineraryData: itineraryData,
            onEditPressed: _handleEditItinerary,
            onDeletePressed: _handleDeleteItinerary,
            onPreviewPressed: _handlePreviewItinerary,
            onPdfPressed: _handleGeneratePdf,
          ),

          SizedBox(height: 24),

          // Services Section
          ItineraryServicesSection(
            itineraryId: widget.id!,
            itineraryItems: itineraryItems,
            onAddFlight: _handleAddFlight,
            onAddHotel: _handleAddHotel,
            onAddActivity: _handleAddActivity,
            onAddTransfer: _handleAddTransfer,
          ),

          SizedBox(height: 24),

          // Passengers Section
          ItineraryPassengersSection(
            itineraryId: widget.id!,
            passengers: passengers,
            onAddPassenger: _handleAddPassenger,
            onEditPassenger: _handleEditPassenger,
            onDeletePassenger: _handleDeletePassenger,
          ),

          SizedBox(height: 24),

          // Payments Section
          ItineraryPaymentsSection(
            itineraryId: widget.id!,
            itineraryData: itineraryData,
            transactions: transactions,
            onAddPayment: _handleAddPayment,
            onEditTransaction: _handleEditTransaction,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              FlutterFlowTheme.of(context).primary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando itinerario...',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: FlutterFlowTheme.of(context).error,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Error al cargar el itinerario',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).error,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (widget.id != null) {
                  appServices.itinerary
                      .loadItineraryDetails(int.parse(widget.id!));
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
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Itinerario no encontrado',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'El itinerario solicitado no existe o fue eliminado.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed('main_itineraries'),
              child: Text('Volver a Itinerarios'),
            ),
          ],
        ),
      ),
    );
  }

  // Action Handlers
  void _handleEditItinerary() {
    final itineraryData =
        appServices.itinerary.getItinerary(int.parse(widget.id!));
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
              // context.goNamed('main_itineraries');
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
      final itineraryData =
          appServices.itinerary.getItinerary(int.parse(widget.id!));
      final itineraryItems =
          appServices.itinerary.getItineraryItems(int.parse(widget.id!));

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
        FFAppState().accountId,
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
            accountId: FFAppState().accountId,
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
            accountId: FFAppState().accountId,
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
    final passengers =
        appServices.itinerary.getItineraryPassengers(int.parse(widget.id!));

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: ComponentAddPaidWidget(
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
}
