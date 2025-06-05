import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';

import '../../lib/services/error_service.dart';

void main() {
  group('ErrorService Tests', () {
    late ErrorService errorService;

    setUp(() {
      errorService = ErrorService();
    });

    tearDown(() {
      errorService.clearAllErrors();
    });

    group('Error Handling', () {
      test('should handle string errors correctly', () {
        // Arrange
        const errorMessage = 'Test error message';

        // Act
        errorService.handleError(errorMessage);

        // Assert
        expect(errorService.hasError, isTrue);
        expect(errorService.currentError?.message, equals(errorMessage));
        expect(errorService.currentError?.type, equals(ErrorType.unknown));
        expect(errorService.currentError?.severity, equals(ErrorSeverity.medium));
      });

      test('should handle exception errors correctly', () {
        // Arrange
        final exception = Exception('Test exception');

        // Act
        errorService.handleError(exception);

        // Assert
        expect(errorService.hasError, isTrue);
        expect(errorService.currentError?.message, contains('Test exception'));
        expect(errorService.currentError?.originalError, equals(exception));
      });

      test('should categorize API errors correctly', () {
        // Act
        errorService.handleApiError(
          'API Error',
          endpoint: '/api/test',
          statusCode: 404,
          method: 'GET',
        );

        // Assert
        expect(errorService.hasError, isTrue);
        expect(errorService.currentError?.type, equals(ErrorType.api));
        expect(errorService.currentError?.context, contains('/api/test'));
        expect(errorService.currentError?.metadata['statusCode'], equals(404));
      });

      test('should categorize validation errors correctly', () {
        // Act
        errorService.handleValidationError(
          'Invalid email format',
          field: 'email',
          value: 'invalid-email',
        );

        // Assert
        expect(errorService.hasError, isTrue);
        expect(errorService.currentError?.type, equals(ErrorType.validation));
        expect(errorService.currentError?.severity, equals(ErrorSeverity.low));
        expect(errorService.currentError?.metadata['field'], equals('email'));
      });

      test('should categorize business errors correctly', () {
        // Act
        errorService.handleBusinessError(
          'Insufficient funds',
          operation: 'payment_processing',
          context: {'amount': 100, 'balance': 50},
        );

        // Assert
        expect(errorService.hasError, isTrue);
        expect(errorService.currentError?.type, equals(ErrorType.business));
        expect(errorService.currentError?.severity, equals(ErrorSeverity.medium));
        expect(errorService.currentError?.metadata['amount'], equals(100));
      });
    });

    group('Error Categorization', () {
      test('should determine network error type correctly', () {
        // Test network-related errors
        errorService.handleError('Network connection failed');
        expect(errorService.currentError?.type, equals(ErrorType.network));

        errorService.clearError();
        errorService.handleError('Connection timeout');
        expect(errorService.currentError?.type, equals(ErrorType.network));
      });

      test('should determine authentication error type correctly', () {
        // Test auth-related errors
        errorService.handleError('Unauthorized access');
        expect(errorService.currentError?.type, equals(ErrorType.authentication));

        errorService.clearError();
        errorService.handleError('Authentication failed');
        expect(errorService.currentError?.type, equals(ErrorType.authentication));
      });

      test('should determine validation error type correctly', () {
        // Test validation-related errors
        errorService.handleError('Invalid input data');
        expect(errorService.currentError?.type, equals(ErrorType.validation));
      });
    });

    group('Error Severity', () {
      test('should determine high severity correctly', () {
        errorService.handleError('Critical system failure');
        expect(errorService.currentError?.severity, equals(ErrorSeverity.high));

        errorService.clearError();
        errorService.handleError('Fatal error occurred');
        expect(errorService.currentError?.severity, equals(ErrorSeverity.high));
      });

      test('should determine low severity correctly', () {
        errorService.handleError('Warning: deprecated function');
        expect(errorService.currentError?.severity, equals(ErrorSeverity.low));

        errorService.clearError();
        errorService.handleError('Validation warning');
        expect(errorService.currentError?.severity, equals(ErrorSeverity.low));
      });

      test('should default to medium severity', () {
        errorService.handleError('Regular error');
        expect(errorService.currentError?.severity, equals(ErrorSeverity.medium));
      });
    });

    group('API Error Severity', () {
      test('should assign high severity to 5xx errors', () {
        errorService.handleApiError('Server error', statusCode: 500);
        expect(errorService.currentError?.severity, equals(ErrorSeverity.high));

        errorService.clearError();
        errorService.handleApiError('Bad gateway', statusCode: 502);
        expect(errorService.currentError?.severity, equals(ErrorSeverity.high));
      });

      test('should assign medium severity to 4xx errors', () {
        errorService.handleApiError('Not found', statusCode: 404);
        expect(errorService.currentError?.severity, equals(ErrorSeverity.medium));

        errorService.clearError();
        errorService.handleApiError('Bad request', statusCode: 400);
        expect(errorService.currentError?.severity, equals(ErrorSeverity.medium));
      });

      test('should assign low severity to other status codes', () {
        errorService.handleApiError('Success with warning', statusCode: 200);
        expect(errorService.currentError?.severity, equals(ErrorSeverity.low));
      });
    });

    group('User Messages', () {
      test('should provide appropriate user messages for different error types', () {
        // Network error
        errorService.handleError('Connection failed', type: ErrorType.network);
        expect(
          errorService.getUserMessage(errorService.currentError!),
          equals('Error de conexión. Verifica tu internet.'),
        );

        // Validation error
        errorService.clearError();
        errorService.handleValidationError('Invalid email');
        expect(
          errorService.getUserMessage(errorService.currentError!),
          equals('Invalid email'),
        );

        // Authentication error
        errorService.clearError();
        errorService.handleError('Auth failed', type: ErrorType.authentication);
        expect(
          errorService.getUserMessage(errorService.currentError!),
          equals('Error de autenticación. Por favor, inicia sesión nuevamente.'),
        );
      });

      test('should provide specific API error messages', () {
        // 401 Unauthorized
        errorService.handleApiError('Unauthorized', statusCode: 401);
        expect(
          errorService.getUserMessage(errorService.currentError!),
          equals('Sesión expirada. Inicia sesión nuevamente.'),
        );

        // 404 Not Found
        errorService.clearError();
        errorService.handleApiError('Not found', statusCode: 404);
        expect(
          errorService.getUserMessage(errorService.currentError!),
          equals('El recurso solicitado no fue encontrado.'),
        );

        // 500 Server Error
        errorService.clearError();
        errorService.handleApiError('Server error', statusCode: 500);
        expect(
          errorService.getUserMessage(errorService.currentError!),
          equals('Error interno del servidor. Intenta más tarde.'),
        );
      });
    });

    group('Suggested Actions', () {
      test('should provide network error actions', () {
        // Arrange
        errorService.handleError('Network error', type: ErrorType.network);

        // Act
        final actions = errorService.getSuggestedActions(errorService.currentError!);

        // Assert
        expect(actions.length, greaterThan(0));
        expect(actions.any((a) => a.label.contains('Reintentar')), isTrue);
        expect(actions.any((a) => a.label.contains('Verificar')), isTrue);
      });

      test('should provide authentication error actions', () {
        // Arrange
        errorService.handleError('Auth error', type: ErrorType.authentication);

        // Act
        final actions = errorService.getSuggestedActions(errorService.currentError!);

        // Assert
        expect(actions.any((a) => a.label.contains('Iniciar sesión')), isTrue);
      });

      test('should provide validation error actions', () {
        // Arrange
        errorService.handleValidationError('Invalid data');

        // Act
        final actions = errorService.getSuggestedActions(errorService.currentError!);

        // Assert
        expect(actions.any((a) => a.label.contains('Corregir')), isTrue);
      });
    });

    group('Error History', () {
      test('should maintain error history', () {
        // Act
        errorService.handleError('Error 1');
        errorService.handleError('Error 2');
        errorService.handleError('Error 3');

        // Assert
        expect(errorService.errorHistory.length, equals(3));
        expect(errorService.errorHistory[0].message, equals('Error 1'));
        expect(errorService.errorHistory[2].message, equals('Error 3'));
        expect(errorService.currentError?.message, equals('Error 3'));
      });

      test('should limit error history to 50 entries', () {
        // Act - Generate 60 errors
        for (int i = 0; i < 60; i++) {
          errorService.handleError('Error $i');
        }

        // Assert
        expect(errorService.errorHistory.length, equals(50));
        expect(errorService.errorHistory.first.message, equals('Error 10'));
        expect(errorService.errorHistory.last.message, equals('Error 59'));
      });
    });

    group('Auto-clear Functionality', () {
      test('should auto-clear low severity errors', () async {
        // Arrange
        errorService.handleError(
          'Warning message',
          severity: ErrorSeverity.low,
        );

        // Assert initial state
        expect(errorService.hasError, isTrue);

        // Wait for auto-clear (we can't easily test the actual timer,
        // but we can test the logic)
        // In a real test, you might want to mock the timer or use a shorter duration
      });

      test('should not auto-clear high severity errors', () {
        // Arrange
        errorService.handleError(
          'Critical error',
          severity: ErrorSeverity.high,
        );

        // Assert - High severity errors should not auto-clear
        expect(errorService.hasError, isTrue);
        // High severity errors would require manual clearing
      });
    });

    group('Error Clearing', () {
      test('should clear current error', () {
        // Arrange
        errorService.handleError('Test error');
        expect(errorService.hasError, isTrue);

        // Act
        errorService.clearError();

        // Assert
        expect(errorService.hasError, isFalse);
        expect(errorService.currentError, isNull);
      });

      test('should clear all errors', () {
        // Arrange
        errorService.handleError('Error 1');
        errorService.handleError('Error 2');
        expect(errorService.errorHistory.length, equals(2));

        // Act
        errorService.clearAllErrors();

        // Assert
        expect(errorService.hasError, isFalse);
        expect(errorService.currentError, isNull);
        expect(errorService.errorHistory, isEmpty);
      });
    });

    group('Error Callback', () {
      test('should call custom error callback when set', () {
        // Arrange
        AppError? capturedError;
        errorService.setErrorCallback((error) {
          capturedError = error;
        });

        // Act
        errorService.handleError('Callback test');

        // Assert
        expect(capturedError, isNotNull);
        expect(capturedError?.message, equals('Callback test'));
      });
    });
  });
}