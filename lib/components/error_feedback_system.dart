import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../legacy/flutter_flow/flutter_flow_theme.dart';
import '../legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import '../services/error_service.dart';
import '../services/app_services.dart';

/// Comprehensive error feedback system with multiple UI components
class ErrorFeedbackSystem {
  static final ErrorFeedbackSystem _instance = ErrorFeedbackSystem._internal();
  factory ErrorFeedbackSystem() => _instance;
  ErrorFeedbackSystem._internal();

  /// Show inline error message for forms and specific contexts
  static Widget buildInlineError(
    String? errorMessage, {
    IconData? icon,
    Color? color,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    if (errorMessage == null || errorMessage.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: BukeerSpacing.xs),
      padding: EdgeInsets.all(BukeerSpacing.s),
      decoration: BoxDecoration(
        color: (color ?? BukeerColors.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(BukeerSpacing.xs),
        border: Border.all(
          color: (color ?? BukeerColors.error).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            color: color ?? BukeerColors.error,
            size: 20,
          ),
          SizedBox(width: BukeerSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: color ?? BukeerColors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (onRetry != null || onDismiss != null) ...[
                  SizedBox(height: BukeerSpacing.xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onRetry != null)
                        TextButton(
                          onPressed: onRetry,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: BukeerSpacing.xs,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'Reintentar',
                            style: TextStyle(
                              color: color ?? BukeerColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (onDismiss != null)
                        TextButton(
                          onPressed: onDismiss,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: BukeerSpacing.xs,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'Cerrar',
                            style: TextStyle(
                              color: (color ?? BukeerColors.error)
                                  .withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show banner error for page-level errors
  static Widget buildErrorBanner(
    BuildContext context,
    AppError error, {
    bool showDetails = false,
    VoidCallback? onDismiss,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(BukeerSpacing.s),
      decoration: BoxDecoration(
        color: _getErrorColor(error.severity),
        borderRadius: BorderRadius.circular(BukeerSpacing.xs),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(BukeerSpacing.xs),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: BukeerSpacing.s,
            vertical: BukeerSpacing.xs,
          ),
          leading: Icon(
            _getErrorIcon(error.type),
            color: Colors.white,
            size: 24,
          ),
          title: Text(
            ErrorService().getUserMessage(error),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            _getErrorSubtitle(error),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDetails)
                Icon(
                  Icons.expand_more,
                  color: Colors.white.withOpacity(0.8),
                ),
              if (onDismiss != null)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: onDismiss,
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
            ],
          ),
          children: showDetails
              ? [
                  Container(
                    padding: EdgeInsets.all(BukeerSpacing.s),
                    color: Colors.black.withOpacity(0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildErrorDetails(error),
                        SizedBox(height: BukeerSpacing.s),
                        _buildErrorActions(context, error),
                      ],
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  /// Show toast-style error notification
  static void showErrorToast(
    BuildContext context,
    String message, {
    ErrorSeverity severity = ErrorSeverity.medium,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getSeverityIcon(severity),
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: BukeerSpacing.xs),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getErrorColor(severity),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BukeerSpacing.xs),
        ),
        action: onAction != null
            ? SnackBarAction(
                label: actionLabel ?? 'Acción',
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// Show fullscreen error page
  static Widget buildErrorPage(
    AppError error, {
    VoidCallback? onRetry,
    VoidCallback? onGoHome,
    bool showDetails = false,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
        backgroundColor: _getErrorColor(error.severity),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(BukeerSpacing.m),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _getErrorColor(error.severity).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getErrorIcon(error.type),
                  size: 60,
                  color: _getErrorColor(error.severity),
                ),
              ),

              SizedBox(height: BukeerSpacing.m),

              // Error title
              Text(
                _getErrorTitle(error.type),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getErrorColor(error.severity),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: BukeerSpacing.s),

              // Error message
              Text(
                ErrorService().getUserMessage(error),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: BukeerSpacing.m),

              // Actions
              Wrap(
                spacing: BukeerSpacing.s,
                runSpacing: BukeerSpacing.s,
                alignment: WrapAlignment.center,
                children: [
                  if (onRetry != null)
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: Icon(Icons.refresh),
                      label: Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getErrorColor(error.severity),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: BukeerSpacing.m,
                          vertical: BukeerSpacing.s,
                        ),
                      ),
                    ),
                  if (onGoHome != null)
                    OutlinedButton.icon(
                      onPressed: onGoHome,
                      icon: Icon(Icons.home),
                      label: Text('Ir al inicio'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _getErrorColor(error.severity),
                        side: BorderSide(color: _getErrorColor(error.severity)),
                        padding: EdgeInsets.symmetric(
                          horizontal: BukeerSpacing.m,
                          vertical: BukeerSpacing.s,
                        ),
                      ),
                    ),
                ],
              ),

              // Error details (expandable)
              if (showDetails) ...[
                SizedBox(height: BukeerSpacing.l),
                ExpansionTile(
                  title: Text('Detalles técnicos'),
                  children: [
                    Container(
                      padding: EdgeInsets.all(BukeerSpacing.s),
                      child: _buildErrorDetails(error),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  static Widget _buildErrorDetails(AppError error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Tipo', error.type.name),
        _buildDetailRow('Severidad', error.severity.name),
        _buildDetailRow('Tiempo', _formatTimestamp(error.timestamp)),
        if (error.context != null) _buildDetailRow('Contexto', error.context!),
        if (error.metadata.isNotEmpty) ...[
          SizedBox(height: BukeerSpacing.xs),
          Text(
            'Información adicional:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: BukeerSpacing.xs),
          ...error.metadata.entries
              .map((entry) =>
                  _buildDetailRow(entry.key, entry.value?.toString() ?? 'null'))
              .toList(),
        ],
      ],
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildErrorActions(BuildContext context, AppError error) {
    final actions = ErrorService().getSuggestedActions(error);

    if (actions.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: BukeerSpacing.xs,
      children: actions
          .map(
            (action) => ElevatedButton(
              onPressed: action.action,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: BukeerSpacing.s,
                  vertical: BukeerSpacing.xs,
                ),
              ),
              child: Text(
                action.label,
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
          .toList(),
    );
  }

  static Color _getErrorColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return BukeerColors.info;
      case ErrorSeverity.medium:
        return BukeerColors.warning;
      case ErrorSeverity.high:
        return BukeerColors.error;
    }
  }

  static IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.api:
        return Icons.cloud_off;
      case ErrorType.validation:
        return Icons.warning_amber;
      case ErrorType.authentication:
        return Icons.lock_outline;
      case ErrorType.authorization:
        return Icons.no_accounts;
      case ErrorType.business:
        return Icons.business_center;
      case ErrorType.storage:
        return Icons.storage;
      case ErrorType.navigation:
        return Icons.navigation;
      default:
        return Icons.error_outline;
    }
  }

  static IconData _getSeverityIcon(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Icons.info_outline;
      case ErrorSeverity.medium:
        return Icons.warning_amber;
      case ErrorSeverity.high:
        return Icons.error_outline;
    }
  }

  static String _getErrorTitle(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'Sin conexión a internet';
      case ErrorType.api:
        return 'Error del servidor';
      case ErrorType.validation:
        return 'Datos inválidos';
      case ErrorType.authentication:
        return 'Error de autenticación';
      case ErrorType.authorization:
        return 'Sin permisos';
      case ErrorType.business:
        return 'Error de proceso';
      case ErrorType.storage:
        return 'Error de almacenamiento';
      case ErrorType.navigation:
        return 'Error de navegación';
      default:
        return 'Error inesperado';
    }
  }

  static String _getErrorSubtitle(AppError error) {
    final time = _formatTimestamp(error.timestamp);
    return 'Ocurrió el $time • ${error.severity.name}';
  }

  static String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'hace un momento';
    } else if (difference.inHours < 1) {
      return 'hace ${difference.inMinutes} min';
    } else if (difference.inDays < 1) {
      return 'hace ${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

/// Enhanced error boundary widget
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(AppError error)? errorBuilder;
  final void Function(AppError error)? onError;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.errorBuilder,
    this.onError,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  AppError? _caughtError;

  @override
  Widget build(BuildContext context) {
    if (_caughtError != null) {
      return widget.errorBuilder?.call(_caughtError!) ??
          ErrorFeedbackSystem.buildErrorPage(
            _caughtError!,
            onRetry: () => setState(() => _caughtError = null),
            onGoHome: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/mainHome',
              (route) => false,
            ),
            showDetails: true,
          );
    }

    return widget.child;
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    final appError = AppError(
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
      context: 'ErrorBoundary',
      severity: ErrorSeverity.high,
      type: ErrorType.unknown,
      timestamp: DateTime.now(),
      metadata: {},
    );

    setState(() => _caughtError = appError);
    widget.onError?.call(appError);
    ErrorService().handleError(error, stackTrace: stackTrace);
  }
}

/// Loading state with error handling
class LoadingWithError extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final Widget child;
  final VoidCallback? onRetry;
  final String? loadingText;

  const LoadingWithError({
    Key? key,
    required this.isLoading,
    this.error,
    required this.child,
    this.onRetry,
    this.loadingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            if (loadingText != null) ...[
              SizedBox(height: BukeerSpacing.s),
              Text(
                loadingText!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: BukeerColors.error,
            ),
            SizedBox(height: BukeerSpacing.s),
            Text(
              error!,
              style: TextStyle(
                color: BukeerColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: BukeerSpacing.m),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh),
                label: Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BukeerColors.error,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return child;
  }
}
