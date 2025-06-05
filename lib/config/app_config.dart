import 'package:flutter/foundation.dart';

/// Application configuration class
/// Manages runtime configuration loaded from JavaScript
class AppConfig {
  // Static cache for configuration values
  static Map<String, dynamic>? _configCache;

  // Development fallback values
  static const Map<String, dynamic> _fallbackConfig = {
    'supabaseUrl': 'https://wzlxbpicdcdvxvdcvgas.supabase.co',
    'supabaseAnonKey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIxNjk1OTAsImV4cCI6MjAyNzc0NTU5MH0.qqy1F21s7cLPWiV8fU0bGdjJS6unl8imYLB4CH7Muug',
    'apiBaseUrl': 'https://bukeer.bukeerpro.com/api',
    'googleMapsApiKey': 'AIzaSyDEUekXeyIKJUreRydJyv05gCexdSjUdBc',
    'environment': 'development',
    'features': {
      'enableAnalytics': false,
      'enableDebugLogs': true,
      'enableOfflineMode': false,
    },
    'settings': {
      'sessionTimeout': 3600000,
      'maxRetries': 3,
      'requestTimeout': 30000,
    },
  };

  /// Initialize configuration from JavaScript runtime config
  static void initialize() {
    // Always start with fallback configuration
    _configCache = Map<String, dynamic>.from(_fallbackConfig);

    // For web platform, try to merge with JavaScript config
    if (kIsWeb) {
      try {
        final jsConfig = _loadConfigFromJS();
        if (jsConfig != null && jsConfig.isNotEmpty) {
          // Merge JS config with fallback config
          _configCache!.addAll(jsConfig);

          if (kDebugMode) {
            debugPrint('Configuration loaded from JavaScript successfully');
          }
        } else {
          if (kDebugMode) {
            debugPrint(
                'Warning: BukeerConfig not found in JavaScript. Using fallback configuration.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error loading configuration from JavaScript: $e');
        }
        // Continue with fallback configuration
      }
    }

    // Validate configuration
    if (!isConfigValid) {
      throw Exception('Invalid configuration: Missing required fields');
    }

    // Log configuration in debug mode
    logConfig();
  }

  /// Load configuration from JavaScript (web only)
  /// This method attempts to read the BukeerConfig from the global window object
  static Map<String, dynamic>? _loadConfigFromJS() {
    if (!kIsWeb) return null;

    try {
      // This is a placeholder that should be implemented with platform-specific code
      // For now, return null to use fallback configuration

      // Note: In a real implementation, this would use dart:js_interop or dart:html
      // to access window.BukeerConfig, but to keep things simple and avoid
      // dependency issues, we'll rely on the setConfig method being called
      // from JavaScript when the config is available

      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in _loadConfigFromJS: $e');
      }
      return null;
    }
  }

  /// Get configuration value with fallback
  /// Priority: JS Config > Environment Variables > Fallback
  static T _getConfig<T>(String key, T fallback) {
    if (_configCache == null) {
      initialize();
    }

    try {
      // 1. Try JS config first
      final jsValue = _configCache?[key];
      if (jsValue != null && jsValue is T) {
        return jsValue;
      }

      // 2. Try environment variables (for CapRover)
      final envValue = _getEnvValue(key);
      if (envValue != null && envValue is T) {
        return envValue;
      }
    } catch (e) {
      debugPrint('Error getting config value for $key: $e');
    }

    return fallback;
  }

