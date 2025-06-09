import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../legacy/flutter_flow/flutter_flow_theme.dart';

/// Widget wrapper que garantiza que los datos del usuario estén cargados
/// antes de mostrar el contenido
class UserDataWrapper extends StatefulWidget {
  const UserDataWrapper({
    super.key,
    required this.child,
    this.loadingWidget,
    this.errorWidget,
  });

  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  @override
  State<UserDataWrapper> createState() => _UserDataWrapperState();
}

class _UserDataWrapperState extends State<UserDataWrapper> {
  final UserService _userService = UserService();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Si los datos ya están cargados, no hacer nada
    if (_userService.hasLoadedData) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Cargar datos
    final success = await _userService.initializeUserData();

    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError = !success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ?? _buildDefaultLoadingWidget();
    }

    if (_hasError) {
      return widget.errorWidget ?? _buildDefaultErrorWidget();
    }

    return widget.child;
  }

  Widget _buildDefaultLoadingWidget() {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Cargando información...',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: FlutterFlowTheme.of(context).error,
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar los datos',
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Por favor, intenta recargar la página',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _initializeData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Reintentar',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
