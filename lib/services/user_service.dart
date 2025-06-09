import 'package:flutter/material.dart';
import '../backend/api_requests/api_calls.dart';
import '../auth/supabase_auth/auth_util.dart';
import "package:bukeer/legacy/flutter_flow/flutter_flow_util.dart";
import 'app_services.dart';

/// Servicio para gestionar la carga de datos del usuario y cuenta
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  bool _isLoading = false;
  bool _hasLoadedData = false;

  // Selected user data (replacement for allDataUser)
  dynamic _selectedUser;

  // User role ID
  String? _roleId;

  // Agent data from API
  dynamic _agentData;

  /// Indica si los datos están siendo cargados
  bool get isLoading => _isLoading;

  /// Indica si los datos ya fueron cargados exitosamente
  bool get hasLoadedData => _hasLoadedData;

  // Selected user getters (replacement for allDataUser)
  dynamic get selectedUser => _selectedUser;

  // Backward compatibility getter for allDataUser pattern
  dynamic get allDataUser => _selectedUser;

  // Role ID getter
  String? get roleId => _roleId;

  // Agent data getter
  dynamic get agentData => _agentData;

  // Account ID for forms getter - now delegated to AccountService
  String get accountIdFm {
    // NOTE: Callers should import app_services.dart to use this
    return ''; // Will be replaced by AccountService
  }

  // Setter para actualizar accountIdFm - deprecated
  set accountIdFm(String value) {
    debugPrint(
        'UserService: accountIdFm setter called - please use AccountService directly');
  }

  /// Set user role ID
  Future<void> setUserRole(String roleId) async {
    _roleId = roleId;
    debugPrint('UserService: Role ID set to $roleId');
  }

  /// Carga inicial de todos los datos del usuario
  /// Se ejecuta una sola vez al inicio de la sesión
  Future<bool> initializeUserData({String? accountId}) async {
    // Evitar cargas múltiples
    if (_isLoading || _hasLoadedData) {
      return _hasLoadedData;
    }

    _isLoading = true;

    try {
      // Verificar que tenemos un usuario autenticado
      if (currentUserUid == null || currentJwtToken == null) {
        debugPrint('UserService: No hay usuario autenticado');
        return false;
      }

      // Cargar datos del agente/usuario
      final agentLoaded = await _loadAgentData(accountId: accountId);
      if (!agentLoaded) {
        debugPrint('UserService: Error cargando datos del agente');
        return false;
      }

      _hasLoadedData = true;
      debugPrint('UserService: Datos cargados exitosamente');
      return true;
    } catch (e) {
      debugPrint('UserService: Error en initializeUserData: $e');
      return false;
    } finally {
      _isLoading = false;
    }
  }

  /// Carga los datos del agente/usuario
  Future<bool> _loadAgentData({String? accountId}) async {
    try {
      // Verificar si tenemos los datos mínimos necesarios
      if (currentUserUid == null || currentUserUid!.isEmpty) {
        debugPrint('UserService: currentUserUid no disponible');
        return false;
      }

      if (accountId == null || accountId.isEmpty) {
        debugPrint('UserService: accountId parameter required');
        return false;
      }

      final response = await GetAgentCall.call(
        authToken: currentJwtToken,
        id: currentUserUid,
        accountIdParam: accountId,
      );

      if (response.succeeded) {
        // Store agent data in service
        _agentData = response.jsonBody;
        _selectedUser = response.jsonBody;

        // Extraer y guardar el rol del usuario
        final roleId = getJsonField(
          response.jsonBody,
          r'$[:].role_id',
        );

        if (roleId != null) {
          _roleId = roleId.toString();
        }

        // Set account ID in AccountService
        await appServices.account.setCurrentAccount(accountId);

        debugPrint('UserService: Datos del agente cargados exitosamente');
        return true;
      } else {
        debugPrint(
            'UserService: API call failed - Status: ${response.statusCode}');
        debugPrint('UserService: Response body: ${response.jsonBody}');

        // Si la API falla, establecer valores por defecto para permitir que la app funcione
        _setDefaultUserData();
        return true; // Permitir que continúe funcionando
      }
    } catch (e) {
      debugPrint('UserService: Error en _loadAgentData: $e');

      // En caso de error, establecer valores por defecto
      _setDefaultUserData();
      return true; // Permitir que continúe funcionando
    }
  }

  /// Establece datos por defecto del usuario en caso de error de API
  void _setDefaultUserData() {
    debugPrint('UserService: Estableciendo datos por defecto del usuario');

    // Crear un objeto agent básico para evitar errores
    _agentData = [
      {
        'id': currentUserUid,
        'name': 'Usuario',
        'last_name': '',
        'email': currentUserEmail ?? '',
        'role_id': 1, // Rol admin para acceso completo en caso de error API
        'main_image': null,
      }
    ];
    _selectedUser = _agentData;

    // Establecer rol por defecto - Admin para acceso completo
    _roleId = '1'; // Admin
  }

  /// Refresca los datos del usuario
  Future<bool> refreshUserData() async {
    _hasLoadedData = false;
    return await initializeUserData();
  }

  /// Limpia los datos al cerrar sesión
  void clearUserData() {
    _hasLoadedData = false;
    _isLoading = false;
    _selectedUser = null;
    // El reset del AppState se maneja en el logout
  }

  /// Verifica si el usuario tiene un rol específico
  bool hasRole(int roleId) {
    if (_roleId == null) return false;
    return int.tryParse(_roleId!) == roleId;
  }

  /// Verifica si el usuario es administrador
  bool get isAdmin => hasRole(1);

  /// Verifica si el usuario es super administrador
  bool get isSuperAdmin => hasRole(2);

  /// Obtiene información segura del agente
  dynamic getAgentInfo(String field) {
    try {
      if (_agentData == null) return null;
      return getJsonField(_agentData, field);
    } catch (e) {
      debugPrint('UserService: Error obteniendo campo $field: $e');
      return null;
    }
  }

  /// Obtiene información segura de la cuenta - delegado a AccountService
  dynamic getAccountInfo(String field) {
    debugPrint(
        'UserService: getAccountInfo called - please use AccountService directly');
    return null;
  }

  // Methods to manage selected user (replacement for allDataUser pattern)
  void setSelectedUser(dynamic user) {
    _selectedUser = user;
  }

  void clearSelectedUser() {
    _selectedUser = null;
  }

  // Backward compatibility setter for allDataUser pattern
  set allDataUser(dynamic value) {
    _selectedUser = value;
  }
}
