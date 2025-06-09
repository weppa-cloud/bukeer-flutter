import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pwa_service.dart';
import 'package:bukeer/design_system/tokens/index.dart';

/// Banner that notifies users when an app update is available
class PWAUpdateBanner extends StatelessWidget {
  final VoidCallback? onDismiss;

  const PWAUpdateBanner({
    Key? key,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        if (!pwaService.hasUpdate) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade600,
                Colors.orange.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Update Icon
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    Icons.system_update,
                    color: Colors.orange.shade600,
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
                        'Actualización disponible',
                        style: BukeerTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Una nueva versión de Bukeer está lista para instalar',
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
                    // Update Button
                    ElevatedButton(
                      onPressed: () => _handleUpdate(context, pwaService),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Actualizar',
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
                          'Después',
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

  Future<void> _handleUpdate(
      BuildContext context, PWAService pwaService) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Track update
      pwaService.trackEvent(
        event: 'pwa_update_initiated',
        parameters: {'source': 'update_banner'},
      );

      // Reload app to apply update
      await pwaService.reloadForUpdate();
    } catch (e) {
      debugPrint('Error updating PWA: $e');

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al actualizar la aplicación'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

/// Floating action button for PWA updates
class PWAUpdateFAB extends StatelessWidget {
  const PWAUpdateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, child) {
        if (!pwaService.hasUpdate) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => _showUpdateDialog(context, pwaService),
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.system_update, color: Colors.white),
          label: const Text(
            'Actualizar',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, PWAService pwaService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.system_update, color: Colors.orange.shade600),
            const SizedBox(width: 8.0),
            const Text('Actualización disponible'),
          ],
        ),
        content: const Text(
          'Una nueva versión de Bukeer está disponible. '
          '¿Deseas actualizar ahora para obtener las últimas mejoras?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Después'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pwaService.reloadForUpdate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}

/// Notification dot indicator for updates
class PWAUpdateIndicator extends StatelessWidget {
  final Widget child;

  const PWAUpdateIndicator({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PWAService>(
      builder: (context, pwaService, widget) {
        if (!pwaService.hasUpdate) return child;

        return Stack(
          children: [
            child,
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
