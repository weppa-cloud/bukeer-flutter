import 'package:flutter/material.dart';
import '../services/base_service.dart';

/// Widget builder that listens to service changes and rebuilds UI
/// Handles loading, error, and data states automatically
class ServiceBuilder<T extends BaseService> extends StatelessWidget {
  final T service;
  final Widget Function(BuildContext context, T service) builder;
  final Widget? loadingWidget;
  final Widget Function(String error)? errorBuilder;
  final bool showLoadingOverlay;
  
  const ServiceBuilder({
    Key? key,
    required this.service,
    required this.builder,
    this.loadingWidget,
    this.errorBuilder,
    this.showLoadingOverlay = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: service,
      builder: (context, child) {
        // Show error state if there's an error
        if (service.hasError && errorBuilder != null) {
          return errorBuilder!(service.errorMessage!);
        }
        
        // Show loading overlay if enabled
        if (service.isLoading && showLoadingOverlay) {
          return Stack(
            children: [
              builder(context, service),
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: Center(
                    child: loadingWidget ?? const CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        }
        
        // Show loading widget if provided and loading
        if (service.isLoading && loadingWidget != null && !showLoadingOverlay) {
          return loadingWidget!;
        }
        
        // Normal builder
        return builder(context, service);
      },
    );
  }
}

/// Convenience widget for building with multiple services
class MultiServiceBuilder extends StatelessWidget {
  final List<BaseService> services;
  final Widget Function(BuildContext context) builder;
  final Widget? loadingWidget;
  final Widget Function(String error)? errorBuilder;
  
  const MultiServiceBuilder({
    Key? key,
    required this.services,
    required this.builder,
    this.loadingWidget,
    this.errorBuilder,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(services),
      builder: (context, child) {
        // Check if any service has error
        final errorService = services.firstWhere(
          (s) => s.hasError,
          orElse: () => services.first,
        );
        
        if (errorService.hasError && errorBuilder != null) {
          return errorBuilder!(errorService.errorMessage!);
        }
        
        // Check if any service is loading
        final isAnyLoading = services.any((s) => s.isLoading);
        
        if (isAnyLoading && loadingWidget != null) {
          return loadingWidget!;
        }
        
        return builder(context);
      },
    );
  }
}