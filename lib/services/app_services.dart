import 'package:flutter/foundation.dart';
import 'user_service.dart';
import 'itinerary_service.dart';
import 'product_service.dart';
import 'contact_service.dart';
import 'authorization_service.dart';
import 'error_service.dart';

/// Central service manager for the app
/// Provides singleton access to all services and coordinates initialization
class AppServices {
  static final AppServices _instance = AppServices._internal();
  factory AppServices() => _instance;
  AppServices._internal();

  // Service instances
  final UserService user = UserService();
  final ItineraryService itinerary = ItineraryService();
  final ProductService product = ProductService();
  final ContactService contact = ContactService();
  final AuthorizationService authorization = AuthorizationService();
  final ErrorService error = ErrorService();

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

      // Initialize user service first (required for other services)
      await user.initializeUserData();

      // Only proceed if user data loaded successfully
      if (user.hasLoadedData) {
        // Load user authorization data
        final userId = user.getAgentInfo(r'$[:].id')?.toString();
        if (userId != null) {
          await authorization.loadUserRoles(userId);
        }

        // Initialize other services in parallel
        await Future.wait([
          itinerary.initialize(),
          product.initialize(),
          contact.initialize(),
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

    _isInitialized = true;
  }

  /// Clear all cached data
  void clearAllCaches() {
    product.clearCache();
    // Add clear methods for other services as needed
    _isInitialized = false;
  }

  /// Reset services (useful for logout)
  void reset() {
    clearAllCaches();
    authorization.clearRoles();
    error.clearAllErrors();
    _isInitialized = false;
    _isInitializing = false;
  }
}

/// Global instance for easy access
final appServices = AppServices();
