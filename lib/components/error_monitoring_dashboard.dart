import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import '../services/error_service.dart';
import '../services/error_analytics_service.dart';
import '../legacy/flutter_flow/flutter_flow_theme.dart';

/// Error monitoring dashboard for debugging and analytics
class ErrorMonitoringDashboard extends StatelessWidget {
  const ErrorMonitoringDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoreo de Errores'),
        backgroundColor: BukeerColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh data
              (context as Element).markNeedsBuild();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Exportar datos'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Limpiar datos'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ErrorAnalyticsService>(
        builder: (context, analytics, child) {
          final data = analytics.getAnalytics();

          return SingleChildScrollView(
            padding: EdgeInsets.all(BukeerSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Health Overview
                _buildHealthOverview(data),

                SizedBox(height: BukeerSpacing.m),

                // Error Statistics
                _buildErrorStatistics(data),

                SizedBox(height: BukeerSpacing.m),

                // Error Type Distribution
                _buildErrorTypeDistribution(data),

                SizedBox(height: BukeerSpacing.m),

                // Recent Errors
                _buildRecentErrors(data),

                SizedBox(height: BukeerSpacing.m),

                // Error Patterns
                _buildErrorPatterns(analytics),

                SizedBox(height: BukeerSpacing.m),

                // Error Trends
                _buildErrorTrends(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthOverview(ErrorAnalytics data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  color: _getHealthColor(data.healthStatus),
                ),
                SizedBox(width: BukeerSpacing.s),
                Text(
                  'Estado de Salud: ${data.healthStatus}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getHealthColor(data.healthStatus),
                  ),
                ),
              ],
            ),
            SizedBox(height: BukeerSpacing.m),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Errores Totales',
                    data.totalErrors.toString(),
                    Icons.error_outline,
                    BukeerColors.error,
                  ),
                ),
                SizedBox(width: BukeerSpacing.s),
                Expanded(
                  child: _buildStatCard(
                    'Resueltos',
                    data.resolvedErrors.toString(),
                    Icons.check_circle,
                    BukeerColors.success,
                  ),
                ),
                SizedBox(width: BukeerSpacing.s),
                Expanded(
                  child: _buildStatCard(
                    'Pendientes',
                    data.pendingErrors.toString(),
                    Icons.pending,
                    BukeerColors.warning,
                  ),
                ),
              ],
            ),
            SizedBox(height: BukeerSpacing.s),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tasa de Resolución',
                    '${(data.resolutionRate * 100).toStringAsFixed(1)}%',
                    Icons.trending_up,
                    BukeerColors.info,
                  ),
                ),
                SizedBox(width: BukeerSpacing.s),
                Expanded(
                  child: _buildStatCard(
                    'Errores/Hora',
                    data.errorRate.toStringAsFixed(1),
                    Icons.speed,
                    _getErrorRateColor(data.errorRate),
                  ),
                ),
                SizedBox(width: BukeerSpacing.s),
                Expanded(
                  child: _buildStatCard(
                    'Sesión',
                    _formatDuration(data.sessionDuration),
                    Icons.timer,
                    Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(BukeerSpacing.s),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(BukeerSpacing.xs),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: BukeerSpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorStatistics(ErrorAnalytics data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Errores Más Comunes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            if (data.mostCommonErrors.isEmpty)
              Text(
                'No hay errores registrados',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              ...data.mostCommonErrors
                  .map(
                    (error) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: BukeerColors.error.withOpacity(0.1),
                        child: Text(
                          error.count.toString(),
                          style: TextStyle(
                            color: BukeerColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        error.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('Tipo: ${error.type}'),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: BukeerSpacing.xs,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: BukeerColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${error.count}x',
                          style: TextStyle(
                            color: BukeerColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTypeDistribution(ErrorAnalytics data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución por Tipo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            if (data.errorTypeDistribution.isEmpty)
              Text(
                'No hay datos disponibles',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              ...data.errorTypeDistribution.entries.map((entry) {
                final percentage = data.totalErrors > 0
                    ? (entry.value / data.totalErrors * 100).toStringAsFixed(1)
                    : '0.0';

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getErrorTypeColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: BukeerSpacing.s),
                      Expanded(
                        child: Text(entry.key.name),
                      ),
                      Text(
                        '${entry.value} ($percentage%)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentErrors(ErrorAnalytics data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Errores Recientes (últimos 30 min)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            if (data.recentErrors.isEmpty)
              Text(
                'No hay errores recientes',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              ...data.recentErrors
                  .take(5)
                  .map(
                    (error) => ListTile(
                      leading: Icon(
                        _getErrorIcon(error.type),
                        color: _getSeverityColor(error.severity),
                      ),
                      title: Text(
                        error.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${error.context ?? 'Sin contexto'} • ${_formatTime(error.timestamp)}',
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: BukeerSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(error.severity)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          error.severity.name,
                          style: TextStyle(
                            color: _getSeverityColor(error.severity),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPatterns(ErrorAnalyticsService analytics) {
    final patterns = analytics.getErrorPatterns();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patrones de Errores',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            if (patterns.isEmpty)
              Text(
                'No hay patrones identificados',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              ...patterns
                  .take(5)
                  .map(
                    (pattern) => ExpansionTile(
                      leading: Icon(
                        _getErrorIcon(pattern.type),
                        color: _getSeverityColor(pattern.severity),
                      ),
                      title: Text('${pattern.type.name} - ${pattern.context}'),
                      subtitle: Text(
                        '${pattern.occurrences} ocurrencias • ${pattern.isRecurring ? 'Recurrente' : 'Esporádico'}',
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(BukeerSpacing.s),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Primera ocurrencia: ${_formatDateTime(pattern.firstOccurrence)}'),
                              Text(
                                  'Última ocurrencia: ${_formatDateTime(pattern.lastOccurrence)}'),
                              if (pattern.isRecurring)
                                Text(
                                  'PATRÓN RECURRENTE - Requiere atención',
                                  style: TextStyle(
                                    color: BukeerColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTrends(ErrorAnalytics data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tendencias (últimos 7 días)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: BukeerSpacing.s),
            if (data.errorTrends.isEmpty)
              Text(
                'No hay datos de tendencias',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: data.errorTrends.entries.map((entry) {
                    final maxValue =
                        data.errorTrends.values.reduce((a, b) => a > b ? a : b);
                    final height = maxValue > 0
                        ? (entry.value / maxValue * 80).clamp(4.0, 80.0)
                        : 4.0;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 20,
                          height: height,
                          decoration: BoxDecoration(
                            color: BukeerColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          entry.key,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'export':
        _exportData(context);
        break;
      case 'clear':
        _clearData(context);
        break;
    }
  }

  void _exportData(BuildContext context) {
    final analytics = ErrorAnalyticsService();
    final data = analytics.exportErrorData();

    // In a real app, this would save to file or share
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Datos exportados (${data.length} caracteres)'),
        action: SnackBarAction(
          label: 'Ver',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Datos Exportados'),
                content: SingleChildScrollView(
                  child: Text(
                    data,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 10),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cerrar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _clearData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpiar Datos'),
        content: Text(
            '¿Estás seguro de que quieres eliminar todos los datos de error?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ErrorAnalyticsService().clearAnalytics();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Datos eliminados')),
              );
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getHealthColor(String status) {
    switch (status) {
      case 'Excelente':
        return BukeerColors.success;
      case 'Bueno':
        return BukeerColors.info;
      case 'Regular':
        return BukeerColors.warning;
      case 'Crítico':
        return BukeerColors.error;
      default:
        return Colors.grey;
    }
  }

  Color _getErrorRateColor(double rate) {
    if (rate < 1.0) return BukeerColors.success;
    if (rate < 3.0) return BukeerColors.warning;
    return BukeerColors.error;
  }

  Color _getErrorTypeColor(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.blue;
      case ErrorType.api:
        return Colors.orange;
      case ErrorType.validation:
        return Colors.yellow;
      case ErrorType.authentication:
        return Colors.red;
      case ErrorType.authorization:
        return Colors.purple;
      case ErrorType.business:
        return Colors.green;
      case ErrorType.storage:
        return Colors.brown;
      case ErrorType.navigation:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getSeverityColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return BukeerColors.info;
      case ErrorSeverity.medium:
        return BukeerColors.warning;
      case ErrorSeverity.high:
        return BukeerColors.error;
    }
  }

  IconData _getErrorIcon(ErrorType type) {
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${_formatTime(time)}';
  }
}
