import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/services/ui_state_service.dart';

class FooterSection extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const FooterSection({
    super.key,
    required this.isEdit,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 20.0,
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel button
              Align(
                alignment: const AlignmentDirectional(0.0, 0.05),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.read<UiStateService>().selectedContact = null;
                    onCancel();
                  },
                  text: 'Cancel',
                  options: FFButtonOptions(
                    height: 44.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    hoverColor: FlutterFlowTheme.of(context).alternate,
                    hoverBorderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    hoverTextColor: BukeerColors.primaryText,
                    hoverElevation: 3.0,
                  ),
                ),
              ),
              // Save/Add button
              Align(
                alignment: const AlignmentDirectional(0.0, 0.05),
                child: FFButtonWidget(
                  onPressed: onSave,
                  text: isEdit ? 'Guardar' : 'Agregar',
                  options: FFButtonOptions(
                    height: 44.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: BukeerColors.primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                        ),
                    elevation: 3.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    hoverColor: BukeerColors.primaryAccent,
                    hoverBorderSide: BorderSide(
                      color: BukeerColors.primary,
                      width: 1.0,
                    ),
                    hoverTextColor: BukeerColors.primaryText,
                    hoverElevation: 0.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
