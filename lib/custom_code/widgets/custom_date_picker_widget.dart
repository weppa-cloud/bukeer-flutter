// Automatic FlutterFlow imports
import '../../../backend/schema/structs/index.dart';
import '../../../backend/supabase/supabase.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class CustomDatePickerWidget extends StatefulWidget {
  const CustomDatePickerWidget({
    Key? key,
    this.width,
    this.height,
    this.initialStartDate,
    this.initialEndDate,
    this.onRangeSelected,
    this.labelText = 'Seleccionar fecha',
    this.isRangePicker = false,
    this.onDateSelected,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? initialStartDate;
  final String? initialEndDate;
  final Future<void> Function(String? startDateString, String? endDateString)?
      onRangeSelected;
  final Future<void> Function(String? date)? onDateSelected;
  final String labelText;
  final bool isRangePicker;

  @override
  _CustomDatePickerWidgetState createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  String? _selectedDateStr;
  String? _rangeStartDateStr;
  String? _rangeEndDateStr;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    // We need context for locale, so initial update happens in didChangeDependencies or first build
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update display text here or in build, as locale might not be ready in initState
    if (widget.isRangePicker) {
      _rangeStartDateStr = widget.initialStartDate;
      _rangeEndDateStr = widget.initialEndDate;
      _updateRangeDisplayText(context); // Pass context
    } else {
      _selectedDateStr = widget.initialStartDate;
      _updateSingleDisplayText(context); // Pass context
    }
  }

  void _updateSingleDisplayText(BuildContext context) {
    if (_selectedDateStr != null &&
        _selectedDateStr!.isNotEmpty &&
        _selectedDateStr != 'd/m/y') {
      try {
        final date = DateTime.parse(_selectedDateStr!);
        final locale = Localizations.localeOf(context).toString();
        _displayText = DateFormat('d MMM yyyy', locale).format(date);
      } catch (e) {
        _displayText = _selectedDateStr!;
        print('Error parsing date string for display: $_selectedDateStr');
      }
    } else {
      _displayText = '';
    }
  }

  void _updateRangeDisplayText(BuildContext context) {
    if (_rangeStartDateStr != null &&
        _rangeStartDateStr!.isNotEmpty &&
        _rangeEndDateStr != null &&
        _rangeEndDateStr!.isNotEmpty) {
      try {
        final startDate = DateTime.parse(_rangeStartDateStr!);
        final endDate = DateTime.parse(_rangeEndDateStr!);
        final locale = Localizations.localeOf(context).toString();
        final startStr = DateFormat('d MMM yyyy', locale).format(startDate);
        final endStr = DateFormat('d MMM yyyy', locale).format(endDate);
        _displayText = '$startStr - $endStr';
      } catch (e) {
        _displayText = '$_rangeStartDateStr - $_rangeEndDateStr';
        print(
            'Error parsing range date strings for display: $_rangeStartDateStr, $_rangeEndDateStr');
      }
    } else {
      _displayText = '';
    }
  }

  DateTime? _stringToDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == 'd/m/y') return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      print('Error al convertir string a fecha: $dateStr - $e');
      return null;
    }
  }

  String? _dateTimeToString(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _showDatePicker(BuildContext context) async {
    // Store BuildContext to use after the async gap.
    final currentContext = context;

    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: widget.isRangePicker
          ? CalendarDatePicker2Type.range
          : CalendarDatePicker2Type.single,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      currentDate: _stringToDateTime(
              widget.isRangePicker ? _rangeStartDateStr : _selectedDateStr) ??
          DateTime.now(),
      selectedDayHighlightColor: FlutterFlowTheme.of(context).primary,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: FlutterFlowTheme.of(context).primaryText),
      controlsTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: FlutterFlowTheme.of(context).primaryText),
      selectedDayTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      dayTextStyle: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
      disabledDayTextStyle: TextStyle(
          color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5)),
      okButton: Text('Aceptar',
          style: TextStyle(
              color: FlutterFlowTheme.of(context).primary,
              fontWeight: FontWeight.bold)),
      cancelButton: Text('Cancelar',
          style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText)),
    );

    List<DateTime?> initialValues = [];
    if (widget.isRangePicker) {
      final startDate = _stringToDateTime(_rangeStartDateStr);
      final endDate = _stringToDateTime(_rangeEndDateStr);
      if (startDate != null && endDate != null) {
        initialValues = [startDate, endDate];
      } else if (startDate != null) {
        initialValues = [startDate];
      }
    } else {
      final date = _stringToDateTime(_selectedDateStr);
      if (date != null) initialValues = [date];
    }

    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: initialValues,
      dialogBackgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
    );

    // Use stored context to avoid using context across async gaps.
    if (!currentContext.mounted) return;

    if (results != null) {
      if (widget.isRangePicker) {
        if (results.length >= 2 && results[0] != null && results[1] != null) {
          final startDateStr = _dateTimeToString(results[0]);
          final endDateStr = _dateTimeToString(results[1]);
          if (currentContext.mounted) {
            setState(() {
              _rangeStartDateStr = startDateStr;
              _rangeEndDateStr = endDateStr;
              _updateRangeDisplayText(currentContext); // Use stored context
            });
          }
          if (widget.onRangeSelected != null) {
            widget.onRangeSelected!(startDateStr, endDateStr);
          }
        } else if (results.isEmpty && widget.onRangeSelected != null) {
          if (currentContext.mounted) {
            setState(() {
              _rangeStartDateStr = null;
              _rangeEndDateStr = null;
              _updateRangeDisplayText(currentContext); // Use stored context
            });
          }
          widget.onRangeSelected!(null, null);
        }
      } else {
        if (results.isNotEmpty && results[0] != null) {
          final dateStr = _dateTimeToString(results[0]);
          if (currentContext.mounted) {
            setState(() {
              _selectedDateStr = dateStr;
              _updateSingleDisplayText(currentContext); // Use stored context
            });
          }
          if (widget.onDateSelected != null) {
            widget.onDateSelected!(dateStr);
          }
        } else if (results.isEmpty && widget.onDateSelected != null) {
          if (currentContext.mounted) {
            setState(() {
              _selectedDateStr = null;
              _updateSingleDisplayText(currentContext); // Use stored context
            });
          }
          widget.onDateSelected!(null);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update display text in build to ensure locale is available
    if (widget.isRangePicker) {
      _updateRangeDisplayText(context);
    } else {
      _updateSingleDisplayText(context);
    }

    bool hasSelection = widget.isRangePicker
        ? (_rangeStartDateStr != null &&
            _rangeStartDateStr!.isNotEmpty &&
            _rangeEndDateStr != null &&
            _rangeEndDateStr!.isNotEmpty)
        : (_selectedDateStr != null &&
            _selectedDateStr!.isNotEmpty &&
            _selectedDateStr != 'd/m/y');

    String mainDisplayText;
    if (hasSelection && _displayText.isNotEmpty) {
      // Use generated display text if available and selection is valid
      mainDisplayText = _displayText;
    } else {
      // Otherwise show placeholder
      mainDisplayText =
          widget.isRangePicker ? 'Seleccionar rango' : 'Seleccionar fecha';
    }

    return Container(
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: InkWell(
        splashColor: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
        highlightColor: FlutterFlowTheme.of(context).primary.withOpacity(0.05),
        onTap: () => _showDatePicker(context),
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: FlutterFlowTheme.of(context)
                      .primary, // Color primario aplicado
                  size: 20.0,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainDisplayText,
                      style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                            color: hasSelection
                                ? FlutterFlowTheme.of(context).primaryText
                                : FlutterFlowTheme.of(context).secondaryText,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (widget.labelText.isNotEmpty &&
                        widget.labelText != 'Seleccionar fecha' &&
                        widget.labelText != 'Seleccionar rango')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                        child: Text(
                          widget.labelText,
                          style: FlutterFlowTheme.of(context).labelSmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DO NOT REMOVE OR MODIFY THE CODE BELOW!
// End custom widget code
