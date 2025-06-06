import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Enhanced base service with performance optimizations and memory management
mixin PerformanceOptimizedService on ChangeNotifier {
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];
  Timer? _batchNotifyTimer;
  bool _hasPendingNotifications = false;
  bool _disposed = false;

  // Performance metrics
  int _notificationCount = 0;
  int _batchedNotificationCount = 0;
  final DateTime _createdAt = DateTime.now();

  /// Batched notification system to reduce UI rebuilds
  void notifyListenersBatched() {
    if (_disposed) return;

    _notificationCount++;

    if (!_hasPendingNotifications) {
      _hasPendingNotifications = true;
      _batchNotifyTimer?.cancel();
      _batchNotifyTimer = Timer(const Duration(milliseconds: 16), () {
        if (!_disposed) {
          _hasPendingNotifications = false;
          _batchedNotificationCount++;
          notifyListeners();
        }
      });
    }
  }

  /// Convenience method for batched notifications
  void batchNotify(String operation) {
    notifyListenersBatched();
  }

  /// Immediate notification for critical updates
  void notifyImmediately() {
    if (_disposed) return;
    notifyListeners();
  }

  /// Track a timer for automatic disposal
  Timer addManagedTimer(Timer timer) {
    if (_disposed) {
      timer.cancel();
      return timer;
    }
    _timers.add(timer);
    return timer;
  }

  /// Track a subscription for automatic disposal
  StreamSubscription addManagedSubscription(StreamSubscription subscription) {
    if (_disposed) {
      subscription.cancel();
      return subscription;
    }
    _subscriptions.add(subscription);
    return subscription;
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    return {
      'notificationCount': _notificationCount,
      'batchedNotificationCount': _batchedNotificationCount,
      'efficiency': _notificationCount > 0
          ? (_batchedNotificationCount / _notificationCount * 100)
                  .toStringAsFixed(1) +
              '%'
          : '0%',
      'uptime': DateTime.now().difference(_createdAt).toString(),
      'managedTimers': _timers.length,
      'managedSubscriptions': _subscriptions.length,
    };
  }

  /// Override this method to implement service-specific cleanup
  void disposeServiceResources() {}

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    // Cancel batch timer
    _batchNotifyTimer?.cancel();

    // Cancel all managed timers
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    // Cancel all managed subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Service-specific cleanup
    disposeServiceResources();

    super.dispose();

    if (kDebugMode) {
      debugPrint(
          '🗑️ Disposed ${runtimeType} - Stats: ${getPerformanceStats()}');
    }
  }
}

/// Enhanced cache with LRU eviction and size limits
class BoundedCache<K, V> {
  final int maxSize;
  final Duration maxAge;
  final LinkedHashMap<K, _CacheEntry<V>> _cache = LinkedHashMap();

  BoundedCache({
    this.maxSize = 100,
    this.maxAge = const Duration(minutes: 30),
  });

  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // Check if expired
    if (DateTime.now().difference(entry.timestamp) > maxAge) {
      _cache.remove(key);
      return null;
    }

    // Move to end (LRU)
    _cache.remove(key);
    _cache[key] = entry;

    return entry.value;
  }

  void put(K key, V value) {
    // Remove if exists
    _cache.remove(key);

    // Add to end
    _cache[key] = _CacheEntry(value, DateTime.now());

    // Evict oldest if over limit
    if (_cache.length > maxSize) {
      _cache.remove(_cache.keys.first);
    }
  }

  void clear() {
    _cache.clear();
  }

  int get length => _cache.length;

  Map<String, dynamic> getStats() {
    final now = DateTime.now();
    int expiredCount = 0;

    for (final entry in _cache.values) {
      if (now.difference(entry.timestamp) > maxAge) {
        expiredCount++;
      }
    }

    return {
      'size': _cache.length,
      'maxSize': maxSize,
      'expiredEntries': expiredCount,
      'usage': '${(_cache.length / maxSize * 100).toStringAsFixed(1)}%',
    };
  }

  void cleanExpired() {
    final now = DateTime.now();
    _cache
        .removeWhere((key, entry) => now.difference(entry.timestamp) > maxAge);
  }
}

class _CacheEntry<V> {
  final V value;
  final DateTime timestamp;

  _CacheEntry(this.value, this.timestamp);
}

/// Memory usage monitor
class MemoryManager {
  static MemoryManager? _instance;
  static MemoryManager get instance => _instance ??= MemoryManager._();
  MemoryManager._();

  Timer? _monitoringTimer;
  final List<String> _memoryLog = [];
  static const int maxLogEntries = 100;

