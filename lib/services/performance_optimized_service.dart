import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Enhanced service with granular notifications and performance optimizations
mixin PerformanceOptimizedService on ChangeNotifier {
  final Map<String, Set<VoidCallback>> _specificListeners = {};
  Timer? _batchNotifyTimer;
  final Set<String> _pendingNotifications = {};

  /// Add listener for specific data changes
  void addSpecificListener(String key, VoidCallback listener) {
    _specificListeners[key] ??= <VoidCallback>{};
    _specificListeners[key]!.add(listener);
  }

  /// Remove specific listener
  void removeSpecificListener(String key, VoidCallback listener) {
    _specificListeners[key]?.remove(listener);
    if (_specificListeners[key]?.isEmpty ?? false) {
      _specificListeners.remove(key);
    }
  }

  /// Notify only specific listeners
  void notifySpecificListeners(String key) {
    _specificListeners[key]?.forEach((listener) => listener());
  }

  /// Batch multiple notifications into one
  void batchNotify(String key) {
    _pendingNotifications.add(key);
    _batchNotifyTimer?.cancel();
    _batchNotifyTimer = Timer(const Duration(milliseconds: 16), () {
      for (final notificationKey in _pendingNotifications) {
        notifySpecificListeners(notificationKey);
      }
      _pendingNotifications.clear();
      notifyListeners();
    });
  }

  /// Notify immediately for critical updates
  void notifyImmediately([String? key]) {
    _batchNotifyTimer?.cancel();
    _pendingNotifications.clear();
    if (key != null) {
      notifySpecificListeners(key);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _batchNotifyTimer?.cancel();
    _specificListeners.clear();
    _pendingNotifications.clear();
    super.dispose();
  }
}

/// Selector widget for granular rebuilds
class PerformanceSelector<T, R> extends StatelessWidget {
  final T listenable;
  final R Function(T) selector;
  final Widget Function(BuildContext, R) builder;
  final bool Function(R previous, R next)? shouldRebuild;

  const PerformanceSelector({
    Key? key,
    required this.listenable,
    required this.selector,
    required this.builder,
    this.shouldRebuild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<R>(
      valueListenable: _SelectorListenable(
        listenable as Listenable,
        selector,
        shouldRebuild,
      ),
      builder: (context, value, child) => builder(context, value),
    );
  }
}

class _SelectorListenable<T, R> extends ValueListenable<R> {
  final Listenable _listenable;
  final R Function(T) _selector;
  final bool Function(R previous, R next)? _shouldRebuild;
  R? _value;
  final List<VoidCallback> _listeners = [];

  _SelectorListenable(
    this._listenable,
    this._selector,
    this._shouldRebuild,
  ) {
    _listenable.addListener(_onListenableChange);
    _value = _selector(_listenable as T);
  }

  void _onListenableChange() {
    final newValue = _selector(_listenable as T);
    if (_shouldRebuild?.call(_value as R, newValue) ?? _value != newValue) {
      _value = newValue;
      for (final listener in _listeners) {
        listener();
      }
    }
  }

  @override
  R get value => _value!;

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listenable.removeListener(_onListenableChange);
    _listeners.clear();
  }
}

/// Performance monitoring utilities
class PerformanceMonitor {
  static final Map<String, DateTime> _timers = {};
  static final Map<String, int> _counters = {};

  static void startTimer(String name) {
    _timers[name] = DateTime.now();
  }

  static void endTimer(String name) {
    final start = _timers[name];
    if (start != null) {
      final duration = DateTime.now().difference(start);
      debugPrint('⏱️ $name took ${duration.inMilliseconds}ms');
      _timers.remove(name);
    }
  }

  static void incrementCounter(String name) {
    _counters[name] = (_counters[name] ?? 0) + 1;
    if (_counters[name]! % 10 == 0) {
      debugPrint('🔄 $name called ${_counters[name]} times');
    }
  }

  static void logRebuild(String widgetName) {
    incrementCounter('rebuild_$widgetName');
  }

  static void reset() {
    _timers.clear();
    _counters.clear();
  }
}

