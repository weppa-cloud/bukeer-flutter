import 'package:flutter/foundation.dart';
import '../backend/supabase/supabase.dart';
import '../backend/api_requests/api_calls.dart';
import '../auth/supabase_auth/auth_util.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'base_service.dart';

/// Service for managing account-related data
class AccountService extends BaseService {
  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();

  // Account data
  dynamic _accountData;
  List<dynamic> _currency = [];
  List<dynamic> _typesIncrease = [];
  List<dynamic> _paymentMethods = [];

  // Current account ID
  String? _currentAccountId;

  // Getters
  dynamic get accountData => _accountData;
  List<dynamic> get currency => List.unmodifiable(_currency);
  List<dynamic> get typesIncrease => List.unmodifiable(_typesIncrease);
  List<dynamic> get paymentMethods => List.unmodifiable(_paymentMethods);
  String? get currentAccountId => _currentAccountId;
  
  // Additional getters for compatibility
  String? get accountId => _currentAccountId;
  List<dynamic>? get accountCurrency => _currency.isEmpty ? null : _currency;
  List<dynamic>? get accountTypesIncrease => _typesIncrease.isEmpty ? null : _typesIncrease;
  List<dynamic>? get accountPaymentMethods => _paymentMethods.isEmpty ? null : _paymentMethods;

  /// Get account ID for forms (includes dash)
  String get accountIdFm {
    if (_accountData == null) return '';
    final idFm = getJsonField(_accountData, r'$.id_fm')?.toString() ?? '';
    return idFm.isNotEmpty ? '$idFm-' : '';
  }

  /// Set current account ID and load account data
  Future<void> setCurrentAccount(String accountId) async {
    if (_currentAccountId == accountId && _accountData != null) {
      return; // Already loaded
    }

    _currentAccountId = accountId;
    await loadAccountData();
  }
  
  /// Set account ID (alias for setCurrentAccount for backward compatibility)
  Future<void> setAccountId(String accountId, {bool loadData = true}) async {
    _currentAccountId = accountId;
    if (loadData) {
      await loadAccountData();
    }
    notifyListeners();
  }
  
  /// Set account ID for forms
  Future<void> setAccountIdFm(String accountIdFm) async {
    // Store the ID FM value directly for forms
    if (_accountData == null) {
      _accountData = {};
    }
    _accountData['id_fm'] = accountIdFm.replaceAll('-', '');
    notifyListeners();
  }

  /// Load account data
  Future<void> loadAccountData() async {
    if (_currentAccountId == null) return;

    await loadData(() async {
      // Get account data
      final accountResponse = await AccountsTable().queryRows(
        queryFn: (q) => q.eq('id', _currentAccountId!),
      );

      if (accountResponse.isNotEmpty) {
        _accountData = {
          'id': accountResponse.first.id,
          'name': accountResponse.first.name,
          'id_fm': accountResponse.first.idFm,
          // Add other fields as needed
        };

        // Load account configuration
        await _loadAccountConfiguration();
      }
    });
  }

  /// Load account configuration (currency, payment methods, etc.)
  Future<void> _loadAccountConfiguration() async {
    if (_currentAccountId == null) return;

    // For now, we'll initialize with empty arrays
    // These will be populated when creating/updating itineraries
    // or through specific account configuration endpoints
    _currency = [];
    _typesIncrease = [];
    _paymentMethods = [];

    // TODO: Implement proper API calls when endpoints are available
    debugPrint('AccountService: Account configuration loaded (placeholder)');

    notifyListeners();
  }

  /// Update account currency
  Future<void> updateCurrency(List<dynamic> newCurrency) async {
    _currency = List.from(newCurrency);
    notifyListeners();
  }

  /// Update payment methods
  Future<void> updatePaymentMethods(List<dynamic> newMethods) async {
    _paymentMethods = List.from(newMethods);
    notifyListeners();
  }

  /// Update types increase
  Future<void> updateTypesIncrease(List<dynamic> newTypes) async {
    _typesIncrease = List.from(newTypes);
    notifyListeners();
  }

  /// Get currency by name
  dynamic getCurrencyByName(String name) {
    try {
      return _currency.firstWhere(
        (c) => getJsonField(c, r'$.name')?.toString() == name,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get payment method by name
  dynamic getPaymentMethodByName(String name) {
    try {
      return _paymentMethods.firstWhere(
        (p) => getJsonField(p, r'$.name')?.toString() == name,
      );
    } catch (_) {
      return null;
    }
  }

  /// Clear all data
  void clearData() {
    _accountData = null;
    _currency = [];
    _typesIncrease = [];
    _paymentMethods = [];
    _currentAccountId = null;
    notifyListeners();
  }

  /// Initialize service
  @override
  Future<void> initialize() async {
    // This will be called when user logs in
    // The currentAccountId should be set from UserService
    if (_currentAccountId != null) {
      await loadAccountData();
    }
  }
}
