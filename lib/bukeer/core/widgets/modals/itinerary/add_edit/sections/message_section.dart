import 'package:flutter/material.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';

class MessageSection extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode messageFocusNode;
  final FormFieldValidator<String>? messageValidator;

  const MessageSection({
    super.key,
    required this.messageController,
    required this.messageFocusNode,
    this.messageValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 5.0, 24.0, 5.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: messageController,
          focusNode: messageFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Mensaje destacado',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelMediumIsCustom,
                ),
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelMediumIsCustom,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.s),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: BukeerColors.primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.s),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: BukeerColors.error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.s),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: BukeerColors.error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.s),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                letterSpacing: 0.0,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
              ),
          maxLines: null,
          minLines: 3,
          cursorColor: BukeerColors.primary,
          validator: messageValidator,
        ),
      ),
    );
  }
}
