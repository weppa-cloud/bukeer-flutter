import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import '../../core/widgets/navigation/sidebar/sidebar_navigation_widget.dart';
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
  int _selectedServiceTab = 1; // Hotels by default
  bool _isHotelsExpanded = true;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItineraryDetailsModel());

    _mainTabController = TabController(length: 5, vsync: this);
    _servicesTabController =
        TabController(length: 4, vsync: this, initialIndex: 1);

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
        getJsonField(itineraryData, r'$[:].itinerary_name')?.toString() ??
            'Sin nombre';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        InkWell(
          onTap: () {
            setState(() {
              _isHotelsExpanded = !_isHotelsExpanded;
            });
          },
          borderRadius: BukeerBorders.radiusSmall,
          child: Padding(
            padding: EdgeInsets.all(BukeerSpacing.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total hoteles \$3.500.000,00',
                  style: BukeerTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? BukeerColors.textPrimaryDark
                        : BukeerColors.textPrimary,
                  ),
                ),
                Icon(
                  _isHotelsExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 22,
                  color: isDark
                      ? BukeerColors.textSecondaryDark
                      : BukeerColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        if (_isHotelsExpanded) ...[
          SizedBox(height: BukeerSpacing.m),
          Expanded(
            child: ListView(
              children: [
                _buildHotelCard(
                  name: 'Hotel Estelar Blue',
                  provider: 'Booking.com',
                  roomType: 'Doble Estándar',
                  dates: '07 Jul - 11 Jul 2025',
                  location: 'Medellín, Antioquia',
                  nights: 4,
                  rooms: 2,
                  nightRate: 350000,
                  markup: 15,
                  value: 402500,
                  total: 3500000,
                  imageUrl:
                      'https://images.unsplash.com/photo-1566073771259-6a8506099945',
                ),
                SizedBox(height: BukeerSpacing.m),
                _buildHotelCard(
                  name: 'Hotel Dann Carlton Medellín',
                  provider: 'Expedia',
                  roomType: 'Suite Ejecutiva',
                  dates: '07 Jul - 11 Jul 2025',
                  location: 'Medellín, Antioquia',
                  nights: 4,
                  rooms: 1,
                  nightRate: 550000,
                  markup: 10,
                  value: 605000,
                  total: 2420000,
                  imageUrl:
                      'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHotelCard({
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildPriceItem(
                              Icons.sell, _formatCurrency(nightRate)),
                          SizedBox(width: BukeerSpacing.s),
                          Text('|',
                              style: TextStyle(
                                  color: isDark
                                      ? BukeerColors.dividerDark
                                      : BukeerColors.divider)),
                          SizedBox(width: BukeerSpacing.s),
                          _buildPriceItem(
                              Icons.trending_up, '${markup.toInt()}%'),
                          SizedBox(width: BukeerSpacing.s),
                          Text('|',
                              style: TextStyle(
                                  color: isDark
                                      ? BukeerColors.dividerDark
                                      : BukeerColors.divider)),
                          SizedBox(width: BukeerSpacing.s),
                          _buildPriceItem(
                              Icons.request_quote, _formatCurrency(value)),
                        ],
                      ),
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments,
            size: 64,
            color: isDark
                ? BukeerColors.textTertiaryDark
                : BukeerColors.textTertiary,
          ),
          SizedBox(height: BukeerSpacing.m),
          Text(
            'Gestión de pagos',
            style: BukeerTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? BukeerColors.textPrimaryDark
                  : BukeerColors.textPrimary,
            ),
          ),
          SizedBox(height: BukeerSpacing.s),
          Text(
            'Administra los pagos del itinerario',
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

  Widget _buildProvidersTabContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            'Proveedores',
            style: BukeerTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? BukeerColors.textPrimaryDark
                  : BukeerColors.textPrimary,
            ),
          ),
          SizedBox(height: BukeerSpacing.s),
          Text(
            'Gestiona los proveedores del itinerario',
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
    final travelPlannerName =
        getJsonField(itineraryData, r'$[:].travel_planner_name')?.toString() ??
            'Sin asignar';
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
              border: Border.all(
                color: BukeerColors.primary,
                width: BukeerBorders.widthMedium,
              ),
              color: BukeerColors.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                travelPlannerName.isNotEmpty
                    ? travelPlannerName[0].toUpperCase()
                    : 'U',
                style: BukeerTypography.bodyMedium.copyWith(
                  color: BukeerColors.primary,
                  fontWeight: FontWeight.w600,
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
                  travelPlannerName,
                  style: BukeerTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? BukeerColors.textPrimaryDark
                        : BukeerColors.textPrimary,
                  ),
                ),
                Text(
                  'Travel Planner',
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
    );
  }

  Widget _buildItineraryInfoBox(dynamic itineraryData) {
    final clientName =
        getJsonField(itineraryData, r'$[:].client_name')?.toString() ?? '';
    final startDate =
        getJsonField(itineraryData, r'$[:].start_date')?.toString() ?? '';
    final endDate =
        getJsonField(itineraryData, r'$[:].end_date')?.toString() ?? '';
    final status =
        getJsonField(itineraryData, r'$[:].status')?.toString() ?? 'budget';
    final passengers =
        getJsonField(itineraryData, r'$[:].total_passengers')?.toInt() ?? 5;
    final children =
        getJsonField(itineraryData, r'$[:].total_children')?.toInt() ?? 2;
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
          _buildInfoItem(Icons.tag, 'ID:', '1-6180'),
          _buildInfoItem(Icons.person_outline, 'Cliente:', clientName),
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
                  color: _isConfirmed
                      ? BukeerColors.success.withOpacity(0.1)
                      : BukeerColors.info.withOpacity(0.1),
                  borderRadius: BukeerBorders.radiusLarge,
                ),
                child: Text(
                  _isConfirmed ? 'Confirmado' : 'Presupuesto',
                  style: BukeerTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color:
                        _isConfirmed ? BukeerColors.success : BukeerColors.info,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: BukeerSpacing.m),
          _buildInfoItem(Icons.date_range, 'Fechas:',
              '${_formatDate(startDate)} - ${_formatDate(endDate)}'),
          _buildInfoItem(Icons.people_alt, 'Pasajeros:',
              '$passengers adultos, $children niños'),
          _buildInfoItem(Icons.translate, 'Idioma:', 'Español'),
          _buildInfoItem(Icons.flight_class, 'Clase:', 'Econo'),
          _buildInfoItem(Icons.event_available, 'Creado:', '08 Jun 2025'),
          _buildInfoItem(Icons.currency_exchange, 'Rate:', '3,950 COP/USD'),

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
                  _isConfirmed
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
                  value: _isConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _isConfirmed = value;
                    });
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
        getJsonField(itineraryData, r'$[:].totalPrice')?.toDouble() ??
            7450100.0;
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
                    _formatCurrency(totalPrice) + ' COP',
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
                        _formatCurrency(totalPrice / 5) + ' COP',
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
                        _formatCurrency(1179100) + ' COP',
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
                      _formatCurrency(totalPrice) + ' COP',
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
                      _formatCurrency(totalPrice / 5) + ' COP',
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
                      _formatCurrency(1179100) + ' COP',
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
          _buildToggleItem('Ocultar Tarifas', false),
          SizedBox(height: BukeerSpacing.m),
          _buildToggleItem('Publicar en la Web', true),
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

  Widget _buildToggleItem(String label, bool value) {
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
          onChanged: (newValue) {},
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

  // Helper methods
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
}
