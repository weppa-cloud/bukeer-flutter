import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/custom_code/widgets/index.dart';
import 'package:flutter/material.dart';
import 'date_range_picker_model.dart';
export 'date_range_picker_model.dart';

class DateRangePickerWidget extends StatefulWidget {
  const DateRangePickerWidget({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.onDateRangeChanged,
    this.showPresets = true,
  });

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime? startDate, DateTime? endDate)? onDateRangeChanged;
  final bool showPresets;

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  late DateRangePickerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DateRangePickerModel());

    // Initialize with provided dates or default to last 30 days
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _model.startDate =
        widget.initialStartDate ?? today.subtract(Duration(days: 29));
    _model.endDate = widget.initialEndDate ?? today;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDateRangePickerDialog(),
        borderRadius: BorderRadius.circular(BukeerSpacing.xs),
        child: Container(
          height: BukeerSpacing.xl + BukeerSpacing.xs,
          constraints: BoxConstraints(
            minWidth: 180.0,
            maxWidth: 300.0,
          ),
          decoration: BoxDecoration(
            color: BukeerColors.getBackground(context, secondary: true),
            borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: BukeerSpacing.s, vertical: BukeerSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.date_range,
                  color: BukeerColors.secondaryText,
                  size: 16.0,
                ),
                SizedBox(width: 6.0),
                Expanded(
                  child: Text(
                    _getCompactDateRangeText(),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodySmallFamily,
                          color: BukeerColors.primaryText,
                          fontSize: 13.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodySmallIsCustom,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 2.0),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: BukeerColors.secondaryText,
                  size: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCompactDateRangeText() {
    if (_model.startDate == null || _model.endDate == null) {
      return 'los últimos 30 días';
    }

    final presetName = _detectPresetName(_model.startDate!, _model.endDate!);
    final startText = dateTimeFormat('d MMM', _model.startDate!,
        locale: FFLocalizations.of(context).languageCode);
    final endText = dateTimeFormat('d MMM y', _model.endDate!,
        locale: FFLocalizations.of(context).languageCode);

    return '$presetName  $startText - $endText';
  }

  String _detectPresetName(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check for "Últimos 30 días" (29 days before today to today)
    final thirtyDaysAgo = today.subtract(Duration(days: 29));
    if (startDate.isAtSameMomentAs(thirtyDaysAgo) &&
        endDate.isAtSameMomentAs(today)) {
      return 'los últimos 30 días';
    }

    // Check for "Últimos 7 días" (6 days before today to today)
    final sevenDaysAgo = today.subtract(Duration(days: 6));
    if (startDate.isAtSameMomentAs(sevenDaysAgo) &&
        endDate.isAtSameMomentAs(today)) {
      return 'los últimos 7 días';
    }

    // Check for "Hoy"
    if (startDate.isAtSameMomentAs(today) && endDate.isAtSameMomentAs(today)) {
      return 'hoy';
    }

    // Check for "Ayer"
    final yesterday = today.subtract(Duration(days: 1));
    if (startDate.isAtSameMomentAs(yesterday) &&
        endDate.isAtSameMomentAs(yesterday)) {
      return 'ayer';
    }

    // Check for "Este mes"
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    if (startDate.isAtSameMomentAs(firstDayOfMonth) &&
        endDate.isAtSameMomentAs(lastDayOfMonth)) {
      return 'este mes';
    }

    // Check for "Mes anterior"
    final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
    if (startDate.isAtSameMomentAs(firstDayOfLastMonth) &&
        endDate.isAtSameMomentAs(lastDayOfMonth)) {
      return 'el mes anterior';
    }

    return 'personalizado';
  }

  void _showDateRangePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 500,
            height: 400,
            child: DateRangePickerWithPresets(
              width: 500,
              height: 400,
              initialStartDate: _model.startDate,
              initialEndDate: _model.endDate,
              onDateRangeChanged: (startDate, endDate) {
                setState(() {
                  _model.startDate = startDate;
                  _model.endDate = endDate;
                });

                // Call the callback if provided
                if (widget.onDateRangeChanged != null) {
                  widget.onDateRangeChanged!(startDate, endDate);
                }

                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
