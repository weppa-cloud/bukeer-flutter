import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/forms/search_box/search_box_widget.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:provider/provider.dart';

WidgetbookComponent getSearchBoxUseCases() {
  return WidgetbookComponent(
    name: 'SearchBox',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _SearchBoxWrapper(
          hintText: context.knobs.string(
            label: 'Hint Text',
            initialValue: 'Buscar',
          ),
          debounceTime: context.knobs.double
              .input(
                label: 'Debounce Time (ms)',
                initialValue: 2000,
              )
              .toInt(),
          width: context.knobs.double.input(
            label: 'Width',
            initialValue: 400,
          ),
          height: context.knobs.double.input(
            label: 'Height',
            initialValue: 50,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Initial Value',
        builder: (context) => _SearchBoxWrapper(
          hintText: 'Buscar productos',
          initialValue: 'Hotel en Miami',
          width: 400,
        ),
      ),
      WidgetbookUseCase(
        name: 'Search Hotels',
        builder: (context) => _SearchBoxWrapper(
          hintText: 'Buscar hoteles...',
          debounceTime: 500,
          width: 350,
        ),
      ),
      WidgetbookUseCase(
        name: 'Search Activities',
        builder: (context) => _SearchBoxWrapper(
          hintText: 'Buscar actividades...',
          debounceTime: 1000,
          width: 350,
        ),
      ),
      WidgetbookUseCase(
        name: 'Full Width',
        builder: (context) => _SearchBoxWrapper(
          hintText: 'Buscar en todo el catálogo',
          width: double.infinity,
        ),
      ),
      WidgetbookUseCase(
        name: 'Compact',
        builder: (context) => _SearchBoxWrapper(
          hintText: 'Buscar',
          width: 250,
          height: 40,
        ),
      ),
      WidgetbookUseCase(
        name: 'No Debounce',
        builder: (context) => _SearchBoxWrapper(
          hintText: 'Búsqueda instantánea',
          debounceTime: 0,
          width: 400,
        ),
      ),
    ],
  );
}

class _SearchBoxWrapper extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final int debounceTime;
  final double? width;
  final double height;

  const _SearchBoxWrapper({
    this.hintText = 'Buscar',
    this.initialValue,
    this.debounceTime = 2000,
    this.width,
    this.height = 50.0,
  });

  @override
  State<_SearchBoxWrapper> createState() => _SearchBoxWrapperState();
}

class _SearchBoxWrapperState extends State<_SearchBoxWrapper> {
  String _lastSearch = '';
  List<String> _searchHistory = [];

  void _onSearchChanged(String value) {
    setState(() {
      _lastSearch = value;
      if (value.isNotEmpty) {
        _searchHistory.insert(
            0, '$value (${DateTime.now().toString().substring(11, 19)})');
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UiStateService(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box
              Center(
                child: SearchBoxWidget(
                  hintText: widget.hintText,
                  initialValue: widget.initialValue,
                  debounceTime: widget.debounceTime,
                  width: widget.width,
                  height: widget.height,
                  onSearchChanged: _onSearchChanged,
                ),
              ),

              const SizedBox(height: 32),

              // Search Results Info
              if (_lastSearch.isNotEmpty) ...[
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
                        'Buscando:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _lastSearch,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Search History
              if (_searchHistory.isNotEmpty) ...[
                Text(
                  'Historial de búsqueda:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 8),
                ...(_searchHistory.map((search) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $search',
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
                        'Debounce: ${widget.debounceTime}ms | '
                        'Width: ${widget.width ?? "auto"} | '
                        'Height: ${widget.height}px',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
