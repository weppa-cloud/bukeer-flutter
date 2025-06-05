import 'package:flutter/foundation.dart';
import '../backend/api_requests/api_calls.dart';
import '../backend/supabase/supabase.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'error_service.dart';
import 'memory_manager.dart';

abstract class BaseService extends ChangeNotifier with AutoMemoryManagement {
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastLoadTime;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Cache duration - override in subclasses if needed
  Duration get cacheDuration => const Duration(minutes: 5);

  // Check if cache is still valid
  bool get isCacheValid {
    if (_lastLoadTime == null) return false;
    return DateTime.now().difference(_lastLoadTime!) < cacheDuration;
  }

  // Base method for loading data with error handling
  Future<T?> loadData<T>(Future<T> Function() loader, {String? context}) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await loader();
      _lastLoadTime = DateTime.now();

      return result;
    } catch (e, stackTrace) {
      final errorMessage = e.toString();
      _setError(errorMessage);

      // Use global error service for better error handling
      ErrorService().handleError(
        e,
        stackTrace: stackTrace,
        context: context ?? '${runtimeType}.loadData',
        type: _determineErrorType(e),
        severity: _determineErrorSeverity(e),
      );

      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Determine error type based on error object
  ErrorType _determineErrorType(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return ErrorType.network;
    }

    if (errorString.contains('unauthorized') ||
        errorString.contains('authentication')) {
      return ErrorType.authentication;
    }

    if (errorString.contains('forbidden') ||
        errorString.contains('permission')) {
      return ErrorType.authorization;
    }

    if (errorString.contains('validation') || errorString.contains('invalid')) {
      return ErrorType.validation;
    }

    // Check for API response errors
    if (error is ApiCallResponse) {
      return ErrorType.api;
    }

    return ErrorType.unknown;
  }

  // Determine error severity
  ErrorSeverity _determineErrorSeverity(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('critical') ||
        errorString.contains('fatal') ||
        errorString.contains('crash')) {
      return ErrorSeverity.high;
    }

    if (errorString.contains('warning') || errorString.contains('validation')) {
      return ErrorSeverity.low;
    }

    return ErrorSeverity.medium;
  }

  // Refresh data - forces reload ignoring cache
  Future<void> refresh() async {
    _lastLoadTime = null;
    await loadData(() => initialize());
  }

  // Initialize service - must be implemented by subclasses
  Future<void> initialize();

  // Helper methods
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void _setError(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      notifyListeners();
    }
  }

  void _clearError() => _setError(null);

  // Safe data access with null handling
  T? safeGet<T>(dynamic data, String path, {T? defaultValue}) {
    try {
      return getJsonField(data, path) ?? defaultValue;
    } catch (e) {
      debugPrint('Error accessing $path: $e');
      return defaultValue;
    }
  }

  // Batch operations support
  Future<List<T>> batchLoad<T>(List<Future<T>> operations) async {
    try {
      _setLoading(true);
      _clearError();

      final results = await Future.wait(operations);
      _lastLoadTime = DateTime.now();

      return results;
    } catch (e) {
      _setError(e.toString());
      debugPrint('Batch operation error in ${runtimeType}: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  @override
  String get memoryKey => runtimeType.toString();

  @override
  void dispose() {
    disposeManagedResources();
    super.dispose();
  }
}
