import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/app_services.dart';

void main() {
  group('PWA Service Tests', () {
    late AppServices appServices;

    setUp(() {
      appServices = AppServices();
    });

    test('PWA service initializes without errors', () {
      expect(() => appServices.pwa, returnsNormally);
    });

    test('PWA service has default stub values on non-web platforms', () {
      final pwaService = appServices.pwa;

      expect(pwaService.isInstallable, false);
      expect(pwaService.isInstalled, false);
      expect(pwaService.hasUpdate, false);
      expect(pwaService.displayMode, 'mobile');
      expect(pwaService.isPWAContext, false);
      expect(pwaService.isOnline, true);
    });

    test('PWA service methods return appropriate defaults', () async {
      final pwaService = appServices.pwa;

      expect(await pwaService.installApp(), false);
      expect(await pwaService.shareContent(title: 'Test', text: 'Test'), false);
      expect(await pwaService.copyToClipboard('test'), false);
      expect(await pwaService.showNotification(title: 'Test', body: 'Test'),
          false);
      expect(await pwaService.registerForPushNotifications(), null);
      expect(await pwaService.toggleFullscreen(), false);
    });

    test('PWA service device info returns mobile platform info', () {
      final pwaService = appServices.pwa;
      final deviceInfo = pwaService.getDeviceInfo();

      // On non-web platforms, getDeviceInfo returns an empty map
      expect(deviceInfo, isA<Map<String, dynamic>>());
    });

    test('PWA service app info is correct', () {
      final pwaService = appServices.pwa;
      final appInfo = pwaService.getAppInfo();

      expect(appInfo['version'], '2.0.0');
      expect(appInfo['platform'], 'mobile');
      expect(appInfo['displayMode'], 'mobile');
      expect(appInfo.containsKey('buildMode'), true);
      expect(appInfo.containsKey('timestamp'), true);
    });
  });
}
