import 'package:flutter/foundation.dart';
import '../backend/supabase/supabase.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'error_service.dart';

/// Comprehensive authorization service
/// Handles roles, permissions, and access control throughout the app
class AuthorizationService extends ChangeNotifier {
  static final AuthorizationService _instance =
      AuthorizationService._internal();
  factory AuthorizationService() => _instance;
  AuthorizationService._internal();

  // Cached user roles and permissions
  List<UserRole> _userRoles = [];
  Set<String> _userPermissions = {};
  DateTime? _lastRoleCheck;

  // Cache duration for roles (5 minutes)
  Duration get _roleCacheDuration => const Duration(minutes: 5);

  List<UserRole> get userRoles => List.unmodifiable(_userRoles);
  Set<String> get userPermissions => Set.unmodifiable(_userPermissions);
  bool get hasLoadedRoles => _userRoles.isNotEmpty;

  /// Load user roles and permissions
  Future<void> loadUserRoles(String userId) async {
    // Check cache validity
    if (_lastRoleCheck != null &&
        DateTime.now().difference(_lastRoleCheck!) < _roleCacheDuration &&
        _userRoles.isNotEmpty) {
      return;
    }

    try {
      final response = await SupaFlow.client
          .from('user_roles_view')
          .select('*')
          .eq('user_id', userId);

      _userRoles.clear();
      _userPermissions.clear();

      for (final roleData in response) {
        final role = UserRole.fromJson(roleData);
        _userRoles.add(role);
        _userPermissions.addAll(role.permissions);
      }

      _lastRoleCheck = DateTime.now();
      notifyListeners();

      debugPrint(
          'Loaded ${_userRoles.length} roles and ${_userPermissions.length} permissions for user $userId');
    } catch (e) {
      ErrorService().handleError(
        e,
        context: 'AuthorizationService.loadUserRoles',
        type: ErrorType.authorization,
        severity: ErrorSeverity.medium,
      );
    }
  }

  /// Check if user has specific role
  bool hasRole(RoleType roleType) {
    return _userRoles.any((role) => role.type == roleType);
  }

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<RoleType> roleTypes) {
    return roleTypes.any((roleType) => hasRole(roleType));
  }

  /// Check if user has all specified roles
  bool hasAllRoles(List<RoleType> roleTypes) {
    return roleTypes.every((roleType) => hasRole(roleType));
  }

  /// Check if user has specific permission
  bool hasPermission(String permission) {
    return _userPermissions.contains(permission);
  }

  /// Check if user has any of the specified permissions
  bool hasAnyPermission(List<String> permissions) {
    return permissions.any((permission) => hasPermission(permission));
  }

  /// Check if user has all specified permissions
  bool hasAllPermissions(List<String> permissions) {
    return permissions.every((permission) => hasPermission(permission));
  }

  /// Check if user can access resource
  bool canAccessResource(
    String resourceType,
    String action, {
    String? ownerId,
    String? currentUserId,
  }) {
    // Owner can always access their own resources
    if (ownerId != null && currentUserId != null && ownerId == currentUserId) {
      return true;
    }

    // Check specific permission
    final permission = '$resourceType:$action';
    if (hasPermission(permission)) {
      return true;
    }

    // Check role-based permissions
    return _checkRoleBasedAccess(resourceType, action);
  }

  /// Comprehensive authorization check
  Future<bool> authorize({
    required String userId,
    String? resourceId,
    String? ownerId,
    List<RoleType>? requiredRoles,
    List<String>? requiredPermissions,
    String? resourceType,
    String? action,
  }) async {
    try {
      // Ensure roles are loaded
      await loadUserRoles(userId);

      // Check role requirements
      if (requiredRoles != null && requiredRoles.isNotEmpty) {
        if (!hasAnyRole(requiredRoles)) {
          return false;
        }
      }

      // Check permission requirements
      if (requiredPermissions != null && requiredPermissions.isNotEmpty) {
        if (!hasAnyPermission(requiredPermissions)) {
          return false;
        }
      }

      // Check resource access
      if (resourceType != null && action != null) {
        return canAccessResource(
          resourceType,
          action,
          ownerId: ownerId,
          currentUserId: userId,
        );
      }

      return true;
    } catch (e) {
      ErrorService().handleError(
        e,
        context: 'AuthorizationService.authorize',
        type: ErrorType.authorization,
        severity: ErrorSeverity.medium,
      );
      return false;
    }
  }

  /// Check if user is admin or super admin
  bool get isAdmin => hasAnyRole([RoleType.admin, RoleType.superAdmin]);

  /// Check if user is super admin
  bool get isSuperAdmin => hasRole(RoleType.superAdmin);

  /// Check if user is agent
  bool get isAgent => hasRole(RoleType.agent);

  /// Get current user's role type
  RoleType get currentUserRole {
    if (isSuperAdmin) return RoleType.superAdmin;
    if (isAdmin) return RoleType.admin;
    if (isAgent) return RoleType.agent;
    return RoleType.guest;
  }

  /// Get highest role level (for UI purposes)
  int get roleLevel {
    if (isSuperAdmin) return 3;
    if (isAdmin) return 2;
    if (isAgent) return 1;
    return 0;
  }

  /// Clear cached roles (call on logout)
  void clearRoles() {
    _userRoles.clear();
    _userPermissions.clear();
    _lastRoleCheck = null;
    notifyListeners();
  }

  /// Invalidate the authorization cache
  void invalidateCache() {
    clearRoles();
  }

  /// Private helper methods
  bool _checkRoleBasedAccess(String resourceType, String action) {
    // Super admin can do everything
    if (isSuperAdmin) return true;

    // Admin permissions
    if (isAdmin) {
      return _adminPermissions[resourceType]?.contains(action) ?? false;
    }

    // Agent permissions
    if (isAgent) {
      return _agentPermissions[resourceType]?.contains(action) ?? false;
    }

    return false;
  }

  /// Role-based permission matrices
  static const Map<String, List<String>> _adminPermissions = {
    'itinerary': ['create', 'read', 'update', 'delete', 'assign'],
    'contact': ['create', 'read', 'update', 'delete'],
    'product': ['create', 'read', 'update', 'delete'],
    'user': ['read', 'update'],
    'payment': ['create', 'read', 'update'],
    'report': ['read', 'export'],
  };

  static const Map<String, List<String>> _agentPermissions = {
    'itinerary': ['create', 'read', 'update'], // No delete, no assign
    'contact': ['create', 'read', 'update'],
    'product': ['read'], // Read-only
    'user': ['read'], // Read-only
    'payment': ['read'], // Read-only
    'report': ['read'], // Read-only
  };
}

