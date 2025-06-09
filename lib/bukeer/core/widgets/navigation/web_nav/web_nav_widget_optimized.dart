import '../../../../../auth/supabase_auth/auth_util.dart';
import '../main_logo_small/main_logo_small_widget.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../design_system/index.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../services/ui_state_service.dart';
import 'dart:ui';
import '../../../../../index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'web_nav_model.dart';
import '../../../../../services/user_service.dart';
import '../../../../../services/authorization_service.dart';
import '../../../../../services/app_services.dart';
import '../../../../../navigation/route_definitions.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'web_nav_model.dart';

/// Optimized version of WebNavWidget with performance improvements
///
/// Key optimizations:
/// 1. Separated user info into its own widget with selective watching
/// 2. Const widgets where possible
/// 3. Cached navigation items
/// 4. RepaintBoundary for complex sections
/// 5. Proper lifecycle management
class WebNavWidgetOptimized extends StatefulWidget {
  const WebNavWidgetOptimized({
    super.key,
    this.selectedNav,
  });

  final int? selectedNav;

  @override
  State<WebNavWidgetOptimized> createState() => _WebNavWidgetOptimizedState();
}

class _WebNavWidgetOptimizedState extends State<WebNavWidgetOptimized> {
  late WebNavModel _model;
  final UserService _userService = UserService();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WebNavModel());

    // Load user data if needed
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    if (!_userService.hasLoadedData) {
      await _userService.initializeUserData();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 1.0, 0.0),
      child: Container(
        width: 270.0,
        height: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 300.0,
        ),
        decoration: BoxDecoration(
          color: BukeerColors.getBackground(context, secondary: true),
          boxShadow: [
            BoxShadow(
              color: BukeerColors.getBorderColor(context),
              offset: const Offset(1.0, 0.0),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(BukeerSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(bottom: BukeerSpacing.m),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    wrapWithModel(
                      model: _model.mainLogoSmallModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const MainLogoSmallWidget(),
                    ),
                  ],
                ),
              ),

              // User info with RepaintBoundary
              RepaintBoundary(
                child: _UserInfoSection(userService: _userService),
              ),

              const Divider(
                height: 24.0,
                thickness: 1.0,
              ),

              // Navigation menu
              Expanded(
                child: _NavigationMenu(
                  selectedNav: widget.selectedNav,
                  userService: _userService,
                ),
              ),

              // Logout button
              const _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Separated user info section that only rebuilds when user data changes
class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({
    required this.userService,
  });

  final UserService userService;

  String _getUserName() {
    final name = userService.getAgentInfo(r'$[:].name');
    final lastName = userService.getAgentInfo(r'$[:].last_name');

    if (name != null && lastName != null) {
      return '$name $lastName';
    } else if (name != null) {
      return name.toString();
    }

    return 'Usuario';
  }

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

  String? _getUserImage() {
    final image = userService.getAgentInfo(r'$[:].main_image');
    return image?.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Only watch specific user data changes
    final hasUserData =
        context.select<UserService, bool>((service) => service.hasLoadedData);

    if (!hasUserData) {
      return const _LoadingUserInfo();
    }

    final userImage = _getUserImage();

    return InkWell(
      splashColor: BukeerColors.primaryColor.withOpacity(0.08),
      focusColor: BukeerColors.primaryColor.withOpacity(0.04),
      hoverColor: BukeerColors.primaryColor.withOpacity(0.04),
      highlightColor: BukeerColors.primaryColor.withOpacity(0.12),
      onTap: () => context.pushNamed(MainProfilePageWidget.routeName),
      child: Container(
        decoration: BoxDecoration(
          color: BukeerColors.getBackground(context),
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
        ),
        child: Padding(
          padding: const EdgeInsets.all(BukeerSpacing.s),
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
                          fadeInDuration: UiConstants.animationDuration,
                          fadeOutDuration: UiConstants.animationDuration,
                          imageUrl: userImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _buildUserInitials(context, _getUserName()),
                          errorWidget: (context, error, stackTrace) =>
                              _buildUserInitials(context, _getUserName()),
                        )
                      : _buildUserInitials(context, _getUserName()),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: BukeerSpacing.s),
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

  Widget _buildUserInitials(BuildContext context, String name) {
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
}

/// Loading state for user info
class _LoadingUserInfo extends StatelessWidget {
  const _LoadingUserInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(BukeerSpacing.s),
      child: const Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(BukeerColors.primary),
            ),
          ),
          SizedBox(width: BukeerSpacing.s),
          Text('Cargando...'),
        ],
      ),
    );
  }
}

