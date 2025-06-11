import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/legacy/flutter_flow/flutter_flow_theme.dart';
import '/legacy/flutter_flow/flutter_flow_widgets.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import '/design_system/index.dart';
import '../../../core/widgets/forms/dropdowns/airports/dropdown_airports_widget.dart';

class AddFlightsWidget extends StatefulWidget {
  const AddFlightsWidget({
    Key? key,
    required this.itineraryId,
    this.isEdit = false,
  }) : super(key: key);

  final String? itineraryId;
  final bool isEdit;

  static String routeName = 'add_flights';
  static String routePath = 'addFlights';

  @override
  State<AddFlightsWidget> createState() => _AddFlightsWidgetState();
}

class _AddFlightsWidgetState extends State<AddFlightsWidget> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _searchController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  final _dateController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  // Selected values
  dynamic _selectedFlight;
  dynamic _selectedRate;
  String? _selectedDeparture;
  String? _selectedArrival;
  DateTime _selectedDate = DateTime.now();

  // Lists
  List<dynamic> _airlines = [];
  List<dynamic> _filteredAirlines = [];
  List<dynamic> _rates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAirlines();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _flightNumberController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadAirlines() async {
    setState(() => _isLoading = true);

    try {
      // Note: flights table doesn't exist, so using a mock structure
      // In production, this should load from the actual flights table
      setState(() {
        _airlines = [
          {
            'id': '1',
            'name': 'American Airlines',
            'iata_code': 'AA',
            'logo_url':
                'https://logos.skyscnr.com/images/airlines/favicon/AA.png',
            'contacts': {'id': '1', 'name': 'American Airlines Inc.'}
          },
          {
            'id': '2',
            'name': 'United Airlines',
            'iata_code': 'UA',
            'logo_url':
                'https://logos.skyscnr.com/images/airlines/favicon/UA.png',
            'contacts': {'id': '2', 'name': 'United Airlines Inc.'}
          },
          {
            'id': '3',
            'name': 'Delta Air Lines',
            'iata_code': 'DL',
            'logo_url':
                'https://logos.skyscnr.com/images/airlines/favicon/DL.png',
            'contacts': {'id': '3', 'name': 'Delta Air Lines Inc.'}
          },
        ];
        _filteredAirlines = _airlines;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading airlines: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRates(String airlineId) async {
    try {
      // Mock rates for demonstration
      setState(() {
        _rates = [
          {
            'id': '1',
            'name': 'Economy',
            'price': 250.0,
            'cost': 200.0,
            'description': 'Basic economy fare'
          },
          {
            'id': '2',
            'name': 'Premium Economy',
            'price': 450.0,
            'cost': 380.0,
            'description': 'Premium economy with extra legroom'
          },
          {
            'id': '3',
            'name': 'Business',
            'price': 1200.0,
            'cost': 1000.0,
            'description': 'Business class fare'
          },
        ];
        if (_rates.isNotEmpty) {
          _selectedRate = _rates.first;
        }
      });
    } catch (e) {
      print('Error loading rates: $e');
    }
  }

  Future<void> _addFlightToItinerary() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFlight == null || _selectedRate == null) return;
    if (_selectedDeparture == null || _selectedArrival == null) return;

    setState(() => _isLoading = true);

    try {
      // Calculate pricing
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final unitCost = (_selectedRate['cost'] ?? 0.0) as double;
      final unitPrice = (_selectedRate['price'] ?? 0.0) as double;
      final totalCost = unitCost * quantity;
      final totalPrice = unitPrice * quantity;
      final profit = totalPrice - totalCost;
      final profitPercentage = totalCost > 0 ? (profit / totalCost) * 100 : 0;

      // Add to itinerary
      await ItineraryItemsTable().insert({
        'id_itinerary': widget.itineraryId,
        'id_product': _selectedFlight['id'],
        'product_type': 'Vuelos',
        'product_name':
            '${_selectedFlight['name']} - ${_flightNumberController.text}',
        'rate_name': _selectedRate['name'],
        'date': _selectedDate.toIso8601String(),
        'flight_departure': _selectedDeparture,
        'flight_arrival': _selectedArrival,
        'departure_time': _departureTimeController.text,
        'arrival_time': _arrivalTimeController.text,
        'flight_number': _flightNumberController.text,
        'airline': _selectedFlight['name'],
        'quantity': quantity,
        'unit_cost': unitCost,
        'unit_price': unitPrice,
        'total_cost': totalCost,
        'total_price': totalPrice,
        'profit': profit,
        'profit_percentage': profitPercentage,
        'reservation_status': false,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vuelo agregado exitosamente'),
          backgroundColor: BukeerColors.success,
        ),
      );

      // Close modal
      Navigator.of(context).pop(true);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                        // Airline selector
                        Text(
                          'Seleccionar Aerolínea',
                          style: BukeerTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? BukeerColors.textPrimaryDark
                                : BukeerColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: BukeerSpacing.m),

                        // Search field
                        BukeerTextField(
                          controller: _searchController,
                          hintText: 'Buscar aerolínea...',
                          leadingIcon: Icons.search,
                          onChanged: (value) {
                            setState(() {
                              _filteredAirlines = _airlines.where((airline) {
                                final name =
                                    airline['name']?.toLowerCase() ?? '';
                                final code =
                                    airline['iata_code']?.toLowerCase() ?? '';
                                final searchLower = value.toLowerCase();
                                return name.contains(searchLower) ||
                                    code.contains(searchLower);
                              }).toList();
                            });
                          },
                        ),
                        SizedBox(height: BukeerSpacing.m),

                        // Airlines list
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? BukeerColors.dividerDark
                                  : BukeerColors.divider,
                              width: BukeerBorders.widthThin,
                            ),
                            borderRadius: BukeerBorders.radiusMedium,
                          ),
                          child: ListView.builder(
                            itemCount: _filteredAirlines.length,
                            itemBuilder: (context, index) {
                              final airline = _filteredAirlines[index];
                              final isSelected =
                                  _selectedFlight?['id'] == airline['id'];

                              return ListTile(
                                selected: isSelected,
                                selectedTileColor:
                                    BukeerColors.primary.withOpacity(0.1),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      BukeerColors.primary.withOpacity(0.1),
                                  child: Text(
                                    airline['iata_code'] ?? 'XX',
                                    style: BukeerTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: BukeerColors.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  airline['name'] ?? '',
                                  style: BukeerTypography.bodyLarge.copyWith(
                                    fontWeight:
                                        isSelected ? FontWeight.w600 : null,
                                    color: isSelected
                                        ? BukeerColors.primary
                                        : isDark
                                            ? BukeerColors.textPrimaryDark
                                            : BukeerColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  'Código: ${airline['iata_code'] ?? 'N/A'}',
                                  style: BukeerTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? BukeerColors.textSecondaryDark
                                        : BukeerColors.textSecondary,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedFlight = airline;
                                    _selectedRate = null;
                                    _rates = [];
                                  });
                                  _loadRates(airline['id']);
                                },
                              );
                            },
                          ),
                        ),

                        if (_selectedFlight != null) ...[
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

                          // Flight number
                          BukeerTextField(
                            controller: _flightNumberController,
                            label: 'Número de Vuelo',
                            hintText: 'Ej: AA1234',
                            required: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Número de vuelo requerido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          // Departure and arrival
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Origen',
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
                                        final result =
                                            await showModalBottomSheet<String>(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              DropdownAirportsWidget(
                                                  type: 'departure'),
                                        );
                                        if (result != null) {
                                          setState(() =>
                                              _selectedDeparture = result);
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
                                              Icons.flight_takeoff,
                                              size: 20,
                                              color: isDark
                                                  ? BukeerColors
                                                      .textSecondaryDark
                                                  : BukeerColors.textSecondary,
                                            ),
                                            SizedBox(width: BukeerSpacing.s),
                                            Text(
                                              _selectedDeparture ??
                                                  'Seleccionar',
                                              style: BukeerTypography.bodyMedium
                                                  .copyWith(
                                                color: _selectedDeparture !=
                                                        null
                                                    ? (isDark
                                                        ? BukeerColors
                                                            .textPrimaryDark
                                                        : BukeerColors
                                                            .textPrimary)
                                                    : (isDark
                                                        ? BukeerColors
                                                            .textSecondaryDark
                                                        : BukeerColors
                                                            .textSecondary),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Destino',
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
                                        final result =
                                            await showModalBottomSheet<String>(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              DropdownAirportsWidget(
                                                  type: 'arrival'),
                                        );
                                        if (result != null) {
                                          setState(
                                              () => _selectedArrival = result);
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
                                              Icons.flight_land,
                                              size: 20,
                                              color: isDark
                                                  ? BukeerColors
                                                      .textSecondaryDark
                                                  : BukeerColors.textSecondary,
                                            ),
                                            SizedBox(width: BukeerSpacing.s),
                                            Text(
                                              _selectedArrival ?? 'Seleccionar',
                                              style: BukeerTypography.bodyMedium
                                                  .copyWith(
                                                color: _selectedArrival != null
                                                    ? (isDark
                                                        ? BukeerColors
                                                            .textPrimaryDark
                                                        : BukeerColors
                                                            .textPrimary)
                                                    : (isDark
                                                        ? BukeerColors
                                                            .textSecondaryDark
                                                        : BukeerColors
                                                            .textSecondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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

                          // Rate selector
                          Text(
                            'Seleccionar Tarifa',
                            style: BukeerTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? BukeerColors.textPrimaryDark
                                  : BukeerColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          if (_rates.isEmpty)
                            Center(
                              child: Text(
                                'No hay tarifas disponibles',
                                style: BukeerTypography.bodyMedium.copyWith(
                                  color: isDark
                                      ? BukeerColors.textSecondaryDark
                                      : BukeerColors.textSecondary,
                                ),
                              ),
                            )
                          else
                            ...List.generate(_rates.length, (index) {
                              final rate = _rates[index];
                              final isSelected =
                                  _selectedRate?['id'] == rate['id'];

                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: BukeerSpacing.s),
                                child: InkWell(
                                  onTap: () =>
                                      setState(() => _selectedRate = rate),
                                  borderRadius: BukeerBorders.radiusMedium,
                                  child: Container(
                                    padding: EdgeInsets.all(BukeerSpacing.m),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? BukeerColors.primary
                                            : isDark
                                                ? BukeerColors.dividerDark
                                                : BukeerColors.divider,
                                        width: isSelected
                                            ? BukeerBorders.widthMedium
                                            : BukeerBorders.widthThin,
                                      ),
                                      borderRadius: BukeerBorders.radiusMedium,
                                      color: isSelected
                                          ? BukeerColors.primary
                                              .withOpacity(0.05)
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                rate['name'] ?? '',
                                                style: BukeerTypography
                                                    .bodyLarge
                                                    .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark
                                                      ? BukeerColors
                                                          .textPrimaryDark
                                                      : BukeerColors
                                                          .textPrimary,
                                                ),
                                              ),
                                              if (rate['description'] !=
                                                  null) ...[
                                                SizedBox(
                                                    height: BukeerSpacing.xs),
                                                Text(
                                                  rate['description']!,
                                                  style: BukeerTypography
                                                      .bodySmall
                                                      .copyWith(
                                                    color: isDark
                                                        ? BukeerColors
                                                            .textSecondaryDark
                                                        : BukeerColors
                                                            .textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '\$${rate['price']?.toStringAsFixed(2) ?? '0.00'}',
                                          style: BukeerTypography.titleMedium
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: BukeerColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                          SizedBox(height: BukeerSpacing.xl),

                          // Date and quantity
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha',
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cantidad',
                                      style:
                                          BukeerTypography.titleSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? BukeerColors.textPrimaryDark
                                            : BukeerColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: BukeerSpacing.s),
                                    BukeerTextField(
                                      controller: _quantityController,
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
                                  ],
                                ),
                              ),
                            ],
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
                  onPressed: (_selectedFlight != null &&
                          _selectedRate != null &&
                          _selectedDeparture != null &&
                          _selectedArrival != null)
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
}
