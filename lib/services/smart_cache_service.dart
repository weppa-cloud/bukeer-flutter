import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Smart cache service with LRU eviction, TTL, and compression
class SmartCacheService {
  static final SmartCacheService _instance = SmartCacheService._internal();
  factory SmartCacheService() => _instance;
  SmartCacheService._internal();

  final Map<String, _CacheEntry> _cache = {};
  final Map<String, DateTime> _accessTimes = {};
  Timer? _cleanupTimer;
  
  // Configuration
  static const int maxCacheSize = 100;
  static const Duration defaultTtl = Duration(minutes: 10);
  static const Duration cleanupInterval = Duration(minutes: 2);

  void initialize() {
    _cleanupTimer = Timer.periodic(cleanupInterval, (_) => _performCleanup());
  }

  /// Store data in cache with optional TTL
  void put<T>(String key, T data, {Duration? ttl}) {
    final entry = _CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl ?? defaultTtl,
      size: _calculateSize(data),
    );

    _cache[key] = entry;
    _accessTimes[key] = DateTime.now();

    // Ensure cache size limit
    _enforceSizeLimit();
  }

  /// Retrieve data from cache
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // Check if expired
    if (entry.isExpired) {
      remove(key);
      return null;
    }

    // Update access time for LRU
    _accessTimes[key] = DateTime.now();
    return entry.data as T?;
  }

  /// Get or compute data with caching
  Future<T> getOrCompute<T>(
    String key,
    Future<T> Function() computeFunction, {
    Duration? ttl,
  }) async {
    final cached = get<T>(key);
    if (cached != null) {
      return cached;
    }

    final computed = await computeFunction();
    put(key, computed, ttl: ttl);
    return computed;
  }

  /// Remove specific entry
  void remove(String key) {
    _cache.remove(key);
    _accessTimes.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
    _accessTimes.clear();
  }

  /// Clear cache by pattern
  void clearByPattern(String pattern) {
    final regex = RegExp(pattern);
    final keysToRemove = _cache.keys.where((key) => regex.hasMatch(key)).toList();
    
    for (final key in keysToRemove) {
      remove(key);
    }
  }

  /// Check if key exists and is valid
  bool contains(String key) {
    final entry = _cache[key];
    return entry != null && !entry.isExpired;
  }

  /// Get cache statistics
  CacheStats getStats() {
    final now = DateTime.now();
    int validEntries = 0;
    int expiredEntries = 0;
    int totalSize = 0;

    for (final entry in _cache.values) {
      if (entry.isExpired) {
        expiredEntries++;
      } else {
        validEntries++;
      }
      totalSize += entry.size;
    }

    return CacheStats(
      totalEntries: _cache.length,
      validEntries: validEntries,
      expiredEntries: expiredEntries,
      totalSize: totalSize,
      hitRatio: _calculateHitRatio(),
    );
  }

  /// Preload data into cache
  Future<void> preload<T>(Map<String, Future<T> Function()> loaders) async {
    final futures = <Future<void>>[];
    
    for (final entry in loaders.entries) {
      futures.add(_preloadSingle(entry.key, entry.value));
    }

    await Future.wait(futures);
  }

  Future<void> _preloadSingle<T>(String key, Future<T> Function() loader) async {
    try {
      final data = await loader();
      put(key, data);
    } catch (e) {
      debugPrint('Failed to preload $key: $e');
    }
  }

  void _performCleanup() {
    debugPrint('🧹 SmartCache: Performing cleanup...');
    
    // Remove expired entries
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      remove(key);
    }

    // Enforce size limit
    _enforceSizeLimit();

    debugPrint('🧹 SmartCache: Removed ${expiredKeys.length} expired entries');
  }

  void _enforceSizeLimit() {
    if (_cache.length <= maxCacheSize) return;

    // Sort by access time (LRU)
    final sortedEntries = _accessTimes.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Remove oldest entries
    final entriesToRemove = _cache.length - maxCacheSize;
    for (int i = 0; i < entriesToRemove; i++) {
      remove(sortedEntries[i].key);
    }
  }

  int _calculateSize(dynamic data) {
    try {
      if (data is String) return data.length;
      if (data is List) return data.length * 50; // Estimate
      if (data is Map) return data.length * 100; // Estimate
      return json.encode(data).length;
    } catch (e) {
      return 1000; // Default size if calculation fails
    }
  }

  double _calculateHitRatio() {
    // This would require tracking hits/misses
    // For now, return a placeholder
    return 0.0;
  }

  void dispose() {
    _cleanupTimer?.cancel();
    clear();
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration ttl;
  final int size;

  _CacheEntry({
    required this.data,
    required this.timestamp,
    required this.ttl,
    required this.size,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}

class CacheStats {
  final int totalEntries;
  final int validEntries;
  final int expiredEntries;
  final int totalSize;
  final double hitRatio;

  CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
    required this.totalSize,
    required this.hitRatio,
  });

  @override
  String toString() {
    return 'CacheStats(total: $totalEntries, valid: $validEntries, '
           'expired: $expiredEntries, size: ${(totalSize / 1024).toStringAsFixed(1)}KB, '
           'hit ratio: ${(hitRatio * 100).toStringAsFixed(1)}%)';
  }
}

/// Mixin for services that use smart caching
mixin SmartCacheable {
  SmartCacheService get cache => SmartCacheService();

  String getCacheKey(String operation, [Map<String, dynamic>? params]) {
    final baseKey = '${runtimeType}_$operation';
    if (params == null || params.isEmpty) return baseKey;
    
    final paramString = params.entries
        .map((e) => '${e.key}:${e.value}')
        .join('_');
    return '${baseKey}_$paramString';
  }

  void invalidateCache([String? pattern]) {
    if (pattern != null) {
      cache.clearByPattern(pattern);
    } else {
      cache.clearByPattern(runtimeType.toString());
    }
  }
}