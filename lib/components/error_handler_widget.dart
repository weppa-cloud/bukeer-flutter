import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';

import '../flutter_flow/flutter_flow_widgets.dart';
import '../services/error_service.dart';

/// Global error display widget
/// Shows user-friendly error messages with suggested actions
class ErrorHandlerWidget extends StatelessWidget {
  final Widget child;

  const ErrorHandlerWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        // Error overlay
        AnimatedBuilder(
          animation: ErrorService(),
          builder: (context, _) {
            final errorService = ErrorService();

            if (!errorService.hasError) {
              return SizedBox.shrink();
            }

            return _buildErrorOverlay(context, errorService.currentError!);
          },
        ),
      ],
    );
  }

  Widget _buildErrorOverlay(BuildContext context, AppError error) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getErrorColor(error.severity).withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showErrorDetails(context, error),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          _getErrorIcon(error.type),
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getErrorTitle(error.type),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () => ErrorService().clearError(),
                          padding: EdgeInsets.all(4),
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Message
                    Text(
                      ErrorService().getUserMessage(error),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),

                    // Actions
                    SizedBox(height: 12),
                    _buildErrorActions(context, error),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorActions(BuildContext context, AppError error) {
    final actions = ErrorService().getSuggestedActions(error);

    if (actions.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 8,
      children: actions
          .take(2)
          .map(
            (action) => // Show max 2 actions
                FFButtonWidget(
              onPressed: action.action,
              text: action.label,
              options: FFButtonOptions(
                height: 32,
                padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                color: Colors.white.withOpacity(0.2),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          )
          .toList(),
    );
  }

  void _showErrorDetails(BuildContext context, AppError error) {
    showDialog(
      context: context,
      builder: (context) => ErrorDetailsDialog(error: error),
    );
  }

  Color _getErrorColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Colors.blue.shade600;
      case ErrorSeverity.medium:
        return Colors.orange.shade600;
      case ErrorSeverity.high:
        return Colors.red.shade600;
    }
  }

  IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.api:
        return Icons.cloud_off;
      case ErrorType.validation:
        return Icons.warning;
      case ErrorType.authentication:
        return Icons.lock;
      case ErrorType.authorization:
        return Icons.no_accounts;
      case ErrorType.business:
        return Icons.business;
      case ErrorType.storage:
        return Icons.storage;
      case ErrorType.navigation:
        return Icons.navigation;
      default:
        return Icons.error;
    }
  }

  String _getErrorTitle(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'Sin conexión';
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
        return 'Error';
    }
  }
}

/// Detailed error dialog
class ErrorDetailsDialog extends StatelessWidget {
  final AppError error;

  const ErrorDetailsDialog({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.bug_report,
            color: FlutterFlowTheme.of(context).error,
          ),
          SizedBox(width: 12),
          Text('Detalles del Error'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Tipo', error.type.name),
            _buildDetailRow('Severidad', error.severity.name),
            _buildDetailRow('Hora', _formatTime(error.timestamp)),
            if (error.context != null)
              _buildDetailRow('Contexto', error.context!),
            _buildDetailRow('Mensaje', error.message),
            if (error.metadata.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Información adicional:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              ...error.metadata.entries
                  .map((entry) => _buildDetailRow(
                      entry.key, entry.value?.toString() ?? 'null'))
                  .toList(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cerrar'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Copy error details to clipboard
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Detalles copiados al portapapeles')),
            );
          },
          child: Text('Copiar'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}
