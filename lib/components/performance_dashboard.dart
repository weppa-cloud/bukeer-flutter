import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/performance_optimized_service.dart';
import '../services/ui_state_service.dart';
import '../services/user_service.dart';
import '../services/app_services.dart';

/// Debug-only performance monitoring dashboard
class PerformanceDashboard extends StatefulWidget {
  const PerformanceDashboard({Key? key}) : super(key: key);

  @override
  State<PerformanceDashboard> createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard> {
  Timer? _refreshTimer;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _refreshTimer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => setState(() {}),
      );
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (!kDebugMode) return const SizedBox.shrink();

    return Positioned(
      top: 50,
      right: 10,
      child: Column(
        children: [
          FloatingActionButton.small(
            onPressed: () => setState(() => _isVisible = !_isVisible),
            child: Icon(_isVisible ? Icons.close : Icons.speed),
            backgroundColor: Colors.orange,
          ),
          if (_isVisible) _buildDashboard(),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      width: 350,
      height: 500,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceStats(),
                  const SizedBox(height: 12),
                  _buildMemoryStats(),
                  const SizedBox(height: 12),
                  _buildRebuildStats(),
                  const SizedBox(height: 12),
                  _buildPerformanceStats(),
                  const SizedBox(height: 12),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.speed, color: Colors.orange, size: 16),
        const SizedBox(width: 8),
        const Text(
          'Performance Monitor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          DateTime.now().toString().substring(11, 19),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildServiceStats() {
    return _buildSection('Service Stats', [
      _buildServiceStat('UiStateService', _getUiStateServiceStats()),
      _buildServiceStat('UserService', _getUserServiceStats()),
      _buildServiceStat('Memory Manager', MemoryManager.instance.getStats()),
    ]);
  }

  Widget _buildServiceStat(String serviceName, Map<String, dynamic> stats) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceName,
            style: const TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          ...stats.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  '${entry.key}: ${entry.value}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              )),
        ],
      ),
    );
  }

  Map<String, dynamic> _getUiStateServiceStats() {
    try {
      // Access UiStateService through Provider if available
      final uiService = appServices.ui; // Assuming this exists
      if (uiService is PerformanceOptimizedService) {
        return uiService.getPerformanceStats();
      }
    } catch (e) {
      return {'error': 'Service not accessible'};
    }
    return {'status': 'No stats available'};
  }

  Map<String, dynamic> _getUserServiceStats() {
    try {
      final userService = UserService();
      return {
        'hasLoadedData': userService.hasLoadedData,
        'isLoading': userService.isLoading,
        'selectedUser': userService.selectedUser != null ? 'Set' : 'Null',
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Widget _buildMemoryStats() {
    final memoryStats = MemoryManager.instance.getStats();
    return _buildSection('Memory Stats', [
      _buildStatRow('Monitoring', memoryStats['monitoringActive'] ? '✅' : '❌'),
      _buildStatRow('Log Entries', memoryStats['logEntries'].toString()),
      _buildStatRow('Last Check', memoryStats['lastCheck'].toString()),
    ]);
  }

  Widget _buildRebuildStats() {
    final rebuildStats = WidgetRebuildTracker.getRebuildStats();
    final topWidgets = rebuildStats.entries
        .where((entry) => entry.value > 5)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _buildSection('Widget Rebuilds (>5)', [
      if (topWidgets.isEmpty)
        const Text(
          'No frequent rebuilds detected',
          style: TextStyle(color: Colors.green, fontSize: 11),
        )
      else
        ...topWidgets.take(5).map((entry) => _buildStatRow(
              entry.key.replaceAll('Widget', ''),
              '${entry.value} rebuilds',
              entry.value > 20 ? Colors.red : Colors.yellow,
            )),
    ]);
  }

  Widget _buildPerformanceStats() {
    final perfStats = PerformanceMonitor.getPerformanceStats();
    return _buildSection('Operation Times', [
      if (perfStats.isEmpty)
        const Text(
          'No performance data yet',
          style: TextStyle(color: Colors.grey, fontSize: 11),
        )
      else
        ...perfStats.entries.take(5).map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(color: Colors.cyan, fontSize: 11),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    'Avg: ${entry.value['avgMs']}ms | Max: ${entry.value['maxMs']}ms',
                    style: TextStyle(
                      color: double.parse(entry.value['avgMs']) > 50
                          ? Colors.red
                          : Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            )),
    ]);
  }

  Widget _buildActions() {
    return _buildSection('Actions', [
      Wrap(
        spacing: 8,
        children: [
          _buildActionButton('Clear Rebuilds', () {
            WidgetRebuildTracker.clearRebuildStats();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rebuild stats cleared')),
            );
          }),
          _buildActionButton('Clear Performance', () {
            PerformanceMonitor.clearStats();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Performance stats cleared')),
            );
          }),
          _buildActionButton('Start Memory Monitor', () {
            MemoryManager.instance.startMonitoring();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Memory monitoring started')),
            );
          }),
        ],
      ),
    ]);
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontSize: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        ...children,
      ],
    );
  }

  Widget _buildStatRow(String label, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapper widget that includes performance monitoring
class PerformanceAwareApp extends StatelessWidget {
  final Widget child;

  const PerformanceAwareApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return child;
    }

    // Start memory monitoring in debug mode
    MemoryManager.instance.startMonitoring();

    return Stack(
      children: [
        child,
        const PerformanceDashboard(),
      ],
    );
  }
}
