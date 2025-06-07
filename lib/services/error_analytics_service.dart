import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'error_service.dart';

/// Error analytics and monitoring service
/// Tracks error patterns, frequency, and provides insights
class ErrorAnalyticsService extends ChangeNotifier {
  static final ErrorAnalyticsService _instance = ErrorAnalyticsService._internal();
  factory ErrorAnalyticsService() => _instance;
  ErrorAnalyticsService._internal();

  final List<ErrorEvent> _errorEvents = [];
  final Map<String, int> _errorCounts = {};
  final Map<ErrorType, int> _errorTypeStats = {};
  final Map<ErrorSeverity, int> _severityStats = {};
  
  DateTime? _sessionStartTime;
  int _totalErrors = 0;
  int _resolvedErrors = 0;

  /// Start analytics session
  void startSession() {
    _sessionStartTime = DateTime.now();
    _totalErrors = 0;
    _resolvedErrors = 0;
    notifyListeners();
  }

  /// Record an error event
  void recordError(AppError error) {
    final event = ErrorEvent(
      error: error,
      timestamp: DateTime.now(),
      sessionId: _getSessionId(),
    );

    _errorEvents.add(event);
    _totalErrors++;

    // Update statistics
    final errorKey = '${error.type.name}:${error.message}';
    _errorCounts[errorKey] = (_errorCounts[errorKey] ?? 0) + 1;
    _errorTypeStats[error.type] = (_errorTypeStats[error.type] ?? 0) + 1;
    _severityStats[error.severity] = (_severityStats[error.severity] ?? 0) + 1;

    // Clean old events (keep last 100)
    if (_errorEvents.length > 100) {
      _errorEvents.removeRange(0, _errorEvents.length - 100);
    }

    notifyListeners();
  }

  /// Mark an error as resolved
  void markErrorResolved(String errorId) {
    final event = _errorEvents.firstWhere(
      (e) => e.id == errorId,
      orElse: () => ErrorEvent(
        error: AppError(
          message: '',
          originalError: null,
          stackTrace: StackTrace.current,
          severity: ErrorSeverity.low,
          type: ErrorType.unknown,
          timestamp: DateTime.now(),
          metadata: {},
        ),
        timestamp: DateTime.now(),
        sessionId: '',
      ),
    );

    if (event.id == errorId) {
      event.resolvedAt = DateTime.now();
      _resolvedErrors++;
      notifyListeners();
    }
  }

  /// Get error statistics
  ErrorAnalytics getAnalytics() {
    final now = DateTime.now();
    final sessionDuration = _sessionStartTime != null
        ? now.difference(_sessionStartTime!)
        : Duration.zero;

    return ErrorAnalytics(
      totalErrors: _totalErrors,
      resolvedErrors: _resolvedErrors,
      sessionDuration: sessionDuration,
      errorRate: _calculateErrorRate(),
      mostCommonErrors: _getMostCommonErrors(),
      errorTypeDistribution: Map.from(_errorTypeStats),
      severityDistribution: Map.from(_severityStats),
      recentErrors: _getRecentErrors(),
      criticalErrors: _getCriticalErrors(),
      errorTrends: _getErrorTrends(),
    );
  }

  /// Get error patterns for debugging
  List<ErrorPattern> getErrorPatterns() {
    final patterns = <String, ErrorPattern>{};

    for (final event in _errorEvents) {
      final key = '${event.error.type.name}:${event.error.context ?? 'unknown'}';
      
      if (patterns.containsKey(key)) {
        patterns[key]!.occurrences++;
        patterns[key]!.lastOccurrence = event.timestamp;
      } else {
        patterns[key] = ErrorPattern(
          type: event.error.type,
          context: event.error.context ?? 'unknown',
          occurrences: 1,
          firstOccurrence: event.timestamp,
          lastOccurrence: event.timestamp,
          severity: event.error.severity,
        );
      }
    }

    final patternList = patterns.values.toList();
    patternList.sort((a, b) => b.occurrences.compareTo(a.occurrences));
    return patternList;
  }

  /// Export error data for analysis
  String exportErrorData() {
    final data = {
      'session_id': _getSessionId(),
      'session_start': _sessionStartTime?.toIso8601String(),
      'total_errors': _totalErrors,
      'resolved_errors': _resolvedErrors,
      'error_events': _errorEvents.map((e) => e.toJson()).toList(),
      'error_counts': _errorCounts,
      'type_stats': _errorTypeStats.map((k, v) => MapEntry(k.name, v)),
      'severity_stats': _severityStats.map((k, v) => MapEntry(k.name, v)),
    };

    return jsonEncode(data);
  }

