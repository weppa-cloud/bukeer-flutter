import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pwa_service.dart';
import 'pwa_install_banner.dart';
import 'pwa_update_banner.dart';

/// Wrapper that provides PWA functionality to the entire app
class PWAWrapper extends StatefulWidget {
  final Widget child;
  final bool showInstallBanner;
  final bool showUpdateBanner;

  const PWAWrapper({
    Key? key,
    required this.child,
    this.showInstallBanner = true,
    this.showUpdateBanner = true,
  }) : super(key: key);

  @override
  State<PWAWrapper> createState() => _PWAWrapperState();
}

class _PWAWrapperState extends State<PWAWrapper> {
  bool _installBannerDismissed = false;
  bool _updateBannerDismissed = false;

  @override
  void initState() {
    super.initState();
    // Initialize PWA service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pwaService = context.read<PWAService>();
      pwaService.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        return Stack(
          children: [
            // Main app content
            widget.child,

            // PWA banners overlay
            if (widget.showInstallBanner || widget.showUpdateBanner)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Update banner (higher priority)
                      if (widget.showUpdateBanner &&
                          !_updateBannerDismissed &&
                          pwaService.hasUpdate)
                        PWAUpdateBanner(
                          onDismiss: () {
                            setState(() {
                              _updateBannerDismissed = true;
                            });
                          },
                        ),

                      // Install banner
                      if (widget.showInstallBanner &&
                          !_installBannerDismissed &&
                          pwaService.isInstallable &&
                          !pwaService.isInstalled &&
                          !pwaService
                              .hasUpdate) // Don't show both at the same time
                        PWAInstallBanner(
                          onDismiss: () {
                            setState(() {
                              _installBannerDismissed = true;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// PWA-aware scaffold that includes PWA functionality
class PWAScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool showPWAFeatures;

  const PWAScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.showPWAFeatures = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
      appBar: showPWAFeatures && appBar != null
          ? _enhanceAppBarWithPWA(appBar!)
          : appBar,
      body: body,
      floatingActionButton: _buildFloatingActionButton(context),
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
    );

    if (showPWAFeatures) {
      scaffold = PWAWrapper(child: scaffold);
    }

    return scaffold;
  }

  PreferredSizeWidget _enhanceAppBarWithPWA(PreferredSizeWidget appBar) {
    if (appBar is AppBar) {
      final actions = List<Widget>.from(appBar.actions ?? []);

      // Add PWA install button if not already present
      if (!actions.any((widget) => widget is PWAInstallButton)) {
        actions.insert(0, const PWAInstallButton());
      }

      return AppBar(
        title: appBar.title,
        leading: appBar.leading,
        automaticallyImplyLeading: appBar.automaticallyImplyLeading,
        actions: actions,
        backgroundColor: appBar.backgroundColor,
        foregroundColor: appBar.foregroundColor,
        elevation: appBar.elevation,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        titleTextStyle: appBar.titleTextStyle,
        toolbarTextStyle: appBar.toolbarTextStyle,
        primary: appBar.primary,
        centerTitle: appBar.centerTitle,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarOpacity: appBar.toolbarOpacity,
        bottomOpacity: appBar.bottomOpacity,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        bottom: appBar.bottom,
        flexibleSpace: appBar.flexibleSpace,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    }

    return appBar;
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        // If there's an update available, show update FAB
        if (pwaService.hasUpdate) {
          return const PWAUpdateFAB();
        }

        // Otherwise, show the regular FAB
        return floatingActionButton;
      },
    );
  }
}

/// PWA Status widget that shows connection and app state
class PWAStatusBar extends StatelessWidget {
  const PWAStatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        final isOnline = pwaService.isOnline;
        final isPWA = pwaService.isPWAContext;

        if (isOnline && !isPWA) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          color: isOnline ? Colors.green.shade100 : Colors.red.shade100,
          child: Row(
            children: [
              Icon(
                isOnline ? Icons.wifi : Icons.wifi_off,
                size: 16.0,
                color: isOnline ? Colors.green.shade700 : Colors.red.shade700,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  isOnline
                      ? (isPWA ? 'Aplicación instalada • En línea' : 'En línea')
                      : 'Sin conexión • Modo offline',
                  style: TextStyle(
                    fontSize: 12.0,
                    color:
                        isOnline ? Colors.green.shade700 : Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isPWA) const PWAStatusIndicator(),
            ],
          ),
        );
      },
    );
  }
}

/// Share button that uses Web Share API when available
class PWAShareButton extends StatelessWidget {
  final String title;
  final String text;
  final String? url;
  final Widget? fallbackWidget;

  const PWAShareButton({
    Key? key,
    required this.title,
    required this.text,
    this.url,
    this.fallbackWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        return IconButton(
          onPressed: () => _handleShare(context, pwaService),
          icon: const Icon(Icons.share),
          tooltip: 'Compartir',
        );
      },
    );
  }

  Future<void> _handleShare(BuildContext context, PWAService pwaService) async {
    final success = await pwaService.shareContent(
      title: title,
      text: text,
      url: url,
    );

    if (!success) {
      // Fallback to copying URL to clipboard
      final urlToCopy = url ?? 'https://bukeer.com';
      final copied = await pwaService.copyToClipboard(urlToCopy);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              copied
                  ? 'Enlace copiado al portapapeles'
                  : 'No se pudo compartir el contenido',
            ),
            backgroundColor: copied ? Colors.green : Colors.orange,
          ),
        );
      }
    }
  }
}
