import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth/base_auth_user_provider.dart';
import '../../services/app_services.dart';
import '../route_definitions.dart';

/// Authentication guard for protected routes
class AuthGuard {
  /// Check if user is authenticated and redirect if needed
  static String? check(BuildContext context, GoRouterState state) {
    final appStateNotifier = context.read<AppStateNotifier>();
    final isLoggedIn = appStateNotifier.loggedIn;
    final isLoading = appStateNotifier.loading;

    // If still loading, show splash
    if (isLoading) {
      return AppRoutes.splash;
    }

    // If not logged in, redirect to login and save current location
    if (!isLoggedIn) {
      appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
      return AppRoutes.login;
    }

    // User is authenticated
    return null;
  }

  /// Check authentication for admin routes
  static String? checkAdmin(BuildContext context, GoRouterState state) {
    // First check basic authentication
    final authRedirect = check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check admin permissions
    final authService = appServices.authorization;
    if (!authService.isAdmin && !authService.isSuperAdmin) {
      // Redirect to home if not admin
      return AppRoutes.home;
    }

    return null;
  }

  /// Check authentication for super admin routes
  static String? checkSuperAdmin(BuildContext context, GoRouterState state) {
    // First check basic authentication
    final authRedirect = check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check super admin permissions
    final authService = appServices.authorization;
    if (!authService.isSuperAdmin) {
      // Redirect to home if not super admin
      return AppRoutes.home;
    }

    return null;
  }

  /// Check if user has specific permissions
  static String? checkPermissions(
    BuildContext context,
    GoRouterState state,
    List<String> requiredPermissions,
  ) {
    // First check basic authentication
    final authRedirect = check(context, state);
    if (authRedirect != null) return authRedirect;

    // Check specific permissions
    final authService = appServices.authorization;
    final hasPermissions = requiredPermissions.every(
      (permission) => authService.hasPermission(permission),
    );

    if (!hasPermissions) {
      // Redirect to home if insufficient permissions
      return AppRoutes.home;
    }

    return null;
  }

  /// Middleware to ensure user data is loaded
  static Future<bool> ensureUserDataLoaded(BuildContext context) async {
    try {
      final userService = appServices.user;
      if (!userService.isInitialized) {
        await userService.initialize();
      }
      return true;
    } catch (e) {
      debugPrint('Error loading user data: $e');
      return false;
    }
  }

  /// Get redirect location after successful login
  static String getPostLoginRedirect(BuildContext context) {
    final appStateNotifier = context.read<AppStateNotifier>();

    if (appStateNotifier.hasRedirect()) {
      final redirect = appStateNotifier.getRedirectLocation();
      appStateNotifier.clearRedirectLocation();
      return redirect;
    }

    return AppRoutes.home;
  }

  /// Check if route requires authentication
  static bool routeRequiresAuth(String path) {
    const publicRoutes = [
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
      AppRoutes.resetPassword,
    ];

    // Check if it's a preview route (public)
    if (path.startsWith('/preview/')) {
      return false;
    }

    return !publicRoutes.contains(path);
  }

  /// Helper to logout and redirect to login
  static void logout(BuildContext context) {
    final appStateNotifier = context.read<AppStateNotifier>();
    appStateNotifier.updateNotifyOnAuthChange(false);

    // Clear app services
    appServices.clearAll();

    // Navigate to login
    context.go(AppRoutes.login);
  }
}
