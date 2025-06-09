import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:async';

/// Web implementation of PWA service
abstract class PWAServiceImpl extends ChangeNotifier {
  bool get isInstallable;
  bool get isInstalled;
  bool get hasUpdate;
  String get displayMode;
  bool get isPWAContext;

  void initialize();
  Future<bool> installApp();
  Future<void> reloadForUpdate();
  Future<bool> shareContent(
      {required String title, required String text, String? url});
  Future<bool> copyToClipboard(String text);
  bool get isOnline;
  Map<String, dynamic> getDeviceInfo();
  Future<bool> showNotification(
      {required String title, required String body, String? icon, String? tag});
  Future<String?> registerForPushNotifications();
  Future<bool> toggleFullscreen();
  void trackEvent({required String event, Map<String, dynamic>? parameters});
  Future<void> clearAppData();
}

class _PWAServiceWebImpl extends PWAServiceImpl {
  bool _isInstallable = false;
  bool _isInstalled = false;
  bool _hasUpdate = false;
  String _displayMode = 'browser';

  @override
  bool get isInstallable => _isInstallable;

  @override
  bool get isInstalled => _isInstalled;

  @override
  bool get hasUpdate => _hasUpdate;

  @override
  String get displayMode => _displayMode;

  @override
  bool get isPWAContext =>
      _displayMode == 'standalone' || _displayMode == 'twa';

  @override
  void initialize() {
    _checkDisplayMode();
    _setupPWAHandlers();
    _checkForUpdates();
  }

  void _checkDisplayMode() {
    try {
      // Check for PWA display mode using JavaScript
      final mode = js.context.callMethod('eval', [
            'window.getComputedStyle(document.documentElement).getPropertyValue("--pwa-display-mode")'
          ]) ??
          (html.window as dynamic).PWA_DISPLAY_MODE?.toString() ??
          'browser';
      _displayMode = mode.toString();
      _isInstalled = _displayMode == 'standalone' || _displayMode == 'twa';
      notifyListeners();
    } catch (e) {
      debugPrint('PWA: Error checking display mode: $e');
    }
  }

  void _setupPWAHandlers() {
    try {
      // Setup install prompt handler
      js.context['showInstallPrompt'] = js.allowInterop((prompt) {
        _isInstallable = true;
        notifyListeners();
      });

      // Setup update notification handler
      js.context['showUpdateNotification'] = js.allowInterop(() {
        _hasUpdate = true;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('PWA: Error setting up handlers: $e');
    }
  }

  void _checkForUpdates() {
    try {
      // This will be handled by the service worker
      // We just need to listen for the update event
    } catch (e) {
      debugPrint('PWA: Error checking for updates: $e');
    }
  }

  @override
  Future<bool> installApp() async {
    if (!_isInstallable) return false;

    try {
      // Call the install prompt from JavaScript
      final result = await (html.window as dynamic).callMethod('installPWA');
      if (result == true) {
        _isInstallable = false;
        _isInstalled = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('PWA: Error installing app: $e');
    }
    return false;
  }

  @override
  Future<void> reloadForUpdate() async {
    if (!_hasUpdate) return;

    try {
      html.window.location.reload();
    } catch (e) {
      debugPrint('PWA: Error reloading app: $e');
    }
  }

  @override
  Future<bool> shareContent({
    required String title,
    required String text,
    String? url,
  }) async {
    try {
      final navigator = html.window.navigator;
      if ((navigator as dynamic).share != null) {
        final shareData = {
          'title': title,
          'text': text,
          if (url != null) 'url': url,
        };

        await (navigator as dynamic).callMethod('share', [shareData]);
        return true;
      }
    } catch (e) {
      debugPrint('PWA: Error sharing content: $e');
    }
    return false;
  }

  @override
  Future<bool> copyToClipboard(String text) async {
    try {
      if (html.window.navigator.clipboard != null) {
        await html.window.navigator.clipboard!.writeText(text);
        return true;
      }
    } catch (e) {
      debugPrint('PWA: Error copying to clipboard: $e');
    }
    return false;
  }

  @override
  bool get isOnline {
    return html.window.navigator.onLine ?? true;
  }

  @override
  Map<String, dynamic> getDeviceInfo() {
    try {
      final navigator = html.window.navigator;
      return {
        'userAgent': navigator.userAgent,
        'platform': navigator.platform,
        'language': navigator.language,
        'cookieEnabled': navigator.cookieEnabled,
        'onLine': navigator.onLine,
        'displayMode': _displayMode,
        'isPWAInstalled': _isInstalled,
        'screenWidth': html.window.screen?.width,
        'screenHeight': html.window.screen?.height,
        'viewport': {
          'width': html.window.innerWidth,
          'height': html.window.innerHeight,
        },
      };
    } catch (e) {
      debugPrint('PWA: Error getting device info: $e');
      return {};
    }
  }

  @override
  Future<bool> showNotification({
    required String title,
    required String body,
    String? icon,
    String? tag,
  }) async {
    try {
      // Check if notifications are supported and permitted
      final permission = await html.Notification.requestPermission();
      if (permission != 'granted') return false;

      final notification = html.Notification(
        title,
        body: body,
        icon: icon ?? '/icons/Icon-192.png',
        tag: tag,
      );

      // Auto-close after 5 seconds
      Timer(Duration(seconds: 5), () {
        notification.close();
      });

      return true;
    } catch (e) {
      debugPrint('PWA: Error showing notification: $e');
      return false;
    }
  }

  @override
  Future<String?> registerForPushNotifications() async {
    try {
      final registration = await html.window.navigator.serviceWorker?.ready;
      if (registration == null) return null;

      // This would need a proper implementation with push service
      // For now, we just return a placeholder token
      return 'pwa_push_token_placeholder';
    } catch (e) {
      debugPrint('PWA: Error registering for push notifications: $e');
      return null;
    }
  }

  @override
  Future<bool> toggleFullscreen() async {
    try {
      final document = html.document;
      if (document.fullscreenElement != null) {
        document.exitFullscreen();
        return false;
      } else {
        await document.documentElement?.requestFullscreen();
        return true;
      }
    } catch (e) {
      debugPrint('PWA: Error toggling fullscreen: $e');
      return false;
    }
  }

  @override
  void trackEvent({
    required String event,
    Map<String, dynamic>? parameters,
  }) {
    try {
      // Send to analytics if available
      if ((html.window as dynamic).gtag != null) {
        (html.window as dynamic).callMethod('gtag', [
          'event',
          event,
          {
            'event_category': 'PWA',
            'custom_parameters': parameters ?? {},
            'display_mode': _displayMode,
            'is_installed': _isInstalled,
            ...?parameters,
          }
        ]);
      }
    } catch (e) {
      debugPrint('PWA: Error tracking event: $e');
    }
  }

  @override
  Future<void> clearAppData() async {
    try {
      // Clear cache storage
      final cacheNames = await html.window.caches?.keys();
      if (cacheNames != null) {
        for (final cacheName in cacheNames) {
          await html.window.caches?.delete(cacheName);
        }
      }

      // Clear local storage
      html.window.localStorage.clear();
      html.window.sessionStorage.clear();

      debugPrint('PWA: App data cleared successfully');
    } catch (e) {
      debugPrint('PWA: Error clearing app data: $e');
    }
  }
}

PWAServiceImpl createPWAServiceImpl() => _PWAServiceWebImpl();