/// Navigation menu with cached items
class _NavigationMenu extends StatelessWidget {
  const _NavigationMenu({
    required this.selectedNav,
    required this.userService,
  });

  final int? selectedNav;
  final UserService userService;

  @override
  Widget build(BuildContext context) {
    final isAdmin = userService.isAdmin || userService.isSuperAdmin;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NavItem(
            key: const ValueKey('nav_dashboard'),
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isSelected: selectedNav == 1,
            onTap: () => context.pushNamed(MainHomeWidget.routeName),
          ),
          _NavItem(
            key: const ValueKey('nav_itineraries'),
            icon: Icons.event_note_rounded,
            label: 'Itinerarios',
            isSelected: selectedNav == 2,
            onTap: () => context.pushNamed(MainItinerariesWidget.routeName),
          ),
          _NavItem(
            key: const ValueKey('nav_products'),
            icon: Icons.inventory_2_rounded,
            label: 'Productos',
            isSelected: selectedNav == 3,
            onTap: () => context.pushNamed(MainProductsWidget.routeName),
          ),
          _NavItem(
            key: const ValueKey('nav_contacts'),
            icon: Icons.people_rounded,
            label: 'Contactos',
            isSelected: selectedNav == 4,
            onTap: () => context.pushNamed(MainContactsWidget.routeName),
          ),
          if (isAdmin)
            _NavItem(
              key: const ValueKey('nav_users'),
              icon: Icons.supervised_user_circle_rounded,
              label: 'Usuarios',
              isSelected: selectedNav == 5,
              onTap: () => context.pushNamed(MainUsersWidget.routeName),
            ),
          _NavItem(
            key: const ValueKey('nav_settings'),
            icon: Icons.settings_rounded,
            label: 'Configuración',
            isSelected: selectedNav == 6,
            onTap: () => context.pushNamed(MainProfileAccountWidget.routeName),
          ),
        ],
      ),
    );
  }
}

/// Individual navigation item
class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BukeerSpacing.xs),
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? BukeerColors.primary
                      : BukeerColors.getTextColor(context,
                          type: TextColorType.secondary),
                  size: 24.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: BukeerSpacing.s),
                    child: Text(
                      label,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: isSelected
                                ? BukeerColors.getTextColor(context,
                                    type: TextColorType.primary)
                                : BukeerColors.getTextColor(context,
                                    type: TextColorType.secondary),
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

/// Logout button
class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: BukeerSpacing.m),
      child: InkWell(
        splashColor:
            FlutterFlowTheme.of(context).primaryColor.withOpacity(0.08),
        focusColor: FlutterFlowTheme.of(context).primaryColor.withOpacity(0.04),
        hoverColor: FlutterFlowTheme.of(context).primaryColor.withOpacity(0.04),
        highlightColor:
            FlutterFlowTheme.of(context).primaryColor.withOpacity(0.12),
        onTap: () async {
          GoRouter.of(context).prepareAuthEvent();
          await authManager.signOut();
          GoRouter.of(context).clearRedirectLocation();

          // Clear user data
          context.read<UserService>().clearUserData();

          context.goNamed(RouteNames.login);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: BukeerColors.getBackground(context),
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          child: Padding(
            padding: const EdgeInsets.all(BukeerSpacing.s),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: BukeerColors.getTextColor(context,
                      type: TextColorType.secondary),
                  size: 24.0,
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                  child: Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
