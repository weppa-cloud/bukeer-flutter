import 'package:flutter/foundation.dart';
import 'user_service.dart';
import 'itinerary_service.dart';
import 'product_service.dart';
import 'contact_service.dart';
import 'authorization_service.dart';
import 'error_service.dart';
import 'error_analytics_service.dart';
import 'ui_state_service.dart';
import 'account_service.dart';
import 'pwa_service.dart';
import '../backend/supabase/supabase.dart';
import '../auth/supabase_auth/auth_util.dart';

/// Central service manager for the app
/// Provides singleton access to all services and coordinates initialization
class AppServices {
  static final AppServices _instance = AppServices._internal();
  factory AppServices() => _instance;
  AppServices._internal();

  // Service instances
  final UserService user = UserService();
  final UiStateService ui = UiStateService();
  final ItineraryService itinerary = ItineraryService();
  final ProductService product = ProductService();
  final ContactService contact = ContactService();
  final AuthorizationService authorization = AuthorizationService();
  final ErrorService error = ErrorService();
  final ErrorAnalyticsService errorAnalytics = ErrorAnalyticsService();
  final AccountService account = AccountService();
  final PWAService pwa = PWAService();

  // Track initialization state
  bool _isInitialized = false;
  bool _isInitializing = false;

  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;

  /// Initialize all services
  /// This should be called once when the app starts after authentication
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;

    try {
      _isInitializing = true;
      debugPrint('AppServices: Starting initialization...');

      // Start error analytics session
      errorAnalytics.startSession();

      // Initialize PWA service for web features
      pwa.initialize();

      // Set up error service callbacks
      error.setErrorCallback((appError) {
        errorAnalytics.recordError(appError);
      });

      // Initialize user service first (required for other services)
      // First, we need to get the accountId from the user's roles
      String? accountId;

      try {
        // Import needed for UserRolesTable
        final userRoles = await UserRolesTable().queryRows(
          queryFn: (q) => q.eq('user_id', currentUserUid ?? ''),
        );

        if (userRoles.isNotEmpty) {
          accountId = userRoles.first.accountId;
          debugPrint(
              'AppServices: Found accountId from user roles: $accountId');

          // Set accountId in AccountService immediately
          if (accountId != null) {
            await account.setAccountId(accountId);
          }
        } else {
          debugPrint(
              'AppServices: No user roles found for user: $currentUserUid');
        }
      } catch (e) {
        debugPrint('AppServices: Error fetching user roles: $e');
      }

      // Now initialize user data with the accountId
      if (accountId != null) {
        await user.initializeUserData(accountId: accountId);
      } else {
        // Fallback approach if no accountId found
        debugPrint('AppServices: No accountId found, using fallback');
        await user.initializeUserData(accountId: null);
      }

      // Only proceed if user data loaded successfully
      if (user.hasLoadedData) {
        // Load user authorization data
        final userId = user.getAgentInfo(r'$[:].id')?.toString();
        if (userId != null) {
          await authorization.loadUserRoles(userId);
        }

        // Set account ID for AccountService
        accountId = user.getAgentInfo(r'$[:].id_account')?.toString();
        if (accountId != null) {
          await account.setAccountId(accountId);
        }

        // Initialize other services in parallel
        await Future.wait([
          itinerary.initialize(),
          product.initialize(),
          contact.initialize(),
          account.initialize(),
        ]);

        _isInitialized = true;
        debugPrint('AppServices: Initialization complete');
      } else {
        debugPrint('AppServices: User data failed to load');
      }
    } catch (e) {
      debugPrint('AppServices: Initialization error: $e');
      _isInitialized = false;
    } finally {
      _isInitializing = false;
    }
  }

  /// Refresh all services data
  Future<void> refreshAll() async {
    _isInitialized = false;

    await Future.wait([
      user.refreshUserData(),
      itinerary.refresh(),
      product.refresh(),
      contact.refresh(),
    ]);

    // Reload authorization data
    final userId = user.getAgentInfo(r'$[:].id')?.toString();
    if (userId != null) {
      await authorization.loadUserRoles(userId);
    }

    // Reload account data
    final accountId = user.getAgentInfo(r'$[:].id_account')?.toString();
    if (accountId != null) {
      await account.loadAccountData();
    }

    _isInitialized = true;
  }

  /// Clear all cached data
  void clearAllCaches() {
    product.clearCache();
    ui.clearAll();
    account.clearData();
    // Add clear methods for other services as needed
    _isInitialized = false;
  }

  /// Reset services (useful for logout)
  void reset() {
    clearAllCaches();
    authorization.clearRoles();
    error.clearAllErrors();
    errorAnalytics.clearAnalytics();
    user.clearUserData();
    account.clearData();
    _isInitialized = false;
    _isInitializing = false;
  }
}

/// Global instance for easy access
final appServices = AppServices();
