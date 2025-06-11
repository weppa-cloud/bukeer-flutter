import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/legacy/flutter_flow/flutter_flow_theme.dart';
import '/legacy/flutter_flow/flutter_flow_widgets.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import '/design_system/index.dart';

class AddTransferWidget extends StatefulWidget {
  const AddTransferWidget({
    Key? key,
    required this.itineraryId,
    this.isEdit = false,
  }) : super(key: key);

  final String? itineraryId;
  final bool isEdit;

  static String routeName = 'add_transfer';
  static String routePath = 'addTransfer';

  @override
  State<AddTransferWidget> createState() => _AddTransferWidgetState();
}

class _AddTransferWidgetState extends State<AddTransferWidget> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _searchController = TextEditingController();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  // Selected values
  dynamic _selectedTransfer;
  dynamic _selectedRate;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Lists
  List<dynamic> _transfers = [];
  List<dynamic> _filteredTransfers = [];
  List<dynamic> _rates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransfers();
    _updateTimeController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pickupController.dispose();
    _dropoffController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _updateTimeController() {
    final hour = _selectedTime.hour.toString().padLeft(2, '0');
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    _timeController.text = '$hour:$minute';
  }

  Future<void> _loadTransfers() async {
    setState(() => _isLoading = true);

    try {
      // Load transfers with provider information
      final transfers = await SupaFlow.client
          .from('transfers')
          .select('*, contacts!transfers_id_contact_fkey(id, name)')
          .order('name');

      setState(() {
        _transfers = transfers;
        _filteredTransfers = transfers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading transfers: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRates(String transferId) async {
    try {
      final rates = await TransferRatesTable().queryRows(
        queryFn: (q) => q.eq('id_transfer', transferId).order('name'),
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

  Future<void> _addTransferToItinerary() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTransfer == null || _selectedRate == null) return;
    if (_pickupController.text.isEmpty || _dropoffController.text.isEmpty)
      return;

    setState(() => _isLoading = true);

    try {
      // Calculate pricing
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final unitCost = _selectedRate.cost ?? 0.0;
      final unitPrice = _selectedRate.price ?? 0.0;
      final totalCost = unitCost * quantity;
      final totalPrice = unitPrice * quantity;
      final profit = totalPrice - totalCost;
      final profitPercentage = totalCost > 0 ? (profit / totalCost) * 100 : 0;

      // Combine date and time
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Add to itinerary
      await ItineraryItemsTable().insert({
        'id_itinerary': widget.itineraryId,
        'id_product': _selectedTransfer['id'],
        'product_type': 'Transporte',
        'product_name': _selectedTransfer['name'],
        'rate_name': _selectedRate.name,
        'date': dateTime.toIso8601String(),
        'destination': '${_pickupController.text} → ${_dropoffController.text}',
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
          content: Text('Transporte agregado exitosamente'),
          backgroundColor: BukeerColors.success,
        ),
      );

      // Close modal
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error adding transfer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar el transporte'),
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
                      Icons.directions_car,
                      color: BukeerColors.primary,
                      size: 28,
                    ),
                    SizedBox(width: BukeerSpacing.s),
                    Text(
                      widget.isEdit
                          ? 'Editar Transporte'
                          : 'Agregar Transporte',
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
                        // Transfer selector
                        Text(
                          'Seleccionar Transporte',
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
                          hintText: 'Buscar transporte...',
                          leadingIcon: Icons.search,
                          onChanged: (value) {
                            setState(() {
                              _filteredTransfers = _transfers.where((transfer) {
                                final name =
                                    transfer['name']?.toLowerCase() ?? '';
                                final type =
                                    transfer['vehicle_type']?.toLowerCase() ??
                                        '';
                                final searchLower = value.toLowerCase();
                                return name.contains(searchLower) ||
                                    type.contains(searchLower);
                              }).toList();
                            });
                          },
                        ),
                        SizedBox(height: BukeerSpacing.m),

                        // Transfers list
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
                            itemCount: _filteredTransfers.length,
                            itemBuilder: (context, index) {
                              final transfer = _filteredTransfers[index];
                              final isSelected =
                                  _selectedTransfer?['id'] == transfer['id'];

                              return ListTile(
                                selected: isSelected,
                                selectedTileColor:
                                    BukeerColors.primary.withOpacity(0.1),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      BukeerColors.primary.withOpacity(0.1),
                                  child: Icon(
                                    _getVehicleIcon(transfer['vehicle_type']),
                                    color: BukeerColors.primary,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  transfer['name'] ?? '',
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
                                    if (transfer['vehicle_type'] != null)
                                      Text(
                                        transfer['vehicle_type'],
                                        style:
                                            BukeerTypography.bodySmall.copyWith(
                                          color: isDark
                                              ? BukeerColors.textSecondaryDark
                                              : BukeerColors.textSecondary,
                                        ),
                                      ),
                                    if (transfer['contacts'] != null &&
                                        transfer['contacts']['name'] != null)
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
                                            transfer['contacts']['name'],
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
                                    _selectedTransfer = transfer;
                                    _selectedRate = null;
                                    _rates = [];
                                  });
                                  _loadRates(transfer['id']);
                                },
                              );
                            },
                          ),
                        ),

                        if (_selectedTransfer != null) ...[
                          SizedBox(height: BukeerSpacing.xl),

                          // Route details
                          Text(
                            'Detalles de la Ruta',
                            style: BukeerTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? BukeerColors.textPrimaryDark
                                  : BukeerColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          // Pickup location
                          BukeerTextField(
                            controller: _pickupController,
                            label: 'Lugar de Recogida',
                            hintText: 'Ej: Hotel Marriott',
                            leadingIcon: Icons.location_on,
                            required: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lugar de recogida requerido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: BukeerSpacing.m),

                          // Dropoff location
                          BukeerTextField(
                            controller: _dropoffController,
                            label: 'Lugar de Destino',
                            hintText: 'Ej: Aeropuerto Internacional',
                            leadingIcon: Icons.flag,
                            required: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lugar de destino requerido';
                              }
                              return null;
                            },
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
                                        Text(
                                          '\$${rate.price?.toStringAsFixed(2) ?? '0.00'}',
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

                          // Date and time
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
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
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hora',
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
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: _selectedTime,
                                        );
                                        if (time != null) {
                                          setState(() {
                                            _selectedTime = time;
                                            _updateTimeController();
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
                                              Icons.access_time,
                                              size: 20,
                                              color: isDark
                                                  ? BukeerColors
                                                      .textSecondaryDark
                                                  : BukeerColors.textSecondary,
                                            ),
                                            SizedBox(width: BukeerSpacing.s),
                                            Text(
                                              _timeController.text,
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

                          // Quantity
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cantidad de Vehículos',
                                style: BukeerTypography.titleSmall.copyWith(
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
                  onPressed: (_selectedTransfer != null &&
                          _selectedRate != null &&
                          _pickupController.text.isNotEmpty &&
                          _dropoffController.text.isNotEmpty)
                      ? _addTransferToItinerary
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

  IconData _getVehicleIcon(String? vehicleType) {
    switch (vehicleType?.toLowerCase()) {
      case 'car':
      case 'auto':
      case 'sedan':
        return Icons.directions_car;
      case 'van':
      case 'minivan':
        return Icons.airport_shuttle;
      case 'bus':
      case 'autobus':
        return Icons.directions_bus;
      case 'suv':
        return Icons.directions_car;
      default:
        return Icons.directions_car;
    }
  }
}
