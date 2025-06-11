import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_box_model.dart';
export 'search_box_model.dart';

class SearchBoxWidget extends StatefulWidget {
  const SearchBoxWidget({
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
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  late SearchBoxModel _model;

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
    _model.textController ??= TextEditingController(text: initialText);
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchText = _model.textController.text;

    // Update UiStateService
    final uiState = context.read<UiStateService>();
    uiState.searchQuery = searchText;

    // Call external callback if provided
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(searchText);
    }

    safeSetState(() {});
  }

  void _clearSearch() {
    _model.textController?.clear();
    _onSearchChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        controller: _model.textController,
        focusNode: _model.textFieldFocusNode,
        onChanged: (_) => EasyDebounce.debounce(
          '_model.textController',
          Duration(milliseconds: widget.debounceTime),
          _onSearchChanged,
        ),
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          isDense: false,
          labelText: widget.hintText,
          labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                fontSize: BukeerTypography.bodySmallSize,
                color: BukeerColors.secondaryText,
                letterSpacing: 0.0,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
              ),
          floatingLabelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                fontSize: BukeerTypography.captionSize,
                color: BukeerColors.primary,
                letterSpacing: 0.0,
                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
              ),
          filled: true,
          fillColor: BukeerColors.getBackground(context),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.xl),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: BukeerColors.primary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.xl),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.xl),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.xl),
          ),
          contentPadding: EdgeInsetsDirectional.fromSTEB(
            BukeerSpacing.m,
            BukeerSpacing.m,
            BukeerSpacing.m,
            BukeerSpacing.m,
          ),
          prefixIcon: Icon(
            Icons.search_sharp,
            color: BukeerColors.secondaryText,
            size: 20.0,
          ),
          suffixIcon: _model.textController.text.isNotEmpty
              ? InkWell(
                  onTap: _clearSearch,
                  child: Icon(
                    Icons.clear,
                    color: BukeerColors.textSecondary,
                    size: 20.0,
                  ),
                )
              : null,
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              fontSize: BukeerTypography.bodySmallSize,
              letterSpacing: 0.0,
              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
            ),
        cursorColor: BukeerColors.primary,
        validator: _model.textControllerValidator.asValidator(context),
      ),
    );
  }
}
