import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import '../../core/widgets/navigation/sidebar/sidebar_navigation_widget.dart';
import '../../../services/app_services.dart';
import '../../../services/itinerary_service.dart';
import '../../../components/service_builder.dart';
import '../../../backend/supabase/supabase.dart';
import '../../../backend/api_requests/api_calls.dart';
import 'sections/itinerary_passengers_section.dart';
import '../../core/widgets/modals/itinerary/add_edit/modal_add_edit_itinerary_widget.dart';
import '../servicios/add_hotel/add_hotel_widget.dart';
import '../servicios/add_flights/add_flights_widget.dart';
import '../servicios/add_activities/add_activities_widget.dart';
import '../servicios/add_transfer/add_transfer_widget.dart';
import '../../core/widgets/modals/passenger/add/modal_add_passenger_widget.dart';
import '../../core/widgets/payments/payment_add/payment_add_widget.dart';
import '../proveedores/reservation_message/reservation_message_widget.dart';
import '../proveedores/show_reservation_message/show_reservation_message_widget.dart';
import '../main_itineraries/main_itineraries_widget.dart';
import '../../core/widgets/modals/itinerary/change_owner/modal_change_owner_widget.dart';
import 'itinerary_details_model.dart';

export 'itinerary_details_model.dart';

/// ItineraryDetailsWidget - Using Bukeer Design System with proper tokens
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

  int _selectedMainTab = 0;
  int _selectedServiceTab = 2; // Services/Activities by default
  bool _isServicesExpanded = true;

  // Helper to get complete itinerary data
  Map<String, dynamic>? get _completeData => _itineraryId != null
      ? appServices.itinerary.getCompleteItineraryData(_itineraryId!)
      : null;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItineraryDetailsModel());

    _mainTabController = TabController(length: 5, vsync: this);
    _servicesTabController = TabController(
        length: 4, vsync: this, initialIndex: _selectedServiceTab);

    _mainTabController.addListener(() {
      if (_mainTabController.indexIsChanging) {
        setState(() {
          _selectedMainTab = _mainTabController.index;
        });
      }
    });

    _servicesTabController.addListener(() {
      if (_servicesTabController.indexIsChanging) {
        setState(() {
          _selectedServiceTab = _servicesTabController.index;
        });
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (_itineraryId != null && _itineraryId!.isNotEmpty) {
        print(
            'ItineraryDetailsWidget: Loading complete data for itinerary $_itineraryId');
        final completeData = await appServices.itinerary
            .loadItineraryDetailsOptimized(_itineraryId!);

        if (completeData != null) {
          print('ItineraryDetailsWidget: Data loaded successfully');
          print('Has flights: ${completeData['has_flights']}');
          print('Has hotels: ${completeData['has_hotels']}');
          print('Has activities: ${completeData['has_activities']}');
          print('Has transfers: ${completeData['has_transfers']}');

          // Set the initial service tab based on available content
          int newTab = _selectedServiceTab;
          if (completeData['has_flights'] == true && _selectedServiceTab == 0) {
            newTab = 0;
          } else if (completeData['has_hotels'] == true &&
              _selectedServiceTab == 1) {
            newTab = 1;
          } else if (completeData['has_activities'] == true) {
            newTab = 2;
          } else if (completeData['has_transfers'] == true) {
            newTab = 3;
          } else if (completeData['has_flights'] == true) {
            newTab = 0;
          } else if (completeData['has_hotels'] == true) {
            newTab = 1;
          }

          if (newTab != _selectedServiceTab) {
            setState(() {
              _selectedServiceTab = newTab;
              _servicesTabController.animateTo(newTab);
            });
          }
        }

        // Force a rebuild after loading
        if (mounted) {
          setState(() {});
        }
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

  // Handle delete service
  Future<void> _handleDeleteService(dynamic item, String serviceType) async {
    final itemId = getJsonField(item, r'$.id')?.toString();
    if (itemId == null) return;

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: BukeerColors.primary,
          ),
        ),
      );

      // Delete from backend
      await SupaFlow.client.from('itinerary_items').delete().eq('id', itemId);

      // Close loading
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Servicio eliminado exitosamente'),
          backgroundColor: BukeerColors.success,
        ),
      );

      // Reload itinerary data
      if (_itineraryId != null) {
        await appServices.itinerary
            .loadItineraryDetailsOptimized(_itineraryId!);
        setState(() {});
      }
    } catch (e) {
      // Close loading if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el servicio: $e'),
          backgroundColor: BukeerColors.error,
        ),
      );
    }
  }

  // Handle edit service
  void _handleEditService(dynamic item, String serviceType) async {
    // Navigate to edit screen based on service type
    final itemId = getJsonField(item, r'$.id')?.toString();
    if (itemId == null) return;

    bool? result;

    switch (serviceType) {
      case 'flight':
        result = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => AddFlightsWidget(
            itineraryId: _itineraryId,
            isEdit: true,
            itemId: itemId,
          ),
        );
        break;
      case 'hotel':
        context.pushNamed(
          'AddHotel',
          queryParameters: {
            'itineraryId': _itineraryId,
            'itemId': itemId,
            'isEdit': 'true',
          },
        );
        break;
      case 'activity':
        context.pushNamed(
          'AddActivities',
          queryParameters: {
            'itineraryId': _itineraryId,
            'itemId': itemId,
            'isEdit': 'true',
          },
        );
        break;
      case 'transfer':
        context.pushNamed(
          'AddTransfer',
          queryParameters: {
            'itineraryId': _itineraryId,
            'itemId': itemId,
            'isEdit': 'true',
          },
        );
        break;
    }

    // Reload data if edited
    if (result == true && _itineraryId != null) {
      await appServices.itinerary.loadItineraryDetailsOptimized(_itineraryId!);
      setState(() {});
    }
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(
      dynamic item, String serviceType) async {
    final serviceName = _getServiceDisplayName(item, serviceType);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.m),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: 28,
              ),
              SizedBox(width: BukeerSpacing.s),
              Expanded(
                child: Text(
                  'Confirmar eliminación',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Estás seguro de que deseas eliminar este servicio?',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
              SizedBox(height: BukeerSpacing.m),
              Container(
                padding: EdgeInsets.all(BukeerSpacing.m),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1,
                  ),
                ),
                child: Text(
                  serviceName,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SizedBox(height: BukeerSpacing.s),
              Text(
                'Esta acción no se puede deshacer.',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).error,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
          actions: <Widget>[
            BukeerButton(
              text: 'Cancelar',
              onPressed: () {
                Navigator.of(context).pop();
              },
              variant: BukeerButtonVariant.secondary,
              size: BukeerButtonSize.small,
            ),
            BukeerButton(
              text: 'Eliminar',
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleDeleteService(item, serviceType);
              },
              variant: BukeerButtonVariant.primary,
              backgroundColor: BukeerColors.error,
              size: BukeerButtonSize.small,
            ),
          ],
        );
      },
    );
  }

  // Get service display name for dialogs
  String _getServiceDisplayName(dynamic item, String serviceType) {
    switch (serviceType) {
      case 'flight':
        final origin =
            getJsonField(item, r'$.departure_airport')?.toString() ?? '';
        final destination =
            getJsonField(item, r'$.arrival_airport')?.toString() ?? '';
        final flightNumber =
            getJsonField(item, r'$.flight_number')?.toString() ?? '';
        return 'Vuelo $flightNumber: $origin - $destination';
      case 'hotel':
        final hotelName =
            getJsonField(item, r'$.product_name')?.toString() ?? 'Hotel';
        final roomType = getJsonField(item, r'$.rate_name')?.toString() ?? '';
        return '$hotelName - $roomType';
      case 'activity':
        final activityName =
            getJsonField(item, r'$.product_name')?.toString() ?? 'Actividad';
        return activityName;
      case 'transfer':
        final transferName =
            getJsonField(item, r'$.product_name')?.toString() ?? 'Traslado';
        return transferName;
      default:
        return 'Servicio';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor:
          isDark ? BukeerColors.backgroundDark : BukeerColors.backgroundPrimary,
      drawer: responsiveVisibility(
        context: context,
        tablet: false,
        desktop: false,
      )
          ? SidebarDrawer(currentRoute: ItineraryDetailsWidget.routeName)
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Navigation
          if (responsiveVisibility(
            context: context,
            phone: false,
            tablet: false,
          ))
            SidebarNavigationWidget(
              currentRoute: ItineraryDetailsWidget.routeName,
            ),

          // Main Content
          Expanded(
            child: Consumer<ItineraryService>(
              builder: (context, itineraryService, child) {
                if (widget.id == null || widget.id!.isEmpty) {
                  return _buildNotFoundState();
                }

                if (itineraryService.isLoading) {
                  return _buildLoadingState();
                }

                if (itineraryService.hasError) {
                  return _buildErrorState(
                      itineraryService.errorMessage ?? 'Error loading data');
                }

                final itineraryData = itineraryService.getItinerary(widget.id!);
                print(
                    'ItineraryDetailsWidget: Itinerary data from service: $itineraryData');

                if (itineraryData == null) {
                  print(
                      'ItineraryDetailsWidget: No data found for itinerary ${widget.id}');
                  return _buildLoadingState(); // Show loading while data arrives
                }

                return _buildMainContent(itineraryData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(dynamic itineraryData) {
    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(itineraryData),
              SizedBox(height: BukeerSpacing.m),

              // Main grid layout
              Expanded(
                child: _buildGridLayout(itineraryData),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic itineraryData) {
    final itineraryName =
        getJsonField(itineraryData, r'$.name')?.toString() ?? 'Sin nombre';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        BukeerIconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop(),
          variant: BukeerIconButtonVariant.ghost,
          size: BukeerIconButtonSize.large,
        ),
        SizedBox(width: BukeerSpacing.s),

        // Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$itineraryName ✈️',
                style: BukeerTypography.headlineMedium.copyWith(
                  color: isDark
                      ? BukeerColors.textPrimaryDark
                      : BukeerColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Mobile menu button
        if (responsiveVisibility(
          context: context,
          tablet: false,
          desktop: false,
        ))
          BukeerIconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            variant: BukeerIconButtonVariant.ghost,
          ),
      ],
    );
  }

  Widget _buildGridLayout(dynamic itineraryData) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= BukeerBreakpoints.desktop;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content column
              Expanded(
                flex: 2,
                child: _buildContentColumn(itineraryData),
              ),
              SizedBox(width: BukeerSpacing.m),
              // Info column
              SizedBox(
                width: 350,
                child: SingleChildScrollView(
                  child: _buildInfoColumn(itineraryData),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 600,
                  child: _buildContentColumn(itineraryData),
                ),
                SizedBox(height: BukeerSpacing.m),
                _buildInfoColumn(itineraryData),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildContentColumn(dynamic itineraryData) {
    return Column(
      children: [
        // Main tabs
        _buildMainTabs(),

        // Financial info box (only for Items tab)
        if (_selectedMainTab == 0) _buildFinancialInfoBox(itineraryData),

        // Service buttons (only for Items tab)
        if (_selectedMainTab == 0) _buildServiceButtons(),

        // Content section
        Expanded(
          child: _buildContentSection(itineraryData),
        ),
      ],
    );
  }

  Widget _buildMainTabs() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.only(
          topLeft: BukeerBorders.radiusLarge.topLeft,
          topRight: BukeerBorders.radiusLarge.topRight,
        ),
        boxShadow: BukeerShadows.small,
      ),
      child: TabBar(
        controller: _mainTabController,
        isScrollable: true,
        labelColor: BukeerColors.primary,
        unselectedLabelColor: isDark
            ? BukeerColors.textSecondaryDark
            : BukeerColors.textSecondary,
        labelStyle:
            BukeerTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: BukeerTypography.bodyMedium,
        indicatorColor: BukeerColors.primary,
        indicatorWeight: 2,
        labelPadding: EdgeInsets.symmetric(horizontal: BukeerSpacing.l),
        tabs: [
          _buildTab(Icons.list_alt, 'Items'),
          _buildTab(Icons.group, 'Passengers'),
          _buildTab(Icons.visibility, 'Preview'),
          _buildTab(Icons.payments, 'Payments'),
          _buildTab(Icons.storefront, 'Providers'),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      height: 48,
      child: Row(
        children: [
          Icon(icon, size: 19),
          SizedBox(width: BukeerSpacing.s),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildServiceButtons() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
          BukeerSpacing.l, BukeerSpacing.l, BukeerSpacing.l, 0),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        boxShadow: BukeerShadows.subtle,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildServiceButton(Icons.flight, 'Flights', 0),
            SizedBox(width: BukeerSpacing.m),
            _buildServiceButton(Icons.hotel, 'Hotels', 1),
            SizedBox(width: BukeerSpacing.m),
            _buildServiceButton(Icons.room_service, 'Services', 2),
            SizedBox(width: BukeerSpacing.m),
            _buildServiceButton(Icons.directions_car, 'Transfers', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton(IconData icon, String label, int index) {
    final isActive = _selectedServiceTab == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BukeerBorders.radiusSmall,
        onTap: () {
          setState(() {
            _selectedServiceTab = index;
            _servicesTabController.animateTo(index);
          });
        },
        child: AnimatedContainer(
          duration: BukeerAnimations.fast,
          curve: BukeerAnimations.standard,
          padding: EdgeInsets.symmetric(
            horizontal: BukeerSpacing.m,
            vertical: BukeerSpacing.s,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? BukeerColors.primary
                : (isDark
                    ? BukeerColors.surfaceSecondaryDark
                    : BukeerColors.surfaceSecondary),
            borderRadius: BukeerBorders.radiusSmall,
            border: Border.all(
              color: isActive
                  ? BukeerColors.primary
                  : (isDark ? BukeerColors.dividerDark : BukeerColors.divider),
              width: BukeerBorders.widthThin,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 19,
                color: isActive
                    ? Colors.white
                    : (isDark
                        ? BukeerColors.textSecondaryDark
                        : BukeerColors.textSecondary),
              ),
              SizedBox(width: BukeerSpacing.s),
              Text(
                label,
                style: BukeerTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? Colors.white
                      : (isDark
                          ? BukeerColors.textSecondaryDark
                          : BukeerColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(dynamic itineraryData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: BukeerBorders.radiusLarge.bottomLeft,
          bottomRight: BukeerBorders.radiusLarge.bottomRight,
        ),
        boxShadow: BukeerShadows.small,
      ),
      padding: EdgeInsets.all(BukeerSpacing.l),
      child: TabBarView(
        controller: _mainTabController,
        children: [
          _buildItemsTabContent(itineraryData),
          _buildPassengersTabContent(itineraryData),
          _buildPreviewTabContent(),
          _buildPaymentsTabContent(),
          _buildProvidersTabContent(),
        ],
      ),
    );
  }

  Widget _buildItemsTabContent(dynamic itineraryData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get items already filtered by type - OPTIMIZED
    final serviceTypeMap = {
      0: 'vuelos',
      1: 'hoteles',
      2: 'servicios',
      3: 'transporte',
    };

    final selectedType = serviceTypeMap[_selectedServiceTab]!;
    final filteredItems = _itineraryId != null
        ? appServices.itinerary
            .getItineraryItemsByType(_itineraryId!, selectedType)
        : [];

    // Get total for this type directly from service
    final totalAmount = _itineraryId != null
        ? appServices.itinerary
            .getItineraryTotalByType(_itineraryId!, selectedType)
        : 0.0;

    print('ItemsTab: Selected type: $selectedType');
    print('ItemsTab: Filtered items count: ${filteredItems.length}');
    print('ItemsTab: Total amount: $totalAmount');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with total and add button
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isServicesExpanded = !_isServicesExpanded;
                  });
                },
                borderRadius: BukeerBorders.radiusSmall,
                child: Padding(
                  padding: EdgeInsets.all(BukeerSpacing.s),
                  child: Row(
                    children: [
                      Text(
                        'Total ${_getServiceLabel(_selectedServiceTab)} ${_formatCurrency(totalAmount)}',
                        style: BukeerTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: BukeerSpacing.s),
                      Icon(
                        _isServicesExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 22,
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: BukeerSpacing.m),
            BukeerButton(
              text: 'Agregar',
              onPressed: () => _handleAddService(selectedType),
              variant: BukeerButtonVariant.primary,
              size: BukeerButtonSize.small,
              icon: Icons.add,
            ),
          ],
        ),

        if (_isServicesExpanded) ...[
          SizedBox(height: BukeerSpacing.m),
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState(selectedType!)
                : ListView.separated(
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: BukeerSpacing.m),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      switch (selectedType) {
                        case 'vuelos':
                          return _buildFlightCard(item);
                        case 'hoteles':
                          return _buildHotelItemCard(item);
                        case 'servicios':
                          return _buildActivityCard(item);
                        case 'transporte':
                          return _buildTransferCard(item);
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
          ),
        ],
      ],
    );
  }

  // New card builders for real data
  Widget _buildFlightCard(dynamic item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Extract airline data - we need to load it separately if not included
    final airlineId = getJsonField(item, r'$.airline')?.toString();
    final airlineName = getJsonField(item, r'$.airline_name')?.toString() ??
        getJsonField(item, r'$.airline_data.name')?.toString() ??
        'Aerolínea';
    final airlineCode =
        getJsonField(item, r'$.airline_data.iata_code')?.toString() ?? '';
    final airlineLogo =
        getJsonField(item, r'$.airline_data.logo_png')?.toString();

    final flightNumber =
        getJsonField(item, r'$.flight_number')?.toString() ?? '';
    final departure =
        getJsonField(item, r'$.flight_departure')?.toString() ?? '';
    final arrival = getJsonField(item, r'$.flight_arrival')?.toString() ?? '';
    final departureTime =
        getJsonField(item, r'$.departure_time')?.toString() ?? '';
    final arrivalTime = getJsonField(item, r'$.arrival_time')?.toString() ?? '';
    final date = getJsonField(item, r'$.date')?.toString() ?? '';
    final unitPrice = getJsonField(item, r'$.unit_price')?.toDouble() ?? 0;
    final quantity = getJsonField(item, r'$.quantity')?.toInt() ?? 1;
    final totalPrice = getJsonField(item, r'$.total_price')?.toDouble() ?? 0;

    // Extract city codes from departure/arrival strings (e.g., "BOG - Bogotá" -> "BOG")
    final departureCode = departure.split(' - ').first.trim();
    final arrivalCode = arrival.split(' - ').first.trim();
    final departureCity = departure.contains(' - ')
        ? departure.split(' - ').last.trim()
        : departure;
    final arrivalCity =
        arrival.contains(' - ') ? arrival.split(' - ').last.trim() : arrival;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfaceSecondaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark
              ? BukeerColors.borderSecondaryDark
              : BukeerColors.borderSecondary,
          width: BukeerBorders.widthThin,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact header with airline info and status
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: BukeerSpacing.m,
              vertical: BukeerSpacing.s,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? BukeerColors.surfacePrimaryDark.withOpacity(0.5)
                  : BukeerColors.backgroundSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BukeerBorders.radiusMedium.topLeft.x),
                topRight:
                    Radius.circular(BukeerBorders.radiusMedium.topRight.x),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Airline logo - smaller
                      FutureBuilder<List<AirlinesRow>>(
                        future: airlineId != null
                            ? AirlinesTable().queryRows(
                                queryFn: (q) => q.eq('id', airlineId),
                                limit: 1,
                              )
                            : Future.value([]),
                        builder: (context, snapshot) {
                          String? logoUrl;
                          String? name;

                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            final airline = snapshot.data!.first;
                            logoUrl = airline.logoPng;
                            name = airline.name;
                          }

                          return Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BukeerBorders.radiusSmall,
                              border: Border.all(
                                color: isDark
                                    ? BukeerColors.dividerDark
                                    : BukeerColors.divider,
                                width: 0.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BukeerBorders.radiusSmall,
                              child: (logoUrl ?? airlineLogo) != null &&
                                      (logoUrl ?? airlineLogo)!.isNotEmpty
                                  ? Image.network(
                                      logoUrl ?? airlineLogo!,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.airlines,
                                          size: 20,
                                          color: BukeerColors.primary,
                                        );
                                      },
                                    )
                                  : Icon(
                                      Icons.airlines,
                                      size: 20,
                                      color: BukeerColors.primary,
                                    ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: BukeerSpacing.s),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                airlineName,
                                style: BukeerTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? BukeerColors.textPrimaryDark
                                      : BukeerColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (flightNumber.isNotEmpty) ...[
                              SizedBox(width: BukeerSpacing.s),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: BukeerSpacing.xs,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: BukeerColors.primary.withOpacity(0.1),
                                  borderRadius: BukeerBorders.radiusSmall,
                                ),
                                child: Text(
                                  flightNumber,
                                  style: BukeerTypography.labelSmall.copyWith(
                                    color: BukeerColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(width: BukeerSpacing.s),
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                            SizedBox(width: BukeerSpacing.xs),
                            Text(
                              _formatDate(date),
                              style: BukeerTypography.labelSmall.copyWith(
                                color: isDark
                                    ? BukeerColors.textSecondaryDark
                                    : BukeerColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _handleEditService(item, 'flight'),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: BukeerColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: BukeerSpacing.xs),
                    InkWell(
                      onTap: () =>
                          _showDeleteConfirmationDialog(item, 'flight'),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete,
                          size: 16,
                          color: BukeerColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Compact route information
          Container(
            padding: EdgeInsets.all(BukeerSpacing.m),
            child: Row(
              children: [
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureCode,
                        style: BukeerTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary,
                        ),
                      ),
                      Text(
                        departureCity,
                        style: BukeerTypography.labelSmall.copyWith(
                          color: isDark
                              ? BukeerColors.textSecondaryDark
                              : BukeerColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: BukeerSpacing.xs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: BukeerSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? BukeerColors.backgroundDarkSecondary
                              : BukeerColors.backgroundSecondary,
                          borderRadius: BukeerBorders.radiusSmall,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              departureTime.isEmpty ? '--:--' : departureTime,
                              style: BukeerTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? BukeerColors.textPrimaryDark
                                    : BukeerColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Compact flight path
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: BukeerSpacing.s),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  BukeerColors.primary.withOpacity(0.3),
                                  BukeerColors.primary,
                                  BukeerColors.primary.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? BukeerColors.surfaceSecondaryDark
                                  : BukeerColors.surfacePrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.flight_takeoff,
                              size: 16,
                              color: BukeerColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Directo',
                        style: BukeerTypography.labelSmall.copyWith(
                          fontSize: 10,
                          color: isDark
                              ? BukeerColors.textSecondaryDark
                              : BukeerColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalCode,
                        style: BukeerTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary,
                        ),
                      ),
                      Text(
                        arrivalCity,
                        style: BukeerTypography.labelSmall.copyWith(
                          color: isDark
                              ? BukeerColors.textSecondaryDark
                              : BukeerColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: BukeerSpacing.xs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: BukeerSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? BukeerColors.backgroundDarkSecondary
                              : BukeerColors.backgroundSecondary,
                          borderRadius: BukeerBorders.radiusSmall,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              arrivalTime.isEmpty ? '--:--' : arrivalTime,
                              style: BukeerTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? BukeerColors.textPrimaryDark
                                    : BukeerColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Compact pricing footer
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: BukeerSpacing.m,
              vertical: BukeerSpacing.s,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? BukeerColors.backgroundDark.withOpacity(0.3)
                  : BukeerColors.backgroundSecondary.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(BukeerBorders.radiusMedium.bottomLeft.x),
                bottomRight:
                    Radius.circular(BukeerBorders.radiusMedium.bottomRight.x),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: BukeerColors.primary.withOpacity(0.1),
                        borderRadius: BukeerBorders.radiusSmall,
                      ),
                      child: Icon(
                        Icons.people,
                        size: 14,
                        color: BukeerColors.primary,
                      ),
                    ),
                    SizedBox(width: BukeerSpacing.xs),
                    Text(
                      '$quantity ${quantity > 1 ? "pax" : "pax"}',
                      style: BukeerTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? BukeerColors.textPrimaryDark
                            : BukeerColors.textPrimary,
                      ),
                    ),
                    Text(
                      ' • ${_formatCurrency(unitPrice)} c/u',
                      style: BukeerTypography.labelSmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Total: ',
                      style: BukeerTypography.labelSmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatCurrency(totalPrice),
                      style: BukeerTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: BukeerColors.primary,
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

  Widget _buildHotelItemCard(dynamic item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = getJsonField(item, r'$.product_name')?.toString() ?? 'Hotel';
    final rateName = getJsonField(item, r'$.rate_name')?.toString() ?? '';
    final providerName =
        getJsonField(item, r'$.provider_name')?.toString() ?? '';
    final destination = getJsonField(item, r'$.destination')?.toString() ?? '';
    final date = getJsonField(item, r'$.date')?.toString() ?? '';
    final nights = getJsonField(item, r'$.hotel_nights')?.toInt() ?? 1;
    final quantity = getJsonField(item, r'$.quantity')?.toInt() ?? 1;
    final unitCost = getJsonField(item, r'$.unit_cost')?.toDouble() ?? 0;
    final profitPercentage =
        getJsonField(item, r'$.profit_percentage')?.toDouble() ?? 0;
    final unitPrice = getJsonField(item, r'$.unit_price')?.toDouble() ?? 0;
    final totalPrice = getJsonField(item, r'$.total_price')?.toDouble() ?? 0;

    // Calculate check-out date
    DateTime checkIn = DateTime.parse(date);
    DateTime checkOut = checkIn.add(Duration(days: nights));

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfaceSecondaryDark
            : BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          width: BukeerBorders.widthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel image with fallback
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BukeerBorders.radiusSmall,
              color: isDark
                  ? BukeerColors.surfacePrimaryDark
                  : BukeerColors.surfaceSecondary,
            ),
            child: ClipRRect(
              borderRadius: BukeerBorders.radiusSmall,
              child: () {
                // Try to get image from different possible fields
                final mainImage =
                    getJsonField(item, r'$.main_image')?.toString();
                final productMainImage =
                    getJsonField(item, r'$.product_main_image')?.toString();
                final hotelMainImage =
                    getJsonField(item, r'$.hotel_main_image')?.toString();
                final imageUrl =
                    mainImage ?? productMainImage ?? hotelMainImage;

                if (imageUrl != null && imageUrl.isNotEmpty) {
                  return Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder(Icons.hotel, isDark);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            BukeerColors.primary,
                          ),
                        ),
                      );
                    },
                  );
                }
                return _buildImagePlaceholder(Icons.hotel, isDark);
              }(),
            ),
          ),
          SizedBox(width: BukeerSpacing.m),

          // Hotel info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: BukeerTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? BukeerColors.textPrimaryDark
                                  : BukeerColors.textPrimary,
                            ),
                          ),
                          if (rateName.isNotEmpty) ...[
                            SizedBox(height: BukeerSpacing.xs),
                            Text(
                              rateName,
                              style: BukeerTypography.bodySmall.copyWith(
                                color: isDark
                                    ? BukeerColors.textSecondaryDark
                                    : BukeerColors.textSecondary,
                              ),
                            ),
                          ],
                          // Provider info
                          if (providerName.isNotEmpty) ...[
                            SizedBox(height: BukeerSpacing.xs),
                            Row(
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 14,
                                  color: isDark
                                      ? BukeerColors.textSecondaryDark
                                      : BukeerColors.textSecondary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  providerName,
                                  style: BukeerTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? BukeerColors.textSecondaryDark
                                        : BukeerColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Actions
                        InkWell(
                          onTap: () => _handleEditService(item, 'hotel'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: BukeerColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: BukeerSpacing.xs),
                        InkWell(
                          onTap: () =>
                              _showDeleteConfirmationDialog(item, 'hotel'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: BukeerColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: BukeerSpacing.m),

                // Meta info
                Wrap(
                  spacing: BukeerSpacing.m,
                  runSpacing: BukeerSpacing.s,
                  children: [
                    if (destination.isNotEmpty)
                      _buildHotelMetaItem(Icons.location_on, destination),
                    _buildHotelMetaItem(Icons.calendar_today,
                        '${_formatDate(date)} - ${_formatDate(checkOut.toString())}'),
                    _buildHotelMetaItem(Icons.nights_stay, '$nights noches'),
                    _buildHotelMetaItem(
                        Icons.meeting_room, '$quantity habitaciones'),
                  ],
                ),

                // Pricing
                Container(
                  margin: EdgeInsets.only(top: BukeerSpacing.m),
                  padding: EdgeInsets.only(top: BukeerSpacing.m),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? BukeerColors.dividerDark
                            : BukeerColors.divider,
                        width: BukeerBorders.widthThin,
                      ),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 400) {
                        // Mobile layout - vertical
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: BukeerSpacing.s,
                              runSpacing: BukeerSpacing.s,
                              children: [
                                _buildPriceItem(
                                    Icons.sell, _formatCurrency(unitCost)),
                                Text('|',
                                    style: TextStyle(
                                        color: isDark
                                            ? BukeerColors.dividerDark
                                            : BukeerColors.divider)),
                                _buildPriceItem(Icons.trending_up,
                                    '${profitPercentage.toInt()}%'),
                                Text('|',
                                    style: TextStyle(
                                        color: isDark
                                            ? BukeerColors.dividerDark
                                            : BukeerColors.divider)),
                                _buildPriceItem(Icons.request_quote,
                                    _formatCurrency(unitPrice)),
                              ],
                            ),
                            SizedBox(height: BukeerSpacing.m),
                            Row(
                              children: [
                                Icon(
                                  Icons.paid,
                                  size: 18,
                                  color: BukeerColors.primary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  _formatCurrency(totalPrice),
                                  style: BukeerTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: BukeerColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Desktop layout - horizontal
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Wrap(
                                spacing: BukeerSpacing.s,
                                runSpacing: BukeerSpacing.s,
                                children: [
                                  _buildPriceItem(
                                      Icons.sell, _formatCurrency(unitCost)),
                                  Text('|',
                                      style: TextStyle(
                                          color: isDark
                                              ? BukeerColors.dividerDark
                                              : BukeerColors.divider)),
                                  _buildPriceItem(Icons.trending_up,
                                      '${profitPercentage.toInt()}%'),
                                  Text('|',
                                      style: TextStyle(
                                          color: isDark
                                              ? BukeerColors.dividerDark
                                              : BukeerColors.divider)),
                                  _buildPriceItem(Icons.request_quote,
                                      _formatCurrency(unitPrice)),
                                ],
                              ),
                            ),
                            SizedBox(width: BukeerSpacing.m),
                            Row(
                              children: [
                                Icon(
                                  Icons.paid,
                                  size: 18,
                                  color: BukeerColors.primary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  _formatCurrency(totalPrice),
                                  style: BukeerTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: BukeerColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(dynamic item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name =
        getJsonField(item, r'$.product_name')?.toString() ?? 'Actividad';
    final rateName = getJsonField(item, r'$.rate_name')?.toString() ?? '';
    final providerName =
        getJsonField(item, r'$.provider_name')?.toString() ?? '';
    final destination = getJsonField(item, r'$.destination')?.toString() ?? '';
    final date = getJsonField(item, r'$.date')?.toString() ?? '';
    final startTime = getJsonField(item, r'$.start_time')?.toString() ?? '';
    final quantity = getJsonField(item, r'$.quantity')?.toInt() ?? 1;
    final unitCost = getJsonField(item, r'$.unit_cost')?.toDouble() ?? 0;
    final unitPrice = getJsonField(item, r'$.unit_price')?.toDouble() ?? 0;
    final totalPrice = getJsonField(item, r'$.total_price')?.toDouble() ?? 0;
    final profitPercentage =
        getJsonField(item, r'$.profit_percentage')?.toDouble() ?? 0;
    final reservationStatus =
        getJsonField(item, r'$.reservation_status') ?? false;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfaceSecondaryDark
            : BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          width: BukeerBorders.widthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity image with fallback
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BukeerBorders.radiusSmall,
              color: isDark
                  ? BukeerColors.surfacePrimaryDark
                  : BukeerColors.surfaceSecondary,
            ),
            child: ClipRRect(
              borderRadius: BukeerBorders.radiusSmall,
              child: () {
                // Try to get image from different possible fields
                final mainImage =
                    getJsonField(item, r'$.main_image')?.toString();
                final productMainImage =
                    getJsonField(item, r'$.product_main_image')?.toString();
                final activityMainImage =
                    getJsonField(item, r'$.activity_main_image')?.toString();
                final imageUrl =
                    mainImage ?? productMainImage ?? activityMainImage;

                if (imageUrl != null && imageUrl.isNotEmpty) {
                  return Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder(
                          Icons.local_activity, isDark);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            BukeerColors.primary,
                          ),
                        ),
                      );
                    },
                  );
                }
                return _buildImagePlaceholder(Icons.local_activity, isDark);
              }(),
            ),
          ),
          SizedBox(width: BukeerSpacing.m),

          // Activity info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: BukeerTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? BukeerColors.textPrimaryDark
                                  : BukeerColors.textPrimary,
                            ),
                          ),
                          if (rateName.isNotEmpty) ...[
                            SizedBox(height: BukeerSpacing.xs),
                            Text(
                              rateName,
                              style: BukeerTypography.bodySmall.copyWith(
                                color: isDark
                                    ? BukeerColors.textSecondaryDark
                                    : BukeerColors.textSecondary,
                              ),
                            ),
                          ],
                          // Provider info
                          if (providerName.isNotEmpty) ...[
                            SizedBox(height: BukeerSpacing.xs),
                            Row(
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 14,
                                  color: isDark
                                      ? BukeerColors.textSecondaryDark
                                      : BukeerColors.textSecondary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  providerName,
                                  style: BukeerTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? BukeerColors.textSecondaryDark
                                        : BukeerColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Actions
                        InkWell(
                          onTap: () => _handleEditService(item, 'activity'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: BukeerColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: BukeerSpacing.xs),
                        InkWell(
                          onTap: () =>
                              _showDeleteConfirmationDialog(item, 'activity'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: BukeerColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: BukeerSpacing.m),

                // Meta info
                Wrap(
                  spacing: BukeerSpacing.m,
                  runSpacing: BukeerSpacing.s,
                  children: [
                    if (destination.isNotEmpty)
                      _buildHotelMetaItem(Icons.location_on, destination),
                    _buildHotelMetaItem(
                        Icons.calendar_today, _formatDate(date)),
                    if (startTime.isNotEmpty)
                      _buildHotelMetaItem(Icons.access_time, startTime),
                    _buildHotelMetaItem(Icons.people, '$quantity personas'),
                  ],
                ),

                // Pricing
                Container(
                  margin: EdgeInsets.only(top: BukeerSpacing.m),
                  padding: EdgeInsets.only(top: BukeerSpacing.m),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? BukeerColors.dividerDark
                            : BukeerColors.divider,
                        width: BukeerBorders.widthThin,
                      ),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 400) {
                        // Mobile layout - vertical
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: BukeerSpacing.s,
                              runSpacing: BukeerSpacing.s,
                              children: [
                                _buildPriceItem(
                                    Icons.sell, _formatCurrency(unitCost)),
                                Text('|',
                                    style: TextStyle(
                                        color: isDark
                                            ? BukeerColors.dividerDark
                                            : BukeerColors.divider)),
                                _buildPriceItem(Icons.trending_up,
                                    '${profitPercentage.toInt()}%'),
                                Text('|',
                                    style: TextStyle(
                                        color: isDark
                                            ? BukeerColors.dividerDark
                                            : BukeerColors.divider)),
                                _buildPriceItem(Icons.request_quote,
                                    _formatCurrency(unitPrice)),
                              ],
                            ),
                            SizedBox(height: BukeerSpacing.m),
                            Row(
                              children: [
                                Icon(
                                  Icons.paid,
                                  size: 18,
                                  color: BukeerColors.primary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  _formatCurrency(totalPrice),
                                  style: BukeerTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: BukeerColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Desktop layout - horizontal
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Wrap(
                                spacing: BukeerSpacing.s,
                                runSpacing: BukeerSpacing.s,
                                children: [
                                  _buildPriceItem(
                                      Icons.sell, _formatCurrency(unitCost)),
                                  Text('|',
                                      style: TextStyle(
                                          color: isDark
                                              ? BukeerColors.dividerDark
                                              : BukeerColors.divider)),
                                  _buildPriceItem(Icons.trending_up,
                                      '${profitPercentage.toInt()}%'),
                                  Text('|',
                                      style: TextStyle(
                                          color: isDark
                                              ? BukeerColors.dividerDark
                                              : BukeerColors.divider)),
                                  _buildPriceItem(Icons.request_quote,
                                      _formatCurrency(unitPrice)),
                                ],
                              ),
                            ),
                            SizedBox(width: BukeerSpacing.m),
                            Row(
                              children: [
                                Icon(
                                  Icons.paid,
                                  size: 18,
                                  color: BukeerColors.primary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  _formatCurrency(totalPrice),
                                  style: BukeerTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: BukeerColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferCard(dynamic item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name =
        getJsonField(item, r'$.product_name')?.toString() ?? 'Traslado';
    final date = getJsonField(item, r'$.date')?.toString() ?? '';
    final startTime = getJsonField(item, r'$.start_time')?.toString() ?? '';
    final quantity = getJsonField(item, r'$.quantity')?.toInt() ?? 1;
    final unitPrice = getJsonField(item, r'$.unit_price')?.toDouble() ?? 0;
    final totalPrice = getJsonField(item, r'$.total_price')?.toDouble() ?? 0;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfaceSecondaryDark
            : BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          width: BukeerBorders.widthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transfer image with fallback
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BukeerBorders.radiusSmall,
              color: isDark
                  ? BukeerColors.surfacePrimaryDark
                  : BukeerColors.surfaceSecondary,
            ),
            child: ClipRRect(
              borderRadius: BukeerBorders.radiusSmall,
              child: () {
                // Try to get image from different possible fields
                final mainImage =
                    getJsonField(item, r'$.main_image')?.toString();
                final productMainImage =
                    getJsonField(item, r'$.product_main_image')?.toString();
                final transferMainImage =
                    getJsonField(item, r'$.transfer_main_image')?.toString();
                final imageUrl =
                    mainImage ?? productMainImage ?? transferMainImage;

                if (imageUrl != null && imageUrl.isNotEmpty) {
                  return Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.directions_car,
                        size: 30,
                        color: isDark
                            ? BukeerColors.textTertiaryDark
                            : BukeerColors.textTertiary,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            BukeerColors.primary,
                          ),
                        ),
                      );
                    },
                  );
                }
                return Icon(
                  Icons.directions_car,
                  size: 30,
                  color: isDark
                      ? BukeerColors.textTertiaryDark
                      : BukeerColors.textTertiary,
                );
              }(),
            ),
          ),
          SizedBox(width: BukeerSpacing.m),

          // Transfer info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: BukeerTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Actions
                        InkWell(
                          onTap: () => _handleEditService(item, 'transfer'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: BukeerColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: BukeerSpacing.xs),
                        InkWell(
                          onTap: () =>
                              _showDeleteConfirmationDialog(item, 'transfer'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: BukeerColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: BukeerSpacing.s),

                // Meta info
                Wrap(
                  spacing: BukeerSpacing.l,
                  runSpacing: BukeerSpacing.s,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: isDark
                              ? BukeerColors.textTertiaryDark
                              : BukeerColors.textTertiary,
                        ),
                        SizedBox(width: BukeerSpacing.xs),
                        Text(
                          _formatDate(date),
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (startTime.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: isDark
                                ? BukeerColors.textTertiaryDark
                                : BukeerColors.textTertiary,
                          ),
                          SizedBox(width: BukeerSpacing.xs),
                          Text(
                            startTime,
                            style: BukeerTypography.bodySmall.copyWith(
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: 16,
                          color: isDark
                              ? BukeerColors.textTertiaryDark
                              : BukeerColors.textTertiary,
                        ),
                        SizedBox(width: BukeerSpacing.xs),
                        Text(
                          '$quantity ${quantity > 1 ? "vehículos" : "vehículo"}',
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Pricing
                Container(
                  margin: EdgeInsets.only(top: BukeerSpacing.m),
                  padding: EdgeInsets.only(top: BukeerSpacing.m),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? BukeerColors.dividerDark
                            : BukeerColors.divider,
                        width: BukeerBorders.widthThin,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatCurrency(unitPrice)} x $quantity',
                        style: BukeerTypography.bodySmall.copyWith(
                          color: isDark
                              ? BukeerColors.textSecondaryDark
                              : BukeerColors.textSecondary,
                        ),
                      ),
                      Text(
                        _formatCurrency(totalPrice),
                        style: BukeerTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: BukeerColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Renamed old method
  Widget _buildHotelCardOld({
    required String name,
    required String provider,
    required String roomType,
    required String dates,
    required String location,
    required int nights,
    required int rooms,
    required double nightRate,
    required double markup,
    required double value,
    required double total,
    required String imageUrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfaceSecondaryDark
            : BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          width: BukeerBorders.widthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel image
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BukeerBorders.radiusSmall,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: BukeerSpacing.m),

          // Hotel info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: BukeerTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? BukeerColors.textPrimaryDark
                                : BukeerColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: BukeerSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.store,
                              size: 15,
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                            SizedBox(width: BukeerSpacing.xs),
                            Text(
                              provider,
                              style: BukeerTypography.bodySmall.copyWith(
                                color: isDark
                                    ? BukeerColors.textSecondaryDark
                                    : BukeerColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: BukeerSpacing.m),

                // Meta info
                Wrap(
                  spacing: BukeerSpacing.m,
                  runSpacing: BukeerSpacing.s,
                  children: [
                    _buildHotelMetaItem(Icons.king_bed, roomType),
                    _buildHotelMetaItem(Icons.date_range, dates),
                    _buildHotelMetaItem(Icons.location_on, location),
                    _buildHotelMetaItem(Icons.night_shelter, '$nights'),
                    _buildHotelMetaItem(Icons.meeting_room, '$rooms'),
                  ],
                ),
                SizedBox(height: BukeerSpacing.m),

                // Pricing
                Container(
                  padding: EdgeInsets.only(top: BukeerSpacing.m),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? BukeerColors.dividerDark
                            : BukeerColors.divider,
                        width: BukeerBorders.widthThin,
                      ),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Mobile layout - vertical
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: BukeerSpacing.s,
                              runSpacing: BukeerSpacing.s,
                              children: [
                                _buildPriceItem(
                                    Icons.sell, _formatCurrency(nightRate)),
                                Text('|',
                                    style: TextStyle(
                                        color: isDark
                                            ? BukeerColors.dividerDark
                                            : BukeerColors.divider)),
                                _buildPriceItem(
                                    Icons.trending_up, '${markup.toInt()}%'),
                                Text('|',
                                    style: TextStyle(
                                        color: isDark
                                            ? BukeerColors.dividerDark
                                            : BukeerColors.divider)),
                                _buildPriceItem(Icons.request_quote,
                                    _formatCurrency(value)),
                              ],
                            ),
                            SizedBox(height: BukeerSpacing.m),
                            Row(
                              children: [
                                Icon(
                                  Icons.paid,
                                  size: 18,
                                  color: BukeerColors.primary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  _formatCurrency(total),
                                  style: BukeerTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: BukeerColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Desktop layout - horizontal
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Wrap(
                                spacing: BukeerSpacing.s,
                                runSpacing: BukeerSpacing.s,
                                children: [
                                  _buildPriceItem(
                                      Icons.sell, _formatCurrency(nightRate)),
                                  Text('|',
                                      style: TextStyle(
                                          color: isDark
                                              ? BukeerColors.dividerDark
                                              : BukeerColors.divider)),
                                  _buildPriceItem(
                                      Icons.trending_up, '${markup.toInt()}%'),
                                  Text('|',
                                      style: TextStyle(
                                          color: isDark
                                              ? BukeerColors.dividerDark
                                              : BukeerColors.divider)),
                                  _buildPriceItem(Icons.request_quote,
                                      _formatCurrency(value)),
                                ],
                              ),
                            ),
                            SizedBox(width: BukeerSpacing.m),
                            Row(
                              children: [
                                Icon(
                                  Icons.paid,
                                  size: 18,
                                  color: BukeerColors.primary,
                                ),
                                SizedBox(width: BukeerSpacing.xs),
                                Text(
                                  _formatCurrency(total),
                                  style: BukeerTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: BukeerColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelMetaItem(IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 17,
          color: isDark
              ? BukeerColors.textTertiaryDark
              : BukeerColors.textTertiary,
        ),
        SizedBox(width: BukeerSpacing.xs),
        Text(
          text,
          style: BukeerTypography.bodySmall.copyWith(
            color: isDark
                ? BukeerColors.textPrimaryDark
                : BukeerColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceItem(IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: isDark
              ? BukeerColors.textTertiaryDark
              : BukeerColors.textTertiary,
        ),
        SizedBox(width: BukeerSpacing.xs),
        Text(
          text,
          style: BukeerTypography.bodySmall.copyWith(
            color: isDark
                ? BukeerColors.textPrimaryDark
                : BukeerColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPassengersTabContent(dynamic itineraryData) {
    final passengers = _itineraryId != null
        ? appServices.itinerary.getItineraryPassengers(_itineraryId!)
        : [];

    return ItineraryPassengersSection(
      itineraryId: _itineraryId ?? '',
      passengers: passengers,
      onAddPassenger: _handleAddPassenger,
      onEditPassenger: (passenger) {},
      onDeletePassenger: (passenger) {},
    );
  }

  Widget _buildPreviewTabContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility,
            size: 64,
            color: isDark
                ? BukeerColors.textTertiaryDark
                : BukeerColors.textTertiary,
          ),
          SizedBox(height: BukeerSpacing.m),
          Text(
            'Vista previa del itinerario',
            style: BukeerTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? BukeerColors.textPrimaryDark
                  : BukeerColors.textPrimary,
            ),
          ),
          SizedBox(height: BukeerSpacing.s),
          Text(
            'Genera una vista previa para compartir con el cliente',
            style: BukeerTypography.bodyMedium.copyWith(
              color: isDark
                  ? BukeerColors.textSecondaryDark
                  : BukeerColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTabContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get itinerary data
    final itineraryData = _itineraryId != null
        ? appServices.itinerary.getItinerary(_itineraryId!)
        : null;

    // Get financial data from itinerary
    final totalPrice =
        getJsonField(itineraryData, r'$.total_amount')?.toDouble() ?? 0.0;
    final totalCost =
        getJsonField(itineraryData, r'$.total_cost')?.toDouble() ?? 0.0;
    final profit = totalPrice - totalCost;

    return FutureBuilder<List<dynamic>>(
      future: _itineraryId != null
          ? SupaFlow.client
              .from('transactions')
              .select()
              .eq('id_itinerary', _itineraryId!)
              .order('created_at', ascending: false)
          : Future.value([]),
      builder: (context, snapshot) {
        List<dynamic> transactions = snapshot.data ?? [];

        // Calculate payments
        double totalPaid = 0;
        double totalPaidToProviders = 0;
        for (var transaction in transactions) {
          final type = getJsonField(transaction, r'$.type')?.toString() ?? '';
          final value = getJsonField(transaction, r'$.value')?.toDouble() ?? 0;

          if (type == 'ingreso') {
            totalPaid += value;
          } else if (type == 'egreso') {
            totalPaidToProviders += value;
          }
        }
        double pendingPayment = totalPrice - totalPaid;
        double pendingToProviders = totalCost - totalPaidToProviders;

        return Column(
          children: [
            // Financial summary
            Container(
              padding: EdgeInsets.all(BukeerSpacing.l),
              decoration: BoxDecoration(
                color: isDark
                    ? BukeerColors.surfaceSecondaryDark
                    : BukeerColors.backgroundPrimary,
                borderRadius: BukeerBorders.radiusMedium,
                border: Border.all(
                  color:
                      isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                  width: BukeerBorders.widthThin,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen Financiero',
                    style: BukeerTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? BukeerColors.textPrimaryDark
                          : BukeerColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: BukeerSpacing.m),
                  // Summary grid - Simplified as requested
                  Wrap(
                    spacing: BukeerSpacing.xl,
                    runSpacing: BukeerSpacing.m,
                    children: [
                      _buildFinancialSummaryItem(
                        'Total',
                        _formatCurrency(totalPrice),
                        Icons.attach_money,
                        BukeerColors.primary,
                      ),
                      _buildFinancialSummaryItem(
                        'Valor Pagado',
                        _formatCurrency(totalPaid),
                        Icons.check_circle,
                        BukeerColors.success,
                      ),
                      _buildFinancialSummaryItem(
                        'Saldo Pendiente',
                        _formatCurrency(pendingPayment),
                        Icons.pending,
                        pendingPayment > 0
                            ? BukeerColors.warning
                            : BukeerColors.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: BukeerSpacing.l),

            // Transactions header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transacciones',
                  style: BukeerTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? BukeerColors.textPrimaryDark
                        : BukeerColors.textPrimary,
                  ),
                ),
                BukeerButton(
                  text: 'Registrar pago',
                  onPressed: _handleAddPayment,
                  variant: BukeerButtonVariant.primary,
                  size: BukeerButtonSize.small,
                  icon: Icons.add,
                ),
              ],
            ),

            SizedBox(height: BukeerSpacing.m),

            // Transactions list
            Expanded(
              child: transactions.isEmpty
                  ? _buildEmptyTransactionsState()
                  : ListView.separated(
                      itemCount: transactions.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: BukeerSpacing.m),
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return _buildTransactionCard(transaction);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProvidersTabContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get itinerary items to extract providers
    final items = _itineraryId != null
        ? appServices.itinerary.getItineraryItems(_itineraryId!)
        : [];

    // Extract unique providers from items
    Map<String, Map<String, dynamic>> providersMap = {};
    for (var item in items) {
      final productType =
          getJsonField(item, r'$.product_type')?.toString() ?? '';
      final productId = getJsonField(item, r'$.id_product')?.toString() ?? '';

      // Get provider info based on product type
      if (productId.isNotEmpty) {
        // For now, we'll create a provider entry based on item data
        // In a real implementation, we'd fetch the actual provider data from contacts table
        final providerName =
            getJsonField(item, r'$.product_name')?.toString() ?? 'Proveedor';
        final key = '$productType-$productId';

        if (!providersMap.containsKey(key)) {
          providersMap[key] = {
            'name': providerName,
            'type': productType,
            'itemCount': 1,
            'totalCost': getJsonField(item, r'$.total_cost')?.toDouble() ?? 0,
            'items': [item],
          };
        } else {
          providersMap[key]!['itemCount'] = providersMap[key]!['itemCount'] + 1;
          providersMap[key]!['totalCost'] = providersMap[key]!['totalCost'] +
              (getJsonField(item, r'$.total_cost')?.toDouble() ?? 0);
          providersMap[key]!['items'].add(item);
        }
      }
    }

    final providers = providersMap.values.toList();

    if (providers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront,
              size: 64,
              color: isDark
                  ? BukeerColors.textTertiaryDark
                  : BukeerColors.textTertiary,
            ),
            SizedBox(height: BukeerSpacing.m),
            Text(
              'No hay proveedores en este itinerario',
              style: BukeerTypography.titleMedium.copyWith(
                color: isDark
                    ? BukeerColors.textSecondaryDark
                    : BukeerColors.textSecondary,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            Text(
              'Los proveedores aparecerán cuando agregues servicios',
              style: BukeerTypography.bodyMedium.copyWith(
                color: isDark
                    ? BukeerColors.textTertiaryDark
                    : BukeerColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(bottom: BukeerSpacing.m),
          child: Text(
            'Proveedores del Itinerario',
            style: BukeerTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? BukeerColors.textPrimaryDark
                  : BukeerColors.textPrimary,
            ),
          ),
        ),

        // Providers list
        Expanded(
          child: ListView.separated(
            itemCount: providers.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: BukeerSpacing.m),
            itemBuilder: (context, index) {
              final provider = providers[index];
              return _buildProviderCard(provider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(dynamic itineraryData) {
    return Column(
      children: [
        // User info
        _buildUserInfoBox(itineraryData),
        SizedBox(height: BukeerSpacing.m),

        // Itinerary info
        _buildItineraryInfoBox(itineraryData),
        SizedBox(height: BukeerSpacing.m),

        // Actions (previously Financial info)
        _buildActionsBox(itineraryData),
      ],
    );
  }

  Widget _buildUserInfoBox(dynamic itineraryData) {
    final createdById =
        getJsonField(itineraryData, r'$.id_created_by')?.toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (createdById == null || createdById.isEmpty) {
      return _buildUserInfoBoxPlaceholder('Sin asignar', itineraryData);
    }

    return FutureBuilder<ApiCallResponse>(
      future: GetAgentCall.call(
        authToken: currentJwtToken,
        id: createdById,
        accountIdParam: appServices.account.accountId ?? '',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildUserInfoBoxLoading();
        }

        if (!snapshot.hasData || !snapshot.data!.succeeded) {
          return _buildUserInfoBoxPlaceholder('Error al cargar', itineraryData);
        }

        final agentData = snapshot.data!.jsonBody;
        final agentsList = getJsonField(agentData, r'$[:]');

        if (agentsList == null || (agentsList is List && agentsList.isEmpty)) {
          return _buildUserInfoBoxPlaceholder(
              'Usuario no encontrado', itineraryData);
        }

        // Get first agent from the list
        final agent = agentsList is List ? agentsList.first : agentsList;
        final name = getJsonField(agent, r'$.name')?.toString() ?? '';
        final lastName = getJsonField(agent, r'$.last_name')?.toString() ?? '';
        final fullName = '$name $lastName'.trim();
        final mainImage = getJsonField(agent, r'$.main_image')?.toString();
        final email = getJsonField(agent, r'$.email')?.toString() ?? '';

        return Container(
          padding: EdgeInsets.all(BukeerSpacing.m),
          decoration: BoxDecoration(
            color: isDark
                ? BukeerColors.surfacePrimaryDark
                : BukeerColors.surfacePrimary,
            borderRadius: BukeerBorders.radiusLarge,
            boxShadow: BukeerShadows.small,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Travel Planner',
                style: BukeerTypography.labelMedium.copyWith(
                  color: isDark
                      ? BukeerColors.textSecondaryDark
                      : BukeerColors.textSecondary,
                ),
              ),
              SizedBox(height: BukeerSpacing.s),
              Row(
                children: [
                  // Profile image or placeholder
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BukeerBorders.radiusFull,
                      border: Border.all(
                        color: BukeerColors.primary,
                        width: BukeerBorders.widthMedium,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BukeerBorders.radiusFull,
                      child: mainImage != null && mainImage.isNotEmpty
                          ? Image.network(
                              mainImage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: BukeerColors.primary.withOpacity(0.1),
                                  child: Center(
                                    child: Text(
                                      fullName.isNotEmpty
                                          ? fullName[0].toUpperCase()
                                          : 'U',
                                      style:
                                          BukeerTypography.titleMedium.copyWith(
                                        color: BukeerColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: BukeerColors.primary.withOpacity(0.1),
                              child: Center(
                                child: Text(
                                  fullName.isNotEmpty
                                      ? fullName[0].toUpperCase()
                                      : 'U',
                                  style: BukeerTypography.titleMedium.copyWith(
                                    color: BukeerColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: BukeerSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isNotEmpty ? fullName : 'Sin nombre',
                          style: BukeerTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? BukeerColors.textPrimaryDark
                                : BukeerColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: BukeerSpacing.xs),
                        Text(
                          email,
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Change owner button
              BukeerIconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () => _handleChangeOwner(itineraryData),
                variant: BukeerIconButtonVariant.ghost,
                size: BukeerIconButtonSize.small,
                tooltip: 'Cambiar propietario',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfoBoxPlaceholder(String message, dynamic itineraryData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BukeerBorders.radiusLarge,
        boxShadow: BukeerShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travel Planner',
            style: BukeerTypography.labelMedium.copyWith(
              color: isDark
                  ? BukeerColors.textSecondaryDark
                  : BukeerColors.textSecondary,
            ),
          ),
          SizedBox(height: BukeerSpacing.s),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BukeerBorders.radiusFull,
                  border: Border.all(
                    color: BukeerColors.textTertiary,
                    width: BukeerBorders.widthMedium,
                  ),
                  color: BukeerColors.textTertiary.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: BukeerColors.textTertiary,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: BukeerSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: BukeerTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? BukeerColors.textPrimaryDark
                            : BukeerColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: BukeerSpacing.xs),
                    Text(
                      'No hay propietario asignado',
                      style: BukeerTypography.bodySmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Change owner button
          BukeerIconButton(
            icon: Icon(Icons.person_add),
            onPressed: () => _handleChangeOwner(itineraryData),
            variant: BukeerIconButtonVariant.ghost,
            size: BukeerIconButtonSize.small,
            tooltip: 'Asignar propietario',
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoBoxLoading() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BukeerBorders.radiusLarge,
        boxShadow: BukeerShadows.small,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BukeerBorders.radiusFull,
              color: BukeerColors.primary.withOpacity(0.1),
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(BukeerColors.primary),
                ),
              ),
            ),
          ),
          SizedBox(width: BukeerSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isDark
                        ? BukeerColors.dividerDark
                        : BukeerColors.divider,
                    borderRadius: BukeerBorders.radiusSmall,
                  ),
                ),
                SizedBox(height: BukeerSpacing.xs),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark
                        ? BukeerColors.dividerDark
                        : BukeerColors.divider,
                    borderRadius: BukeerBorders.radiusSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryInfoBox(dynamic itineraryData) {
    // Try to get client name from different possible fields
    final clientName =
        getJsonField(itineraryData, r'$.contact_name')?.toString() ??
            getJsonField(itineraryData, r'$.client_name')?.toString() ??
            'Cliente no especificado';
    final startDate =
        getJsonField(itineraryData, r'$.start_date')?.toString() ?? '';
    final endDate =
        getJsonField(itineraryData, r'$.end_date')?.toString() ?? '';
    final status =
        getJsonField(itineraryData, r'$.status')?.toString() ?? 'budget';
    final passengers =
        getJsonField(itineraryData, r'$.passenger_count')?.toInt() ?? 0;
    final idFm = getJsonField(itineraryData, r'$.id_fm')?.toString() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BukeerBorders.radiusLarge,
        boxShadow: BukeerShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Información del Itinerario',
                style: BukeerTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? BukeerColors.textPrimaryDark
                      : BukeerColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  BukeerIconButton(
                    icon: const Icon(Icons.file_copy),
                    onPressed: () {},
                    variant: BukeerIconButtonVariant.ghost,
                    size: BukeerIconButtonSize.small,
                  ),
                  SizedBox(width: BukeerSpacing.s),
                  BukeerIconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _handleEditItinerary,
                    variant: BukeerIconButtonVariant.ghost,
                    size: BukeerIconButtonSize.small,
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: BukeerSpacing.m),
            height: 1,
            color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          ),

          // Info items
          _buildInfoItem(Icons.tag, 'ID:', idFm.isNotEmpty ? idFm : 'N/A'),
          _buildInfoItem(Icons.person_outline, 'Cliente:', clientName),
          if (getJsonField(itineraryData, r'$.contact_email') != null)
            _buildInfoItem(
                Icons.email,
                'Email:',
                getJsonField(itineraryData, r'$.contact_email')?.toString() ??
                    ''),
          if (getJsonField(itineraryData, r'$.contact_phone') != null)
            _buildInfoItem(
                Icons.phone,
                'Teléfono:',
                getJsonField(itineraryData, r'$.contact_phone')?.toString() ??
                    ''),
          Row(
            children: [
              Icon(Icons.label,
                  size: 19,
                  color: isDark
                      ? BukeerColors.textTertiaryDark
                      : BukeerColors.textTertiary),
              SizedBox(width: BukeerSpacing.m),
              Text(
                'Estado:',
                style: BukeerTypography.bodyMedium.copyWith(
                  color: isDark
                      ? BukeerColors.textSecondaryDark
                      : BukeerColors.textSecondary,
                ),
              ),
              SizedBox(width: BukeerSpacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: BukeerSpacing.m, vertical: BukeerSpacing.xs),
                decoration: BoxDecoration(
                  color: status == 'confirmed'
                      ? BukeerColors.success.withOpacity(0.1)
                      : BukeerColors.info.withOpacity(0.1),
                  borderRadius: BukeerBorders.radiusLarge,
                ),
                child: Text(
                  status == 'confirmed' ? 'Confirmado' : 'Presupuesto',
                  style: BukeerTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: status == 'confirmed'
                        ? BukeerColors.success
                        : BukeerColors.info,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: BukeerSpacing.m),
          _buildInfoItem(Icons.date_range, 'Fechas:',
              '${_formatDate(startDate)} - ${_formatDate(endDate)}'),
          _buildInfoItem(Icons.people_alt, 'Pasajeros:',
              passengers > 0 ? '$passengers personas' : 'No especificado'),
          _buildInfoItem(
              Icons.translate,
              'Idioma:',
              getJsonField(itineraryData, r'$.language')?.toString() ??
                  'Español'),
          _buildInfoItem(
              Icons.attach_money,
              'Moneda:',
              getJsonField(itineraryData, r'$.currency_type')?.toString() ??
                  'COP'),
          _buildInfoItem(
              Icons.event_available,
              'Creado:',
              _formatDate(
                  getJsonField(itineraryData, r'$.created_at')?.toString() ??
                      '')),
          if (getJsonField(itineraryData, r'$.valid_until') != null)
            _buildInfoItem(
                Icons.timer,
                'Válido hasta:',
                _formatDate(
                    getJsonField(itineraryData, r'$.valid_until')?.toString() ??
                        '')),

          // Status toggle
          Container(
            margin: EdgeInsets.only(top: BukeerSpacing.m),
            padding: EdgeInsets.only(top: BukeerSpacing.m),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                  width: BukeerBorders.widthThin,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status == 'confirmed'
                      ? 'Bloqueado (Confirmado)'
                      : 'Desbloqueado (Presupuesto)',
                  style: BukeerTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? BukeerColors.textSecondaryDark
                        : BukeerColors.textSecondary,
                  ),
                ),
                Switch(
                  value: status == 'confirmed',
                  onChanged: (value) {
                    _handleStatusChange(value);
                  },
                  activeColor: BukeerColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInfoBox(dynamic itineraryData) {
    final totalPrice =
        getJsonField(itineraryData, r'$.total_amount')?.toDouble() ?? 0.0;
    final totalCost =
        getJsonField(itineraryData, r'$.total_cost')?.toDouble() ?? 0.0;
    final totalMarkup =
        getJsonField(itineraryData, r'$.total_markup')?.toDouble() ?? 0.0;
    final passengerCount =
        getJsonField(itineraryData, r'$.passenger_count')?.toInt() ?? 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
          BukeerSpacing.l, BukeerSpacing.m, BukeerSpacing.l, 0),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        boxShadow: BukeerShadows.subtle,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: BukeerSpacing.xl, vertical: BukeerSpacing.m),
        decoration: BoxDecoration(
          color: BukeerColors.info.withOpacity(0.1),
          borderRadius: BukeerBorders.radiusMedium,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - vertical
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFinancialItem(
                    'Total',
                    _formatCurrency(totalPrice) +
                        ' ' +
                        (getJsonField(itineraryData, r'$.currency_type')
                                ?.toString() ??
                            'COP'),
                    BukeerColors.primary,
                    true,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: BukeerSpacing.s),
                    height: 1,
                    width: double.infinity,
                    color: BukeerColors.info.withOpacity(0.3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFinancialItem(
                        'Por persona',
                        _formatCurrency(passengerCount > 0
                                ? totalPrice / passengerCount
                                : totalPrice) +
                            ' ' +
                            (getJsonField(itineraryData, r'$.currency_type')
                                    ?.toString() ??
                                'COP'),
                        BukeerColors.info,
                        false,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: BukeerColors.info.withOpacity(0.3),
                      ),
                      _buildFinancialItem(
                        'Margen',
                        _formatCurrency(totalMarkup) +
                            ' ' +
                            (getJsonField(itineraryData, r'$.currency_type')
                                    ?.toString() ??
                                'COP'),
                        BukeerColors.info,
                        false,
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // Desktop layout - horizontal
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildFinancialItem(
                      'Total',
                      _formatCurrency(totalPrice) +
                          ' ' +
                          (getJsonField(itineraryData, r'$.currency_type')
                                  ?.toString() ??
                              'COP'),
                      BukeerColors.primary,
                      true,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: BukeerColors.info.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildFinancialItem(
                      'Por persona',
                      _formatCurrency(passengerCount > 0
                              ? totalPrice / passengerCount
                              : totalPrice) +
                          ' ' +
                          (getJsonField(itineraryData, r'$.currency_type')
                                  ?.toString() ??
                              'COP'),
                      BukeerColors.info,
                      false,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: BukeerColors.info.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildFinancialItem(
                      'Margen',
                      _formatCurrency(totalMarkup) +
                          ' ' +
                          (getJsonField(itineraryData, r'$.currency_type')
                                  ?.toString() ??
                              'COP'),
                      BukeerColors.info,
                      false,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildFinancialItem(
      String label, String value, Color color, bool isTotal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: BukeerTypography.labelSmall.copyWith(
            color: color.withOpacity(0.8),
          ),
        ),
        SizedBox(height: BukeerSpacing.xs),
        Text(
          value,
          style: isTotal
              ? BukeerTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                )
              : BukeerTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
        ),
      ],
    );
  }

  Widget _buildActionsBox(dynamic itineraryData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BukeerBorders.radiusLarge,
        boxShadow: BukeerShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acciones',
            style: BukeerTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? BukeerColors.textPrimaryDark
                  : BukeerColors.textPrimary,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: BukeerSpacing.m),
            height: 1,
            color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          ),
          BukeerButton(
            text: 'Exportar Itinerario (PDF)',
            onPressed: () {},
            variant: BukeerButtonVariant.secondary,
            size: BukeerButtonSize.medium,
            icon: Icons.picture_as_pdf,
          ),
          SizedBox(height: BukeerSpacing.m),
          BukeerButton(
            text: 'Ver en la Web',
            onPressed: () {},
            variant: BukeerButtonVariant.secondary,
            size: BukeerButtonSize.medium,
            icon: Icons.visibility,
          ),
          SizedBox(height: BukeerSpacing.m),

          // Toggles from financial info
          _buildToggleItem(
              'Ocultar Tarifas',
              getJsonField(itineraryData, r'$.rates_visibility') ?? false,
              (value) => _handleVisibilityToggle('rates_visibility', value)),
          SizedBox(height: BukeerSpacing.m),
          _buildToggleItem(
              'Publicar en la Web',
              getJsonField(itineraryData, r'$.itinerary_visibility') ?? false,
              (value) =>
                  _handleVisibilityToggle('itinerary_visibility', value)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: BukeerSpacing.m),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: isDark
                ? BukeerColors.textTertiaryDark
                : BukeerColors.textTertiary,
          ),
          SizedBox(width: BukeerSpacing.m),
          Text(
            label,
            style: BukeerTypography.bodyMedium.copyWith(
              color: isDark
                  ? BukeerColors.textSecondaryDark
                  : BukeerColors.textSecondary,
            ),
          ),
          SizedBox(width: BukeerSpacing.xs),
          Expanded(
            child: Text(
              value,
              style: BukeerTypography.bodyMedium.copyWith(
                color: isDark
                    ? BukeerColors.textPrimaryDark
                    : BukeerColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, bool value, Function(bool)? onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: BukeerTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark
                ? BukeerColors.textSecondaryDark
                : BukeerColors.textSecondary,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: BukeerColors.primary,
        ),
      ],
    );
  }

  // Loading, error and not found states
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(BukeerColors.primary),
          ),
          SizedBox(height: BukeerSpacing.m),
          Text(
            'Cargando itinerario...',
            style: BukeerTypography.bodyMedium.copyWith(
              color: BukeerColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: BukeerColors.error,
            ),
            SizedBox(height: BukeerSpacing.m),
            Text(
              'Error al cargar el itinerario',
              style: BukeerTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: BukeerColors.error,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            Text(
              error,
              style: BukeerTypography.bodyMedium.copyWith(
                color: BukeerColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: BukeerSpacing.l),
            BukeerButton(
              text: 'Volver',
              onPressed: () => context.safePop(),
              variant: BukeerButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: BukeerColors.textTertiary,
            ),
            SizedBox(height: BukeerSpacing.m),
            Text(
              'Itinerario no encontrado',
              style: BukeerTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            Text(
              'El itinerario que buscas no existe o ha sido eliminado',
              style: BukeerTypography.bodyMedium.copyWith(
                color: BukeerColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: BukeerSpacing.l),
            BukeerButton(
              text: 'Ir a Itinerarios',
              onPressed: () =>
                  context.pushReplacementNamed(MainItinerariesWidget.routeName),
              variant: BukeerButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummaryItem(
      String label, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: BukeerBorders.widthThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              SizedBox(width: BukeerSpacing.s),
              Text(
                label,
                style: BukeerTypography.labelMedium.copyWith(
                  color: isDark
                      ? BukeerColors.textSecondaryDark
                      : BukeerColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: BukeerSpacing.xs),
          Text(
            value,
            style: BukeerTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactionsState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: isDark
                ? BukeerColors.textTertiaryDark
                : BukeerColors.textTertiary,
          ),
          SizedBox(height: BukeerSpacing.m),
          Text(
            'No hay transacciones registradas',
            style: BukeerTypography.titleMedium.copyWith(
              color: isDark
                  ? BukeerColors.textSecondaryDark
                  : BukeerColors.textSecondary,
            ),
          ),
          SizedBox(height: BukeerSpacing.s),
          Text(
            'Registra el primer pago para este itinerario',
            style: BukeerTypography.bodyMedium.copyWith(
              color: isDark
                  ? BukeerColors.textTertiaryDark
                  : BukeerColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(dynamic transaction) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final type = getJsonField(transaction, r'$.type')?.toString() ?? '';
    final value = getJsonField(transaction, r'$.value')?.toDouble() ?? 0;
    final date = getJsonField(transaction, r'$.date')?.toString() ?? '';
    final paymentMethod =
        getJsonField(transaction, r'$.payment_method')?.toString() ?? '';
    final reference =
        getJsonField(transaction, r'$.reference')?.toString() ?? '';
    final voucherUrl =
        getJsonField(transaction, r'$.voucher_url')?.toString() ?? '';

    final isIncome = type == 'ingreso';
    final color = isIncome ? BukeerColors.success : BukeerColors.error;
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    final label = isIncome ? 'Pago recibido' : 'Pago a proveedor';

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfaceSecondaryDark
            : BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          width: BukeerBorders.widthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BukeerBorders.radiusFull,
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          SizedBox(width: BukeerSpacing.m),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: BukeerTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? BukeerColors.textPrimaryDark
                            : BukeerColors.textPrimary,
                      ),
                    ),
                    Text(
                      _formatCurrency(value),
                      style: BukeerTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: BukeerSpacing.xs),
                Wrap(
                  spacing: BukeerSpacing.m,
                  runSpacing: BukeerSpacing.xs,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: isDark
                              ? BukeerColors.textTertiaryDark
                              : BukeerColors.textTertiary,
                        ),
                        SizedBox(width: BukeerSpacing.xs),
                        Text(
                          _formatDate(date),
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (paymentMethod.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.payment,
                            size: 14,
                            color: isDark
                                ? BukeerColors.textTertiaryDark
                                : BukeerColors.textTertiary,
                          ),
                          SizedBox(width: BukeerSpacing.xs),
                          Text(
                            paymentMethod,
                            style: BukeerTypography.bodySmall.copyWith(
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    if (reference.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tag,
                            size: 14,
                            color: isDark
                                ? BukeerColors.textTertiaryDark
                                : BukeerColors.textTertiary,
                          ),
                          SizedBox(width: BukeerSpacing.xs),
                          Text(
                            reference,
                            style: BukeerTypography.bodySmall.copyWith(
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    if (voucherUrl.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attachment,
                            size: 14,
                            color: BukeerColors.primary,
                          ),
                          SizedBox(width: BukeerSpacing.xs),
                          Text(
                            'Comprobante',
                            style: BukeerTypography.bodySmall.copyWith(
                              color: BukeerColors.primary,
                              decoration: TextDecoration.underline,
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
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = provider['name'] ?? 'Proveedor';
    final type = provider['type'] ?? '';
    final itemCount = provider['itemCount'] ?? 0;
    final totalCost = provider['totalCost'] ?? 0.0;
    final items = provider['items'] as List<dynamic>? ?? [];

    // Check if all items are confirmed
    final confirmedItems = items
        .where((item) => getJsonField(item, r'$.reservation_status') == true)
        .length;
    final isFullyConfirmed = confirmedItems == items.length && items.isNotEmpty;
    final isPartiallyConfirmed =
        confirmedItems > 0 && confirmedItems < items.length;

    // Calculate total paid to this provider
    double totalPaidToProvider = 0;
    // In a real implementation, we'd query transactions for this provider

    final pendingPayment = totalCost - totalPaidToProvider;

    IconData typeIcon;
    Color typeColor;
    String typeLabel;

    switch (type) {
      case 'hotel':
        typeIcon = Icons.hotel;
        typeColor = BukeerColors.primary;
        typeLabel = 'Hotel';
        break;
      case 'activity':
        typeIcon = Icons.local_activity;
        typeColor = BukeerColors.secondary;
        typeLabel = 'Actividad';
        break;
      case 'transfer':
        typeIcon = Icons.directions_car;
        typeColor = BukeerColors.tertiary;
        typeLabel = 'Traslado';
        break;
      case 'flight':
        typeIcon = Icons.flight;
        typeColor = BukeerColors.info;
        typeLabel = 'Vuelo';
        break;
      default:
        typeIcon = Icons.business;
        typeColor = BukeerColors.textTertiary;
        typeLabel = 'Servicio';
    }

    return Container(
      padding: EdgeInsets.all(BukeerSpacing.m),
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfaceSecondaryDark
            : BukeerColors.backgroundPrimary,
        borderRadius: BukeerBorders.radiusMedium,
        border: Border.all(
          color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
          width: BukeerBorders.widthThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BukeerBorders.radiusMedium,
                ),
                child: Icon(
                  typeIcon,
                  size: 24,
                  color: typeColor,
                ),
              ),
              SizedBox(width: BukeerSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: BukeerTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? BukeerColors.textPrimaryDark
                            : BukeerColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$itemCount ${itemCount > 1 ? "servicios" : "servicio"} • $typeLabel',
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                        ),
                        if (isFullyConfirmed) ...[
                          SizedBox(width: BukeerSpacing.s),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: BukeerSpacing.s,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: BukeerColors.success.withOpacity(0.1),
                              borderRadius: BukeerBorders.radiusSmall,
                              border: Border.all(
                                color: BukeerColors.success.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: BukeerColors.success,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Confirmado',
                                  style: BukeerTypography.labelSmall.copyWith(
                                    color: BukeerColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (isPartiallyConfirmed) ...[
                          SizedBox(width: BukeerSpacing.s),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: BukeerSpacing.s,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: BukeerColors.warning.withOpacity(0.1),
                              borderRadius: BukeerBorders.radiusSmall,
                              border: Border.all(
                                color: BukeerColors.warning.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 12,
                                  color: BukeerColors.warning,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Parcial ($confirmedItems/$itemCount)',
                                  style: BukeerTypography.labelSmall.copyWith(
                                    color: BukeerColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Financial info
          Container(
            margin: EdgeInsets.only(top: BukeerSpacing.s),
            padding: EdgeInsets.only(top: BukeerSpacing.s),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                  width: BukeerBorders.widthThin,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Costo total',
                      style: BukeerTypography.labelSmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatCurrency(totalCost),
                      style: BukeerTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? BukeerColors.textPrimaryDark
                            : BukeerColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pagado',
                      style: BukeerTypography.labelSmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatCurrency(totalPaidToProvider),
                      style: BukeerTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: BukeerColors.success,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Pendiente',
                      style: BukeerTypography.labelSmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatCurrency(pendingPayment),
                      style: BukeerTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: pendingPayment > 0
                            ? BukeerColors.warning
                            : BukeerColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons - Optimized single row layout
          SizedBox(height: BukeerSpacing.s),
          Row(
            children: [
              // Primary action - Confirm reservation
              Expanded(
                flex: 2,
                child: BukeerButton(
                  text: isFullyConfirmed
                      ? 'Confirmado'
                      : isPartiallyConfirmed
                          ? 'Confirmar'
                          : 'Confirmar',
                  onPressed: isFullyConfirmed
                      ? null
                      : () => _handleConfirmProviderReservation(provider),
                  variant: isFullyConfirmed
                      ? BukeerButtonVariant.secondary
                      : BukeerButtonVariant.primary,
                  size: BukeerButtonSize.small,
                  icon: isFullyConfirmed
                      ? Icons.check_circle
                      : Icons.check_circle,
                ),
              ),
              SizedBox(width: BukeerSpacing.xs),

              // Secondary actions - Compact buttons with tooltips
              Expanded(
                child: Tooltip(
                  message: 'Enviar mensaje',
                  child: BukeerButton(
                    text: '',
                    onPressed: () => _handleSendProviderMessage(provider),
                    variant: BukeerButtonVariant.secondary,
                    size: BukeerButtonSize.small,
                    icon: Icons.message,
                  ),
                ),
              ),
              SizedBox(width: BukeerSpacing.xs),

              Expanded(
                child: Tooltip(
                  message: 'Registrar pago',
                  child: BukeerButton(
                    text: '',
                    onPressed: () => _handleAddProviderPayment(provider),
                    variant: BukeerButtonVariant.secondary,
                    size: BukeerButtonSize.small,
                    icon: Icons.payment,
                  ),
                ),
              ),

              if (_hasReservationMessages(provider)) ...[
                SizedBox(width: BukeerSpacing.xs),
                Expanded(
                  child: Tooltip(
                    message: 'Ver mensajes',
                    child: BukeerButton(
                      text: '',
                      onPressed: () => _handleViewProviderMessages(provider),
                      variant: BukeerButtonVariant.secondary,
                      size: BukeerButtonSize.small,
                      icon: Icons.history,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String serviceType) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String message = '';
    IconData icon = Icons.add_circle_outline;

    switch (serviceType) {
      case 'vuelos':
        message = 'No hay vuelos agregados';
        icon = Icons.flight;
        break;
      case 'hoteles':
        message = 'No hay hoteles agregados';
        icon = Icons.hotel;
        break;
      case 'servicios':
        message = 'No hay actividades agregadas';
        icon = Icons.local_activity;
        break;
      case 'transporte':
        message = 'No hay traslados agregados';
        icon = Icons.directions_car;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: isDark
                ? BukeerColors.textTertiaryDark
                : BukeerColors.textTertiary,
          ),
          SizedBox(height: BukeerSpacing.m),
          Text(
            message,
            style: BukeerTypography.titleMedium.copyWith(
              color: isDark
                  ? BukeerColors.textSecondaryDark
                  : BukeerColors.textSecondary,
            ),
          ),
          SizedBox(height: BukeerSpacing.l),
          BukeerButton(
            text: 'Agregar ${_getServiceLabel(_selectedServiceTab)}',
            onPressed: () => _handleAddService(serviceType),
            variant: BukeerButtonVariant.primary,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getServiceLabel(int index) {
    switch (index) {
      case 0:
        return 'vuelos';
      case 1:
        return 'hoteles';
      case 2:
        return 'actividades';
      case 3:
        return 'traslados';
      default:
        return '';
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Sin fecha';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '\$$wholePart.${parts[1]}';
  }

  // Action handlers

  void _handleAddService(String serviceType) async {
    final result = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: switch (serviceType) {
              'vuelos' => AddFlightsWidget(
                  isEdit: false,
                  itineraryId: _itineraryId,
                ),
              'hoteles' => AddHotelWidget(
                  isEdit: false,
                  itineraryId: _itineraryId,
                ),
              'servicios' => AddActivitiesWidget(
                  itineraryId: _itineraryId,
                ),
              'transporte' => AddTransferWidget(
                  isEdit: false,
                  itineraryId: _itineraryId,
                ),
              _ => Container(),
            },
          ),
        );
      },
    );

    // Refresh items after adding if result is true (item was added)
    if (result == true && _itineraryId != null) {
      await appServices.itinerary.loadItineraryDetailsOptimized(_itineraryId!);
      setState(() {});
    }
  }

  void _handleAddPayment() async {
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
            child: PaymentAddWidget(
              idItinerary: _itineraryId,
              typeTransaction: 'ingreso',
              agentName: currentUserDisplayName,
              agentEmail: currentUserEmail,
              emailProvider: '',
              nameProvider: 'Cliente',
              fechaReserva: DateTime.now().toString(),
              producto: 'Pago de cliente',
              tarifa: '',
              cantidad: 1,
            ),
          ),
        );
      },
    );

    // Reload itinerary data after adding payment
    if (_itineraryId != null) {
      await appServices.itinerary.loadItineraryDetailsOptimized(_itineraryId!);
      setState(() {});
    }
  }

  void _handleAddProviderPayment(Map<String, dynamic> provider) async {
    // Get first item to extract provider info
    final items = provider['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return;

    final firstItem = items.first;

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
            child: PaymentAddWidget(
              idItinerary: _itineraryId,
              typeTransaction: 'egreso',
              agentName: currentUserDisplayName,
              agentEmail: currentUserEmail,
              emailProvider: '',
              nameProvider: provider['name'] ?? 'Proveedor',
              fechaReserva: DateTime.now().toString(),
              producto: provider['name'] ?? '',
              tarifa: '',
              cantidad: 1,
            ),
          ),
        );
      },
    );

    // Reload itinerary data after adding payment
    if (_itineraryId != null) {
      await appServices.itinerary.loadItineraryDetailsOptimized(_itineraryId!);
      setState(() {});
    }
  }

  // Visibility toggle handler
  Future<void> _handleVisibilityToggle(String field, bool value) async {
    if (_itineraryId == null) return;

    try {
      await ItinerariesTable().update(
        data: {
          field: value,
        },
        matchingRows: (rows) => rows.eq('id', _itineraryId!),
      );

      // Reload itinerary data
      await appServices.itinerary.loadItineraryDetails(_itineraryId!);
      setState(() {});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            field == 'rates_visibility'
                ? (value ? 'Tarifas ocultas' : 'Tarifas visibles')
                : (value ? 'Publicado en la web' : 'No publicado en la web'),
          ),
          backgroundColor: BukeerColors.success,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $e'),
          backgroundColor: BukeerColors.error,
        ),
      );
    }
  }

  // Status change handler
  Future<void> _handleStatusChange(bool isConfirmed) async {
    if (_itineraryId == null) return;

    try {
      final newStatus = isConfirmed ? 'confirmed' : 'budget';
      final confirmationDate = isConfirmed ? DateTime.now() : null;

      await ItinerariesTable().update(
        data: {
          'status': newStatus,
          'confirmation_date': confirmationDate?.toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('id', _itineraryId!),
      );

      // Reload itinerary data
      await appServices.itinerary.loadItineraryDetails(_itineraryId!);
      setState(() {});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isConfirmed
                ? 'Itinerario confirmado exitosamente'
                : 'Itinerario cambiado a presupuesto',
          ),
          backgroundColor: BukeerColors.success,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cambiar el estado: $e'),
          backgroundColor: BukeerColors.error,
        ),
      );
    }
  }

  void _handleEditItinerary() async {
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
            child: ModalAddEditItineraryWidget(
              isEdit: true,
              allDataItinerary:
                  appServices.itinerary.getItinerary(_itineraryId!),
            ),
          ),
        );
      },
    );
  }

  void _handleAddPassenger() async {
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
            child: ModalAddPassengerWidget(
              itineraryId: _itineraryId,
            ),
          ),
        );
      },
    );
  }

  // Helper method to build image placeholder
  Widget _buildImagePlaceholder(IconData icon, bool isDark) {
    return Icon(
      icon,
      size: 40,
      color: isDark ? BukeerColors.textTertiaryDark : BukeerColors.textTertiary,
    );
  }

  // Provider message methods
  void _handleSendProviderMessage(Map<String, dynamic> provider) {
    final items = provider['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return;

    final firstItem = items.first;

    // Extract provider info from item
    final providerName = provider['name'] ?? 'Proveedor';
    final productName =
        getJsonField(firstItem, r'$.product_name')?.toString() ?? '';
    final productType = provider['type'] ?? '';

    // Calculate passenger count from first item or use itinerary total
    final passengers =
        getJsonField(firstItem, r'$.passengers')?.toString() ?? '1';

    // Get provider email - this would need to come from contacts table in real implementation
    String providerEmail = 'proveedor@example.com'; // Placeholder

    // In real implementation, you'd query the contacts table based on provider info
    // For now, we'll use a placeholder email

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: ReservationMessageWidget(
            idItinerary: _itineraryId,
            agentName: currentUserDisplayName,
            agentEmail: currentUserEmail,
            emailProvider: providerEmail,
            nameProvider: providerName,
            passengers: passengers,
            fecha: DateTime.now().toIso8601String(),
            producto: '$productType - $productName',
            tarifa: _formatCurrency(provider['totalCost'] ?? 0.0),
            cantidad: int.tryParse(passengers) ?? 1,
            idItemProduct: getJsonField(firstItem, r'$.id')?.toString(),
            idFm: _itineraryId,
            tipoEmal: 'reservation',
          ),
        ),
      ),
    ).then((value) => safeSetState(() {}));
  }

  void _handleViewProviderMessages(Map<String, dynamic> provider) {
    final items = provider['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return;

    // Extract messages from all items of this provider
    List<dynamic> allMessages = [];
    for (var item in items) {
      final messages = getJsonField(item, r'$.reservation_messages');
      if (messages != null) {
        if (messages is List) {
          allMessages.addAll(messages);
        } else if (messages is Map) {
          allMessages.add(messages);
        }
      }
    }

    if (allMessages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No hay mensajes enviados a este proveedor'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: ShowReservationMessageWidget(
            messages: allMessages,
          ),
        ),
      ),
    );
  }

  bool _hasReservationMessages(Map<String, dynamic> provider) {
    final items = provider['items'] as List<dynamic>? ?? [];

    for (var item in items) {
      final messages = getJsonField(item, r'$.reservation_messages');
      if (messages != null) {
        if (messages is List && messages.isNotEmpty) {
          return true;
        } else if (messages is Map) {
          return true;
        }
      }
    }

    return false;
  }

  void _handleConfirmProviderReservation(Map<String, dynamic> provider) {
    final items = provider['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return;

    final providerName = provider['name'] ?? 'Proveedor';
    final itemCount = provider['itemCount'] ?? 0;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: BukeerColors.success),
            SizedBox(width: BukeerSpacing.s),
            Text('Confirmar Reserva'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Confirmar la reserva con $providerName?',
              style: BukeerTypography.bodyMedium,
            ),
            SizedBox(height: BukeerSpacing.s),
            Text(
              'Se marcará como confirmada la reserva de $itemCount ${itemCount > 1 ? "servicios" : "servicio"}.',
              style: BukeerTypography.bodySmall.copyWith(
                color: BukeerColors.textSecondary,
              ),
            ),
            SizedBox(height: BukeerSpacing.m),
            Container(
              padding: EdgeInsets.all(BukeerSpacing.s),
              decoration: BoxDecoration(
                color: BukeerColors.warning.withOpacity(0.1),
                borderRadius: BukeerBorders.radiusSmall,
                border: Border.all(
                  color: BukeerColors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    size: 16,
                    color: BukeerColors.warning,
                  ),
                  SizedBox(width: BukeerSpacing.s),
                  Expanded(
                    child: Text(
                      'Esta acción actualizará el estado de todos los servicios de este proveedor.',
                      style: BukeerTypography.bodySmall.copyWith(
                        color: BukeerColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _confirmProviderReservation(provider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BukeerColors.success,
            ),
            child: Text(
              'Confirmar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmProviderReservation(
      Map<String, dynamic> provider) async {
    try {
      final items = provider['items'] as List<dynamic>? ?? [];
      final providerName = provider['name'] ?? 'Proveedor';

      // Update reservation status for all items of this provider
      for (var item in items) {
        final itemId = getJsonField(item, r'$.id')?.toString();
        if (itemId != null) {
          // Update the reservation_status to true in the database
          await ItineraryItemsTable().update(
            data: {
              'reservation_status': true,
              'updated_at': DateTime.now().toIso8601String(),
            },
            matchingRows: (rows) => rows.eqOrNull('id', itemId),
          );
        }
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: BukeerSpacing.s),
                Text('Reserva confirmada con $providerName'),
              ],
            ),
            backgroundColor: BukeerColors.success,
            duration: Duration(seconds: 3),
          ),
        );

        // Refresh the itinerary data
        if (_itineraryId != null) {
          await appServices.itinerary.loadItineraryDetails(_itineraryId!);
          setState(() {});
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: BukeerSpacing.s),
                Text('Error al confirmar reserva: $e'),
              ],
            ),
            backgroundColor: BukeerColors.error,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _handleChangeOwner(dynamic itineraryData) async {
    final currentOwnerId =
        getJsonField(itineraryData, r'$.id_created_by')?.toString();
    final itineraryName =
        getJsonField(itineraryData, r'$.name')?.toString() ?? 'Sin nombre';

    if (currentOwnerId == null || _itineraryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se puede cambiar el propietario en este momento'),
          backgroundColor: BukeerColors.error,
        ),
      );
      return;
    }

    final result = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: ModalChangeOwnerWidget(
              itineraryId: _itineraryId!,
              currentOwnerId: currentOwnerId,
              itineraryName: itineraryName,
            ),
          ),
        );
      },
    );

    // Refresh if owner was changed
    if (result == true && _itineraryId != null) {
      await appServices.itinerary.loadItineraryDetailsOptimized(_itineraryId!);
      setState(() {});
    }
  }
}
