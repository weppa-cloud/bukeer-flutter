import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/api_requests/api_manager.dart';
import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dropdown_travel_planner_model.dart';
export 'dropdown_travel_planner_model.dart';

class DropdownTravelPlannerWidget extends StatefulWidget {
  const DropdownTravelPlannerWidget({
    super.key,
    this.currentAgentId,
    this.onAgentChanged,
    this.itineraryId,
  });

  final String? currentAgentId;
  final Future Function(String? newAgentId)? onAgentChanged;
  final String? itineraryId;

  @override
  State<DropdownTravelPlannerWidget> createState() =>
      _DropdownTravelPlannerWidgetState();
}

class _DropdownTravelPlannerWidgetState
    extends State<DropdownTravelPlannerWidget> {
  late DropdownTravelPlannerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropdownTravelPlannerModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Crear llamada personalizada a contacts para obtener usuarios con imágenes
      _model.apiResponseUsers = await ApiManager.instance.makeApiCall(
        callName: 'getUsersWithImages',
        apiUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co/rest/v1/contacts?select=*&user_rol=not.is.null',
        callType: ApiCallType.GET,
        headers: {
          'Authorization': 'Bearer $currentJwtToken',
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8',
        },
        params: {},
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      );

      if ((_model.apiResponseUsers?.succeeded ?? true)) {
        // Obtener todos los usuarios del sistema
        _model.users = getJsonField(
          (_model.apiResponseUsers?.jsonBody ?? ''),
          r'''$[:]''',
          true,
        )?.toList().cast<dynamic>() ?? [];
        
        // Debug: verificar si ahora sí llegan las imágenes
        if (_model.users.isNotEmpty) {
          print('=== NUEVO API DEBUG ===');
          print('Usuarios cargados: ${_model.users.length}');
          for (int i = 0; i < _model.users.length && i < 3; i++) {
            final user = _model.users[i];
            final name = getJsonField(user, r'''$.name''')?.toString() ?? 'Sin nombre';
            final userImage = getJsonField(user, r'''$.user_image''')?.toString();
            print('[$i] $name - Imagen: ${userImage ?? "NULL"}');
          }
          print('=== FIN DEBUG ===');
        }
        
        // Establecer el valor inicial si existe
        if (widget.currentAgentId != null && widget.currentAgentId!.isNotEmpty) {
          _model.dropDownValue = widget.currentAgentId;
        }
        
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_model.users.isNotEmpty)
            Container(
              width: double.infinity,
              height: 56.0, // Altura fija para evitar problemas de tamaño
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: DropdownButtonFormField<String>(
                  value: _model.dropDownValue,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                  ),
                  hint: Row(
                    children: [
                      // Icono por defecto para el hint
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent1,
                          borderRadius: BorderRadius.circular(BukeerSpacing.m),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 20.0,
                        ),
                      ),
                      SizedBox(width: BukeerSpacing.s),
                      Expanded(
                        child: Text(
                          'Selecciona un Travel Planner',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                          ),
                        ),
                      ),
                    ],
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return _model.users.map<Widget>((user) {
                      final userId = getJsonField(user, r'''$.id''').toString();
                      final name = getJsonField(user, r'''$.name''').toString();
                      final lastName = getJsonField(user, r'''$.last_name''').toString();
                      // Usar exactamente el mismo método que main_users.dart - líneas 656-660
                      final userImage = valueOrDefault<String>(
                        getJsonField(user, r'''$.user_image''')?.toString(),
                        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/profile_default.png',
                      );
                      
                      return Row(
                        children: [
                          // Foto del usuario seleccionado
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(BukeerSpacing.m),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(BukeerSpacing.m),
                              child: Image.network(
                                userImage,
                                width: 32.0,
                                height: 32.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: BukeerSpacing.s),
                          // Nombre del usuario seleccionado
                          Expanded(
                            child: Text(
                              '$name $lastName',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                  isExpanded: true, // Permite que el dropdown use todo el ancho disponible
                  items: _model.users.map<DropdownMenuItem<String>>((user) {
                    final userId = getJsonField(user, r'''$.id''').toString();
                    final name = getJsonField(user, r'''$.name''').toString();
                    final lastName = getJsonField(user, r'''$.last_name''').toString();
                    // Usar exactamente el mismo método que main_users.dart - líneas 656-660
                    final userImage = valueOrDefault<String>(
                      getJsonField(user, r'''$.user_image''')?.toString(),
                      'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/profile_default.png',
                    );
                    
                    return DropdownMenuItem<String>(
                      value: userId,
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Foto de perfil en la lista
                            Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(BukeerSpacing.m),
                                child: Image.network(
                                  userImage,
                                  width: 32.0,
                                  height: 32.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: BukeerSpacing.s),
                            // Nombre y apellido en la lista
                            Expanded(
                              child: Text(
                                '$name $lastName',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) async {
                    safeSetState(() => _model.dropDownValue = val);
                    
                    // Solo actualizar si cambió el valor
                    if (val != widget.currentAgentId && widget.onAgentChanged != null) {
                      // Mostrar indicador de carga
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Actualizando Travel Planner...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      
                      // Ejecutar callback
                      await widget.onAgentChanged!(val);
                    }
                  },
                ),
              ),
            ),
          if (_model.users.isEmpty && _model.apiResponseUsers != null)
            Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: BukeerSpacing.s),
                      child: Text(
                        'No hay usuarios disponibles',
                        style: FlutterFlowTheme.of(context).bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_model.apiResponseUsers == null)
            Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}