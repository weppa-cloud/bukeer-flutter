import 'package:flutter/material.dart';
import '../backend/api_requests/api_calls.dart';
import '../auth/supabase_auth/auth_util.dart';
import '../app_state_clean.dart';
import '../flutter_flow/flutter_flow_util.dart';

/// Servicio para gestionar la carga de datos del usuario y cuenta
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  bool _isLoading = false;
  bool _hasLoadedData = false;

  // Selected user data (replacement for allDataUser)
  dynamic _selectedUser;

  /// Indica si los datos están siendo cargados
  bool get isLoading => _isLoading;

  /// Indica si los datos ya fueron cargados exitosamente
  bool get hasLoadedData => _hasLoadedData;

  // Selected user getters (replacement for allDataUser)
  dynamic get selectedUser => _selectedUser;
  
  // Backward compatibility getter for allDataUser pattern
  dynamic get allDataUser => _selectedUser;

  /// Carga inicial de todos los datos del usuario
  /// Se ejecuta una sola vez al inicio de la sesión
  Future<bool> initializeUserData() async {
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
      final agentLoaded = await _loadAgentData();
      if (!agentLoaded) {
        debugPrint('UserService: Error cargando datos del agente');
        return false;
      }

      // Cargar datos de la cuenta
      final accountLoaded = await _loadAccountData();
      if (!accountLoaded) {
        debugPrint('UserService: Error cargando datos de la cuenta');
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
  Future<bool> _loadAgentData() async {
    try {
      final response = await GetAgentCall.call(
        authToken: currentJwtToken,
        id: currentUserUid,
        accountIdParam: FFAppState().accountId,
      );

      if (response.succeeded) {
        FFAppState().agent = response.jsonBody;

        // Extraer y guardar el rol del usuario
        final roleId = getJsonField(
          response.jsonBody,
          r'$[:].role_id',
        );

        if (roleId != null) {
          FFAppState().idRole = int.tryParse(roleId.toString()) ?? 0;
        }

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('UserService: Error en _loadAgentData: $e');
      return false;
    }
  }

  /// Carga los datos de la cuenta
  Future<bool> _loadAccountData() async {
    try {
      final response = await GetAllDataAccountWithLocationCall.call(
        authToken: currentJwtToken,
        accountId: FFAppState().accountId,
      );

      if (response.succeeded) {
        final jsonBody = response.jsonBody;
        FFAppState().allDataAccount = jsonBody;

        // Extraer configuraciones de la cuenta
        _extractAccountSettings(jsonBody);

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('UserService: Error en _loadAccountData: $e');
      return false;
    }
  }

  /// Extrae y guarda las configuraciones de la cuenta
  void _extractAccountSettings(dynamic accountData) {
    try {
      // Monedas
      final currencies = getJsonField(
        accountData,
        r'$[:].currency',
        true,
      );
      if (currencies != null) {
        FFAppState().accountCurrency = currencies.toList().cast<dynamic>();
      }

      // Tipos de incremento
      final typesIncrease = getJsonField(
        accountData,
        r'$[:].types_increase',
        true,
      );
      if (typesIncrease != null) {
        FFAppState().accountTypesIncrease =
            typesIncrease.toList().cast<dynamic>();
      }

      // Métodos de pago
      final paymentMethods = getJsonField(
        accountData,
        r'$[:].payment_methods',
        true,
      );
      if (paymentMethods != null) {
        FFAppState().accountPaymentMethods =
            paymentMethods.toList().cast<dynamic>();
      }

      // ID de la cuenta en FM
      final accountIdFm = getJsonField(
        accountData,
        r'$[:].id_fm',
      );
      if (accountIdFm != null) {
        FFAppState().accountIdFm = accountIdFm.toString();
      }
    } catch (e) {
      debugPrint('UserService: Error en _extractAccountSettings: $e');
    }
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
    // El reset del AppState se maneja en el logout
  }

  /// Verifica si el usuario tiene un rol específico
  bool hasRole(int roleId) {
    return FFAppState().idRole == roleId;
  }

  /// Verifica si el usuario es administrador
  bool get isAdmin => hasRole(1);

  /// Verifica si el usuario es super administrador
  bool get isSuperAdmin => hasRole(2);

  /// Obtiene información segura del agente
  dynamic getAgentInfo(String field) {
    try {
      if (FFAppState().agent == null) return null;
      return getJsonField(FFAppState().agent, field);
    } catch (e) {
      debugPrint('UserService: Error obteniendo campo $field: $e');
      return null;
    }
  }

  /// Obtiene información segura de la cuenta
  dynamic getAccountInfo(String field) {
    try {
      if (FFAppState().allDataAccount == null) return null;
      return getJsonField(FFAppState().allDataAccount, field);
    } catch (e) {
      debugPrint('UserService: Error obteniendo campo $field: $e');
      return null;
    }
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
