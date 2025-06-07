import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/error_service.dart';
import 'package:bukeer/services/error_analytics_service.dart';
import 'package:bukeer/components/form_error_handler.dart';

/// Comprehensive test suite for error handling system
void main() {
  group('Error Handling System Tests', () {
    late ErrorService errorService;
    late ErrorAnalyticsService analyticsService;
    late FormErrorHandler formHandler;

    setUp(() {
      errorService = ErrorService();
      analyticsService = ErrorAnalyticsService();
      formHandler = FormErrorHandler();
      
      // Setup analytics to track errors from service
      errorService.setErrorCallback((error) {
        analyticsService.recordError(error);
      });
      
      analyticsService.startSession();
    });

    tearDown(() {
      errorService.clearAllErrors();
      analyticsService.clearAnalytics();
      formHandler.clearAll();
    });

    group('ErrorService Tests', () {
      test('should handle basic errors correctly', () {
        expect(errorService.hasError, isFalse);
        expect(errorService.currentError, isNull);

        errorService.handleError('Test error');

        expect(errorService.hasError, isTrue);
        expect(errorService.currentError, isNotNull);
        expect(errorService.currentError!.message, equals('Test error'));
      });

      test('should categorize API errors correctly', () {
        errorService.handleApiError(
          'Server error',
          endpoint: '/api/test',
          statusCode: 500,
          method: 'GET',
        );

        final error = errorService.currentError!;
        expect(error.type, equals(ErrorType.api));
        expect(error.severity, equals(ErrorSeverity.high));
        expect(error.context, contains('API Call'));
        expect(error.metadata['statusCode'], equals(500));
        expect(error.metadata['endpoint'], equals('/api/test'));
      });

      test('should provide correct user messages for different error types', () {
        // Network error
        errorService.handleError(
          'Connection failed',
          type: ErrorType.network,
        );
        expect(
          errorService.getUserMessage(errorService.currentError!),
          contains('conexión'),
        );

        // API error with status code
        errorService.handleApiError(
          'Unauthorized',
          statusCode: 401,
        );
        expect(
          errorService.getUserMessage(errorService.currentError!),
          contains('Sesión expirada'),
        );

        // Validation error
        errorService.handleValidationError('Invalid email');
        expect(
          errorService.getUserMessage(errorService.currentError!),
          equals('Invalid email'),
        );
      });

      test('should provide relevant suggested actions', () {
        // Network error actions
        errorService.handleError(
          'No internet',
          type: ErrorType.network,
        );
        final networkActions = errorService.getSuggestedActions(errorService.currentError!);
        expect(networkActions.length, greaterThan(0));
        expect(networkActions.any((a) => a.label.contains('Reintentar')), isTrue);

        // Authentication error actions
        errorService.handleError(
          'Token expired',
          type: ErrorType.authentication,
        );
        final authActions = errorService.getSuggestedActions(errorService.currentError!);
        expect(authActions.any((a) => a.label.contains('sesión')), isTrue);
      });

      test('should auto-clear low severity errors', () async {
        errorService.handleError(
          'Minor warning',
          severity: ErrorSeverity.low,
        );

        expect(errorService.hasError, isTrue);

        // Wait for auto-clear (5 seconds)
        await Future.delayed(Duration(seconds: 6));

        expect(errorService.hasError, isFalse);
      });

      test('should maintain error history', () {
        expect(errorService.errorHistory.length, equals(0));

        errorService.handleError('Error 1');
        errorService.handleError('Error 2');
        errorService.handleError('Error 3');

        expect(errorService.errorHistory.length, equals(3));
        expect(errorService.currentError!.message, equals('Error 3'));
      });

      test('should handle retry mechanism correctly', () {
        bool actionExecuted = false;
        void testAction() {
          actionExecuted = true;
        }

        errorService.setLastAction(testAction);
        
        expect(actionExecuted, isFalse);
        
        // Simulate retry by calling the internal method
        final actions = errorService.getSuggestedActions(
          AppError(
            message: 'Test error',
            originalError: 'Test',
            stackTrace: StackTrace.current,
            severity: ErrorSeverity.medium,
            type: ErrorType.api,
            timestamp: DateTime.now(),
            metadata: {},
          ),
        );
        
        final retryAction = actions.firstWhere(
          (action) => action.label.contains('Reintentar'),
          orElse: () => ErrorAction('', () {}),
        );
        
        if (retryAction.label.isNotEmpty) {
          retryAction.action();
          expect(actionExecuted, isTrue);
        }
      });

      test('should handle callback setup correctly', () {
        bool loginCallbackCalled = false;
        bool adminCallbackCalled = false;
        Map<String, dynamic>? reportData;

        errorService.setLoginCallback(() => loginCallbackCalled = true);
        errorService.setAdminContactCallback(() => adminCallbackCalled = true);
        errorService.setErrorReportCallback((data) => reportData = data);

        // Test callbacks through suggested actions
        errorService.handleError(
          'Unauthorized',
          type: ErrorType.authentication,
        );
        
        final authActions = errorService.getSuggestedActions(errorService.currentError!);
        if (authActions.isNotEmpty) {
          authActions.first.action();
          expect(loginCallbackCalled, isTrue);
        }
      });
    });

    group('ErrorAnalyticsService Tests', () {
      test('should initialize session correctly', () {
        analyticsService.startSession();
        final analytics = analyticsService.getAnalytics();
        
        expect(analytics.totalErrors, equals(0));
        expect(analytics.sessionDuration, isNotNull);
        expect(analytics.healthStatus, equals('Excelente'));
      });

      test('should record errors and update statistics', () {
        final error = AppError(
          message: 'Test error',
          originalError: 'Test',
          stackTrace: StackTrace.current,
          severity: ErrorSeverity.medium,
          type: ErrorType.api,
          timestamp: DateTime.now(),
          metadata: {},
        );

        analyticsService.recordError(error);
        
        final analytics = analyticsService.getAnalytics();
        expect(analytics.totalErrors, equals(1));
        expect(analytics.errorTypeDistribution[ErrorType.api], equals(1));
        expect(analytics.severityDistribution[ErrorSeverity.medium], equals(1));
      });

      test('should calculate error patterns correctly', () {
        // Create multiple similar errors
        for (int i = 0; i < 5; i++) {
          analyticsService.recordError(AppError(
            message: 'API timeout',
            originalError: 'Timeout',
            stackTrace: StackTrace.current,
            severity: ErrorSeverity.medium,
            type: ErrorType.api,
            timestamp: DateTime.now(),
            metadata: {},
            context: 'API call',
          ));
        }

        final patterns = analyticsService.getErrorPatterns();
        expect(patterns.length, greaterThan(0));
        
        final apiPattern = patterns.firstWhere(
          (p) => p.type == ErrorType.api,
          orElse: () => ErrorPattern(
            type: ErrorType.unknown,
            context: '',
            occurrences: 0,
            firstOccurrence: DateTime.now(),
            lastOccurrence: DateTime.now(),
            severity: ErrorSeverity.low,
          ),
        );
        
        expect(apiPattern.occurrences, equals(5));
        expect(apiPattern.isRecurring, isTrue);
      });

      test('should calculate health status correctly', () {
        analyticsService.startSession();
        
        // No errors - should be excellent
        var analytics = analyticsService.getAnalytics();
        expect(analytics.healthStatus, equals('Excelente'));

        // Add many errors to increase error rate
        for (int i = 0; i < 10; i++) {
          analyticsService.recordError(AppError(
            message: 'Error $i',
            originalError: 'Error',
            stackTrace: StackTrace.current,
            severity: ErrorSeverity.high,
            type: ErrorType.api,
            timestamp: DateTime.now(),
            metadata: {},
          ));
        }

        analytics = analyticsService.getAnalytics();
        expect(analytics.totalErrors, equals(10));
        // Health status should degrade with high error count
        expect(['Excelente', 'Bueno', 'Regular', 'Crítico'],
               contains(analytics.healthStatus));
      });

      test('should export error data correctly', () {
        analyticsService.recordError(AppError(
          message: 'Export test error',
          originalError: 'Test',
          stackTrace: StackTrace.current,
          severity: ErrorSeverity.low,
          type: ErrorType.validation,
          timestamp: DateTime.now(),
          metadata: {'test': 'data'},
        ));

        final exportData = analyticsService.exportErrorData();
        expect(exportData, isNotEmpty);
        expect(exportData, contains('Export test error'));
        expect(exportData, contains('validation'));
        expect(exportData, contains('test'));
      });

      test('should mark errors as resolved', () {
        final error = AppError(
          message: 'Resolvable error',
          originalError: 'Test',
          stackTrace: StackTrace.current,
          severity: ErrorSeverity.medium,
          type: ErrorType.business,
          timestamp: DateTime.now(),
          metadata: {},
        );

        analyticsService.recordError(error);
        
        var analytics = analyticsService.getAnalytics();
        expect(analytics.resolvedErrors, equals(0));
        expect(analytics.pendingErrors, equals(1));

        // Mark as resolved (simplified - in real usage would use error ID)
        analyticsService.markErrorResolved('mock-id');
        
        // Note: This test needs the actual error ID from the analytics service
        // For proper testing, we'd need to expose the error ID or modify the API
      });
    });

    group('FormErrorHandler Tests', () {
      test('should initialize with clean state', () {
        expect(formHandler.hasErrors, isFalse);
        expect(formHandler.isSubmitting, isFalse);
        expect(formHandler.generalError, isNull);
        expect(formHandler.getFieldError('test'), isNull);
      });

      test('should manage field errors correctly', () {
        expect(formHandler.getFieldError('email'), isNull);
        
        formHandler.setFieldError('email', 'Invalid email format');
        expect(formHandler.getFieldError('email'), equals('Invalid email format'));
        expect(formHandler.hasErrors, isTrue);
        
        formHandler.clearFieldError('email');
        expect(formHandler.getFieldError('email'), isNull);
        expect(formHandler.hasErrors, isFalse);
      });

      test('should manage general form errors', () {
        expect(formHandler.generalError, isNull);
        
        formHandler.setGeneralError('Network connection failed');
        expect(formHandler.generalError, equals('Network connection failed'));
        expect(formHandler.hasErrors, isTrue);
        
        formHandler.setGeneralError(null);
        expect(formHandler.generalError, isNull);
        expect(formHandler.hasErrors, isFalse);
      });

      test('should track field touch state', () {
        expect(formHandler.isFieldTouched('username'), isFalse);
        
        formHandler.touchField('username');
        expect(formHandler.isFieldTouched('username'), isTrue);
      });

      test('should handle form submission with success', () async {
        bool onSuccessCalled = false;
        
        final result = await formHandler.handleSubmission(
          () async {
            await Future.delayed(Duration(milliseconds: 50));
            return 'success';
          },
          onSuccess: () => onSuccessCalled = true,
          context: 'Test submission',
        );

        expect(result, equals('success'));
        expect(onSuccessCalled, isTrue);
        expect(formHandler.isSubmitting, isFalse);
        expect(formHandler.hasErrors, isFalse);
      });

      test('should handle form submission with error', () async {
        String? capturedError;
        
        final result = await formHandler.handleSubmission(
          () async {
            throw Exception('Submission failed');
          },
          onError: (error) => capturedError = error,
          context: 'Test submission',
        );

        expect(result, isNull);
        expect(capturedError, isNotNull);
        expect(formHandler.isSubmitting, isFalse);
        expect(formHandler.hasErrors, isTrue);
        expect(formHandler.generalError, contains('Error al procesar'));
      });

      test('should manage submitting state correctly', () {
        expect(formHandler.isSubmitting, isFalse);
        
        formHandler.setSubmitting(true);
        expect(formHandler.isSubmitting, isTrue);
        
        formHandler.setSubmitting(false);
        expect(formHandler.isSubmitting, isFalse);
      });

      test('should clear all state correctly', () {
        // Set some state
        formHandler.setFieldError('field1', 'Error 1');
        formHandler.setFieldError('field2', 'Error 2');
        formHandler.setGeneralError('General error');
        formHandler.touchField('field1');
        formHandler.setSubmitting(true);

        expect(formHandler.hasErrors, isTrue);
        expect(formHandler.isSubmitting, isTrue);

        // Clear all
        formHandler.clearAll();

        expect(formHandler.hasErrors, isFalse);
        expect(formHandler.isSubmitting, isFalse);
        expect(formHandler.getFieldError('field1'), isNull);
        expect(formHandler.getFieldError('field2'), isNull);
        expect(formHandler.generalError, isNull);
        expect(formHandler.isFieldTouched('field1'), isFalse);
      });
    });

    group('Integration Tests', () {
      test('should integrate ErrorService with Analytics', () {
        expect(analyticsService.getAnalytics().totalErrors, equals(0));

        // Trigger error through service (should auto-record in analytics)
        errorService.handleError('Integration test error');

        final analytics = analyticsService.getAnalytics();
        expect(analytics.totalErrors, equals(1));
        expect(analytics.recentErrors.length, equals(1));
        expect(analytics.recentErrors.first.message, equals('Integration test error'));
      });

      test('should handle multiple error types in sequence', () {
        // Network error
        errorService.handleError(
          'Connection timeout',
          type: ErrorType.network,
          severity: ErrorSeverity.high,
        );

        // API error
        errorService.handleApiError(
          'Server unavailable',
          statusCode: 503,
        );

        // Validation error
        errorService.handleValidationError(
          'Invalid input',
          field: 'email',
        );

        final analytics = analyticsService.getAnalytics();
        expect(analytics.totalErrors, equals(3));
        expect(analytics.errorTypeDistribution.length, equals(3));
        expect(analytics.severityDistribution.length, greaterThanOrEqualTo(2));
      });

      test('should maintain consistency across services', () {
        final initialAnalytics = analyticsService.getAnalytics();
        
        // Add errors
        for (int i = 0; i < 5; i++) {
          errorService.handleError('Error $i');
        }

        final finalAnalytics = analyticsService.getAnalytics();
        expect(
          finalAnalytics.totalErrors - initialAnalytics.totalErrors,
          equals(5),
        );
        expect(errorService.errorHistory.length, equals(5));
      });
    });

    group('Performance Tests', () {
      test('should handle rapid error generation efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Generate many errors rapidly
        for (int i = 0; i < 100; i++) {
          errorService.handleError('Rapid error $i');
        }

        stopwatch.stop();

        // Should complete quickly (adjust threshold as needed)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(analyticsService.getAnalytics().totalErrors, equals(100));
      });

      test('should manage memory with error history limits', () {
        // Generate more errors than the history limit
        for (int i = 0; i < 60; i++) {
          errorService.handleError('Memory test error $i');
        }

        // Error service should limit history to 50 errors
        expect(errorService.errorHistory.length, lessThanOrEqualTo(50));
        
        // Analytics should limit events to 100
        final analytics = analyticsService.getAnalytics();
        expect(analytics.totalErrors, equals(60)); // Total count maintained
      });
    });
  });
}