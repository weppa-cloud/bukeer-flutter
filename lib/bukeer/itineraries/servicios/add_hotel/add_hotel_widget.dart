import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/legacy/flutter_flow/flutter_flow_theme.dart';
import '/legacy/flutter_flow/flutter_flow_widgets.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import '/design_system/index.dart';

class AddHotelWidget extends StatefulWidget {
  const AddHotelWidget({
    Key? key,
    required this.itineraryId,
    this.isEdit = false,
  }) : super(key: key);

  final String? itineraryId;
  final bool isEdit;

  static String routeName = 'add_hotel';
  static String routePath = 'addHotel';

  @override
  State<AddHotelWidget> createState() => _AddHotelWidgetState();
}

class _AddHotelWidgetState extends State<AddHotelWidget> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _searchController = TextEditingController();
  final _checkInDateController = TextEditingController();
  final _checkOutDateController = TextEditingController();
  final _nightsController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  // Selected values
  dynamic _selectedHotel;
  dynamic _selectedRate;
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 1));

  // Lists
  List<dynamic> _hotels = [];
  List<dynamic> _filteredHotels = [];
  List<dynamic> _rates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHotels();
    _updateNights();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _checkInDateController.dispose();
    _checkOutDateController.dispose();
    _nightsController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _updateNights() {
    final nights = _checkOutDate.difference(_checkInDate).inDays;
    _nightsController.text = nights.toString();
  }

  Future<void> _loadHotels() async {
    setState(() => _isLoading = true);

    try {
      // Load hotels with provider information
      final hotels = await SupaFlow.client
          .from('hotels')
          .select('*, contacts!hotels_id_contact_fkey(id, name)')
          .order('name');

      setState(() {
        _hotels = hotels;
        _filteredHotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading hotels: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRates(String hotelId) async {
    try {
      final rates = await HotelRatesTable().queryRows(
        queryFn: (q) => q.eq('id_hotel', hotelId).order('name'),
      );

      setState(() {
        _rates = rates;
        if (rates.isNotEmpty) {
          _selectedRate = rates.first;
        }
      });
    } catch (e) {
      print('Error loading rates: $e');
    }
  }

  Future<void> _addHotelToItinerary() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHotel == null || _selectedRate == null) return;

    setState(() => _isLoading = true);

    try {
      // Calculate pricing
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final nights = int.tryParse(_nightsController.text) ?? 1;
      final unitCost = _selectedRate.cost ?? 0.0;
      final unitPrice = _selectedRate.price ?? 0.0;
      final totalCost = unitCost * quantity * nights;
      final totalPrice = unitPrice * quantity * nights;
      final profit = totalPrice - totalCost;
      final profitPercentage = totalCost > 0 ? (profit / totalCost) * 100 : 0;

      // Add to itinerary
      await ItineraryItemsTable().insert({
        'id_itinerary': widget.itineraryId,
        'id_product': _selectedHotel['id'],
        'product_type': 'Hoteles',
        'product_name': _selectedHotel['name'],
        'rate_name': _selectedRate.name,
        'date': _checkInDate.toIso8601String(),
        'destination': _selectedHotel['location'] ?? '',
        'hotel_nights': nights,
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
          content: Text('Hotel agregado exitosamente'),
          backgroundColor: BukeerColors.success,
        ),
      );

      // Close modal
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error adding hotel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar el hotel'),
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
                      Icons.hotel,
                      color: BukeerColors.primary,
                      size: 28,
                    ),
                    SizedBox(width: BukeerSpacing.s),
                    Text(
                      widget.isEdit ? 'Editar Hotel' : 'Agregar Hotel',
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
                        // Hotel selector
                        Text(
                          'Seleccionar Hotel',
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
                          hintText: 'Buscar hotel...',
                          leadingIcon: Icons.search,
                          onChanged: (value) {
                            setState(() {
                              _filteredHotels = _hotels.where((hotel) {
                                final name = hotel['name']?.toLowerCase() ?? '';
                                final location =
                                    hotel['location']?.toLowerCase() ?? '';
                                final searchLower = value.toLowerCase();
                                return name.contains(searchLower) ||
                                    location.contains(searchLower);
                              }).toList();
                            });
                          },
                        ),
                        SizedBox(height: BukeerSpacing.m),

                        // Hotels list
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
                            itemCount: _filteredHotels.length,
                            itemBuilder: (context, index) {
                              final hotel = _filteredHotels[index];
                              final isSelected =
                                  _selectedHotel?['id'] == hotel['id'];

                              return ListTile(
                                selected: isSelected,
                                selectedTileColor:
                                    BukeerColors.primary.withOpacity(0.1),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      BukeerColors.primary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.hotel,
                                    color: BukeerColors.primary,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  hotel['name'] ?? '',
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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hotel['location'] != null &&
                                        hotel['location'].toString().isNotEmpty)
                                      Text(
                                        hotel['location'],
                                        style:
                                            BukeerTypography.bodySmall.copyWith(
                                          color: isDark
                                              ? BukeerColors.textSecondaryDark
                                              : BukeerColors.textSecondary,
                                        ),
                                      ),
                                    if (hotel['contacts'] != null &&
                                        hotel['contacts']['name'] != null)
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.business,
                                            size: 12,
                                            color: isDark
                                                ? BukeerColors.textSecondaryDark
                                                : BukeerColors.textSecondary,
                                          ),
                                          SizedBox(width: BukeerSpacing.xs),
                                          Text(
                                            hotel['contacts']['name'],
                                            style: BukeerTypography.bodySmall
                                                .copyWith(
                                              color: isDark
                                                  ? BukeerColors
                                                      .textSecondaryDark
                                                  : BukeerColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedHotel = hotel;
                                    _selectedRate = null;
                                    _rates = [];
                                  });
                                  _loadRates(hotel['id']);
                                },
                              );
                            },
                          ),
                        ),

                        if (_selectedHotel != null) ...[
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
                              final isSelected = _selectedRate?.id == rate.id;

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
                                                rate.name ?? '',
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
                                              if (rate.description != null) ...[
                                                SizedBox(
                                                    height: BukeerSpacing.xs),
                                                Text(
                                                  rate.description!,
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$${rate.price?.toStringAsFixed(2) ?? '0.00'}',
                                              style: BukeerTypography
                                                  .titleMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: BukeerColors.primary,
                                              ),
                                            ),
                                            Text(
                                              'por noche',
                                              style: BukeerTypography.bodySmall
                                                  .copyWith(
                                                color: isDark
                                                    ? BukeerColors
                                                        .textSecondaryDark
                                                    : BukeerColors
                                                        .textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                          SizedBox(height: BukeerSpacing.xl),

                          // Dates
                          Text(
                            'Fechas de Estadía',
                            style: BukeerTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? BukeerColors.textPrimaryDark
                                  : BukeerColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Check-in',
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
                                          initialDate: _checkInDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 730)),
                                        );
                                        if (date != null) {
                                          setState(() {
                                            _checkInDate = date;
                                            // Ensure check-out is after check-in
                                            if (_checkOutDate
                                                .isBefore(_checkInDate)) {
                                              _checkOutDate = _checkInDate
                                                  .add(Duration(days: 1));
                                            }
                                            _updateNights();
                                          });
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
                                                  .format(_checkInDate),
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
                                      'Check-out',
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
                                          initialDate: _checkOutDate,
                                          firstDate: _checkInDate
                                              .add(Duration(days: 1)),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 730)),
                                        );
                                        if (date != null) {
                                          setState(() {
                                            _checkOutDate = date;
                                            _updateNights();
                                          });
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
                                                  .format(_checkOutDate),
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
                            ],
                          ),

                          SizedBox(height: BukeerSpacing.m),

                          // Nights and quantity
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Noches',
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
                                      controller: _nightsController,
                                      type: BukeerTextFieldType.number,
                                      readOnly: true,
                                      enabled: false,
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
                                      'Habitaciones',
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
                  onPressed: _selectedHotel != null && _selectedRate != null
                      ? _addHotelToItinerary
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
