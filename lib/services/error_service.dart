import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Global error handling service
/// Provides centralized error management, logging, and user feedback
class ErrorService extends ChangeNotifier {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  // Current error state
  AppError? _currentError;
  List<AppError> _errorHistory = [];

  // Error callbacks
  void Function(AppError error)? _onError;

  AppError? get currentError => _currentError;
  List<AppError> get errorHistory => List.unmodifiable(_errorHistory);
  bool get hasError => _currentError != null;

  /// Set error callback for custom handling
  void setErrorCallback(void Function(AppError error) callback) {
    _onError = callback;
  }

  /// Handle an error with proper categorization and logging
  void handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    ErrorSeverity severity = ErrorSeverity.medium,
    ErrorType type = ErrorType.unknown,
    Map<String, dynamic>? metadata,
  }) {
    final appError = AppError(
      message: _extractErrorMessage(error),
      originalError: error,
      stackTrace: stackTrace ?? StackTrace.current,
      context: context,
      severity: severity,
      type: type,
      timestamp: DateTime.now(),
      metadata: metadata ?? {},
    );

    _processError(appError);
  }

  /// Handle API errors specifically
  void handleApiError(
    dynamic error, {
    String? endpoint,
    int? statusCode,
    String? method,
    Map<String, dynamic>? requestData,
  }) {
    handleError(
      error,
      context: 'API Call: ${method ?? 'GET'} $endpoint',
      type: ErrorType.api,
      severity: _getApiErrorSeverity(statusCode),
      metadata: {
        'endpoint': endpoint,
        'statusCode': statusCode,
        'method': method,
        'requestData': requestData,
      },
    );
  }

  /// Handle navigation errors
  void handleNavigationError(
    dynamic error, {
    String? route,
    Map<String, String>? parameters,
  }) {
    handleError(
      error,
      context: 'Navigation to: $route',
      type: ErrorType.navigation,
      severity: ErrorSeverity.low,
      metadata: {
        'route': route,
        'parameters': parameters,
      },
    );
  }

  /// Handle validation errors
  void handleValidationError(
    String message, {
    String? field,
    dynamic value,
  }) {
    handleError(
      message,
      context: 'Validation: $field',
      type: ErrorType.validation,
      severity: ErrorSeverity.low,
      metadata: {
        'field': field,
        'value': value,
      },
    );
  }

  /// Handle business logic errors
  void handleBusinessError(
    String message, {
    String? operation,
    Map<String, dynamic>? context,
  }) {
    handleError(
      message,
      context: 'Business Logic: $operation',
      type: ErrorType.business,
      severity: ErrorSeverity.medium,
      metadata: context,
    );
  }

  /// Clear current error
  void clearError() {
    _currentError = null;
    notifyListeners();
  }

  /// Clear all errors
  void clearAllErrors() {
    _currentError = null;
    _errorHistory.clear();
    notifyListeners();
  }

  /// Get user-friendly error message
  String getUserMessage(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return 'Error de conexión. Verifica tu internet.';
      case ErrorType.api:
        return _getApiUserMessage(error);
      case ErrorType.validation:
        return error.message;
      case ErrorType.authentication:
        return 'Error de autenticación. Por favor, inicia sesión nuevamente.';
      case ErrorType.authorization:
        return 'No tienes permisos para realizar esta acción.';
      case ErrorType.business:
        return error.message;
      case ErrorType.storage:
        return 'Error al acceder a los datos locales.';
      default:
        return 'Ha ocurrido un error inesperado.';
    }
  }

  /// Get suggested actions for an error
  List<ErrorAction> getSuggestedActions(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return [
          ErrorAction('Reintentar', () => _retryLastAction()),
          ErrorAction('Verificar conexión', () => _checkConnection()),
        ];
      case ErrorType.api:
        return _getApiActions(error);
      case ErrorType.authentication:
        return [
          ErrorAction('Iniciar sesión', () => _redirectToLogin()),
        ];
      case ErrorType.validation:
        return [
          ErrorAction('Corregir datos', () => clearError()),
        ];
      default:
        return [
          ErrorAction('Reintentar', () => _retryLastAction()),
          ErrorAction('Reportar error', () => _reportError(error)),
        ];
    }
  }

  // Private methods
  void _processError(AppError error) {
    // Log error
    _logError(error);

    // Add to history
    _errorHistory.add(error);
    if (_errorHistory.length > 50) {
      _errorHistory.removeAt(0); // Keep only last 50 errors
    }

    // Set as current error
    _currentError = error;

    // Notify listeners
    notifyListeners();

    // Call custom error handler
    _onError?.call(error);

    // Auto-clear low severity errors after delay
    if (error.severity == ErrorSeverity.low) {
      Future.delayed(Duration(seconds: 5), () {
        if (_currentError == error) {
          clearError();
        }
      });
    }
  }

  void _logError(AppError error) {
    debugPrint('=== ERROR LOG ===');
    debugPrint('Type: ${error.type}');
    debugPrint('Severity: ${error.severity}');
    debugPrint('Context: ${error.context}');
    debugPrint('Message: ${error.message}');
    debugPrint('Timestamp: ${error.timestamp}');

    if (error.metadata.isNotEmpty) {
      debugPrint('Metadata: ${error.metadata}');
    }

    if (kDebugMode && error.severity == ErrorSeverity.high) {
      debugPrint('Stack Trace: ${error.stackTrace}');
    }
    debugPrint('================');
  }

  String _extractErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error is Exception) return error.toString();
    if (error is Error) return error.toString();
    return error?.toString() ?? 'Error desconocido';
  }

  ErrorSeverity _getApiErrorSeverity(int? statusCode) {
    if (statusCode == null) return ErrorSeverity.medium;

    if (statusCode >= 500) return ErrorSeverity.high;
    if (statusCode >= 400) return ErrorSeverity.medium;
    return ErrorSeverity.low;
  }

  String _getApiUserMessage(AppError error) {
    final statusCode = error.metadata['statusCode'] as int?;

    switch (statusCode) {
      case 400:
        return 'Datos inválidos. Verifica la información enviada.';
      case 401:
        return 'Sesión expirada. Inicia sesión nuevamente.';
      case 403:
        return 'No tienes permisos para esta acción.';
      case 404:
        return 'El recurso solicitado no fue encontrado.';
      case 500:
        return 'Error interno del servidor. Intenta más tarde.';
      case 503:
        return 'Servicio no disponible. Intenta más tarde.';
      default:
        return 'Error en la conexión con el servidor.';
    }
  }

  List<ErrorAction> _getApiActions(AppError error) {
    final statusCode = error.metadata['statusCode'] as int?;

    switch (statusCode) {
      case 401:
        return [ErrorAction('Iniciar sesión', () => _redirectToLogin())];
      case 403:
        return [ErrorAction('Contactar administrador', () => _contactAdmin())];
      case 500:
      case 503:
        return [
          ErrorAction('Reintentar en 1 min', () => _retryAfterDelay()),
          ErrorAction('Reportar error', () => _reportError(error)),
        ];
      default:
        return [ErrorAction('Reintentar', () => _retryLastAction())];
    }
  }

  void _retryLastAction() {
    clearError();
    // TODO: Implement retry mechanism
    debugPrint('Retrying last action...');
  }

  void _checkConnection() {
    // TODO: Implement connection check
    debugPrint('Checking connection...');
  }

  void _redirectToLogin() {
    // TODO: Implement login redirect
    debugPrint('Redirecting to login...');
  }

  void _contactAdmin() {
    // TODO: Implement admin contact
    debugPrint('Contacting admin...');
  }

  void _retryAfterDelay() {
    Future.delayed(Duration(minutes: 1), () => _retryLastAction());
  }

  void _reportError(AppError error) {
    // TODO: Implement error reporting
    debugPrint('Reporting error: ${error.message}');
  }
}

/// Error data model
class AppError {
  final String message;
  final dynamic originalError;
  final StackTrace stackTrace;
  final String? context;
  final ErrorSeverity severity;
  final ErrorType type;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  AppError({
    required this.message,
    required this.originalError,
    required this.stackTrace,
    this.context,
    required this.severity,
    required this.type,
    required this.timestamp,
    required this.metadata,
  });
}

/// Error severity levels
enum ErrorSeverity {
  low, // Info/warnings that don't block user
  medium, // Errors that affect functionality but app remains usable
  high, // Critical errors that may crash the app
}

/// Error type categories
enum ErrorType {
  network, // Network connectivity issues
  api, // API/server errors
  validation, // Input validation errors
  authentication, // Auth errors
  authorization, // Permission errors
  business, // Business logic errors
  storage, // Local storage errors
  navigation, // Routing/navigation errors
  unknown, // Uncategorized errors
}

/// Error action definition
class ErrorAction {
  final String label;
  final VoidCallback action;

  ErrorAction(this.label, this.action);
}
