import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';

import '../services/authorization_service.dart';
import '../auth/supabase_auth/auth_util.dart';

/// Widget that conditionally shows/hides content based on user permissions
class AuthorizedWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final List<RoleType>? requiredRoles;
  final List<String>? requiredPermissions;
  final String? resourceType;
  final String? action;
  final String? ownerId;
  final bool requireAll; // If true, user must have ALL permissions/roles

  const AuthorizedWidget({
    Key? key,
    required this.child,
    this.fallback,
    this.requiredRoles,
    this.requiredPermissions,
    this.resourceType,
    this.action,
    this.ownerId,
    this.requireAll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthorization(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading(context);
        }

        final isAuthorized = snapshot.data ?? false;

        if (isAuthorized) {
          return child;
        } else {
          return fallback ?? SizedBox.shrink();
        }
      },
    );
  }

  Future<bool> _checkAuthorization() async {
    final authService = AuthorizationService();
    final userId = currentUserUid;

    if (userId == null) return false;

    return await authService.authorize(
      userId: userId,
      requiredRoles: requiredRoles,
      requiredPermissions: requiredPermissions,
      resourceType: resourceType,
      action: action,
      ownerId: ownerId,
    );
  }

  Widget _buildLoading(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          FlutterFlowTheme.of(context).primary.withOpacity(0.5),
        ),
      ),
    );
  }
}

/// Widget for role-based UI elements
class RoleBasedWidget extends StatelessWidget {
  final RoleType requiredRole;
  final Widget child;
  final Widget? fallback;

  const RoleBasedWidget({
    Key? key,
    required this.requiredRole,
    required this.child,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthorizedWidget(
      requiredRoles: [requiredRole],
      child: child,
      fallback: fallback,
    );
  }
}

/// Admin-only widget
class AdminOnlyWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const AdminOnlyWidget({
    Key? key,
    required this.child,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredRole: RoleType.admin,
      child: child,
      fallback: fallback,
    );
  }
}

/// Super Admin-only widget
class SuperAdminOnlyWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const SuperAdminOnlyWidget({
    Key? key,
    required this.child,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredRole: RoleType.superAdmin,
      child: child,
      fallback: fallback,
    );
  }
}

/// Permission-based button that disables if user lacks permission
class AuthorizedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final List<RoleType>? requiredRoles;
  final List<String>? requiredPermissions;
  final String? resourceType;
  final String? action;
  final String? ownerId;
  final ButtonStyle? style;
  final String? tooltip;

  const AuthorizedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.requiredRoles,
    this.requiredPermissions,
    this.resourceType,
    this.action,
    this.ownerId,
    this.style,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthorization(),
      builder: (context, snapshot) {
        final isAuthorized = snapshot.data ?? false;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        Widget button = ElevatedButton(
          onPressed: (isAuthorized && !isLoading) ? onPressed : null,
          style: style ?? _getDefaultStyle(context, isAuthorized),
          child: isLoading ? _buildLoadingIndicator(context) : child,
        );

        if (tooltip != null) {
          button = Tooltip(
            message:
                isAuthorized ? tooltip! : 'No tienes permisos para esta acción',
            child: button,
          );
        }

        return button;
      },
    );
  }

  Future<bool> _checkAuthorization() async {
    final authService = AuthorizationService();
    final userId = currentUserUid;

    if (userId == null) return false;

    return await authService.authorize(
      userId: userId,
      requiredRoles: requiredRoles,
      requiredPermissions: requiredPermissions,
      resourceType: resourceType,
      action: action,
      ownerId: ownerId,
    );
  }

  ButtonStyle _getDefaultStyle(BuildContext context, bool isAuthorized) {
    return ElevatedButton.styleFrom(
      backgroundColor: isAuthorized
          ? FlutterFlowTheme.of(context).primary
          : FlutterFlowTheme.of(context).secondaryText,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

/// Resource access widget that shows appropriate UI based on ownership/permissions
class ResourceAccessWidget extends StatelessWidget {
  final String resourceType;
  final String? ownerId;
  final Widget ownerChild;
  final Widget adminChild;
  final Widget readOnlyChild;
  final Widget? noAccessChild;

  const ResourceAccessWidget({
    Key? key,
    required this.resourceType,
    this.ownerId,
    required this.ownerChild,
    required this.adminChild,
    required this.readOnlyChild,
    this.noAccessChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccessLevel>(
      future: _determineAccessLevel(),
      builder: (context, snapshot) {
        final accessLevel = snapshot.data ?? AccessLevel.none;

        switch (accessLevel) {
          case AccessLevel.owner:
            return ownerChild;
          case AccessLevel.admin:
            return adminChild;
          case AccessLevel.readOnly:
            return readOnlyChild;
          case AccessLevel.none:
            return noAccessChild ?? _buildNoAccessWidget(context);
        }
      },
    );
  }

  Future<AccessLevel> _determineAccessLevel() async {
    final authService = AuthorizationService();
    final userId = currentUserUid;

    if (userId == null) return AccessLevel.none;

    // Load user roles
    await authService.loadUserRoles(userId);

    // Check if user is owner
    if (ownerId == userId) {
      return AccessLevel.owner;
    }

    // Check if user is admin
    if (authService.isAdmin) {
      return AccessLevel.admin;
    }

    // Check if user has read permission
    if (authService.hasPermission('$resourceType:read')) {
      return AccessLevel.readOnly;
    }

    return AccessLevel.none;
  }

  Widget _buildNoAccessWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 48,
          ),
          SizedBox(height: 8),
          Text(
            'Sin acceso',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
        ],
      ),
    );
  }
}

/// User role badge widget
class UserRoleBadge extends StatelessWidget {
  final String userId;

  const UserRoleBadge({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserRole>>(
      future: _loadUserRoles(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        final roles = snapshot.data!;
        if (roles.isEmpty) return SizedBox.shrink();

        final highestRole = _getHighestRole(roles);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getRoleColor(highestRole.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getRoleColor(highestRole.type),
              width: 1,
            ),
          ),
          child: Text(
            _getRoleDisplayName(highestRole.type),
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Readex Pro',
                  color: _getRoleColor(highestRole.type),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
          ),
        );
      },
    );
  }

  Future<List<UserRole>> _loadUserRoles() async {
    final authService = AuthorizationService();
    await authService.loadUserRoles(userId);
    return authService.userRoles;
  }

  UserRole _getHighestRole(List<UserRole> roles) {
    // Return highest priority role
    for (final roleType in [
      RoleType.superAdmin,
      RoleType.admin,
      RoleType.agent
    ]) {
      final role = roles.firstWhere(
        (r) => r.type == roleType,
        orElse: () => roles.first,
      );
      if (role.type == roleType) return role;
    }
    return roles.first;
  }

  Color _getRoleColor(RoleType roleType) {
    switch (roleType) {
      case RoleType.superAdmin:
        return Colors.red;
      case RoleType.admin:
        return Colors.orange;
      case RoleType.agent:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(RoleType roleType) {
    switch (roleType) {
      case RoleType.superAdmin:
        return 'Super Admin';
      case RoleType.admin:
        return 'Admin';
      case RoleType.agent:
        return 'Agente';
      default:
        return 'Usuario';
    }
  }
}

enum AccessLevel {
  owner,
  admin,
  readOnly,
  none,
}
