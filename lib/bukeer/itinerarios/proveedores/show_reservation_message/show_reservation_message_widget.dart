import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'show_reservation_message_model.dart';
import '../../../../design_system/index.dart';
export 'show_reservation_message_model.dart';

class ShowReservationMessageWidget extends StatefulWidget {
  const ShowReservationMessageWidget({
    super.key,
    this.messages,
  });

  final List<dynamic>? messages;

  @override
  State<ShowReservationMessageWidget> createState() =>
      _ShowReservationMessageWidgetState();
}

class _ShowReservationMessageWidgetState
    extends State<ShowReservationMessageWidget> {
  late ShowReservationMessageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShowReservationMessageModel());

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
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 20.0),
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
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 15.0, 12.0, 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Mensajes enviados al proveedor',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineMediumFamily,
                                    fontSize:
                                        BukeerTypography.headlineSmallSize,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
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
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  decoration: BoxDecoration(
                    color: BukeerColors.secondaryBackground,
                  ),
                  child: Builder(
                    builder: (context) {
                      final itemMessage = widget!.messages?.toList() ?? [];

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemMessage.length,
                        itemBuilder: (context, itemMessageIndex) {
                          final itemMessageItem = itemMessage[itemMessageIndex];
                          return Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (getJsonField(
                                          itemMessageItem,
                                          r'''$.date''',
                                        ) !=
                                        null)
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Text(
                                          '${getJsonField(
                                            itemMessageItem,
                                            r'''$.date''',
                                          ).toString()}: ',
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: BukeerTypography
                                                    .bodySmallSize,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 5.0, 0.0, 16.0),
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Visibility(
                                          visible: getJsonField(
                                                itemMessageItem,
                                                r'''$.message''',
                                              ) !=
                                              null,
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              getJsonField(
                                                itemMessageItem,
                                                r'''$.message''',
                                              ).toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    fontSize: BukeerTypography
                                                        .bodySmallSize,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
