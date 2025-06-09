/// Storage key constants for the Bukeer application
/// These constants define keys used for local storage, shared preferences, and cache
///
/// Usage:
/// ```dart
/// import 'package:bukeer/bukeer/core/constants/storage_keys.dart';
///
/// final prefs = await SharedPreferences.getInstance();
/// final token = prefs.getString(StorageKeys.authToken);
/// ```

class StorageKeys {
  // Prevent instantiation
  StorageKeys._();

  // Prefix for all storage keys to avoid conflicts
  static const String prefix = 'bukeer_';

  // Authentication keys
  static const String authToken = '${prefix}auth_token';
  static const String refreshToken = '${prefix}refresh_token';
  static const String userId = '${prefix}user_id';
  static const String userEmail = '${prefix}user_email';
  static const String userName = '${prefix}user_name';
  static const String userRole = '${prefix}user_role';
  static const String userPermissions = '${prefix}user_permissions';
  static const String lastLoginTime = '${prefix}last_login_time';
  static const String sessionExpiry = '${prefix}session_expiry';
  static const String rememberMe = '${prefix}remember_me';
  static const String biometricEnabled = '${prefix}biometric_enabled';

  // User preferences
  static const String theme = '${prefix}theme';
  static const String language = '${prefix}language';
  static const String currency = '${prefix}currency';
  static const String dateFormat = '${prefix}date_format';
  static const String timeFormat = '${prefix}time_format';
  static const String firstDayOfWeek = '${prefix}first_day_of_week';
  static const String notificationsEnabled = '${prefix}notifications_enabled';
  static const String soundEnabled = '${prefix}sound_enabled';
  static const String vibrationEnabled = '${prefix}vibration_enabled';

  // App state persistence
  static const String lastSyncTime = '${prefix}last_sync_time';
  static const String offlineMode = '${prefix}offline_mode';
  static const String pendingSync = '${prefix}pending_sync';
  static const String lastSelectedTab = '${prefix}last_selected_tab';
  static const String lastSearchQuery = '${prefix}last_search_query';
  static const String lastFilterSettings = '${prefix}last_filter_settings';
  static const String favoriteProducts = '${prefix}favorite_products';
  static const String recentSearches = '${prefix}recent_searches';
  static const String viewPreferences = '${prefix}view_preferences';

  // Cache keys
  static const String cacheVersion = '${prefix}cache_version';
  static const String cachedUserData = '${prefix}cached_user_data';
  static const String cachedContacts = '${prefix}cached_contacts';
  static const String cachedProducts = '${prefix}cached_products';
  static const String cachedItineraries = '${prefix}cached_itineraries';
  static const String cachedLocations = '${prefix}cached_locations';
  static const String cachedAirports = '${prefix}cached_airports';
  static const String cachedAirlines = '${prefix}cached_airlines';
  static const String cachedNationalities = '${prefix}cached_nationalities';
  static const String cachedCurrencyRates = '${prefix}cached_currency_rates';

  // Feature flags and experiments
  static const String featureFlags = '${prefix}feature_flags';
  static const String experimentGroups = '${prefix}experiment_groups';
  static const String betaFeaturesEnabled = '${prefix}beta_features_enabled';

  // Analytics and tracking
  static const String analyticsUserId = '${prefix}analytics_user_id';
  static const String analyticsSessionId = '${prefix}analytics_session_id';
  static const String analyticsConsent = '${prefix}analytics_consent';
  static const String crashReportingConsent =
      '${prefix}crash_reporting_consent';
  static const String performanceMonitoringConsent =
      '${prefix}performance_monitoring_consent';

  // Onboarding and tutorials
  static const String hasCompletedOnboarding =
      '${prefix}has_completed_onboarding';
  static const String hasSeenTutorial = '${prefix}has_seen_tutorial';
  static const String tutorialProgress = '${prefix}tutorial_progress';
  static const String tooltipsEnabled = '${prefix}tooltips_enabled';
  static const String shownTooltips = '${prefix}shown_tooltips';

  // PWA specific
  static const String pwaInstallPromptShown =
      '${prefix}pwa_install_prompt_shown';
  static const String pwaInstallPromptDismissed =
      '${prefix}pwa_install_prompt_dismissed';
  static const String pwaUpdateAvailable = '${prefix}pwa_update_available';
  static const String pwaLastUpdateCheck = '${prefix}pwa_last_update_check';
  static const String pwaOfflineDataVersion =
      '${prefix}pwa_offline_data_version';

  // Form drafts (auto-save)
  static const String draftPrefix = '${prefix}draft_';
  static const String draftItinerary = '${draftPrefix}itinerary';
  static const String draftProduct = '${draftPrefix}product';
  static const String draftContact = '${draftPrefix}contact';
  static const String draftPassenger = '${draftPrefix}passenger';

  // Temporary data
  static const String tempPrefix = '${prefix}temp_';
  static const String tempSearchResults = '${tempPrefix}search_results';
  static const String tempFilterState = '${tempPrefix}filter_state';
  static const String tempFormData = '${tempPrefix}form_data';
  static const String tempUploadQueue = '${tempPrefix}upload_queue';

  // Debug and development
  static const String debugMode = '${prefix}debug_mode';
  static const String mockDataEnabled = '${prefix}mock_data_enabled';
  static const String apiEnvironment = '${prefix}api_environment';
  static const String logLevel = '${prefix}log_level';

  // Migration and versioning
  static const String appVersion = '${prefix}app_version';
  static const String lastMigrationVersion = '${prefix}last_migration_version';
  static const String dataSchemaVersion = '${prefix}data_schema_version';

  // Methods to generate dynamic keys
  static String userPreference(String key) => '${prefix}user_pref_$key';
  static String cachedApiResponse(String endpoint) =>
      '${prefix}api_cache_$endpoint';
  static String formDraft(String formId) => '$draftPrefix$formId';
  static String tempData(String key) => '$tempPrefix$key';
  static String featureFlag(String flagName) => '${prefix}feature_$flagName';
}

/// Storage key prefixes for organizing related keys
class StorageKeyPrefixes {
  StorageKeyPrefixes._();

  static const String auth = '${StorageKeys.prefix}auth_';
  static const String user = '${StorageKeys.prefix}user_';
  static const String cache = '${StorageKeys.prefix}cache_';
  static const String pref = '${StorageKeys.prefix}pref_';
  static const String temp = '${StorageKeys.prefix}temp_';
  static const String draft = '${StorageKeys.prefix}draft_';
  static const String feature = '${StorageKeys.prefix}feature_';
  static const String analytics = '${StorageKeys.prefix}analytics_';
  static const String pwa = '${StorageKeys.prefix}pwa_';
}

/// Storage expiry durations
class StorageExpiry {
  StorageExpiry._();

  // Cache durations
  static const Duration shortCache = Duration(minutes: 5);
  static const Duration mediumCache = Duration(minutes: 30);
  static const Duration longCache = Duration(hours: 24);
  static const Duration veryLongCache = Duration(days: 7);

  // Session durations
  static const Duration sessionTimeout = Duration(hours: 1);
  static const Duration rememberMeTimeout = Duration(days: 30);

  // Draft durations
  static const Duration draftExpiry = Duration(days: 7);
  static const Duration tempDataExpiry = Duration(hours: 1);

  // Feature flag refresh
  static const Duration featureFlagRefresh = Duration(hours: 6);

  // Analytics batch upload
  static const Duration analyticsBatchInterval = Duration(minutes: 5);
}
