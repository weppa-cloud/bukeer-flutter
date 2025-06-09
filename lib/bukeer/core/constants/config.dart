/// Application configuration constants
/// These constants define application-wide settings and configuration values
///
/// Usage:
/// ```dart
/// import 'package:bukeer/bukeer/core/constants/config.dart';
///
/// if (items.length > AppConstants.maxItemsPerPage) {
///   // Handle pagination
/// }
/// ```

class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App information
  static const String appName = 'Bukeer';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.bukeer.app';

  // Environment names
  static const String envDevelopment = 'development';
  static const String envStaging = 'staging';
  static const String envProduction = 'production';

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int maxItemsPerPage = 50;
  static const int searchDebounceMs = 300;

  // UI timing constants (in milliseconds)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;
  static const int splashScreenDuration = 2000;
  static const int snackBarDuration = 3000;
  static const int toastDuration = 2000;

  // Network timeouts (in milliseconds)
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int uploadTimeout = 60000; // 60 seconds
  static const int downloadTimeout = 60000; // 60 seconds

  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const int retryDelayMs = 1000;
  static const double retryDelayMultiplier = 1.5;

  // Cache configuration
  static const int cacheMaxAge = 86400; // 24 hours in seconds
  static const int cacheMaxSize = 104857600; // 100 MB in bytes
  static const int cacheMaxEntries = 1000;
  static const int searchCacheDuration = 300; // 5 minutes in seconds

  // Session management
  static const int sessionTimeout = 3600000; // 1 hour in milliseconds
  static const int sessionWarningTime = 300000; // 5 minutes before timeout
  static const int refreshTokenThreshold = 600000; // 10 minutes before expiry

  // File upload limits
  static const int maxFileSize = 10485760; // 10 MB in bytes
  static const int maxImageSize = 5242880; // 5 MB in bytes
  static const int maxPdfSize = 20971520; // 20 MB in bytes
  static const List<String> allowedImageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp'
  ];
  static const List<String> allowedDocumentExtensions = [
    '.pdf',
    '.doc',
    '.docx'
  ];

  // Image dimensions
  static const int thumbnailSize = 150;
  static const int smallImageSize = 300;
  static const int mediumImageSize = 600;
  static const int largeImageSize = 1200;
  static const double imageCompressionQuality = 0.8;

  // Date/Time formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'';

  // Currency settings
  static const String defaultCurrency = 'USD';
  static const int currencyDecimals = 2;
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'COP',
    'MXN',
    'BRL'
  ];

  // Language settings
  static const String defaultLanguage = 'es';
  static const List<String> supportedLanguages = ['es', 'en', 'pt'];

  // Validation rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int maxNameLength = 100;
  static const int maxEmailLength = 254;
  static const int maxPhoneLength = 20;
  static const int maxAddressLength = 255;
  static const int maxDescriptionLength = 1000;
  static const int maxNotesLength = 5000;

  // Regular expressions
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const String urlRegex =
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

  // Map configuration
  static const double defaultMapZoom = 12.0;
  static const double minMapZoom = 1.0;
  static const double maxMapZoom = 20.0;
  static const double defaultLatitude = 4.7110; // Bogotá, Colombia
  static const double defaultLongitude = -74.0721;

  // PWA configuration
  static const bool enablePwa = true;
  static const bool enableOfflineSupport = true;
  static const bool enablePushNotifications = true;
  static const bool enableBackgroundSync = true;

  // Feature flags
  static const bool enableDebugMode = false;
  static const bool enableCrashReporting = true;
  static const bool enableAnalytics = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableAiFeatures = true;
  static const bool enableBetaFeatures = false;

  // Business rules
  static const double defaultProfitMargin = 0.20; // 20%
  static const double minProfitMargin = 0.0;
  static const double maxProfitMargin = 1.0; // 100%
  static const int maxPassengersPerBooking = 50;
  static const int maxServicesPerItinerary = 100;
  static const int maxDaysInAdvanceBooking = 365;
  static const int minDaysInAdvanceBooking = 1;

  // Error messages
  static const String genericErrorMessage =
      'Ha ocurrido un error. Por favor, intente nuevamente.';
  static const String networkErrorMessage =
      'Error de conexión. Verifique su conexión a internet.';
  static const String sessionExpiredMessage =
      'Su sesión ha expirado. Por favor, inicie sesión nuevamente.';
  static const String validationErrorMessage =
      'Por favor, verifique los datos ingresados.';
}
