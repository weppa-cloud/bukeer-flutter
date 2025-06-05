import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Memory management service to prevent leaks and optimize resource usage
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final Map<String, Timer> _timers = {};
  final Map<String, StreamSubscription> _subscriptions = {};
  final Map<String, Set<ChangeNotifier>> _notifiers = {};
  Timer? _cleanupTimer;

  void initialize() {
    // Schedule periodic cleanup
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      performCleanup();
    });
  }

  /// Register a timer for cleanup
  void registerTimer(String key, Timer timer) {
    cancelTimer(key);
    _timers[key] = timer;
  }

  /// Cancel and remove a timer
  void cancelTimer(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
  }

  /// Register a subscription for cleanup
  void registerSubscription(String key, StreamSubscription subscription) {
    cancelSubscription(key);
    _subscriptions[key] = subscription;
  }

  /// Cancel and remove a subscription
  void cancelSubscription(String key) {
    _subscriptions[key]?.cancel();
    _subscriptions.remove(key);
  }

  /// Register a ChangeNotifier for cleanup
  void registerNotifier(String group, ChangeNotifier notifier) {
    _notifiers[group] ??= <ChangeNotifier>{};
    _notifiers[group]!.add(notifier);
  }

  /// Dispose all notifiers in a group
  void disposeNotifierGroup(String group) {
    final notifiers = _notifiers[group];
    if (notifiers != null) {
      for (final notifier in notifiers) {
        try {
          notifier.dispose();
        } catch (e) {
          debugPrint('Error disposing notifier: $e');
        }
      }
      _notifiers.remove(group);
    }
  }

  /// Perform comprehensive cleanup
  void performCleanup() {
    debugPrint('🧹 MemoryManager: Performing cleanup...');

    // Clean up expired timers
    final expiredTimers = <String>[];
    _timers.forEach((key, timer) {
      if (!timer.isActive) {
        expiredTimers.add(key);
      }
    });

    for (final key in expiredTimers) {
      _timers.remove(key);
    }

    // Clean up closed subscriptions
    final closedSubscriptions = <String>[];
    _subscriptions.forEach((key, subscription) {
      // Note: StreamSubscription doesn't have a direct way to check if closed
      // This is a limitation we need to manage manually
    });

    debugPrint(
        '🧹 MemoryManager: Cleaned ${expiredTimers.length} expired timers');
  }

  /// Dispose all resources
  void dispose() {
    _cleanupTimer?.cancel();

    // Cancel all timers
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();

    // Cancel all subscriptions
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Dispose all notifiers
    for (final group in _notifiers.keys.toList()) {
      disposeNotifierGroup(group);
    }

    debugPrint('🧹 MemoryManager: All resources disposed');
  }

  /// Get memory usage statistics
  Map<String, int> getStats() {
    return {
      'active_timers': _timers.length,
      'active_subscriptions': _subscriptions.length,
      'notifier_groups': _notifiers.length,
      'total_notifiers':
          _notifiers.values.fold(0, (sum, set) => sum + set.length),
    };
  }
}

/// Mixin for automatic memory management
mixin AutoMemoryManagement {
  final Set<Timer> _timers = {};
  final Set<StreamSubscription> _subscriptions = {};
  String get memoryKey;

  Timer createManagedTimer(Duration duration, VoidCallback callback) {
    final timer = Timer(duration, callback);
    _timers.add(timer);
    return timer;
  }

  Timer createManagedPeriodicTimer(
      Duration duration, void Function(Timer) callback) {
    final timer = Timer.periodic(duration, callback);
    _timers.add(timer);
    return timer;
  }

  void addManagedSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  void disposeManagedResources() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}

/// Widget for automatic memory cleanup
class MemoryManagedWidget extends StatefulWidget {
  final Widget child;
  final String memoryKey;
  final VoidCallback? onDispose;

  const MemoryManagedWidget({
    Key? key,
    required this.child,
    required this.memoryKey,
    this.onDispose,
  }) : super(key: key);

  @override
  State<MemoryManagedWidget> createState() => _MemoryManagedWidgetState();
}

class _MemoryManagedWidgetState extends State<MemoryManagedWidget> {
  late final MemoryManager _memoryManager;

  @override
  void initState() {
    super.initState();
    _memoryManager = MemoryManager();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    _memoryManager.disposeNotifierGroup(widget.memoryKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