  /// Get value from environment variables (CapRover support)
  static String? _getEnvValue(String key) {
    try {
      // Map config keys to environment variable names and get values
      switch (key) {
        case 'supabaseUrl':
          final value = const String.fromEnvironment('supabaseUrl');
          return value.isNotEmpty ? value : null;
        case 'supabaseAnonKey':
          final value = const String.fromEnvironment('supabaseAnonKey');
          return value.isNotEmpty ? value : null;
        case 'apiBaseUrl':
          final value = const String.fromEnvironment('apiBaseUrl');
          return value.isNotEmpty ? value : null;
        case 'googleMapsApiKey':
          final value = const String.fromEnvironment('googleMapsApiKey');
          return value.isNotEmpty ? value : null;
        case 'environment':
          final value = const String.fromEnvironment('environment');
          return value.isNotEmpty ? value : null;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error getting environment value for $key: $e');
    }
    return null;
  }

  /// Get nested configuration value with fallback
  static T _getNestedConfig<T>(List<String> keys, T fallback) {
    if (_configCache == null) {
      initialize();
    }

    try {
      dynamic current = _configCache;
      for (final key in keys) {
        if (current is Map && current.containsKey(key)) {
          current = current[key];
        } else {
          return fallback;
        }
      }

      if (current is T) {
        return current;
      }
    } catch (e) {
      debugPrint('Error getting nested config value for ${keys.join('.')}: $e');
    }

    return fallback;
  }

  // Configuration getters
  static String get supabaseUrl =>
      _getConfig('supabaseUrl', _fallbackConfig['supabaseUrl'] as String);

  static String get supabaseAnonKey => _getConfig(
      'supabaseAnonKey', _fallbackConfig['supabaseAnonKey'] as String);

  static String get apiBaseUrl =>
      _getConfig('apiBaseUrl', _fallbackConfig['apiBaseUrl'] as String);

  static String get googleMapsApiKey => _getConfig(
      'googleMapsApiKey', _fallbackConfig['googleMapsApiKey'] as String);

  static String get environment =>
      _getConfig('environment', _fallbackConfig['environment'] as String);

  static bool get isProduction => environment == 'production';

  static bool get isStaging => environment == 'staging';

  static bool get isDevelopment => environment == 'development';

  // Feature flags
  static bool get enableAnalytics =>
      _getNestedConfig(['features', 'enableAnalytics'], false);

  static bool get enableDebugLogs =>
      _getNestedConfig(['features', 'enableDebugLogs'], kDebugMode);

  static bool get enableOfflineMode =>
      _getNestedConfig(['features', 'enableOfflineMode'], false);

  // Settings
  static int get sessionTimeout =>
      _getNestedConfig(['settings', 'sessionTimeout'], 3600000);

  static int get maxRetries => _getNestedConfig(['settings', 'maxRetries'], 3);

  static int get requestTimeout =>
      _getNestedConfig(['settings', 'requestTimeout'], 30000);

  // Debug mode - respects both Flutter debug mode and config setting
  static bool get debugMode => kDebugMode || enableDebugLogs;

  // Validate configuration
  static bool get isConfigValid {
    return supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty &&
        apiBaseUrl.isNotEmpty &&
        googleMapsApiKey.isNotEmpty;
  }

  // Log configuration (only in debug mode)
  static void logConfig() {
    if (debugMode) {
      debugPrint('=== App Configuration ===');
      debugPrint('Config Sources:');
      debugPrint('  JS Config: ${_configCache != null ? "✅" : "❌"}');
      debugPrint('  Environment: ${_hasEnvVars() ? "✅" : "❌"}');
      debugPrint('  Fallback: ✅');
      debugPrint('');
      debugPrint('Values:');
      debugPrint('Environment: $environment');
      debugPrint('Supabase URL: ${_maskString(supabaseUrl)}');
      debugPrint('Anon Key: ${_maskString(supabaseAnonKey, showLast: 4)}');
      debugPrint('API Base URL: ${_maskString(apiBaseUrl)}');
      debugPrint(
          'Google Maps Key: ${_maskString(googleMapsApiKey, showLast: 4)}');
      debugPrint('Debug Mode: $debugMode');
      debugPrint('Analytics: $enableAnalytics');
      debugPrint('Offline Mode: $enableOfflineMode');
      debugPrint('Session Timeout: ${sessionTimeout / 1000 / 60} minutes');
      debugPrint('Config Valid: $isConfigValid');
      debugPrint('========================');
    }
  }

  // Check if environment variables are available
  static bool _hasEnvVars() {
    return _getEnvValue('supabaseUrl') != null ||
        _getEnvValue('environment') != null;
  }

  // Mask sensitive strings for logging
  static String _maskString(String value,
      {int showFirst = 10, int showLast = 0}) {
    if (value.length <= showFirst + showLast) {
      return '***';
    }

    final first = showFirst > 0 ? value.substring(0, showFirst) : '';
    final last = showLast > 0 ? value.substring(value.length - showLast) : '';

    return '$first***$last';
  }

  // Method to update runtime config (useful for testing)
  static void updateConfig(Map<String, dynamic> newConfig) {
    if (_configCache != null) {
      _configCache!.addAll(newConfig);

      if (debugMode) {
        debugPrint('Configuration updated dynamically');
        logConfig();
      }
    }
  }

  // Method to set config from external source (used by JavaScript bridge)
  static void setConfig(Map<String, dynamic> config) {
    _configCache = Map<String, dynamic>.from(config);

    if (debugMode) {
      debugPrint('Configuration set from external source');
      logConfig();
    }
  }

  // Reset configuration (useful for testing)
  static void reset() {
    _configCache = null;
    if (debugMode) {
      debugPrint('Configuration reset');
    }
  }
}
