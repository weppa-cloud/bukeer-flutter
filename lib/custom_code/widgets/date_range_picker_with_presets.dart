// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '../../design_system/index.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

class DateRangePickerWithPresets extends StatefulWidget {
  const DateRangePickerWithPresets({
    super.key,
    this.width,
    this.height,
    required this.onDateRangeChanged,
    this.initialStartDate,
    this.initialEndDate,
    this.showPresets = true,
    this.presetTextStyle,
    this.selectedPresetColor,
  });

  final double? width;
  final double? height;
  final Function(DateTime? startDate, DateTime? endDate) onDateRangeChanged;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool showPresets;
  final TextStyle? presetTextStyle;
  final Color? selectedPresetColor;

  @override
  State<DateRangePickerWithPresets> createState() =>
      _DateRangePickerWithPresetsState();
}

class _DateRangePickerWithPresetsState
    extends State<DateRangePickerWithPresets> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedPreset;

  final List<DatePreset> _presets = [
    DatePreset(
      label: 'Hoy',
      key: 'today',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: today, end: today);
      },
    ),
    DatePreset(
      label: 'Ayer',
      key: 'yesterday',
      getDateRange: () {
        final now = DateTime.now();
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        return DateTimeRange(start: yesterday, end: yesterday);
      },
    ),
    DatePreset(
      label: 'Últimos 7 días',
      key: 'last7days',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final sevenDaysAgo = today.subtract(Duration(days: 6));
        return DateTimeRange(start: sevenDaysAgo, end: today);
      },
    ),
    DatePreset(
      label: 'Últimos 30 días',
      key: 'last30days',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final thirtyDaysAgo = today.subtract(Duration(days: 29));
        return DateTimeRange(start: thirtyDaysAgo, end: today);
      },
    ),
    DatePreset(
      label: 'Este mes',
      key: 'thisMonth',
      getDateRange: () {
        final now = DateTime.now();
        final firstDayOfMonth = DateTime(now.year, now.month, 1);
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
        return DateTimeRange(start: firstDayOfMonth, end: lastDayOfMonth);
      },
    ),
    DatePreset(
      label: 'Mes anterior',
      key: 'lastMonth',
      getDateRange: () {
        final now = DateTime.now();
        final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        return DateTimeRange(
            start: firstDayOfLastMonth, end: lastDayOfLastMonth);
      },
    ),
    DatePreset(
      label: 'Este año',
      key: 'thisYear',
      getDateRange: () {
        final now = DateTime.now();
        final firstDayOfYear = DateTime(now.year, 1, 1);
        final lastDayOfYear = DateTime(now.year, 12, 31);
        return DateTimeRange(start: firstDayOfYear, end: lastDayOfYear);
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Seleccionar Rango de Fechas',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleMediumIsCustom,
                  ),
            ),

            SizedBox(height: BukeerSpacing.s),

            // Current Selection Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(BukeerSpacing.s),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(BukeerSpacing.xs),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 16,
                  ),
                  SizedBox(width: BukeerSpacing.xs),
                  Expanded(
                    child: Text(
                      _getDateRangeText(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: _showDateRangePicker,
                    text: 'Cambiar',
                    options: FFButtonOptions(
                      height: 32,
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                      elevation: 0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(BukeerSpacing.xs),
                    ),
                  ),
                ],
              ),
            ),

            if (widget.showPresets) ...[
              SizedBox(height: BukeerSpacing.s),

              // Presets
              Text(
                'Rangos Rápidos',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).labelMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).labelMediumIsCustom,
                    ),
              ),

              SizedBox(height: BukeerSpacing.xs),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _presets
                        .map((preset) => _buildPresetButton(preset))
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(DatePreset preset) {
    final isSelected = _selectedPreset == preset.key;

    return Padding(
      padding: EdgeInsets.only(bottom: BukeerSpacing.xs),
      child: InkWell(
        onTap: () => _selectPreset(preset),
        borderRadius: BorderRadius.circular(BukeerSpacing.xs),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: BukeerSpacing.s,
            vertical: BukeerSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (widget.selectedPresetColor ??
                    FlutterFlowTheme.of(context).accent1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            border: isSelected
                ? Border.all(color: FlutterFlowTheme.of(context).primary)
                : null,
          ),
          child: Text(
            preset.label,
            style: (widget.presetTextStyle ??
                    FlutterFlowTheme.of(context).bodyMedium)
                .override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
            ),
          ),
        ),
      ),
    );
  }

  void _selectPreset(DatePreset preset) {
    final dateRange = preset.getDateRange();
    setState(() {
      _startDate = dateRange.start;
      _endDate = dateRange.end;
      _selectedPreset = preset.key;
    });
    widget.onDateRangeChanged(_startDate, _endDate);
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: FlutterFlowTheme.of(context).primary,
                  onPrimary: Colors.white,
                  surface: FlutterFlowTheme.of(context).secondaryBackground,
                  onSurface: FlutterFlowTheme.of(context).primaryText,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedPreset = null; // Clear preset selection
      });
      widget.onDateRangeChanged(_startDate, _endDate);
    }
  }

  String _getDateRangeText() {
    if (_startDate == null || _endDate == null) {
      return 'Selecciona un rango de fechas';
    }

    final startText = dateTimeFormat('d/M/y', _startDate!);
    final endText = dateTimeFormat('d/M/y', _endDate!);

    if (_startDate!.isAtSameMomentAs(_endDate!)) {
      return startText;
    }

    return '$startText - $endText';
  }
}

class DatePreset {
  final String label;
  final String key;
  final DateTimeRange Function() getDateRange;

  DatePreset({
    required this.label,
    required this.key,
    required this.getDateRange,
  });
}
