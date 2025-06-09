import 'package:flutter/material.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart' as functions;

class TravelPlannerSection extends StatelessWidget {
  final String? currencyTypeValue;
  final ValueChanged<String?> onCurrencyChanged;
  final String? requestTypeValue;
  final ValueChanged<String?> onRequestChanged;

  const TravelPlannerSection({
    super.key,
    required this.currencyTypeValue,
    required this.onCurrencyChanged,
    required this.requestTypeValue,
    required this.onRequestChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.none,
        children: [
          // Currency dropdown
          FlutterFlowDropDown<String>(
            controller: FormFieldController<String>(currencyTypeValue),
            options: (appServices.account.accountCurrency ?? [])
                .map((e) => functions.getJsonField(e, r'''$.name'''))
                .toList()
                .map((e) => e.toString())
                .toList(),
            onChanged: onCurrencyChanged,
            width: 297.0,
            height: 50.0,
            searchHintTextStyle: FlutterFlowTheme.of(context)
                .labelMedium
                .override(
                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelMediumIsCustom,
                ),
            searchTextStyle: const TextStyle(),
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
            hintText: 'Seleccionar  Moneda',
            searchHintText: 'Search for an item...',
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: 12.0,
            margin: const EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 16.0, 4.0),
            hidesUnderline: true,
            isSearchable: true,
            isMultiSelect: false,
          ),
          // Request type dropdown
          FlutterFlowDropDown<String>(
            controller: FormFieldController<String>(requestTypeValue),
            options: ['Econo', 'Standar', 'Premium', 'Luxury'],
            onChanged: onRequestChanged,
            width: 297.0,
            height: 50.0,
            searchHintTextStyle: FlutterFlowTheme.of(context)
                .labelMedium
                .override(
                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelMediumIsCustom,
                ),
            searchTextStyle: const TextStyle(),
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
            hintText: 'Tipo de solicitud',
            searchHintText: 'Search for an item...',
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: 12.0,
            margin: const EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 16.0, 4.0),
            hidesUnderline: true,
            isSearchable: true,
            isMultiSelect: false,
          ),
        ],
      ),
    );
  }
}
