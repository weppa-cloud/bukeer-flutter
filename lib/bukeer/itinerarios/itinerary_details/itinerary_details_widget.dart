import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../componentes/web_nav/web_nav_widget.dart';
import '../../../services/app_services.dart';
import '../../../services/itinerary_service.dart';
import '../../../components/service_builder.dart';
import 'sections/itinerary_header_section.dart';
import 'sections/itinerary_services_section.dart';
import 'sections/itinerary_passengers_section.dart';
import 'sections/itinerary_payments_section.dart';
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
    final transactions = <dynamic>[]; // TODO: Load from transactions service

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
    // TODO: Open edit modal
    debugPrint('Edit itinerary: ${widget.id}');
  }

  void _handleDeleteItinerary() {
    // TODO: Show confirmation dialog and delete
    debugPrint('Delete itinerary: ${widget.id}');
  }

  void _handlePreviewItinerary() {
    // TODO: Open preview
    debugPrint('Preview itinerary: ${widget.id}');
  }

  void _handleGeneratePdf() {
    // TODO: Generate PDF
    debugPrint('Generate PDF for itinerary: ${widget.id}');
  }

  void _handleAddFlight() {
    // TODO: Open add flight modal
    debugPrint('Add flight to itinerary: ${widget.id}');
  }

  void _handleAddHotel() {
    // TODO: Open add hotel modal
    debugPrint('Add hotel to itinerary: ${widget.id}');
  }

  void _handleAddActivity() {
    // TODO: Open add activity modal
    debugPrint('Add activity to itinerary: ${widget.id}');
  }

  void _handleAddTransfer() {
    // TODO: Open add transfer modal
    debugPrint('Add transfer to itinerary: ${widget.id}');
  }

  void _handleAddPassenger() {
    // TODO: Open add passenger modal
    debugPrint('Add passenger to itinerary: ${widget.id}');
  }

  void _handleEditPassenger(dynamic passenger) {
    // TODO: Open edit passenger modal
    debugPrint('Edit passenger: ${getJsonField(passenger, r'$.id')}');
  }

  void _handleDeletePassenger(dynamic passenger) {
    // TODO: Show confirmation and delete passenger
    debugPrint('Delete passenger: ${getJsonField(passenger, r'$.id')}');
  }

  void _handleAddPayment() {
    // TODO: Open add payment modal
    debugPrint('Add payment to itinerary: ${widget.id}');
  }

  void _handleEditTransaction(dynamic transaction) {
    // TODO: Open edit transaction modal
    debugPrint('Edit transaction: ${getJsonField(transaction, r'$.id')}');
  }
}
