import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_container_flights_model.dart';
export 'component_container_flights_model.dart';

class ComponentContainerFlightsWidget extends StatefulWidget {
  const ComponentContainerFlightsWidget({
    super.key,
    required this.name,
    this.image,
  });

  final String? name;
  final String? image;

  @override
  State<ComponentContainerFlightsWidget> createState() =>
      _ComponentContainerFlightsWidgetState();
}

class _ComponentContainerFlightsWidgetState
    extends State<ComponentContainerFlightsWidget> {
  late ComponentContainerFlightsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentContainerFlightsModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 8.0),
      child: Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BukeerSpacing.m),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(BukeerSpacing.m),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(BukeerSpacing.s),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                        child: Image.network(
                          valueOrDefault<String>(
                            widget!.image,
                            'https://images.unsplash.com/photo-1663659506570-067bf9e9937f?w=500&h=500',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget!.name,
                                'Sin nombre',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleLargeFamily,
                                    fontSize: BukeerTypography.bodyMediumSize,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleLargeIsCustom,
                                  ),
                            ),
                          ].divide(SizedBox(height: BukeerSpacing.xs)),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 16.0,
                    ),
                  ].divide(SizedBox(width: BukeerSpacing.s)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
