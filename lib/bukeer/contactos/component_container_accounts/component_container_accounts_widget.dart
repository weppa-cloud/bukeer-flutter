import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_container_accounts_model.dart';
export 'component_container_accounts_model.dart';

class ComponentContainerAccountsWidget extends StatefulWidget {
  const ComponentContainerAccountsWidget({
    super.key,
    this.name,
  });

  final String? name;

  @override
  State<ComponentContainerAccountsWidget> createState() =>
      _ComponentContainerAccountsWidgetState();
}

class _ComponentContainerAccountsWidgetState
    extends State<ComponentContainerAccountsWidget> {
  late ComponentContainerAccountsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentContainerAccountsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: BukeerSpacing.s),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
          minHeight: 70.0,
        ),
        decoration: BoxDecoration(
          color: BukeerColors.secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: BukeerColors.overlay,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
          border: Border.all(
            color: BukeerColors.borderPrimary,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(BukeerSpacing.m),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: BukeerColors.primaryAccent,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(BukeerSpacing.s),
                  child: Text(
                    'AC',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleMediumFamily,
                          color: BukeerColors.primaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleMediumIsCustom,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (widget!.name != null && widget!.name != '')
                            Text(
                              valueOrDefault<String>(
                                widget!.name,
                                'sin nombre',
                              ),
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyLargeFamily,
                                    color: BukeerColors.primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyLargeIsCustom,
                                  ),
                            ),
                          Icon(
                            Icons.business,
                            color: BukeerColors.primary,
                            size: 16.0,
                          ),
                        ].divide(SizedBox(width: BukeerSpacing.s)),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Manager',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodySmallFamily,
                            color: BukeerColors.primary,
                            letterSpacing: 0.0,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(BukeerSpacing.xs),
                          child: Icon(
                            Icons.call,
                            color: BukeerColors.primary,
                            size: 20.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(BukeerSpacing.xs),
                          child: Icon(
                            Icons.email,
                            color: BukeerColors.primary,
                            size: 20.0,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {},
                          child: Icon(
                            Icons.more_vert,
                            color: BukeerColors.primary,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ].divide(SizedBox(width: BukeerSpacing.m)),
          ),
        ),
      ),
    );
  }
}
