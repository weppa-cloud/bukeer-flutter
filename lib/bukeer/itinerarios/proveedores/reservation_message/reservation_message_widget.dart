import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../backend/supabase/supabase.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '../../../../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reservation_message_model.dart';
import '../../../../design_system/index.dart';
import '../../../../services/app_services.dart';
export 'reservation_message_model.dart';

class ReservationMessageWidget extends StatefulWidget {
  const ReservationMessageWidget({
    super.key,
    required this.idItinerary,
    required this.agentName,
    required this.agentEmail,
    required this.emailProvider,
    required this.nameProvider,
    required this.passengers,
    this.fecha,
    required this.producto,
    required this.tarifa,
    required this.cantidad,
    this.idItemProduct,
    required this.idFm,
    required this.tipoEmal,
  });

  final String? idItinerary;
  final String? agentName;
  final String? agentEmail;
  final String? emailProvider;
  final String? nameProvider;
  final String? passengers;
  final String? fecha;
  final String? producto;
  final String? tarifa;
  final int? cantidad;
  final String? idItemProduct;
  final String? idFm;
  final String? tipoEmal;

  @override
  State<ReservationMessageWidget> createState() =>
      _ReservationMessageWidgetState();
}

class _ReservationMessageWidgetState extends State<ReservationMessageWidget> {
  late ReservationMessageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservationMessageModel());

    _model.messageTextController ??= TextEditingController();
    _model.messageFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>(); // Removed - using services instead

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
            color: BukeerColors.secondaryBackground,
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
                      color: BukeerColors.secondaryBackground,
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
                              'Mensaje al proveedor',
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
                SingleChildScrollView(
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
                              controller: _model.messageTextController,
                              focusNode: _model.messageFocusNode,
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
                                    'Escribe mensaje con información específica de la reserva y los pasajeros',
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
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
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
                              validator: _model.messageTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                  child: Container(
                    decoration: BoxDecoration(
                      color: BukeerColors.secondaryBackground,
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
                                  color: BukeerColors.borderPrimary,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    BorderRadius.circular(BukeerSpacing.s),
                                hoverColor: BukeerColors.borderPrimary,
                                hoverBorderSide: BorderSide(
                                  color: BukeerColors.borderPrimary,
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
                                _model.responsePassengers =
                                    await GetPassengersItineraryCall.call(
                                  authToken: currentJwtToken,
                                  idItinerary: widget!.idItinerary,
                                );

                                _model.responseAccounts =
                                    await AccountsTable().queryRows(
                                  queryFn: (q) => q.eqOrNull(
                                    'id',
                                    context
                                        .read<AppServices>()
                                        .account
                                        .accountId,
                                  ),
                                );
                                _model.responseReservation =
                                    await SendEmailReservaCall.call(
                                  agentMessage:
                                      _model.messageTextController.text,
                                  providerName: widget!.nameProvider,
                                  agentName: widget!.agentName,
                                  agentEmail: widget!.agentEmail,
                                  email: widget!.emailProvider,
                                  passengers:
                                      (_model.responsePassengers?.jsonBody ??
                                              '')
                                          .toString(),
                                  fecha: widget!.fecha,
                                  producto: widget!.producto,
                                  tarifa: widget!.tarifa,
                                  cantidad: widget!.cantidad,
                                  tipoEmail: widget!.tipoEmal,
                                  idItinerario: widget!.idFm,
                                  accountName: _model
                                      .responseAccounts?.firstOrNull?.name,
                                  accountLogo: _model
                                      .responseAccounts?.firstOrNull?.logoImage,
                                );

                                if ((_model.responseReservation?.succeeded ??
                                    true)) {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Mensaje'),
                                        content: Text('Email enviado'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  _model.responseSetMessage =
                                      await actions.setMessageReservation(
                                    widget!.idItemProduct!,
                                    _model.messageTextController.text,
                                    'send',
                                  );
                                  await ItineraryItemsTable().update(
                                    data: {
                                      'reservation_status': true,
                                      'reservation_messages':
                                          _model.responseSetMessage,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      widget!.idItemProduct,
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Mensaje'),
                                        content: Text('Error al enviar email'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
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
