import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pwa_service.dart';
import 'package:bukeer/design_system/tokens/index.dart';

/// Banner widget that prompts users to install the PWA
class PWAInstallBanner extends StatelessWidget {
  final VoidCallback? onDismiss;
  final bool showOnlyIfInstallable;

  const PWAInstallBanner({
    Key? key,
    this.onDismiss,
    this.showOnlyIfInstallable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        // Don't show if already installed or not installable
        if (pwaService.isInstalled) return const SizedBox.shrink();
        if (showOnlyIfInstallable && !pwaService.isInstallable) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                BukeerColors.primary,
                BukeerColors.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: BukeerColors.primary.withOpacity(0.3),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // App Icon
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    Icons.get_app,
                    color: BukeerColors.primary,
                    size: 28.0,
                  ),
                ),

                const SizedBox(width: 16.0),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Instalar Bukeer',
                        style: BukeerTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Accede más rápido a tu plataforma de gestión de viajes',
                        style: BukeerTypography.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16.0),

                // Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Install Button
                    ElevatedButton(
                      onPressed: () => _handleInstall(context, pwaService),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: BukeerColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Instalar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),

                    // Dismiss Button
                    if (onDismiss != null)
                      TextButton(
                        onPressed: onDismiss,
                        child: Text(
                          'Ahora no',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleInstall(
      BuildContext context, PWAService pwaService) async {
    try {
      final success = await pwaService.installApp();

      if (success) {
        // Track installation
        pwaService.trackEvent(
          event: 'pwa_install_success',
          parameters: {'source': 'install_banner'},
        );

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('¡Bukeer instalado exitosamente!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Call dismiss callback
        onDismiss?.call();
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No se pudo instalar la aplicación'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error installing PWA: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error durante la instalación'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

/// Compact PWA install button for navigation bars
class PWAInstallButton extends StatelessWidget {
  const PWAInstallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        if (pwaService.isInstalled || !pwaService.isInstallable) {
          return const SizedBox.shrink();
        }

        return IconButton(
          onPressed: () => _showInstallDialog(context, pwaService),
          icon: const Icon(Icons.get_app),
          tooltip: 'Instalar aplicación',
        );
      },
    );
  }

  void _showInstallDialog(BuildContext context, PWAService pwaService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.get_app, color: BukeerColors.primary),
            const SizedBox(width: 8.0),
            const Text('Instalar Bukeer'),
          ],
        ),
        content: const Text(
          'Instala Bukeer en tu dispositivo para un acceso más rápido y una mejor experiencia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pwaService.installApp();
            },
            child: const Text('Instalar'),
          ),
        ],
      ),
    );
  }
}

/// Status indicator showing PWA state
class PWAStatusIndicator extends StatelessWidget {
  const PWAStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        if (!pwaService.isPWAContext) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: BukeerColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: BukeerColors.primary.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mobile_friendly,
                size: 14.0,
                color: BukeerColors.primary,
              ),
              const SizedBox(width: 4.0),
              Text(
                'PWA',
                style: BukeerTypography.labelSmall.copyWith(
                  color: BukeerColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
