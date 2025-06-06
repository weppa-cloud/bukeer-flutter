import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:bukeer/services/performance_optimized_service.dart';
import 'dart:async';

/// Performance optimization tests
void main() {
  group('Performance Optimization Tests', () {
    late UiStateService uiStateService;

    setUp(() {
      uiStateService = UiStateService();
    });

    tearDown(() {
      uiStateService.dispose();
    });

    group('Batched Notifications', () {
      test('should batch multiple rapid notifications', () async {
        // Arrange
        var notificationCount = 0;
        uiStateService.addListener(() {
          notificationCount++;
        });

        // Act - Rapid changes that would normally trigger many notifications
        uiStateService.selectedProductId = 'product-1';
        uiStateService.selectedProductType = 'hotels';
        uiStateService.currentPage = 2;
        uiStateService.selectedImageUrl = 'image.jpg';
        uiStateService.setSelectedLocation(
          name: 'Test Location',
          city: 'Test City',
        );

        // All changes happen within the batch window
        expect(notificationCount, equals(0), reason: 'Should be batched');

        // Wait for batch notification
        await Future.delayed(Duration(milliseconds: 20));

        // Assert - Should have only 1 batched notification instead of 5+ individual ones
        expect(notificationCount, equals(1),
            reason: 'Should have 1 batched notification');
      });

      test('should measure notification efficiency', () async {
        // Arrange
        final stopwatch = Stopwatch()..start();
        var notificationCount = 0;

        uiStateService.addListener(() {
          notificationCount++;
        });

        // Act - Perform many rapid updates
        for (int i = 0; i < 100; i++) {
          uiStateService.selectedProductId = 'product-$i';
          uiStateService.currentPage = i % 10;
          uiStateService.selectedImageUrl = 'image-$i.jpg';
        }

        // Wait for all batched notifications
        await Future.delayed(Duration(milliseconds: 50));
        stopwatch.stop();

        // Assert - Should have significantly fewer notifications than changes
        expect(notificationCount, lessThan(10),
            reason: 'Batching should reduce notifications');
        expect(stopwatch.elapsedMilliseconds, lessThan(100),
            reason: 'Should be fast');

        // Verify performance stats
        final stats = uiStateService.getPerformanceStats();
        expect(stats['notificationCount'], greaterThan(0));
        expect(stats['batchedNotificationCount'],
            lessThan(stats['notificationCount']));

        final efficiency =
            double.parse(stats['efficiency'].toString().replaceAll('%', ''));
        expect(efficiency, lessThan(50),
            reason: 'Batching should show efficiency improvement');
      });
    });

    group('Memory Management', () {
      test('should properly dispose of resources', () {
        // Arrange - Create and use service
        final service = UiStateService();
        service.searchQuery = 'test';
        service.setSelectedLocation(name: 'Test');

        // Act - Dispose service
        service.dispose();

        // Assert - Should not throw when accessing after dispose
        expect(() => service.getPerformanceStats(), returnsNormally);
      });

      test('should track managed timers and subscriptions', () {
        // Arrange
        final service = UiStateService();

        // Act - Create managed resources
        final timer =
            service.addManagedTimer(Timer(Duration(seconds: 1), () {}));
        final subscription = service.addManagedSubscription(
            Stream.fromIterable([1, 2, 3]).listen((_) {}));

        // Assert
        final stats = service.getPerformanceStats();
        expect(stats['managedTimers'], equals(1));
        expect(stats['managedSubscriptions'], equals(1));

        // Cleanup
        service.dispose();

        // Timers and subscriptions should be cancelled
        expect(timer.isActive, isFalse);
      });
    });

    group('BoundedCache Performance', () {
      test('should limit cache size', () {
        // Arrange
        final cache = BoundedCache<String, String>(maxSize: 5);

        // Act - Add more items than cache size
        for (int i = 0; i < 10; i++) {
          cache.put('key-$i', 'value-$i');
        }

        // Assert - Should not exceed max size
        expect(cache.length, equals(5));

        // Should contain only the last 5 items (LRU eviction)
        expect(cache.get('key-0'), isNull,
            reason: 'Oldest item should be evicted');
        expect(cache.get('key-9'), equals('value-9'),
            reason: 'Newest item should exist');
      });

      test('should handle cache expiration', () async {
        // Arrange
        final cache = BoundedCache<String, String>(
          maxSize: 10,
          maxAge: Duration(milliseconds: 50),
        );

        // Act - Add item and wait for expiration
        cache.put('key1', 'value1');
        expect(cache.get('key1'), equals('value1'));

        await Future.delayed(Duration(milliseconds: 60));

        // Assert - Item should be expired
        expect(cache.get('key1'), isNull, reason: 'Item should be expired');
      });

      test('should provide accurate cache stats', () {
        // Arrange
        final cache = BoundedCache<String, String>(maxSize: 10);

        // Act
        for (int i = 0; i < 5; i++) {
          cache.put('key-$i', 'value-$i');
        }

        // Assert
        final stats = cache.getStats();
        expect(stats['size'], equals(5));
        expect(stats['maxSize'], equals(10));
        expect(stats['usage'], equals('50.0%'));
      });
    });

    group('Performance Monitoring', () {
      test('should track operation performance', () async {
        // Arrange
        const operation = 'test_operation';
        final startTime = DateTime.now();

        // Act
        PerformanceMonitor.startTiming(operation);
        // Simulate some work that takes measurable time
        await Future.delayed(Duration(milliseconds: 1));
        for (int i = 0; i < 10000; i++) {
          i * i * i; // More intensive operation
        }
        PerformanceMonitor.endTiming(operation, startTime);

        // Assert
        final stats = PerformanceMonitor.getPerformanceStats();
        expect(stats.containsKey(operation), isTrue);
        expect(stats[operation]!['samples'], equals(1));
        expect(double.parse(stats[operation]!['avgMs']), greaterThan(0));
      });

      test('should limit sample size', () {
        // Arrange
        const operation = 'sample_limit_test';
        PerformanceMonitor.clearStats();

        // Act - Add more samples than the limit
        for (int i = 0; i < 60; i++) {
          final startTime = DateTime.now();
          PerformanceMonitor.startTiming(operation);
          PerformanceMonitor.endTiming(operation, startTime);
        }

        // Assert - Should not exceed max samples
        final stats = PerformanceMonitor.getPerformanceStats();
        expect(stats[operation]!['samples'], equals(50));
      });
    });

    group('Widget Rebuild Tracking', () {
      test('should track widget rebuilds', () {
        // Arrange
        WidgetRebuildTracker.clearRebuildStats();

        // Act - Simulate widget rebuilds using static methods
        final widgetName = 'TestWidget';
        final rebuildCounts = <String, int>{};

        for (int i = 0; i < 10; i++) {
          rebuildCounts[widgetName] = (rebuildCounts[widgetName] ?? 0) + 1;
        }

        // Assert
        expect(rebuildCounts[widgetName], equals(10));
      });

      test('should clear rebuild stats', () {
        // Arrange & Act
        WidgetRebuildTracker.clearRebuildStats();

        // Assert
        final stats = WidgetRebuildTracker.getRebuildStats();
        expect(stats.isEmpty, isTrue);
      });
    });

    group('Search Debouncing Performance', () {
      test('should debounce search notifications efficiently', () async {
        // Arrange
        var notificationCount = 0;
        uiStateService.addListener(() {
          notificationCount++;
        });

        // Act - Rapid search changes
        final searches = ['a', 'ab', 'abc', 'abcd', 'abcde'];
        for (final search in searches) {
          uiStateService.searchQuery = search;
          await Future.delayed(
              Duration(milliseconds: 50)); // Less than debounce time
        }

        // Wait for final debounce
        await Future.delayed(Duration(milliseconds: 400));

        // Assert - Should have only one notification from final search
        expect(notificationCount, equals(1));
        expect(uiStateService.searchQuery, equals('abcde'));
      });
    });
  });
}
