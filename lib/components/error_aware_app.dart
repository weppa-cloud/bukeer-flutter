import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../legacy/flutter_flow/nav/nav.dart';
import '../services/app_services.dart';
import '../services/error_service.dart';
import '../services/error_analytics_service.dart';
import 'error_handler_widget.dart';
import 'error_feedback_system.dart';

/// Main app wrapper with comprehensive error handling
class ErrorAwareApp extends StatefulWidget {
  final Widget child;

  const ErrorAwareApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ErrorAwareApp> createState() => _ErrorAwareAppState();
}

class _ErrorAwareAppState extends State<ErrorAwareApp> {
  @override
  void initState() {
    super.initState();
    _setupErrorHandling();
  }

  void _setupErrorHandling() {
    final errorService = appServices.error;

    // Set up error service callbacks
    errorService.setLoginCallback(() {
      _handleLoginRequired();
    });

    errorService.setAdminContactCallback(() {
      _handleContactAdmin();
    });

    errorService.setErrorReportCallback((report) {
      _handleErrorReport(report);
    });

    // Set up global error handlers
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      errorService.handleError(
        details.exception,
        stackTrace: details.stack,
        context: 'Flutter Framework Error',
        type: ErrorType.unknown,
        severity: ErrorSeverity.high,
      );
    };
  }

  void _handleLoginRequired() {
    if (mounted) {
      // Clear all user data
      appServices.reset();

      // Navigate to login
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/authLogin',
        (route) => false,
      );

      // Show informative message
      ErrorFeedbackSystem.showErrorToast(
        context,
        'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.',
        severity: ErrorSeverity.medium,
      );
    }
  }

  void _handleContactAdmin() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.support_agent),
              SizedBox(width: 8),
              Text('Contactar Administrador'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Para obtener ayuda, puedes contactar al administrador a través de:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email'),
                subtitle: Text('admin@bukeer.com'),
                onTap: () {
                  // TODO: Open email client
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Teléfono'),
                subtitle: Text('+1 (555) 123-4567'),
                onTap: () {
                  // TODO: Open phone dialer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  void _handleErrorReport(Map<String, dynamic> report) {
    if (mounted) {
      // In a real app, this would send to an error reporting service
      // For now, we'll show a confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange),
              SizedBox(width: 8),
              Text('Reporte de Error'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('El error ha sido reportado automáticamente.'),
              SizedBox(height: 16),
              Text(
                'ID del reporte: ${report['error_id']}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ErrorService>.value(
          value: appServices.error,
        ),
        ChangeNotifierProvider<ErrorAnalyticsService>.value(
          value: appServices.errorAnalytics,
        ),
      ],
      child: ErrorBoundary(
        onError: (error) {
          // Log critical errors that break the UI
          appServices.error.handleError(
            error.originalError,
            stackTrace: error.stackTrace,
            context: 'UI Error Boundary',
            type: ErrorType.unknown,
            severity: ErrorSeverity.high,
          );
        },
        child: ErrorHandlerWidget(
          child: widget.child,
        ),
      ),
    );
  }
}

/// Error-aware button wrapper
class ErrorAwareButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? operationName;
  final ErrorSeverity errorSeverity;

  const ErrorAwareButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.operationName,
    this.errorSeverity = ErrorSeverity.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: onPressed != null ? () => _handlePress(context) : null,
          child: child,
        );
      },
    );
  }

  void _handlePress(BuildContext context) {
    try {
      // Set the action for retry purposes
      appServices.error.setLastAction(
        onPressed!,
        context: {'description': operationName ?? 'Button action'},
      );

      onPressed!();
    } catch (e) {
      appServices.error.handleError(
        e,
        context: operationName ?? 'Button press',
        severity: errorSeverity,
      );
    }
  }
}

/// Error-aware future builder
class ErrorAwareFutureBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      builder;
  final String? operationName;
  final Widget Function(BuildContext context, String error)? errorBuilder;

  const ErrorAwareFutureBuilder({
    Key? key,
    this.future,
    required this.builder,
    this.operationName,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Record the error
          appServices.error.handleError(
            snapshot.error!,
            context: operationName ?? 'Async operation',
            type: ErrorType.api,
            severity: ErrorSeverity.medium,
          );

          // Use custom error builder or default
          if (errorBuilder != null) {
            return errorBuilder!(context, snapshot.error.toString());
          }

          return ErrorFeedbackSystem.buildInlineError(
            'Error al cargar datos: ${snapshot.error}',
            onRetry: () {
              // Trigger rebuild
              (context as Element).markNeedsBuild();
            },
          );
        }

        return builder(context, snapshot);
      },
    );
  }
}

/// Error-aware stream builder
class ErrorAwareStreamBuilder<T> extends StatelessWidget {
  final Stream<T>? stream;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      builder;
  final String? operationName;

  const ErrorAwareStreamBuilder({
    Key? key,
    this.stream,
    required this.builder,
    this.operationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          appServices.error.handleError(
            snapshot.error!,
            context: operationName ?? 'Stream operation',
            type: ErrorType.api,
            severity: ErrorSeverity.medium,
          );

          return ErrorFeedbackSystem.buildInlineError(
            'Error en tiempo real: ${snapshot.error}',
            onRetry: () {
              (context as Element).markNeedsBuild();
            },
          );
        }

        return builder(context, snapshot);
      },
    );
  }
}

/// Extension for easy error handling in widgets
extension ErrorHandlingExtensions on BuildContext {
  /// Show error toast
  void showErrorToast(
    String message, {
    ErrorSeverity severity = ErrorSeverity.medium,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    ErrorFeedbackSystem.showErrorToast(
      this,
      message,
      severity: severity,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Handle async operation with error management
  Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? operationName,
    VoidCallback? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      appServices.error.setLastAction(
        () => handleAsync(operation, operationName: operationName),
        context: {'description': operationName ?? 'Async operation'},
      );

      final result = await operation();
      onSuccess?.call();
      return result;
    } catch (e) {
      final errorMessage = e.toString();
      onError?.call(errorMessage);

      appServices.error.handleError(
        e,
        context: operationName ?? 'Async operation',
        type: ErrorType.api,
        severity: ErrorSeverity.medium,
      );

      return null;
    }
  }
}
