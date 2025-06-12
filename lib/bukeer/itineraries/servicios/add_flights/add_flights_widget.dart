import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/legacy/flutter_flow/flutter_flow_theme.dart';
import '/legacy/flutter_flow/flutter_flow_widgets.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import '/design_system/index.dart';
import '/services/app_services.dart';

class AddFlightsWidget extends StatefulWidget {
  const AddFlightsWidget({
    Key? key,
    required this.itineraryId,
    this.isEdit = false,
    this.itemId,
  }) : super(key: key);

  final String? itineraryId;
  final bool isEdit;
  final String? itemId;

  static String routeName = 'add_flights';
  static String routePath = 'addFlights';

  @override
  State<AddFlightsWidget> createState() => _AddFlightsWidgetState();
}

class _AddFlightsWidgetState extends State<AddFlightsWidget> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _searchProviderController = TextEditingController();
  final _searchAirlineController = TextEditingController();
  final _searchOriginController = TextEditingController();
  final _searchDestinationController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  final _dateController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitCostController = TextEditingController();
  final _markupController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected values
  dynamic _selectedProvider;
  dynamic _selectedAirline;
  DateTime _selectedDate = DateTime.now();

  // Lists
  List<dynamic> _providers = [];
  List<dynamic> _filteredProviders = [];
  List<dynamic> _airlines = [];
  List<dynamic> _filteredAirlines = [];
  List<dynamic> _airports = [];
  List<dynamic> _filteredOriginAirports = [];
  List<dynamic> _filteredDestinationAirports = [];
  dynamic _selectedOriginAirport;
  dynamic _selectedDestinationAirport;
  bool _isLoading = false;

  // Calculated values
  double _total = 0.0;
  bool _isCalculating = false;

  // Services
  final appServices = AppServices();

  @override
  void initState() {
    super.initState();
    _loadProviders();
    _loadAirlines();
    _loadAirports();

    // Load data if editing
    if (widget.isEdit && widget.itemId != null) {
      _loadFlightData();
    }

    // Add listeners for calculations
    _unitCostController.addListener(_calculateFromCostAndMarkup);
    _markupController.addListener(_calculateFromCostAndMarkup);
    _unitPriceController.addListener(_calculateFromCostAndPrice);
    _quantityController.addListener(_updateTotal);
  }

  @override
  void dispose() {
    _searchProviderController.dispose();
    _searchAirlineController.dispose();
    _searchOriginController.dispose();
    _searchDestinationController.dispose();
    _flightNumberController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    _unitCostController.dispose();
    _markupController.dispose();
    _unitPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateFromCostAndMarkup() {
    if (_isCalculating) return;

    final cost = double.tryParse(_unitCostController.text) ?? 0;
    final markup = double.tryParse(_markupController.text) ?? 0;

    if (cost > 0) {
      _isCalculating = true;
      final price = cost * (1 + markup / 100);
      _unitPriceController.text = price.toStringAsFixed(2);
      _isCalculating = false;
    }
    _updateTotal();
  }

  void _calculateFromCostAndPrice() {
    if (_isCalculating) return;

    final cost = double.tryParse(_unitCostController.text) ?? 0;
    final price = double.tryParse(_unitPriceController.text) ?? 0;

    if (cost > 0 && price > 0 && price >= cost) {
      _isCalculating = true;
      final markup = ((price - cost) / cost) * 100;
      _markupController.text = markup.toStringAsFixed(2);
      _isCalculating = false;
    } else if (cost > 0 && price > 0 && price < cost) {
      _isCalculating = true;
      // Negative markup (loss)
      final markup = ((price - cost) / cost) * 100;
      _markupController.text = markup.toStringAsFixed(2);
      _isCalculating = false;
    }
    _updateTotal();
  }

  void _updateTotal() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;

    setState(() {
      _total = quantity * unitPrice;
    });
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);

    try {
      // Load flight providers
      final providers = await SupaFlow.client
          .from('contacts')
          .select('*')
          .eq('is_provider', true)
          .eq('is_flight_provider', true)
          .order('name');

      setState(() {
        _providers = providers;
        _filteredProviders = providers;
        _isLoading = false;
      });

      // Debug: Check provider data structure
      if (providers.isNotEmpty) {
        print('📋 First provider fields: ${providers.first.keys.toList()}');
        print('📋 First provider data: ${providers.first}');
      }
    } catch (e) {
      print('Error loading providers: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAirlines() async {
    try {
      final airlines = await AirlinesTable().queryRows(
        queryFn: (q) => q.order('name'),
      );

      setState(() {
        _airlines = airlines.map((row) => row.data).toList();
        _filteredAirlines = _airlines;
      });
    } catch (e) {
      print('Error loading airlines: $e');
    }
  }

  Future<void> _loadAirports() async {
    try {
      // First, let's check if there's a limit being applied
      print('🔍 Loading ALL airports without any limit...');

      // Load airports in batches to avoid the 1000 limit
      List<dynamic> allAirports = [];
      int offset = 0;
      const int batchSize = 1000;

      while (true) {
        final batch = await SupaFlow.client
            .from('airports')
            .select('*')
            .order('city_name')
            .range(offset, offset + batchSize - 1);

        if (batch.isEmpty) break;

        allAirports.addAll(batch);
        offset += batchSize;

        // If we got less than batchSize, we've reached the end
        if (batch.length < batchSize) break;
      }

      print('✈️ Loaded ${allAirports.length} airports from database');

      // Debug: Check if Madrid is in the loaded data
      final madridAirports = allAirports
          .where((a) =>
              a['iata_code']?.toString()?.toUpperCase() == 'MAD' ||
              a['city_name']?.toString()?.toLowerCase()?.contains('madrid') ==
                  true)
          .toList();

      if (madridAirports.isNotEmpty) {
        print('✅ Madrid found in loaded data:');
        for (var madrid in madridAirports) {
          print(
              '   - ${madrid['iata_code']} | ${madrid['city_name']} | ${madrid['name']}');
        }
      } else {
        print('❌ Madrid NOT found in loaded data!');
      }

      // Debug: Show total count by country
      final countryCounts = <String, int>{};
      for (var airport in allAirports) {
        final country = airport['iata_country_code']?.toString() ?? 'Unknown';
        countryCounts[country] = (countryCounts[country] ?? 0) + 1;
      }
      print(
          '📊 Airports by country: ${countryCounts.entries.take(10).toList()}');

      setState(() {
        _airports = List<Map<String, dynamic>>.from(allAirports);

        // Initially show popular airports (mix of Colombian and international)
        // Prioritize Colombian airports but include some international ones
        final colombianAirports = _airports
            .where((airport) => airport['iata_country_code'] == 'CO')
            .take(10)
            .toList();
        final internationalAirports = _airports
            .where((airport) => airport['iata_country_code'] != 'CO')
            .take(10)
            .toList();

        _filteredOriginAirports = [
          ...colombianAirports,
          ...internationalAirports
        ];
        _filteredDestinationAirports = [
          ...colombianAirports,
          ...internationalAirports
        ];

        print('🌍 Total airports available for search: ${_airports.length}');
      });
    } catch (e) {
      print('❌ Error loading airports: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _addFlightToItinerary() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvider == null || _selectedAirline == null) return;
    if (_selectedOriginAirport == null || _selectedDestinationAirport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor selecciona origen y destino'),
          backgroundColor: BukeerColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Calculate pricing
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final unitCost = double.tryParse(_unitCostController.text) ?? 0;
      final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
      final totalCost = unitCost * quantity;
      final totalPrice = unitPrice * quantity;
      final profit = totalPrice - totalCost;
      final profitPercentage = totalCost > 0 ? (profit / totalCost) * 100 : 0;

      // Get account ID from AppServices
      final accountId = appServices.account.accountId;

      final data = {
        'id_itinerary': widget.itineraryId,
        'id_product': _selectedProvider['id'], // Provider ID as product
        'product_type': 'Vuelos',
        'product_name':
            '${_selectedAirline['name']} - ${_flightNumberController.text}',
        'rate_name': 'Tarifa manual',
        'date': _selectedDate.toIso8601String(),
        'flight_departure': _originController.text,
        'flight_arrival': _destinationController.text,
        'departure_time': _departureTimeController.text,
        'arrival_time': _arrivalTimeController.text,
        'flight_number': _flightNumberController.text,
        'airline': _selectedAirline['id'],
        'quantity': quantity,
        'unit_cost': unitCost,
        'unit_price': unitPrice,
        'total_cost': totalCost,
        'total_price': totalPrice,
        'profit': profit,
        'profit_percentage': profitPercentage,
        'personalized_message': _notesController.text,
        'account_id': accountId,
      };

      if (widget.isEdit && widget.itemId != null) {
        // Update existing
        await SupaFlow.client
            .from('itinerary_items')
            .update(data)
            .eq('id', widget.itemId!);
      } else {
        // Insert new
        await ItineraryItemsTable().insert(data);
      }

      // Close modal first
      Navigator.of(context).pop(true);

      // Show success message after a short delay to ensure modal is closed
      Future.delayed(Duration(milliseconds: 100), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vuelo agregado exitosamente'),
            backgroundColor: BukeerColors.success,
          ),
        );
      });
    } catch (e) {
      print('Error adding flight: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar el vuelo'),
          backgroundColor: BukeerColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSearchableList({
    required String title,
    required List<dynamic> items,
    required dynamic selectedItem,
    required Function(dynamic) onItemSelected,
    required String searchHint,
    required TextEditingController searchController,
    required Function(String) onSearchChanged,
    required String Function(dynamic) getItemTitle,
    String Function(dynamic)? getItemSubtitle,
    IconData itemIcon = Icons.business,
    bool isAirline = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: BukeerTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark
                ? BukeerColors.textPrimaryDark
                : BukeerColors.textPrimary,
          ),
        ),
        SizedBox(height: BukeerSpacing.m),

        // Show selected item if exists
        if (selectedItem != null)
          Container(
            padding: EdgeInsets.all(BukeerSpacing.m),
            margin: EdgeInsets.only(bottom: BukeerSpacing.m),
            decoration: BoxDecoration(
              color: BukeerColors.primary.withOpacity(0.1),
              border: Border.all(
                color: BukeerColors.primary,
                width: BukeerBorders.widthMedium,
              ),
              borderRadius: BukeerBorders.radiusMedium,
            ),
            child: Row(
              children: [
                _buildItemAvatar(selectedItem, itemIcon, isAirline),
                SizedBox(width: BukeerSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getItemTitle(selectedItem),
                        style: BukeerTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary,
                        ),
                      ),
                      if (getItemSubtitle != null &&
                          getItemSubtitle(selectedItem).isNotEmpty) ...[
                        SizedBox(height: BukeerSpacing.xs),
                        Text(
                          getItemSubtitle(selectedItem),
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                BukeerIconButton(
                  icon: Icon(Icons.edit, size: 16),
                  onPressed: () {
                    setState(() {
                      if (isAirline) {
                        _selectedAirline = null;
                      } else {
                        _selectedProvider = null;
                      }
                    });
                  },
                  variant: BukeerIconButtonVariant.ghost,
                  size: BukeerIconButtonSize.small,
                ),
              ],
            ),
          )
        else ...[
          // Search field
          BukeerTextField(
            controller: searchController,
            hintText: searchHint,
            leadingIcon: Icons.search,
            onChanged: onSearchChanged,
          ),
          SizedBox(height: BukeerSpacing.m),

          // Items list
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                width: BukeerBorders.widthThin,
              ),
              borderRadius: BukeerBorders.radiusMedium,
            ),
            child: ListView.builder(
              itemCount: items.length > 3 ? 3 : items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedItem?['id'] == item['id'];

                return ListTile(
                  selected: isSelected,
                  selectedTileColor: BukeerColors.primary.withOpacity(0.1),
                  leading: _buildItemAvatar(item, itemIcon, isAirline),
                  title: Text(
                    getItemTitle(item),
                    style: BukeerTypography.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : null,
                      color: isSelected
                          ? BukeerColors.primary
                          : isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary,
                    ),
                  ),
                  subtitle: getItemSubtitle != null
                      ? Text(
                          getItemSubtitle(item),
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                        )
                      : null,
                  onTap: () => onItemSelected(item),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(BukeerSpacing.l),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                  width: BukeerBorders.widthThin,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flight,
                      color: BukeerColors.primary,
                      size: 28,
                    ),
                    SizedBox(width: BukeerSpacing.s),
                    Text(
                      widget.isEdit ? 'Editar Vuelo' : 'Agregar Vuelo',
                      style: BukeerTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? BukeerColors.textPrimaryDark
                            : BukeerColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                BukeerIconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(false),
                  variant: BukeerIconButtonVariant.ghost,
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(BukeerSpacing.l),
                      children: [
                        // Provider and Airline selectors in a row
                        Row(
                          children: [
                            Expanded(
                              child: _buildSearchableList(
                                title: 'Proveedor de Vuelos',
                                items: _filteredProviders,
                                selectedItem: _selectedProvider,
                                onItemSelected: (provider) {
                                  setState(() => _selectedProvider = provider);
                                },
                                searchHint: 'Buscar proveedor...',
                                searchController: _searchProviderController,
                                onSearchChanged: (value) {
                                  setState(() {
                                    _filteredProviders =
                                        _providers.where((provider) {
                                      final name =
                                          provider['name']?.toLowerCase() ?? '';
                                      final searchLower = value.toLowerCase();
                                      return name.contains(searchLower);
                                    }).toList();
                                  });
                                },
                                getItemTitle: (provider) =>
                                    provider['name'] ?? '',
                                getItemSubtitle: (provider) =>
                                    provider['email'] ?? '',
                              ),
                            ),
                            if (_selectedProvider != null) ...[
                              SizedBox(width: BukeerSpacing.m),
                              Expanded(
                                child: _buildSearchableList(
                                  title: 'Aerolínea',
                                  items: _filteredAirlines,
                                  selectedItem: _selectedAirline,
                                  onItemSelected: (airline) {
                                    setState(() => _selectedAirline = airline);
                                  },
                                  searchHint: 'Buscar aerolínea...',
                                  searchController: _searchAirlineController,
                                  onSearchChanged: (value) {
                                    setState(() {
                                      _filteredAirlines =
                                          _airlines.where((airline) {
                                        final name =
                                            airline['name']?.toLowerCase() ??
                                                '';
                                        final code = airline['iata_code']
                                                ?.toLowerCase() ??
                                            '';
                                        final searchLower = value.toLowerCase();
                                        return name.contains(searchLower) ||
                                            code.contains(searchLower);
                                      }).toList();
                                    });
                                  },
                                  getItemTitle: (airline) =>
                                      airline['name'] ?? '',
                                  getItemSubtitle: (airline) =>
                                      'Código: ${airline['iata_code'] ?? 'N/A'}',
                                  itemIcon: Icons.airlines,
                                  isAirline: true,
                                ),
                              ),
                            ],
                          ],
                        ),

                        if (_selectedAirline != null) ...[
                          SizedBox(height: BukeerSpacing.xl),

                          // Flight details
                          Text(
                            'Detalles del Vuelo',
                            style: BukeerTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? BukeerColors.textPrimaryDark
                                  : BukeerColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          // Origin and destination
                          Row(
                            children: [
                              Expanded(
                                child: _buildAirportSearchableList(
                                  title: 'Origen',
                                  items: _filteredOriginAirports,
                                  selectedItem: _selectedOriginAirport,
                                  searchController: _searchOriginController,
                                  onItemSelected: (airport) {
                                    setState(() {
                                      _selectedOriginAirport = airport;
                                      _originController.text =
                                          '${airport['city_name']} - ${airport['name']} (${airport['iata_code']})';
                                      _searchOriginController.clear();
                                    });
                                  },
                                  onSearchChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        // Show mix of Colombian and international airports when search is empty
                                        final colombianAirports = _airports
                                            .where((airport) =>
                                                airport['iata_country_code'] ==
                                                'CO')
                                            .take(10)
                                            .toList();
                                        final internationalAirports = _airports
                                            .where((airport) =>
                                                airport['iata_country_code'] !=
                                                'CO')
                                            .take(10)
                                            .toList();
                                        _filteredOriginAirports = [
                                          ...colombianAirports,
                                          ...internationalAirports
                                        ];
                                      } else {
                                        // Search in ALL airports when user types
                                        _filteredOriginAirports = _airports
                                            .where((airport) {
                                              final name = airport['name']
                                                      ?.toLowerCase() ??
                                                  '';
                                              final cityName =
                                                  airport['city_name']
                                                          ?.toLowerCase() ??
                                                      '';
                                              final iataCode =
                                                  airport['iata_code']
                                                          ?.toLowerCase() ??
                                                      '';
                                              final searchLower =
                                                  value.toLowerCase();
                                              return name
                                                      .contains(searchLower) ||
                                                  cityName
                                                      .contains(searchLower) ||
                                                  iataCode
                                                      .contains(searchLower);
                                            })
                                            .take(50)
                                            .toList(); // Limit to 50 results for performance
                                      }
                                    });
                                  },
                                  icon: Icons.flight_takeoff,
                                ),
                              ),
                              SizedBox(width: BukeerSpacing.m),
                              Expanded(
                                child: _buildAirportSearchableList(
                                  title: 'Destino',
                                  items: _filteredDestinationAirports,
                                  selectedItem: _selectedDestinationAirport,
                                  searchController:
                                      _searchDestinationController,
                                  onItemSelected: (airport) {
                                    setState(() {
                                      _selectedDestinationAirport = airport;
                                      _destinationController.text =
                                          '${airport['city_name']} - ${airport['name']} (${airport['iata_code']})';
                                      _searchDestinationController.clear();
                                    });
                                  },
                                  onSearchChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        // Show mix of Colombian and international airports when search is empty
                                        final colombianAirports = _airports
                                            .where((airport) =>
                                                airport['iata_country_code'] ==
                                                'CO')
                                            .take(10)
                                            .toList();
                                        final internationalAirports = _airports
                                            .where((airport) =>
                                                airport['iata_country_code'] !=
                                                'CO')
                                            .take(10)
                                            .toList();
                                        _filteredDestinationAirports = [
                                          ...colombianAirports,
                                          ...internationalAirports
                                        ];
                                      } else {
                                        // Search in ALL airports when user types
                                        _filteredDestinationAirports = _airports
                                            .where((airport) {
                                              final name = airport['name']
                                                      ?.toLowerCase() ??
                                                  '';
                                              final cityName =
                                                  airport['city_name']
                                                          ?.toLowerCase() ??
                                                      '';
                                              final iataCode =
                                                  airport['iata_code']
                                                          ?.toLowerCase() ??
                                                      '';
                                              final searchLower =
                                                  value.toLowerCase();
                                              return name
                                                      .contains(searchLower) ||
                                                  cityName
                                                      .contains(searchLower) ||
                                                  iataCode
                                                      .contains(searchLower);
                                            })
                                            .take(50)
                                            .toList(); // Limit to 50 results for performance
                                      }
                                    });
                                  },
                                  icon: Icons.flight_land,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          // Date, Quantity and Flight Number in a row
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha del Vuelo',
                                      style:
                                          BukeerTypography.titleSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? BukeerColors.textPrimaryDark
                                            : BukeerColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: BukeerSpacing.s),
                                    InkWell(
                                      onTap: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: _selectedDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 730)),
                                        );
                                        if (date != null) {
                                          setState(() => _selectedDate = date);
                                        }
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(BukeerSpacing.m),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isDark
                                                ? BukeerColors.dividerDark
                                                : BukeerColors.divider,
                                            width: BukeerBorders.widthThin,
                                          ),
                                          borderRadius:
                                              BukeerBorders.radiusMedium,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 20,
                                              color: isDark
                                                  ? BukeerColors
                                                      .textSecondaryDark
                                                  : BukeerColors.textSecondary,
                                            ),
                                            SizedBox(width: BukeerSpacing.s),
                                            Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(_selectedDate),
                                              style: BukeerTypography.bodyMedium
                                                  .copyWith(
                                                color: isDark
                                                    ? BukeerColors
                                                        .textPrimaryDark
                                                    : BukeerColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: BukeerSpacing.m),
                              Expanded(
                                flex: 1,
                                child: BukeerTextField(
                                  controller: _quantityController,
                                  label: 'Cantidad',
                                  type: BukeerTextFieldType.number,
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requerido';
                                    }
                                    if (int.tryParse(value) == null ||
                                        int.parse(value) < 1) {
                                      return 'Cantidad inválida';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: BukeerSpacing.m),
                              Expanded(
                                flex: 2,
                                child: BukeerTextField(
                                  controller: _flightNumberController,
                                  label: 'Número de Vuelo',
                                  hintText: 'AA1234',
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Número de vuelo requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: BukeerSpacing.m),

                          // Times
                          Row(
                            children: [
                              Expanded(
                                child: BukeerTextField(
                                  controller: _departureTimeController,
                                  label: 'Hora de Salida',
                                  hintText: '14:30',
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: BukeerSpacing.m),
                              Expanded(
                                child: BukeerTextField(
                                  controller: _arrivalTimeController,
                                  label: 'Hora de Llegada',
                                  hintText: '16:45',
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: BukeerSpacing.xl),

                          // Pricing section
                          Text(
                            'Precios y Tarifas',
                            style: BukeerTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? BukeerColors.textPrimaryDark
                                  : BukeerColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          // Pricing fields in a row
                          Row(
                            children: [
                              Expanded(
                                child: BukeerTextField(
                                  controller: _unitCostController,
                                  label: 'Costo Unitario',
                                  hintText: '0.00',
                                  type: BukeerTextFieldType.decimal,
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Costo requerido';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Valor inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: BukeerSpacing.m),
                              Expanded(
                                child: BukeerTextField(
                                  controller: _markupController,
                                  label: 'Markup (%)',
                                  hintText: '0',
                                  type: BukeerTextFieldType.decimal,
                                ),
                              ),
                              SizedBox(width: BukeerSpacing.m),
                              Expanded(
                                child: BukeerTextField(
                                  controller: _unitPriceController,
                                  label: 'Tarifa Unitaria',
                                  hintText: '0.00',
                                  type: BukeerTextFieldType.decimal,
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Tarifa requerida';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Valor inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Compact total display box
                          SizedBox(height: BukeerSpacing.m),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: BukeerSpacing.m,
                              vertical: BukeerSpacing.s,
                            ),
                            decoration: BoxDecoration(
                              color: BukeerColors.primary.withOpacity(0.1),
                              borderRadius: BukeerBorders.radiusMedium,
                              border: Border.all(
                                color: BukeerColors.primary,
                                width: BukeerBorders.widthMedium,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: BukeerTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? BukeerColors.textPrimaryDark
                                        : BukeerColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                    symbol: '\$',
                                    decimalDigits: 2,
                                    locale: 'es_CO',
                                  ).format(_total),
                                  style:
                                      BukeerTypography.headlineSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? BukeerColors.primaryLight
                                        : BukeerColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: BukeerSpacing.m),

                          // Notes
                          BukeerTextField(
                            controller: _notesController,
                            label: 'Notas',
                            hintText: 'Información adicional del vuelo...',
                            maxLines: 3,
                          ),
                        ],
                      ],
                    ),
                  ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(BukeerSpacing.l),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BukeerButton(
                  text: 'Cancelar',
                  onPressed: () => Navigator.of(context).pop(false),
                  variant: BukeerButtonVariant.secondary,
                ),
                SizedBox(width: BukeerSpacing.m),
                BukeerButton(
                  text: widget.isEdit ? 'Guardar' : 'Agregar',
                  onPressed:
                      (_selectedProvider != null && _selectedAirline != null)
                          ? _addFlightToItinerary
                          : null,
                  variant: BukeerButtonVariant.primary,
                  icon: widget.isEdit ? Icons.save : Icons.add,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemAvatar(dynamic item, IconData defaultIcon, bool isAirline) {
    if (isAirline) {
      // For airlines, try to show airline logo
      final logoUrl = item['logo_png'];
      if (logoUrl != null && logoUrl.toString().isNotEmpty) {
        return CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.network(
              logoUrl,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.airlines,
                  color: BukeerColors.primary,
                  size: 20,
                );
              },
            ),
          ),
        );
      }
    } else {
      // For providers, try to show contact image - the field is 'user_image'
      final imageUrl = item['user_image'];
      if (imageUrl != null && imageUrl.toString().isNotEmpty) {
        return CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          onBackgroundImageError: (exception, stackTrace) {
            // Will fall back to default icon
          },
          child: null,
        );
      }
    }

    // Default fallback icon
    return CircleAvatar(
      backgroundColor: BukeerColors.primary.withOpacity(0.1),
      child: Icon(
        defaultIcon,
        color: BukeerColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildAirportSearchableList({
    required String title,
    required List<dynamic> items,
    required dynamic selectedItem,
    required Function(dynamic) onItemSelected,
    required TextEditingController searchController,
    required Function(String) onSearchChanged,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: BukeerTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark
                ? BukeerColors.textPrimaryDark
                : BukeerColors.textPrimary,
          ),
        ),
        SizedBox(height: BukeerSpacing.s),

        // Show selected airport if exists
        if (selectedItem != null)
          Container(
            padding: EdgeInsets.all(BukeerSpacing.m),
            margin: EdgeInsets.only(bottom: BukeerSpacing.s),
            decoration: BoxDecoration(
              color: BukeerColors.primary.withOpacity(0.1),
              border: Border.all(
                color: BukeerColors.primary,
                width: BukeerBorders.widthMedium,
              ),
              borderRadius: BukeerBorders.radiusMedium,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: BukeerColors.primary,
                  size: 16,
                ),
                SizedBox(width: BukeerSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedItem['city_name'] ?? ''} (${selectedItem['iata_code'] ?? ''})',
                        style: BukeerTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary,
                        ),
                      ),
                      Text(
                        selectedItem['name'] ?? '',
                        style: BukeerTypography.bodySmall.copyWith(
                          color: isDark
                              ? BukeerColors.textSecondaryDark
                              : BukeerColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                BukeerIconButton(
                  icon: Icon(Icons.close, size: 16),
                  onPressed: () {
                    setState(() {
                      if (icon == Icons.flight_takeoff) {
                        _selectedOriginAirport = null;
                        _originController.clear();
                      } else {
                        _selectedDestinationAirport = null;
                        _destinationController.clear();
                      }
                    });
                  },
                  variant: BukeerIconButtonVariant.ghost,
                  size: BukeerIconButtonSize.small,
                ),
              ],
            ),
          )
        else ...[
          // Search field
          BukeerTextField(
            controller: searchController,
            hintText: 'Buscar aeropuerto...',
            leadingIcon: Icons.search,
            onChanged: onSearchChanged,
          ),
          SizedBox(height: BukeerSpacing.s),

          // Airports list
          Container(
            height: 140,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                width: BukeerBorders.widthThin,
              ),
              borderRadius: BukeerBorders.radiusSmall,
            ),
            child: items.isEmpty
                ? Center(
                    child: Text(
                      searchController.text.isEmpty
                          ? 'Escribe para buscar aeropuertos'
                          : 'No se encontraron aeropuertos para "${searchController.text}"',
                      style: BukeerTypography.bodySmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length > 3 ? 3 : items.length,
                    itemBuilder: (context, index) {
                      final airport = items[index];
                      final isInternational =
                          airport['iata_country_code'] != 'CO';

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          isInternational ? Icons.public : Icons.flight,
                          color: isInternational
                              ? BukeerColors.info
                              : BukeerColors.primary,
                          size: 20,
                        ),
                        title: Text(
                          '${airport['city_name'] ?? 'Sin ciudad'} (${airport['iata_code'] ?? 'N/A'})',
                          style: BukeerTypography.bodyMedium.copyWith(
                            color: isDark
                                ? BukeerColors.textPrimaryDark
                                : BukeerColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          airport['name'] ?? 'Sin nombre',
                          style: BukeerTypography.bodySmall.copyWith(
                            color: isDark
                                ? BukeerColors.textSecondaryDark
                                : BukeerColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: isInternational
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: BukeerSpacing.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: BukeerColors.info.withOpacity(0.1),
                                  borderRadius: BukeerBorders.radiusSmall,
                                ),
                                child: Text(
                                  'Internacional',
                                  style: BukeerTypography.labelSmall.copyWith(
                                    color: BukeerColors.info,
                                  ),
                                ),
                              )
                            : null,
                        onTap: () => onItemSelected(airport),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }

  // Load flight data for editing
  Future<void> _loadFlightData() async {
    setState(() => _isLoading = true);

    try {
      final response = await SupaFlow.client.from('itinerary_items').select('''
            *,
            contacts!provider(*),
            airlines!airline(*)
          ''').eq('id', widget.itemId!).single();

      if (response != null) {
        // Set provider
        _selectedProvider = response['contacts'];

        // Set airline
        _selectedAirline = response['airlines'];

        // Set flight details
        _flightNumberController.text = response['flight_number'] ?? '';
        _departureTimeController.text = response['departure_time'] ?? '';
        _arrivalTimeController.text = response['arrival_time'] ?? '';

        // Set airports
        final departure = response['flight_departure'] ?? '';
        final arrival = response['flight_arrival'] ?? '';

        // Extract airport codes and search for them
        if (departure.contains(' - ')) {
          final code = departure.split(' - ').first;
          final airport = _airports.firstWhere(
            (a) => a['iata_code'] == code,
            orElse: () => null,
          );
          if (airport != null) {
            _selectedOriginAirport = airport;
            _originController.text = departure;
          }
        }

        if (arrival.contains(' - ')) {
          final code = arrival.split(' - ').first;
          final airport = _airports.firstWhere(
            (a) => a['iata_code'] == code,
            orElse: () => null,
          );
          if (airport != null) {
            _selectedDestinationAirport = airport;
            _destinationController.text = arrival;
          }
        }

        // Set date
        if (response['date'] != null) {
          _selectedDate = DateTime.parse(response['date']);
          _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
        }

        // Set pricing
        _quantityController.text = (response['quantity'] ?? 1).toString();
        _unitCostController.text = (response['unit_cost'] ?? 0.0).toString();
        _markupController.text =
            (response['profit_percentage'] ?? 0.0).toString();
        _unitPriceController.text = (response['unit_price'] ?? 0.0).toString();

        // Set notes
        _notesController.text = response['personalized_message'] ?? '';

        // Calculate total
        _updateTotal();
      }
    } catch (e) {
      print('Error loading flight data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar los datos del vuelo'),
          backgroundColor: BukeerColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
