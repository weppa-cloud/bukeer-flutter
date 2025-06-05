import 'package:flutter/foundation.dart';

/// Application configuration class
/// Manages environment variables and app settings
class AppConfig {
  static const String _supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wzlxbpicdcdvxvdcvgas.supabase.co',
  );
  
  static const String _supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8',
  );
  
  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://wzlxbpicdcdvxvdcvgas.supabase.co/rest/v1',
  );
  
  static const bool _debugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: kDebugMode,
  );
  
  // Getters
  static String get supabaseUrl => _supabaseUrl;
  static String get supabaseAnonKey => _supabaseAnonKey;
  static String get apiBaseUrl => _apiBaseUrl;
  static bool get debugMode => _debugMode;
  
  // Validate configuration
  static bool get isConfigValid {
    return _supabaseUrl.isNotEmpty && 
           _supabaseAnonKey.isNotEmpty &&
           _apiBaseUrl.isNotEmpty;
  }
  
  // Log configuration (only in debug mode)
  static void logConfig() {
    if (_debugMode) {
      debugPrint('=== App Configuration ===');
      debugPrint('Supabase URL: ${_supabaseUrl.length > 10 ? '${_supabaseUrl.substring(0, 10)}...' : _supabaseUrl}');
      debugPrint('Anon Key: ${_supabaseAnonKey.length > 10 ? '***...${_supabaseAnonKey.substring(_supabaseAnonKey.length - 4)}' : '***'}');
      debugPrint('API Base URL: ${_apiBaseUrl.length > 10 ? '${_apiBaseUrl.substring(0, 10)}...' : _apiBaseUrl}');
      debugPrint('Debug Mode: $_debugMode');
      debugPrint('Config Valid: $isConfigValid');
      debugPrint('========================');
    }
  }
}