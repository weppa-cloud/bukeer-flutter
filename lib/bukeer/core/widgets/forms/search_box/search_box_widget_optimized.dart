import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../design_system/index.dart';
import '../../../../../services/ui_state_service.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_box_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'search_box_model.dart';

/// Optimized version of SearchBoxWidget with performance improvements
///
/// Key optimizations:
/// 1. Const widgets where possible
/// 2. Proper debounce initialization
/// 3. ValueListenableBuilder for text changes
/// 4. Selective context watching
/// 5. Cached widget instances
class SearchBoxWidgetOptimized extends StatefulWidget {
  const SearchBoxWidgetOptimized({
    super.key,
    this.hintText = 'Buscar',
    this.onSearchChanged,
    this.initialValue,
    this.debounceTime = 2000,
    this.width,
    this.height = 50.0,
  });

  final String hintText;
  final Function(String)? onSearchChanged;
  final String? initialValue;
  final int debounceTime;
  final double? width;
  final double height;

  @override
  State<SearchBoxWidgetOptimized> createState() =>
      _SearchBoxWidgetOptimizedState();
}

class _SearchBoxWidgetOptimizedState extends State<SearchBoxWidgetOptimized> {
  late SearchBoxModel _model;
  late final String _debouncerId;

  // Cached widgets
  static const Icon _searchIcon = Icon(
    Icons.search_sharp,
    color: BukeerColors.secondaryText,
    size: 20.0,
  );

  static const Icon _clearIcon = Icon(
    Icons.clear,
    color: BukeerColors.textSecondary,
    size: 20.0,
  );

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchBoxModel());

    // Generate unique debouncer ID
    _debouncerId = 'search_box_${hashCode}';

    // Initialize with provided initial value or current search value from UiStateService
    final uiState = context.read<UiStateService>();
    final initialText = widget.initialValue ?? uiState.searchQuery;
    _model.textController ??= TextEditingController(text: initialText);
    _model.textFieldFocusNode ??= FocusNode();

    // Add listener for manual updates
    _model.textController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // Cancel debounce
    EasyDebounce.cancel(_debouncerId);

    // Remove listener
    _model.textController.removeListener(_onTextChanged);

    _model.maybeDispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Debounce the search
    EasyDebounce.debounce(
      _debouncerId,
      Duration(milliseconds: widget.debounceTime),
      _performSearch,
    );
  }

  void _performSearch() {
    final searchText = _model.textController.text;

    // Update UiStateService
    final uiState = context.read<UiStateService>();
    uiState.searchQuery = searchText;

    // Call external callback if provided
    widget.onSearchChanged?.call(searchText);
  }

  void _clearSearch() {
    _model.textController?.clear();
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: BukeerColors.getBackground(context),
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          BukeerSpacing.s,
          0.0,
          BukeerSpacing.xs,
          0.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _model.textController,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      isDense: false,
                      labelText: widget.hintText,
                      alignLabelWithHint: false,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        0.0,
                        0.0,
                        8.0,
                      ),
                      prefixIcon: _searchIcon,
                      suffixIcon: value.text.isNotEmpty
                          ? InkWell(
                              onTap: _clearSearch,
                              child: _clearIcon,
                            )
                          : null,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: BukeerTypography.bodySmallSize,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                    cursorColor: BukeerColors.primary,
                    validator:
                        _model.textControllerValidator.asValidator(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
