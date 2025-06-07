import '../../../auth/supabase_auth/auth_util.dart';
import '../main_logo_small/main_logo_small_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../services/ui_state_service.dart';
import 'dart:ui';
import '../../../index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'web_nav_model.dart';
import '../../../services/user_service.dart';
import '../../../services/authorization_service.dart';
import '../../../services/app_services.dart';
export 'web_nav_model.dart';

class WebNavWidget extends StatefulWidget {
  const WebNavWidget({
    super.key,
    this.selectedNav,
  });

  final int? selectedNav;

  @override
  State<WebNavWidget> createState() => _WebNavWidgetState();
}

class _WebNavWidgetState extends State<WebNavWidget> {
  late WebNavModel _model;
  final UserService _userService = UserService();
  bool _isLoadingData = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WebNavModel());

    // Cargar datos del usuario si no están cargados
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadUserDataIfNeeded();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Carga los datos del usuario solo si es necesario
  Future<void> _loadUserDataIfNeeded() async {
    // Si ya tenemos los datos, no hacer nada
    if (_userService.hasLoadedData) {
      return;
    }

    // Si ya estamos cargando, no duplicar
    if (_isLoadingData) {
      return;
    }

    setState(() {
      _isLoadingData = true;
    });

    try {
      final success = await _userService.initializeUserData();

      if (!success && mounted) {
        // Solo mostrar error si es la primera vez y no es un refresh
        if (!_userService.hasLoadedData) {
          // Reintentar una vez más antes de mostrar error
          await Future.delayed(Duration(seconds: 2));
          final retrySuccess = await _userService.initializeUserData();

          if (!retrySuccess && mounted) {
            // Mostrar error solo si el segundo intento también falla
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Error de conexión'),
                  content: Text(
                    'No se pudo cargar la información de tu cuenta. '
                    'Por favor verifica tu conexión a internet.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(alertDialogContext);
                        // Intentar recargar
                        _loadUserDataIfNeeded();
                      },
                      child: Text('Reintentar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(alertDialogContext);
                      },
                      child: Text('Continuar sin datos'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  /// Obtiene el nombre del usuario de forma segura
  String _getUserName() {
    final name = _userService.getAgentInfo(r'$[:].name');
    final lastName = _userService.getAgentInfo(r'$[:].last_name');

    if (name != null && lastName != null) {
      return '$name $lastName';
    } else if (name != null) {
      return name.toString();
    }

    return 'Usuario';
  }

  /// Obtiene el rol del usuario de forma segura
  String _getUserRole() {
    final roleType = appServices.authorization.currentUserRole;

    switch (roleType) {
      case RoleType.admin:
        return 'Administrador';
      case RoleType.superAdmin:
        return 'Super Admin';
      case RoleType.agent:
        return 'Agente';
      case RoleType.guest:
      default:
        return 'Usuario';
    }
  }

  /// Obtiene la imagen del usuario de forma segura
  String? _getUserImage() {
    final image = _userService.getAgentInfo(r'$[:].main_image');
    return image?.toString();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<UiStateService>();

    // Mostrar indicador de carga mientras se cargan los datos
    if (_isLoadingData) {
      return Container(
        width: 270.0,
        height: double.infinity,
        color: BukeerColors.secondaryBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  BukeerColors.primary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Cargando...',
                style: FlutterFlowTheme.of(context).bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 1.0, 0.0),
      child: Container(
        width: 270.0,
        height: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 300.0,
        ),
        decoration: BoxDecoration(
          color: BukeerColors.secondaryBackground,
          boxShadow: [
            BoxShadow(
              color: BukeerColors.borderPrimary,
              offset: Offset(
                1.0,
                0.0,
              ),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(BukeerSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Padding(
                padding: EdgeInsets.only(bottom: BukeerSpacing.m),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    wrapWithModel(
                      model: _model.mainLogoSmallModel,
                      updateCallback: () => safeSetState(() {}),
                      child: MainLogoSmallWidget(),
                    ),
                  ],
                ),
              ),

              // Información del usuario
              _buildUserInfo(),

              Divider(
                height: 24.0,
                thickness: 1.0,
                color: BukeerColors.borderPrimary,
              ),

              // Menú de navegación
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNavItem(
                        context,
                        icon: Icons.dashboard_rounded,
                        label: 'Dashboard',
                        isSelected: widget.selectedNav == 1,
                        onTap: () => context.pushNamed('Main_Home'),
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.event_note_rounded,
                        label: 'Itinerarios',
                        isSelected: widget.selectedNav == 2,
                        onTap: () => context.pushNamed('main_itineraries'),
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.inventory_2_rounded,
                        label: 'Productos',
                        isSelected: widget.selectedNav == 3,
                        onTap: () => context.pushNamed('main_products'),
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.people_rounded,
                        label: 'Contactos',
                        isSelected: widget.selectedNav == 4,
                        onTap: () => context.pushNamed('main_contacts'),
                      ),

                      // Mostrar usuarios solo para admins
                      if (_userService.isAdmin || _userService.isSuperAdmin)
                        _buildNavItem(
                          context,
                          icon: Icons.supervised_user_circle_rounded,
                          label: 'Usuarios',
                          isSelected: widget.selectedNav == 5,
                          onTap: () => context.pushNamed('main_users'),
                        ),

                      // Configuración de la cuenta
                      _buildNavItem(
                        context,
                        icon: Icons.settings_rounded,
                        label: 'Configuración',
                        isSelected: widget.selectedNav == 6,
                        onTap: () => context.pushNamed('Main_profileAccount'),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón de cerrar sesión
              Padding(
                padding: EdgeInsets.only(top: BukeerSpacing.m),
                child: InkWell(
                  splashColor: FlutterFlowTheme.of(context)
                      .primaryColor
                      .withOpacity(0.08),
                  focusColor: FlutterFlowTheme.of(context)
                      .primaryColor
                      .withOpacity(0.04),
                  hoverColor: FlutterFlowTheme.of(context)
                      .primaryColor
                      .withOpacity(0.04),
                  highlightColor: FlutterFlowTheme.of(context)
                      .primaryColor
                      .withOpacity(0.12),
                  onTap: () async {
                    GoRouter.of(context).prepareAuthEvent();
                    await authManager.signOut();
                    GoRouter.of(context).clearRedirectLocation();

                    // Limpiar datos del usuario
                    _userService.clearUserData();

                    context.goNamedAuth('auth_Login', context.mounted);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: BukeerColors.primaryBackground,
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(BukeerSpacing.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: BukeerColors.secondaryText,
                            size: 24.0,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Cerrar sesión',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ],
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
  }

  /// Construye la sección de información del usuario
  Widget _buildUserInfo() {
    final userImage = _getUserImage();

    return InkWell(
      splashColor: BukeerColors.primaryColor.withOpacity(0.08),
      focusColor: BukeerColors.primaryColor.withOpacity(0.04),
      hoverColor: BukeerColors.primaryColor.withOpacity(0.04),
      highlightColor: BukeerColors.primaryColor.withOpacity(0.12),
      onTap: () => context.pushNamed('Main_profilePage'),
      child: Container(
        decoration: BoxDecoration(
          color: BukeerColors.primaryBackground,
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
        ),
        child: Padding(
          padding: EdgeInsets.all(BukeerSpacing.s),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: BukeerColors.primaryAccent,
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  border: Border.all(
                    color: BukeerColors.primary,
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: userImage != null && userImage.isNotEmpty
                      ? CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeOutDuration: Duration(milliseconds: 500),
                          imageUrl: userImage,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) =>
                              _buildUserInitials(),
                        )
                      : _buildUserInitials(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: BukeerSpacing.s),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getUserName(),
                        style: FlutterFlowTheme.of(context).bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getUserRole(),
                        style: FlutterFlowTheme.of(context).labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye las iniciales del usuario
  Widget _buildUserInitials() {
    final name = _getUserName();
    final initials = name
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();

    return Center(
      child: Text(
        initials.isNotEmpty ? initials : 'U',
        style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: 'Outfit',
              color: BukeerColors.primary,
            ),
      ),
    );
  }

  /// Construye un item del menú de navegación
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: BukeerSpacing.xs),
      child: InkWell(
        splashColor: BukeerColors.primaryColor.withOpacity(0.08),
        focusColor: BukeerColors.primaryColor.withOpacity(0.04),
        hoverColor: BukeerColors.primaryColor.withOpacity(0.04),
        highlightColor: BukeerColors.primaryColor.withOpacity(0.12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 48.0,
          decoration: BoxDecoration(
            color: isSelected ? BukeerColors.primaryAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            border: Border.all(
              color: isSelected ? BukeerColors.primary : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? BukeerColors.primary
                      : BukeerColors.secondaryText,
                  size: 24.0,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: BukeerSpacing.s),
                    child: Text(
                      label,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: isSelected
                                ? BukeerColors.primaryText
                                : BukeerColors.secondaryText,
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
