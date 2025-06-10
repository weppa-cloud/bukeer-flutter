import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/forms/date_range_picker/date_range_picker_widget.dart';
import 'package:bukeer/design_system/index.dart';

WidgetbookComponent getDateRangePickerUseCases() {
  return WidgetbookComponent(
    name: 'DateRangePicker',
    useCases: [
      WidgetbookUseCase(
        name: 'Default (Last 30 days)',
        builder: (context) => _DateRangePickerWrapper(
          showPresets: context.knobs.boolean(
            label: 'Show Presets',
            initialValue: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Today',
        builder: (context) => _DateRangePickerWrapper(
          initialStartDate: DateTime.now(),
          initialEndDate: DateTime.now(),
          showPresets: true,
        ),
      ),
      WidgetbookUseCase(
        name: 'Last 7 Days',
        builder: (context) => _DateRangePickerWrapper(
          initialStartDate: DateTime.now().subtract(const Duration(days: 6)),
          initialEndDate: DateTime.now(),
          showPresets: true,
        ),
      ),
      WidgetbookUseCase(
        name: 'This Month',
        builder: (context) {
          final now = DateTime.now();
          return _DateRangePickerWrapper(
            initialStartDate: DateTime(now.year, now.month, 1),
            initialEndDate: DateTime(now.year, now.month + 1, 0),
            showPresets: true,
          );
        },
      ),
      WidgetbookUseCase(
        name: 'Custom Range',
        builder: (context) => _DateRangePickerWrapper(
          initialStartDate: DateTime.now().subtract(const Duration(days: 45)),
          initialEndDate: DateTime.now().subtract(const Duration(days: 15)),
          showPresets: true,
        ),
      ),
      WidgetbookUseCase(
        name: 'Without Presets',
        builder: (context) => _DateRangePickerWrapper(
          showPresets: false,
        ),
      ),
      WidgetbookUseCase(
        name: 'Future Dates',
        builder: (context) => _DateRangePickerWrapper(
          initialStartDate: DateTime.now().add(const Duration(days: 7)),
          initialEndDate: DateTime.now().add(const Duration(days: 14)),
          showPresets: true,
        ),
      ),
    ],
  );
}

class _DateRangePickerWrapper extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool showPresets;

  const _DateRangePickerWrapper({
    this.initialStartDate,
    this.initialEndDate,
    this.showPresets = true,
  });

  @override
  State<_DateRangePickerWrapper> createState() =>
      _DateRangePickerWrapperState();
}

class _DateRangePickerWrapperState extends State<_DateRangePickerWrapper> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _changeHistory = [];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  void _onDateRangeChanged(DateTime? startDate, DateTime? endDate) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;

      if (startDate != null && endDate != null) {
        final rangeText = '${_formatDate(startDate)} - ${_formatDate(endDate)}';
        _changeHistory.insert(
            0, '$rangeText (${DateTime.now().toString().substring(11, 19)})');
        if (_changeHistory.length > 5) {
          _changeHistory.removeLast();
        }
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Picker
            Center(
              child: DateRangePickerWidget(
                initialStartDate: widget.initialStartDate,
                initialEndDate: widget.initialEndDate,
                showPresets: widget.showPresets,
                onDateRangeChanged: _onDateRangeChanged,
              ),
            ),

            const SizedBox(height: 32),

            // Current Selection
            if (_startDate != null && _endDate != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rango seleccionado:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: BukeerColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_endDate!.difference(_startDate!).inDays + 1} días',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Change History
            if (_changeHistory.isNotEmpty) ...[
              Text(
                'Historial de cambios:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              ...(_changeHistory.map((change) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $change',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ))),
            ],

            const Spacer(),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BukeerColors.primaryAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: BukeerColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Haz clic en el selector para abrir el diálogo con opciones predefinidas${widget.showPresets ? '' : ' (sin presets)'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