  /// Clear analytics data
  void clearAnalytics() {
    _errorEvents.clear();
    _errorCounts.clear();
    _errorTypeStats.clear();
    _severityStats.clear();
    _totalErrors = 0;
    _resolvedErrors = 0;
    notifyListeners();
  }

  // Private methods
  String _getSessionId() {
    return _sessionStartTime?.millisecondsSinceEpoch.toString() ?? 
           DateTime.now().millisecondsSinceEpoch.toString();
  }

  double _calculateErrorRate() {
    if (_sessionStartTime == null) return 0.0;
    
    final duration = DateTime.now().difference(_sessionStartTime!);
    final hours = duration.inMinutes / 60.0;
    
    return hours > 0 ? _totalErrors / hours : 0.0;
  }

  List<ErrorSummary> _getMostCommonErrors() {
    final sorted = _errorCounts.entries.toList();
    sorted.sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((entry) {
      final parts = entry.key.split(':');
      return ErrorSummary(
        type: parts.isNotEmpty ? parts[0] : 'unknown',
        message: parts.length > 1 ? parts.sublist(1).join(':') : entry.key,
        count: entry.value,
      );
    }).toList();
  }

  List<AppError> _getRecentErrors() {
    final recent = _errorEvents
        .where((e) => DateTime.now().difference(e.timestamp).inMinutes < 30)
        .map((e) => e.error)
        .toList();
    
    recent.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return recent.take(10).toList();
  }

  List<AppError> _getCriticalErrors() {
    return _errorEvents
        .where((e) => e.error.severity == ErrorSeverity.high)
        .map((e) => e.error)
        .take(5)
        .toList();
  }

  Map<String, int> _getErrorTrends() {
    final now = DateTime.now();
    final trends = <String, int>{};
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      final count = _errorEvents
          .where((e) => _isSameDay(e.timestamp, date))
          .length;
      trends[dateKey] = count;
    }
    
    return trends;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}

/// Error event with tracking information
class ErrorEvent {
  final String id;
  final AppError error;
  final DateTime timestamp;
  final String sessionId;
  DateTime? resolvedAt;

  ErrorEvent({
    required this.error,
    required this.timestamp,
    required this.sessionId,
    this.resolvedAt,
  }) : id = '${timestamp.millisecondsSinceEpoch}_${error.type.name}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'error': {
        'type': error.type.name,
        'severity': error.severity.name,
        'message': error.message,
        'context': error.context,
        'metadata': error.metadata,
      },
      'timestamp': timestamp.toIso8601String(),
      'session_id': sessionId,
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }
}

/// Error analytics data model
class ErrorAnalytics {
  final int totalErrors;
  final int resolvedErrors;
  final Duration sessionDuration;
  final double errorRate;
  final List<ErrorSummary> mostCommonErrors;
  final Map<ErrorType, int> errorTypeDistribution;
  final Map<ErrorSeverity, int> severityDistribution;
  final List<AppError> recentErrors;
  final List<AppError> criticalErrors;
  final Map<String, int> errorTrends;

  ErrorAnalytics({
    required this.totalErrors,
    required this.resolvedErrors,
    required this.sessionDuration,
    required this.errorRate,
    required this.mostCommonErrors,
    required this.errorTypeDistribution,
    required this.severityDistribution,
    required this.recentErrors,
    required this.criticalErrors,
    required this.errorTrends,
  });

  double get resolutionRate {
    return totalErrors > 0 ? resolvedErrors / totalErrors : 0.0;
  }

  int get pendingErrors => totalErrors - resolvedErrors;

  String get healthStatus {
    if (errorRate < 1.0) return 'Excelente';
    if (errorRate < 3.0) return 'Bueno';
    if (errorRate < 5.0) return 'Regular';
    return 'Crítico';
  }
}

/// Error summary for analytics
class ErrorSummary {
  final String type;
  final String message;
  final int count;

  ErrorSummary({
    required this.type,
    required this.message,
    required this.count,
  });
}

/// Error pattern for debugging
class ErrorPattern {
  final ErrorType type;
  final String context;
  int occurrences;
  final DateTime firstOccurrence;
  DateTime lastOccurrence;
  final ErrorSeverity severity;

  ErrorPattern({
    required this.type,
    required this.context,
    required this.occurrences,
    required this.firstOccurrence,
    required this.lastOccurrence,
    required this.severity,
  });

  Duration get frequency {
    return lastOccurrence.difference(firstOccurrence);
  }

  bool get isRecurring => occurrences > 3;
  bool get isRecent => DateTime.now().difference(lastOccurrence).inHours < 24;
}