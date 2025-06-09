import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../core/widgets/forms/dropdowns/travel_planner/dropdown_travel_planner_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'travel_planner_section_model.dart';
import '../../../services/authorization_service.dart';
import '../../../services/app_services.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'travel_planner_section_model.dart';

class TravelPlannerSectionWidget extends StatefulWidget {
  const TravelPlannerSectionWidget({
    super.key,
    required this.itineraryId,
    required this.currentAgentId,
    this.travelPlannerName,
    this.travelPlannerLastName,
    this.isEditable = true,
    this.onUpdated,
  });

  final String itineraryId;
  final String? currentAgentId;
  final String? travelPlannerName;
  final String? travelPlannerLastName;
  final bool isEditable;
  final Function()? onUpdated;

  @override
  State<TravelPlannerSectionWidget> createState() =>
      _TravelPlannerSectionWidgetState();
}

class _TravelPlannerSectionWidgetState
    extends State<TravelPlannerSectionWidget> {
  late TravelPlannerSectionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TravelPlannerSectionModel());

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

    // Simplificado: solo retornamos el Row sin Container wrapper
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Icono de usuario o imagen
        Padding(
          padding: EdgeInsets.only(right: BukeerSpacing.s),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: Image.network(
              'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
              width: 32.0,
              height: 32.0,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Información del Travel Planner
        Padding(
          padding: EdgeInsets.only(left: BukeerSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_model.isEditing)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (widget.travelPlannerName != null &&
                        widget.travelPlannerName!.isNotEmpty)
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 2.0, 0.0),
                        child: Text(
                          widget.travelPlannerName!,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    if (widget.travelPlannerLastName != null &&
                        widget.travelPlannerLastName!.isNotEmpty)
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 2.0, 0.0),
                        child: Text(
                          widget.travelPlannerLastName!,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    if ((widget.travelPlannerName == null ||
                            widget.travelPlannerName!.isEmpty) &&
                        !_model.isEditing)
                      Text(
                        'Sin asignar',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: BukeerColors.secondaryText,
                              letterSpacing: 0.0,
                              fontStyle: FontStyle.italic,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),

                    // Botón de editar al lado del nombre
                    if (widget.isEditable &&
                        _canEditTravelPlanner() &&
                        !_model.isEditing)
                      Padding(
                        padding: EdgeInsets.only(left: BukeerSpacing.s),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.isEditing = true;
                            safeSetState(() {});
                          },
                          child: Icon(
                            Icons.edit_rounded,
                            color: BukeerColors.secondaryText,
                            size: 16.0,
                          ),
                        ),
                      ),
                  ],
                ),

              if (!_model.isEditing)
                Text(
                  'Travel Planner',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: BukeerColors.secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),

              // Modo edición con dropdown
              if (_model.isEditing)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 250.0,
                      child: wrapWithModel(
                        model: _model.dropdownTravelPlannerModel,
                        updateCallback: () => safeSetState(() {}),
                        child: DropdownTravelPlannerWidget(
                          currentAgentId: widget.currentAgentId,
                          itineraryId: widget.itineraryId,
                          onAgentChanged: (newAgentId) async {
                            // Actualizar el travel planner
                            _model.updateSuccess =
                                await actions.updateTravelPlanner(
                              widget.itineraryId,
                              newAgentId!,
                            );

                            if (_model.updateSuccess!) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Travel Planner actualizado correctamente',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 2000),
                                  backgroundColor: BukeerColors.success,
                                ),
                              );

                              // Salir del modo edición
                              _model.isEditing = false;
                              safeSetState(() {});

                              // Ejecutar callback si existe
                              if (widget.onUpdated != null) {
                                widget.onUpdated!();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error al actualizar Travel Planner',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 2000),
                                  backgroundColor: BukeerColors.error,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    // Botón cancelar
                    Padding(
                      padding: EdgeInsets.only(left: BukeerSpacing.s),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.isEditing = false;
                          safeSetState(() {});
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: BukeerColors.error,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Verifica si el usuario actual puede editar el travel planner
  bool _canEditTravelPlanner() {
    final roleType = appServices.authorization.currentUserRole;

    // Admin y Super admin siempre pueden editar
    return roleType == RoleType.admin || roleType == RoleType.superAdmin;
  }
}
