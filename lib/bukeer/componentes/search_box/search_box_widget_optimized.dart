import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../design_system/index.dart';
import '../../../services/ui_state_service.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/forms/search_box/search_box_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export '../../core/widgets/forms/search_box/search_box_model.dart';

class SearchBoxWidgetOptimized extends StatefulWidget {
  const SearchBoxWidgetOptimized({
    super.key,
    this.hintText = 'Buscar',
    this.onSearchChanged,
    this.initialValue,
    this.debounceTime = 500, // OPTIMIZATION: Reduced default debounce time
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
  Timer? _debounceTimer;
  String _lastSearchQuery = '';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchBoxModel());

    // Initialize with provided initial value or current search value from UiStateService
    final uiState = context.read<UiStateService>();
    final initialText = widget.initialValue ?? uiState.searchQuery;
    _lastSearchQuery = initialText;
    _model.textController ??= TextEditingController(text: initialText);
    _model.textFieldFocusNode ??= FocusNode();

    // OPTIMIZATION: Add listener for text changes to handle clear button visibility
    _model.textController.addListener(_handleTextChange);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _model.textController.removeListener(_handleTextChange);
    _model.maybeDispose();
    super.dispose();
  }

  // OPTIMIZATION: Improved debounce implementation
  void _handleTextChange() {
    final currentText = _model.textController.text;

    // Only trigger setState if the clear button visibility needs to change
    if ((currentText.isEmpty && _lastSearchQuery.isNotEmpty) ||
        (currentText.isNotEmpty && _lastSearchQuery.isEmpty)) {
      safeSetState(() {});
    }

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Only debounce if text actually changed
    if (currentText != _lastSearchQuery) {
      _debounceTimer = Timer(Duration(milliseconds: widget.debounceTime), () {
        if (mounted) {
          _onSearchChanged(currentText);
        }
      });
    }
  }

  void _onSearchChanged(String searchText) {
    _lastSearchQuery = searchText;

    // Update UiStateService
    final uiState = context.read<UiStateService>();
    uiState.searchQuery = searchText;

    // Call external callback if provided
    widget.onSearchChanged?.call(searchText);
  }

  void _clearSearch() {
    _model.textController?.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    // OPTIMIZATION: Use const widgets where possible
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: BukeerColors.primaryBackground,
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        border: Border.all(
          color: BukeerColors.borderPrimary,
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
              child: TextFormField(
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
                  prefixIcon: const Icon(
                    Icons.search_sharp,
                    color: BukeerColors.secondaryText,
                    size: 20.0,
                  ),
                  suffixIcon: _model.textController.text.isNotEmpty
                      ? _ClearButton(onTap: _clearSearch)
                      : null,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontSize: BukeerTypography.bodySmallSize,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
                cursorColor: BukeerColors.primary,
                validator: _model.textControllerValidator.asValidator(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// OPTIMIZATION: Extract clear button as a separate const widget
class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Icon(
        Icons.clear,
        color: BukeerColors.textSecondary,
        size: 20.0,
      ),
    );
  }
}
