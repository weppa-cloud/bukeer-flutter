import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../design_system/index.dart';
import '../../../services/ui_state_service.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_box_model.dart';
export 'search_box_model.dart';

class SearchBoxWidget extends StatefulWidget {
  const SearchBoxWidget({super.key});

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

    // Initialize with current search value from UiStateService
    final uiState = context.read<UiStateService>();
    _model.textController ??= TextEditingController(text: uiState.searchQuery);
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.all(BukeerSpacing.s),
          child: Icon(
            Icons.search,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 30.0,
          ),
        ),
        Flexible(
          child: TextFormField(
            controller: _model.textController,
            focusNode: _model.textFieldFocusNode,
            onChanged: (_) => EasyDebounce.debounce(
              '_model.textController',
              Duration(milliseconds: 2000),
              () async {
                final uiState = context.read<UiStateService>();
                uiState.searchQuery = _model.textController.text;
                uiState.currentPage = 0;
                safeSetState(() {});
              },
            ),
            autofocus: false,
            obscureText: false,
            decoration: InputDecoration(
              labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
              hintText: 'Buscar',
              hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              filled: true,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              contentPadding: EdgeInsets.only(right: BukeerSpacing.s),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
            minLines: 1,
            validator: _model.textControllerValidator.asValidator(context),
          ),
        ),
      ].divide(SizedBox(width: BukeerSpacing.s)),
    );
  }
}