/// User role model
class UserRole {
  final int id;
  final String name;
  final RoleType type;
  final String? description;
  final List<String> permissions;
  final bool isActive;

  UserRole({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.permissions,
    this.isActive = true,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['role_id'] ?? 0,
      name: json['role_name'] ?? '',
      type: _parseRoleType(json['role_name']),
      description: json['role_description'],
      permissions: _parsePermissions(json['role_names'] ?? ''),
      isActive: json['is_active'] ?? true,
    );
  }

  static RoleType _parseRoleType(String? roleName) {
    switch (roleName?.toLowerCase()) {
      case 'super_admin':
      case 'superadmin':
        return RoleType.superAdmin;
      case 'admin':
        return RoleType.admin;
      case 'agent':
        return RoleType.agent;
      default:
        return RoleType.guest;
    }
  }

  static List<String> _parsePermissions(String roleNames) {
    // Convert role names to permissions
    final roles = roleNames.split(',').map((e) => e.trim()).toList();
    final permissions = <String>[];

    for (final role in roles) {
      switch (role.toLowerCase()) {
        case 'super_admin':
          permissions.addAll([
            'itinerary:*',
            'contact:*',
            'product:*',
            'user:*',
            'payment:*',
            'report:*',
            'admin:*'
          ]);
          break;
        case 'admin':
          permissions.addAll([
            'itinerary:create',
            'itinerary:read',
            'itinerary:update',
            'itinerary:delete',
            'contact:create',
            'contact:read',
            'contact:update',
            'contact:delete',
            'product:create',
            'product:read',
            'product:update',
            'product:delete',
            'user:read',
            'user:update',
            'payment:create',
            'payment:read',
            'payment:update',
            'report:read',
            'report:export'
          ]);
          break;
        case 'agent':
          permissions.addAll([
            'itinerary:create',
            'itinerary:read',
            'itinerary:update',
            'contact:create',
            'contact:read',
            'contact:update',
            'product:read',
            'user:read',
            'payment:read',
            'report:read'
          ]);
          break;
      }
    }

    return permissions;
  }
}

/// Role types enum
enum RoleType {
  superAdmin,
  admin,
  agent,
  guest,
}

/// Permission constants
class Permissions {
  // Itinerary permissions
  static const String itineraryCreate = 'itinerary:create';
  static const String itineraryRead = 'itinerary:read';
  static const String itineraryUpdate = 'itinerary:update';
  static const String itineraryDelete = 'itinerary:delete';
  static const String itineraryAssign = 'itinerary:assign';

  // Contact permissions
  static const String contactCreate = 'contact:create';
  static const String contactRead = 'contact:read';
  static const String contactUpdate = 'contact:update';
  static const String contactDelete = 'contact:delete';

  // Product permissions
  static const String productCreate = 'product:create';
  static const String productRead = 'product:read';
  static const String productUpdate = 'product:update';
  static const String productDelete = 'product:delete';

  // User permissions
  static const String userCreate = 'user:create';
  static const String userRead = 'user:read';
  static const String userUpdate = 'user:update';
  static const String userDelete = 'user:delete';

  // Payment permissions
  static const String paymentCreate = 'payment:create';
  static const String paymentRead = 'payment:read';
  static const String paymentUpdate = 'payment:update';

  // Report permissions
  static const String reportRead = 'report:read';
  static const String reportExport = 'report:export';
}
