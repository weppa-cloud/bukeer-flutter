import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state_clean.dart';
import '../services/ui_state_service.dart';
import '../services/app_services.dart';

/// Central provider setup for the entire app
/// Provides clean separation between global app state and local UI state
class AppProviders extends StatelessWidget {
  final Widget child;
  final FFAppState appState;

  const AppProviders({
    Key? key,
    required this.child,
    required this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global app state (user, account, configuration)
        ChangeNotifierProvider<FFAppState>.value(
          value: appState,
        ),

        // UI state service (temporary UI state)
        ChangeNotifierProvider<UiStateService>(
          create: (_) => UiStateService(),
        ),

        // Data services (with their own state management)
        // Note: UserService doesn't extend ChangeNotifier, using Provider instead
        Provider.value(
          value: appServices.user,
        ),
        ChangeNotifierProvider.value(
          value: appServices.itinerary,
        ),
        ChangeNotifierProvider.value(
          value: appServices.product,
        ),
        ChangeNotifierProvider.value(
          value: appServices.contact,
        ),
        ChangeNotifierProvider.value(
          value: appServices.authorization,
        ),
        ChangeNotifierProvider.value(
          value: appServices.error,
        ),
      ],
      child: child,
    );
  }
}

/// Helper extensions for easy access to services
extension AppProvidersContext on BuildContext {
  FFAppState get appState => read<FFAppState>();
  UiStateService get uiState => read<UiStateService>();

  // Watch for changes
  FFAppState get watchAppState => watch<FFAppState>();
  UiStateService get watchUiState => watch<UiStateService>();
}