  void startMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer =
        Timer.periodic(const Duration(minutes: 2), (_) => _logMemoryUsage());
  }

  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }

  void _logMemoryUsage() {
    // In a real app, you would use platform-specific memory APIs
    final timestamp = DateTime.now().toIso8601String();
    final entry = '$timestamp - Memory check performed';

    _memoryLog.add(entry);

    // Keep log bounded
    if (_memoryLog.length > maxLogEntries) {
      _memoryLog.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint(
          '📊 Memory monitoring active - Log entries: ${_memoryLog.length}');
    }
  }

  List<String> getMemoryLog() => List.unmodifiable(_memoryLog);

  Map<String, dynamic> getStats() {
    return {
      'logEntries': _memoryLog.length,
      'monitoringActive': _monitoringTimer?.isActive ?? false,
      'lastCheck': _memoryLog.isNotEmpty ? _memoryLog.last : 'No data',
    };
  }

  void dispose() {
    stopMonitoring();
    _memoryLog.clear();
  }
}

/// Widget rebuild tracking mixin
mixin WidgetRebuildTracker on StatefulWidget {
  static final Map<String, int> _rebuildCounts = {};
  static const int maxTrackingEntries = 50;

  void trackRebuild() {
    if (!kDebugMode) return;

    final widgetName = runtimeType.toString();
    _rebuildCounts[widgetName] = (_rebuildCounts[widgetName] ?? 0) + 1;

    // Clean up old entries if too many
    if (_rebuildCounts.length > maxTrackingEntries) {
      final sortedEntries = _rebuildCounts.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      // Remove widgets with lowest rebuild counts
      for (int i = 0; i < 10; i++) {
        _rebuildCounts.remove(sortedEntries[i].key);
      }
    }

    // Log widgets that rebuild frequently
    final count = _rebuildCounts[widgetName]!;
    if (count % 10 == 0) {
      debugPrint('🔄 Widget $widgetName has rebuilt $count times');
    }
  }

  static Map<String, int> getRebuildStats() {
    return Map.unmodifiable(_rebuildCounts);
  }

  static void clearRebuildStats() {
    _rebuildCounts.clear();
  }
}

/// Performance monitoring utilities
class PerformanceMonitor {
  static final Map<String, List<Duration>> _operationTimes = {};
  static final Map<String, int> _rebuildCounts = {};
  static const int maxSamplesPerOperation = 50;

  static void startTiming(String operation) {
    _operationTimes[operation] ??= [];
  }

  static void logRebuild(String widgetName) {
    if (!kDebugMode) return;

    _rebuildCounts[widgetName] = (_rebuildCounts[widgetName] ?? 0) + 1;
    final count = _rebuildCounts[widgetName]!;

    // Log frequently rebuilding widgets
    if (count % 10 == 0) {
      debugPrint('🔄 Widget $widgetName has rebuilt $count times');
    }
  }

  static void endTiming(String operation, DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    final samples = _operationTimes[operation] ??= [];

    samples.add(duration);

    // Keep sample size bounded
    if (samples.length > maxSamplesPerOperation) {
      samples.removeAt(0);
    }

    // Log slow operations
    if (duration.inMilliseconds > 100 && kDebugMode) {
      debugPrint(
          '⚠️ Slow operation: $operation took ${duration.inMilliseconds}ms');
    }
  }

  static Map<String, Map<String, dynamic>> getPerformanceStats() {
    final stats = <String, Map<String, dynamic>>{};

    for (final entry in _operationTimes.entries) {
      final samples = entry.value;
      if (samples.isEmpty) continue;

      final totalMs = samples.fold<int>(
          0, (sum, duration) => sum + duration.inMilliseconds);
      final avgMs = totalMs / samples.length;
      final maxMs =
          samples.map((d) => d.inMilliseconds).reduce((a, b) => a > b ? a : b);
      final minMs =
          samples.map((d) => d.inMilliseconds).reduce((a, b) => a < b ? a : b);

      stats[entry.key] = {
        'samples': samples.length,
        'avgMs': avgMs.toStringAsFixed(1),
        'maxMs': maxMs,
        'minMs': minMs,
        'totalMs': totalMs,
      };
    }

    return stats;
  }

  static void clearStats() {
    _operationTimes.clear();
  }
}

/// Performance-optimized selector widget
class PerformanceSelector<T extends Listenable, S> extends StatefulWidget {
  final T listenable;
  final S Function(T) selector;
  final Widget Function(BuildContext, S) builder;

  const PerformanceSelector({
    Key? key,
    required this.listenable,
    required this.selector,
    required this.builder,
  }) : super(key: key);

  @override
  State<PerformanceSelector<T, S>> createState() =>
      _PerformanceSelectorState<T, S>();
}

class _PerformanceSelectorState<T extends Listenable, S>
    extends State<PerformanceSelector<T, S>> {
  late S _value;

  @override
  void initState() {
    super.initState();
    _value = widget.selector(widget.listenable);
    widget.listenable.addListener(_listener);
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    final newValue = widget.selector(widget.listenable);
    if (newValue != _value) {
      setState(() {
        _value = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}
