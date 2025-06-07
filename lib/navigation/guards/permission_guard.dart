import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/app_services.dart';
import '../route_definitions.dart';
import 'auth_guard.dart';

/// Permission-based guards for specific resource access
class PermissionGuard {
  /// Check admin permissions
  static String? checkAdmin(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check admin permissions
    final authService = appServices.authorization;
    if (!authService.isAdmin && !authService.isSuperAdmin) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check super admin permissions
  static String? checkSuperAdmin(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check super admin permissions
    final authService = appServices.authorization;
    if (!authService.isSuperAdmin) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check itinerary permissions
  static String? checkItineraries(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check itinerary permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('itinerary:read')) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check itinerary creation permissions
  static String? checkItineraryCreate(
      BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check creation permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('itinerary:create')) {
      return AppRoutes.itineraries;
    }

    return null;
  }

  /// Check itinerary edit permissions
  static String? checkItineraryEdit(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check edit permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('itinerary:update')) {
      // Check if user owns this itinerary
      final itineraryId = state.pathParameters['id'];
      if (itineraryId != null) {
        // TODO: Check ownership via ItineraryService
        // For now, allow if user has basic read permission
        if (!authService.hasPermission('itinerary:read')) {
          return AppRoutes.home;
        }
      }
    }

    return null;
  }

  /// Check product permissions
  static String? checkProducts(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check product permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('product:read')) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check product creation permissions
  static String? checkProductCreate(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check creation permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('product:create')) {
      return AppRoutes.products;
    }

    return null;
  }

  /// Check product edit permissions
  static String? checkProductEdit(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check edit permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('product:update')) {
      return AppRoutes.products;
    }

    return null;
  }

  /// Check contact permissions
  static String? checkContacts(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check contact permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('contact:read')) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check contact creation permissions
  static String? checkContactCreate(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check creation permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('contact:create')) {
      return AppRoutes.contacts;
    }

    return null;
  }

  /// Check user management permissions
  static String? checkUserManagement(
      BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check user management permissions (admin only)
    final authService = appServices.authorization;
    if (!authService.isAdmin && !authService.isSuperAdmin) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check report access permissions
  static String? checkReports(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check report permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('report:read')) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check financial report permissions
  static String? checkFinancialReports(
      BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check financial report permissions (higher level)
    final authService = appServices.authorization;
    if (!authService.hasPermission('financial:read')) {
      return AppRoutes.home;
    }

    return null;
  }

  /// Check booking permissions
  static String? checkBooking(BuildContext context, GoRouterState state) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check booking permissions
    final authService = appServices.authorization;
    if (!authService.hasPermission('booking:create')) {
      return AppRoutes.products;
    }

    return null;
  }

  /// Generic permission checker
  static String? checkPermission(
    BuildContext context,
    GoRouterState state,
    String permission, {
    String? fallbackRoute,
  }) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check specific permission
    final authService = appServices.authorization;
    if (!authService.hasPermission(permission)) {
      return fallbackRoute ?? AppRoutes.home;
    }

    return null;
  }

  /// Check multiple permissions (user must have ALL)
  static String? checkPermissions(
    BuildContext context,
    GoRouterState state,
    List<String> permissions, {
    String? fallbackRoute,
  }) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check all permissions
    final authService = appServices.authorization;
    final hasAllPermissions = permissions.every(
      (permission) => authService.hasPermission(permission),
    );

    if (!hasAllPermissions) {
      return fallbackRoute ?? AppRoutes.home;
    }

    return null;
  }

  /// Check if user has any of the specified permissions
  static String? checkAnyPermission(
    BuildContext context,
    GoRouterState state,
    List<String> permissions, {
    String? fallbackRoute,
  }) {
    // First check authentication
    final authRedirect = AuthGuard.check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check if user has any of the permissions
    final authService = appServices.authorization;
    final hasAnyPermission = permissions.any(
      (permission) => authService.hasPermission(permission),
    );

    if (!hasAnyPermission) {
      return fallbackRoute ?? AppRoutes.home;
    }

    return null;
  }
}
