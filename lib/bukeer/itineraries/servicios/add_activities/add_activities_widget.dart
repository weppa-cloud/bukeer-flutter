import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/legacy/flutter_flow/flutter_flow_theme.dart';
import '/legacy/flutter_flow/flutter_flow_widgets.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import '/design_system/index.dart';

class AddActivitiesWidget extends StatefulWidget {
  const AddActivitiesWidget({
    Key? key,
    required this.itineraryId,
  }) : super(key: key);

  final String? itineraryId;

  @override
  State<AddActivitiesWidget> createState() => _AddActivitiesWidgetState();
}

class _AddActivitiesWidgetState extends State<AddActivitiesWidget> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _searchController = TextEditingController();
  final _dateController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  // Selected values
  dynamic _selectedActivity;
  dynamic _selectedRate;
  DateTime _selectedDate = DateTime.now();

  // Lists
  List<dynamic> _activities = [];
  List<dynamic> _filteredActivities = [];
  List<dynamic> _rates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);

    try {
      // Load activities with provider information
      final activities = await SupaFlow.client
          .from('activities')
          .select('*, contacts!activities_id_contact_fkey(id, name)')
          .order('name');

      setState(() {
        _activities = activities;
        _filteredActivities = activities;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading activities: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRates(String activityId) async {
    try {
      final rates = await ActivitiesRatesTable().queryRows(
        queryFn: (q) => q.eq('id_activity', activityId).order('name'),
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

  Future<void> _addActivityToItinerary() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedActivity == null || _selectedRate == null) return;

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

      // Add to itinerary
      await ItineraryItemsTable().insert({
        'id_itinerary': widget.itineraryId,
        'id_product': _selectedActivity['id'],
        'product_type': 'Servicios',
        'product_name': _selectedActivity['name'],
        'rate_name': _selectedRate.name,
        'date': _selectedDate.toIso8601String(),
        'destination': _selectedActivity['destination'] ?? '',
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
          content: Text('Actividad agregada exitosamente'),
          backgroundColor: BukeerColors.success,
        ),
      );

      // Close modal
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error adding activity: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar la actividad'),
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
                Text(
                  'Agregar Actividad',
                  style: BukeerTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? BukeerColors.textPrimaryDark
                        : BukeerColors.textPrimary,
                  ),
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
                        // Activity selector
                        Text(
                          'Seleccionar Actividad',
                          style: BukeerTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? BukeerColors.textPrimaryDark
                                : BukeerColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: BukeerSpacing.m),

                        // Search field
                        TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar actividad...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDark
                                  ? BukeerColors.textSecondaryDark
                                  : BukeerColors.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BukeerBorders.radiusMedium,
                              borderSide: BorderSide(
                                color: isDark
                                    ? BukeerColors.dividerDark
                                    : BukeerColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BukeerBorders.radiusMedium,
                              borderSide: BorderSide(
                                color: isDark
                                    ? BukeerColors.dividerDark
                                    : BukeerColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BukeerBorders.radiusMedium,
                              borderSide: BorderSide(
                                color: BukeerColors.primary,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? BukeerColors.surfaceSecondaryDark
                                : BukeerColors.surfaceSecondary,
                          ),
                          style: BukeerTypography.bodyMedium.copyWith(
                            color: isDark
                                ? BukeerColors.textPrimaryDark
                                : BukeerColors.textPrimary,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _filteredActivities =
                                  _activities.where((activity) {
                                final name =
                                    activity['name']?.toLowerCase() ?? '';
                                final destination =
                                    activity['destination']?.toLowerCase() ??
                                        '';
                                final searchLower = value.toLowerCase();
                                return name.contains(searchLower) ||
                                    destination.contains(searchLower);
                              }).toList();
                            });
                          },
                        ),
                        SizedBox(height: BukeerSpacing.m),

                        // Activities list
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
                            itemCount: _filteredActivities.length,
                            itemBuilder: (context, index) {
                              final activity = _filteredActivities[index];
                              final isSelected =
                                  _selectedActivity?['id'] == activity['id'];

                              return ListTile(
                                selected: isSelected,
                                selectedTileColor:
                                    BukeerColors.primary.withOpacity(0.1),
                                title: Text(
                                  activity['name'] ?? '',
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
                                    if (activity['destination'] != null &&
                                        activity['destination']
                                            .toString()
                                            .isNotEmpty)
                                      Text(
                                        activity['destination'],
                                        style:
                                            BukeerTypography.bodySmall.copyWith(
                                          color: isDark
                                              ? BukeerColors.textSecondaryDark
                                              : BukeerColors.textSecondary,
                                        ),
                                      ),
                                    if (activity['contacts'] != null &&
                                        activity['contacts']['name'] != null)
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
                                            activity['contacts']['name'],
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
                                    _selectedActivity = activity;
                                    _selectedRate = null;
                                    _rates = [];
                                  });
                                  _loadRates(activity['id']);
                                },
                              );
                            },
                          ),
                        ),

                        if (_selectedActivity != null) ...[
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
                  text: 'Agregar',
                  onPressed: _selectedActivity != null && _selectedRate != null
                      ? _addActivityToItinerary
                      : null,
                  variant: BukeerButtonVariant.primary,
                  icon: Icons.add,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
