// Automatic FlutterFlow imports
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:intl/intl.dart';

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
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime _currentMonth = DateTime.now();

  final List<DatePreset> _presets = [
    DatePreset(
      label: 'Personalizado',
      key: 'custom',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: today, end: today);
      },
    ),
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
      label: 'Esta semana (De dom. a hoy)',
      key: 'thisWeek',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final weekStart = today.subtract(Duration(days: now.weekday % 7));
        return DateTimeRange(start: weekStart, end: today);
      },
    ),
    DatePreset(
      label: 'La semana pasada (De dom. a sáb.)',
      key: 'lastWeek',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final lastWeekEnd = today.subtract(Duration(days: now.weekday % 7));
        final lastWeekStart = lastWeekEnd.subtract(Duration(days: 6));
        return DateTimeRange(start: lastWeekStart, end: lastWeekEnd);
      },
    ),
    DatePreset(
      label: 'los últimos 7 días',
      key: 'last7days',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final sevenDaysAgo = today.subtract(Duration(days: 6));
        return DateTimeRange(start: sevenDaysAgo, end: today);
      },
    ),
    DatePreset(
      label: 'los últimos 28 días',
      key: 'last28days',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final twentyEightDaysAgo = today.subtract(Duration(days: 27));
        return DateTimeRange(start: twentyEightDaysAgo, end: today);
      },
    ),
    DatePreset(
      label: 'los últimos 30 días',
      key: 'last30days',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final thirtyDaysAgo = today.subtract(Duration(days: 29));
        return DateTimeRange(start: thirtyDaysAgo, end: today);
      },
    ),
    DatePreset(
      label: 'los últimos 90 días',
      key: 'last90days',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final ninetyDaysAgo = today.subtract(Duration(days: 89));
        return DateTimeRange(start: ninetyDaysAgo, end: today);
      },
    ),
    DatePreset(
      label: 'los últimos 12 meses',
      key: 'last12months',
      getDateRange: () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final twelveMonthsAgo = DateTime(now.year - 1, now.month, now.day);
        return DateTimeRange(start: twelveMonthsAgo, end: today);
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    // If no dates provided, default to last 28 days
    if (_startDate == null || _endDate == null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      _endDate = today;
      _startDate = today.subtract(Duration(days: 27));
      _selectedPreset = 'last28days';
    } else {
      // Detect which preset matches the current dates
      _selectedPreset = _detectCurrentPreset();
    }

    _updateDateControllers();
  }

  String? _detectCurrentPreset() {
    if (_startDate == null || _endDate == null) return null;

    for (final preset in _presets) {
      if (preset.key == 'custom') continue;

      final range = preset.getDateRange();
      if (_isSameDay(_startDate!, range.start) &&
          _isSameDay(_endDate!, range.end)) {
        return preset.key;
      }
    }

    return 'custom';
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _updateDateControllers() {
    if (_startDate != null) {
      _startDateController.text = DateFormat('d MMM yyyy').format(_startDate!);
    }
    if (_endDate != null) {
      _endDateController.text = DateFormat('d MMM yyyy').format(_endDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 800,
      height: widget.height ?? 600,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left sidebar with presets (Google Analytics style)
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              border: Border(
                right: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: _presets.length,
                    itemBuilder: (context, index) =>
                        _buildPresetButton(_presets[index]),
                  ),
                ),
              ],
            ),
          ),

          // Right side with date inputs and calendar
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date input fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha de inicio',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                controller: _startDateController,
                                readOnly: true,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyLargeIsCustom,
                                    ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '–',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .headlineMediumFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .headlineMediumIsCustom,
                            ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha de final',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                controller: _endDateController,
                                readOnly: true,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyLargeIsCustom,
                                    ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Calendar
                  Expanded(
                    child: _buildCalendar(),
                  ),

                  SizedBox(height: 20),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          // Only call the callback, don't close the dialog here
                          // The parent widget will handle closing the dialog
                          widget.onDateRangeChanged(_startDate, _endDate);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Colors.white,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(DatePreset preset) {
    final isSelected = _selectedPreset == preset.key;

    return InkWell(
      onTap: () => _selectPreset(preset),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : Colors.transparent,
        ),
        child: Text(
          preset.label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                color: isSelected
                    ? Colors.white
                    : FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FontWeight.normal,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
              ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        // Calendar header with navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _currentMonth =
                      DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                });
              },
              icon: Icon(Icons.chevron_left),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase(),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentMonth =
                      DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                });
              },
              icon: Icon(Icons.chevron_right),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Days of week header
        Row(
          children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodySmallFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodySmallIsCustom,
                            ),
                      ),
                    ),
                  ))
              .toList(),
        ),

        SizedBox(height: 8),

        // Calendar grid
        Expanded(
          child: _buildCalendarGrid(),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startDay = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Empty cells for days before the month starts
    for (int i = 0; i < startDay; i++) {
      dayWidgets.add(Container());
    }

    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = _isDateInRange(date);
      final isRangeStart = _startDate != null && _isSameDay(_startDate!, date);
      final isRangeEnd = _endDate != null && _isSameDay(_endDate!, date);

      dayWidgets.add(
        InkWell(
          onTap: () => _selectDate(date),
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isRangeStart || isRangeEnd
                  ? FlutterFlowTheme.of(context).primary
                  : isSelected
                      ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
                      : Colors.transparent,
              shape: isRangeStart || isRangeEnd
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              border: isRangeEnd && !isRangeStart
                  ? Border.all(
                      color: FlutterFlowTheme.of(context).primary, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: isRangeStart || isRangeEnd
                          ? Colors.white
                          : FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      children: dayWidgets,
      shrinkWrap: true,
    );
  }

  bool _isDateInRange(DateTime date) {
    if (_startDate == null || _endDate == null) return false;
    return date.isAfter(_startDate!.subtract(Duration(days: 1))) &&
        date.isBefore(_endDate!.add(Duration(days: 1)));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        // Start new selection
        _startDate = date;
        _endDate = null;
        _selectedPreset = 'custom';
      } else if (_startDate != null && _endDate == null) {
        // Set end date
        if (date.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = date;
        } else {
          _endDate = date;
        }
      }
      _updateDateControllers();
    });
  }

  void _selectPreset(DatePreset preset) {
    if (preset.key == 'custom') {
      setState(() {
        _selectedPreset = preset.key;
      });
      return;
    }

    final dateRange = preset.getDateRange();
    setState(() {
      _startDate = dateRange.start;
      _endDate = dateRange.end;
      _selectedPreset = preset.key;
      _updateDateControllers();
    });
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
