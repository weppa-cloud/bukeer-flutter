import 'package:flutter/foundation.dart';

/// Stub implementation of PWA service for non-web platforms
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

/// Stub implementation for non-web platforms (mobile, desktop)
class _PWAServiceStubImpl extends PWAServiceImpl {
  @override
  bool get isInstallable => false;

  @override
  bool get isInstalled => false;

  @override
  bool get hasUpdate => false;

  @override
  String get displayMode => 'mobile';

  @override
  bool get isPWAContext => false;

  @override
  void initialize() {
    // No-op for non-web platforms
  }

  @override
  Future<bool> installApp() async => false;

  @override
  Future<void> reloadForUpdate() async {
    // No-op for non-web platforms
  }

  @override
  Future<bool> shareContent({
    required String title,
    required String text,
    String? url,
  }) async =>
      false;

  @override
  Future<bool> copyToClipboard(String text) async => false;

  @override
  bool get isOnline => true;

  @override
  Map<String, dynamic> getDeviceInfo() => {
        'platform': 'mobile',
        'isPWASupported': false,
      };

  @override
  Future<bool> showNotification({
    required String title,
    required String body,
    String? icon,
    String? tag,
  }) async =>
      false;

  @override
  Future<String?> registerForPushNotifications() async => null;

  @override
  Future<bool> toggleFullscreen() async => false;

  @override
  void trackEvent({
    required String event,
    Map<String, dynamic>? parameters,
  }) {
    // No-op for non-web platforms
  }

  @override
  Future<void> clearAppData() async {
    // No-op for non-web platforms
  }
}

PWAServiceImpl createPWAServiceImpl() => _PWAServiceStubImpl();
