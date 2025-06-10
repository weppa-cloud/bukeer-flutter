import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// Widget que muestra un banner indicando el entorno actual
/// Solo se muestra en entornos que no son producción
class EnvironmentBanner extends StatelessWidget {
  final Widget child;

  const EnvironmentBanner({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Solo mostrar en entornos que no son producción
    if (AppConfig.isProduction) {
      return child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: AppConfig.environment.toUpperCase(),
        location: BannerLocation.topEnd,
        color: _getBannerColor(),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        child: child,
      ),
    );
  }

  Color _getBannerColor() {
    if (AppConfig.isLocal) {
      return Colors.blue;
    } else if (AppConfig.isStaging) {
      return Colors.orange;
    } else if (AppConfig.isDevelopment) {
      return Colors.green;
    }
    return Colors.grey;
  }
}

/// Widget alternativo que muestra una barra inferior con información del entorno
class EnvironmentInfoBar extends StatelessWidget {
  const EnvironmentInfoBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Solo mostrar en entornos que no son producción
    if (AppConfig.isProduction) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: _getBarColor().withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEnvironmentIcon(),
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            'Entorno: ${AppConfig.environment.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '• ${Uri.parse(AppConfig.supabaseUrl).host}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBarColor() {
    if (AppConfig.isLocal) {
      return Colors.blue;
    } else if (AppConfig.isStaging) {
      return Colors.orange;
    } else if (AppConfig.isDevelopment) {
      return Colors.green;
    }
    return Colors.grey;
  }

  IconData _getEnvironmentIcon() {
    if (AppConfig.isLocal) {
      return Icons.computer;
    } else if (AppConfig.isStaging) {
      return Icons.science;
    } else if (AppConfig.isDevelopment) {
      return Icons.build;
    }
    return Icons.info;
  }
}
