import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Cleaned up FFAppState with only essential global state
/// All temporary UI state has been migrated to specialized services
class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();

    // Load persisted state
    _safeInit(() {
      _accountId = prefs.getString('ff_accountId') ?? _accountId;
    });
    _safeInit(() {
      _idRole = prefs.getInt('ff_idRole') ?? _idRole;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_agent')) {
        try {
          _agent = jsonDecode(prefs.getString('ff_agent') ?? '');
        } catch (e) {
          debugPrint("Can't decode persisted agent data. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _accountIdFm = prefs.getString('ff_accountIdFm') ?? _accountIdFm;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_allDataAccount')) {
        try {
          _allDataAccount =
              jsonDecode(prefs.getString('ff_allDataAccount') ?? '');
        } catch (e) {
          debugPrint("Can't decode persisted account data. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _accountCurrency =
          prefs.getStringList('ff_accountCurrency')?.cast<dynamic>() ??
              _accountCurrency;
    });
    _safeInit(() {
      _accountPaymentMethods =
          prefs.getStringList('ff_accountPaymentMethods')?.cast<dynamic>() ??
              _accountPaymentMethods;
    });
    _safeInit(() {
      _accountTypesIncrease =
          prefs.getStringList('ff_accountTypesIncrease')?.cast<dynamic>() ??
              _accountTypesIncrease;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  // ===========================================================================
  // ESSENTIAL GLOBAL STATE - Core user and account data
  // ===========================================================================

  /// Current user's account ID (multi-tenancy)
  String _accountId = '';
  String get accountId => _accountId;
  set accountId(String value) {
    _accountId = value;
    prefs.setString('ff_accountId', value);
  }

  /// User's role ID for permissions
  int _idRole = 0;
  int get idRole => _idRole;
  set idRole(int value) {
    _idRole = value;
    prefs.setInt('ff_idRole', value);
  }

  /// Current agent/user data
  dynamic _agent;
  dynamic get agent => _agent;
  set agent(dynamic value) {
    _agent = value;
    prefs.setString('ff_agent', jsonEncode(value));
  }

  /// Account ID for FlutterFlow integration
  String _accountIdFm = '';
  String get accountIdFm => _accountIdFm;
  set accountIdFm(String value) {
    _accountIdFm = value;
    prefs.setString('ff_accountIdFm', value);
  }

  /// Complete account data object
  dynamic _allDataAccount;
  dynamic get allDataAccount => _allDataAccount;
  set allDataAccount(dynamic value) {
    _allDataAccount = value;
    prefs.setString('ff_allDataAccount', jsonEncode(value));
  }

  // ===========================================================================
  // APP-WIDE CONFIGURATION - Settings that affect the entire app
  // ===========================================================================

  /// Available currencies for the account
  List<dynamic> _accountCurrency = [];
  List<dynamic> get accountCurrency => _accountCurrency;
  set accountCurrency(List<dynamic> value) {
    _accountCurrency = value;
    prefs.setStringList(
        'ff_accountCurrency', value.map((e) => e.toString()).toList());
  }

  /// Available payment methods for the account
  List<dynamic> _accountPaymentMethods = [];
  List<dynamic> get accountPaymentMethods => _accountPaymentMethods;
  set accountPaymentMethods(List<dynamic> value) {
    _accountPaymentMethods = value;
    prefs.setStringList(
        'ff_accountPaymentMethods', value.map((e) => e.toString()).toList());
  }

  /// Account types for profit calculation
  List<dynamic> _accountTypesIncrease = [];
  List<dynamic> get accountTypesIncrease => _accountTypesIncrease;
  set accountTypesIncrease(List<dynamic> value) {
    _accountTypesIncrease = value;
    prefs.setStringList(
        'ff_accountTypesIncrease', value.map((e) => e.toString()).toList());
  }

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  void _safeInit(VoidCallback callback) {
    try {
      callback();
    } catch (e) {
      debugPrint('FFAppState initialization error: $e');
    }
  }

  /// Clear all persisted data (used during logout)
  void clearPersistedData() {
    prefs.remove('ff_accountId');
    prefs.remove('ff_idRole');
    prefs.remove('ff_agent');
    prefs.remove('ff_accountIdFm');
    prefs.remove('ff_allDataAccount');
    prefs.remove('ff_accountCurrency');
    prefs.remove('ff_accountPaymentMethods');
    prefs.remove('ff_accountTypesIncrease');
  }
}
