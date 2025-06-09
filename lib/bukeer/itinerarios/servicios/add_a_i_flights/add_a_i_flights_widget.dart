import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../design_system/index.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_a_i_flights_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'add_a_i_flights_model.dart';

class AddAIFlightsWidget extends StatefulWidget {
  const AddAIFlightsWidget({
    super.key,
    required this.idItinerary,
    required this.idaccount,
  });

  final String? idItinerary;
  final String? idaccount;

  @override
  State<AddAIFlightsWidget> createState() => _AddAIFlightsWidgetState();
}

class _AddAIFlightsWidgetState extends State<AddAIFlightsWidget> {
  late AddAIFlightsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddAIFlightsModel());

    _model.textFlightTextController ??= TextEditingController();
    _model.textFlightFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 690.0,
            maxHeight: 400.0,
          ),
          decoration: BoxDecoration(
            color: BukeerColors.getBackground(context, secondary: true),
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: BukeerColors.overlay,
                offset: Offset(
                  0.0,
                  -1.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: BukeerSpacing.s),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: BukeerSpacing.s),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          BukeerColors.getBackground(context, secondary: true),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          color: BukeerColors.overlay,
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Agregar vuelos con IA',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .headlineMediumIsCustom,
                                  ),
                            ),
                          ),
                        ].divide(SizedBox(width: BukeerSpacing.s)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(BukeerSpacing.m),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 12.0, 16.0, 12.0),
                              child: TextFormField(
                                controller: _model.textFlightTextController,
                                focusNode: _model.textFlightFocusNode,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelMediumFamily,
                                        letterSpacing: 0.0,
                                        shadows: [
                                          Shadow(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 2.0,
                                          )
                                        ],
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelMediumIsCustom,
                                      ),
                                  hintText:
                                      'Copia el texto aqui con toda al información de los vuelos que quieres agregar, asegurate que el texto contega  origen y destino , escalas, numero de personas, equipaje, tarifas. Normalmente esta infomación la encuentras en las plataformas de vuelos, en las páginas de resumen antes de proceder con el pago.',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelMediumIsCustom,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xB0606A85),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          12.0, 24.0, 20.0, 24.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                maxLines: null,
                                minLines: 8,
                                keyboardType: TextInputType.multiline,
                                validator: _model
                                    .textFlightTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          BukeerColors.getBackground(context, secondary: true),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.0,
                          color: BukeerColors.overlay,
                          offset: Offset(
                            0.0,
                            -1.0,
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 6.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.05),
                            child: FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              text: 'Cancelar',
                              options: FFButtonOptions(
                                height: 44.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    BorderRadius.circular(BukeerSpacing.s),
                                hoverColor:
                                    FlutterFlowTheme.of(context).alternate,
                                hoverBorderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                hoverTextColor: BukeerColors.primaryText,
                                hoverElevation: 3.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                _model.apiResult92n =
                                    await ProcessFlightExtractionCall.call(
                                  itineraryId: widget!.idItinerary,
                                  accountId: widget!.idaccount,
                                  authToken: currentJwtToken,
                                  textToAnalyze: (String text) {
                                    return (text ?? '')
                                        .replaceAll('\n', ' ')
                                        .replaceAll('\r', '')
                                        .replaceAll('"', '\\"')
                                        .replaceAll(
                                            RegExp(r'[\x00-\x1F\x7F]'), '');
                                  }(_model.textFlightTextController.text),
                                );

                                if ((_model.apiResult92n?.succeeded ?? true)) {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title:
                                            Text('Resultado de la importación'),
                                        content: Text(
                                            'Items agregados: ${ProcessFlightExtractionCall.itemsAdded(
                                          (_model.apiResult92n?.jsonBody ?? ''),
                                        )?.toString()}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Aceptar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  Navigator.pop(context);
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Advertencia '),
                                        content: Text(getJsonField(
                                          (_model.apiResult92n?.jsonBody ?? ''),
                                          r'''$.error_message''',
                                        ).toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Cerrar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                safeSetState(() {});
                              },
                              text: 'Enviar',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: BukeerColors.primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 0.0,
                                borderRadius:
                                    BorderRadius.circular(BukeerSpacing.s),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
