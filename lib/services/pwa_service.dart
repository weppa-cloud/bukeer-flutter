import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// Conditional import - only import html on web platform
import 'pwa_service_web.dart' if (dart.library.io) 'pwa_service_stub.dart';

/// Service for managing Progressive Web App (PWA) functionality
/// Handles installation prompts, updates, and PWA-specific features
class PWAService extends ChangeNotifier {
  static final PWAService _instance = PWAService._internal();
  factory PWAService() => _instance;
  PWAService._internal() {
    _impl = createPWAServiceImpl();
  }

  late final PWAServiceImpl _impl;

  bool get isInstallable => _impl.isInstallable;
  bool get isInstalled => _impl.isInstalled;
  bool get hasUpdate => _impl.hasUpdate;
  String get displayMode => _impl.displayMode;
  bool get isPWAContext => _impl.isPWAContext;

  /// Initialize PWA service
  void initialize() {
    if (kIsWeb) {
      _impl.initialize();
      _impl.addListener(_onImplChanged);
    }
  }

  void _onImplChanged() {
    notifyListeners();
  }

  /// Trigger PWA installation
  Future<bool> installApp() async {
    if (!kIsWeb) return false;
    return await _impl.installApp();
  }

  /// Reload app to apply updates
  Future<void> reloadForUpdate() async {
    if (!kIsWeb) return;
    await _impl.reloadForUpdate();
  }

  /// Share content using Web Share API
  Future<bool> shareContent({
    required String title,
    required String text,
    String? url,
  }) async {
    if (!kIsWeb) return false;
    return await _impl.shareContent(title: title, text: text, url: url);
  }

  /// Copy text to clipboard
  Future<bool> copyToClipboard(String text) async {
    if (!kIsWeb) {
      try {
        await Clipboard.setData(ClipboardData(text: text));
        return true;
      } catch (e) {
        debugPrint('PWA: Error copying to clipboard: $e');
        return false;
      }
    }
    return await _impl.copyToClipboard(text);
  }

  /// Check if device is online
  bool get isOnline => kIsWeb ? _impl.isOnline : true;

  /// Get device information for PWA analytics
  Map<String, dynamic> getDeviceInfo() {
    if (!kIsWeb) return {};
    return _impl.getDeviceInfo();
  }

  /// Show native notification (if supported)
  Future<bool> showNotification({
    required String title,
    required String body,
    String? icon,
    String? tag,
  }) async {
    if (!kIsWeb) return false;
    return await _impl.showNotification(
      title: title,
      body: body,
      icon: icon,
      tag: tag,
    );
  }

  /// Register for push notifications
  Future<String?> registerForPushNotifications() async {
    if (!kIsWeb) return null;
    return await _impl.registerForPushNotifications();
  }

  /// Enable/disable fullscreen mode
  Future<bool> toggleFullscreen() async {
    if (!kIsWeb) return false;
    return await _impl.toggleFullscreen();
  }

  /// Track PWA usage events
  void trackEvent({
    required String event,
    Map<String, dynamic>? parameters,
  }) {
    if (!kIsWeb) return;
    _impl.trackEvent(event: event, parameters: parameters);
  }

  /// Clear app data and cache
  Future<void> clearAppData() async {
    if (!kIsWeb) return;
    await _impl.clearAppData();
  }

  /// Get app version and build info
  Map<String, String> getAppInfo() {
    return {
      'version': '2.0.0', // Should come from pubspec.yaml
      'buildMode': kDebugMode ? 'debug' : 'release',
      'platform': kIsWeb ? 'web' : 'mobile',
      'displayMode': displayMode,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _impl.removeListener(_onImplChanged);
    }
    super.dispose();
  }
}

/// PWA related constants
class PWAConstants {
  static const String defaultIcon = '/icons/Icon-192.png';
  static const String defaultTitle = 'Bukeer';
  static const Duration notificationDuration = Duration(seconds: 5);
  static const Duration updateCheckInterval = Duration(minutes: 30);
}
