import 'package:flutter/material.dart';
import 'backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

/// Cleaned up FFAppState with only essential global state
/// Removed temporary UI state and component-specific variables
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
  // TEMPORARY LEGACY SUPPORT - To be migrated later
  // ===========================================================================

  /// Location state for product filtering (temporary)
  String _locationState = '';
  String get locationState => _locationState;
  set locationState(String value) {
    _locationState = value;
    notifyListeners();
  }

  /// Selected payment method name (temporary)
  String _namePaymentMethods = '';
  String get namePaymentMethods => _namePaymentMethods;
  set namePaymentMethods(String value) {
    _namePaymentMethods = value;
    notifyListeners();
  }

  /// Legacy location properties (should be migrated to UiStateService)
  String _latlngLocation = '';
  String get latlngLocation => _latlngLocation;
  set latlngLocation(String value) {
    _latlngLocation = value;
    notifyListeners();
  }

  String _nameLocation = '';
  String get nameLocation => _nameLocation;
  set nameLocation(String value) {
    _nameLocation = value;
    notifyListeners();
  }

  String _addressLocation = '';
  String get addressLocation => _addressLocation;
  set addressLocation(String value) {
    _addressLocation = value;
    notifyListeners();
  }

  String _cityLocation = '';
  String get cityLocation => _cityLocation;
  set cityLocation(String value) {
    _cityLocation = value;
    notifyListeners();
  }

  String _stateLocation = '';
  String get stateLocation => _stateLocation;
  set stateLocation(String value) {
    _stateLocation = value;
    notifyListeners();
  }

  String _countryLocation = '';
  String get countryLocation => _countryLocation;
  set countryLocation(String value) {
    _countryLocation = value;
    notifyListeners();
  }

  String _zipCodeLocation = '';
  String get zipCodeLocation => _zipCodeLocation;
  set zipCodeLocation(String value) {
    _zipCodeLocation = value;
    notifyListeners();
  }

  /// Additional temporary properties needed for compilation
  bool _selectRates = false;
  bool get selectRates => _selectRates;
  set selectRates(bool value) {
    _selectRates = value;
    notifyListeners();
  }

  dynamic _itemsProducts;
  dynamic get itemsProducts => _itemsProducts;
  set itemsProducts(dynamic value) {
    _itemsProducts = value;
    notifyListeners();
  }

  String _searchStringState = '';
  String get searchStringState => _searchStringState;
  set searchStringState(String value) {
    _searchStringState = value;
    notifyListeners();
  }

  bool _isCreatedinItinerary = false;
  bool get isCreatedinItinerary => _isCreatedinItinerary;
  set isCreatedinItinerary(bool value) {
    _isCreatedinItinerary = value;
    notifyListeners();
  }

  dynamic _itemsContact;
  dynamic get itemsContact => _itemsContact;
  set itemsContact(dynamic value) {
    _itemsContact = value;
    notifyListeners();
  }

  dynamic _allDataHotel;
  dynamic get allDataHotel => _allDataHotel;
  set allDataHotel(dynamic value) {
    _allDataHotel = value;
    notifyListeners();
  }

  dynamic _allDataTransfer;
  dynamic get allDataTransfer => _allDataTransfer;
  set allDataTransfer(dynamic value) {
    _allDataTransfer = value;
    notifyListeners();
  }

  dynamic _allDataActivity;
  dynamic get allDataActivity => _allDataActivity;
  set allDataActivity(dynamic value) {
    _allDataActivity = value;
    notifyListeners();
  }

  dynamic _allDataFlight;
  dynamic get allDataFlight => _allDataFlight;
  set allDataFlight(dynamic value) {
    _allDataFlight = value;
    notifyListeners();
  }

  dynamic _allDataContact;
  dynamic get allDataContact => _allDataContact;
  set allDataContact(dynamic value) {
    _allDataContact = value;
    notifyListeners();
  }

  dynamic _allDataItinerary;
  dynamic get allDataItinerary => _allDataItinerary;
  set allDataItinerary(dynamic value) {
    _allDataItinerary = value;
    notifyListeners();
  }

  dynamic _allDataUser;
  dynamic get allDataUser => _allDataUser;
  set allDataUser(dynamic value) {
    _allDataUser = value;
    notifyListeners();
  }

  /// Flight-related temporary state
  String _departureState = '';
  String get departureState => _departureState;
  set departureState(String value) {
    _departureState = value;
    notifyListeners();
  }

  String _arrivalState = '';
  String get arrivalState => _arrivalState;
  set arrivalState(String value) {
    _arrivalState = value;
    notifyListeners();
  }

  /// Product type for filtering
  int _typeProduct = 1;
  int get typeProduct => _typeProduct;
  set typeProduct(int value) {
    _typeProduct = value;
    notifyListeners();
  }

  /// Image main URL
  String _imageMain = '';
  String get imageMain => _imageMain;
  set imageMain(String value) {
    _imageMain = value;
    notifyListeners();
  }

  /// Selected passenger data
  dynamic _allDataPassenger;
  dynamic get allDataPassenger => _allDataPassenger;
  set allDataPassenger(dynamic value) {
    _allDataPassenger = value;
    notifyListeners();
  }

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  /// Safe initialization helper
  void _safeInit(Function() initFunction) {
    try {
      initFunction();
    } catch (e) {
      debugPrint('Error during app state initialization: $e');
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _accountId.isNotEmpty && _agent != null;

  /// Check if user is admin
  bool get isAdmin => _idRole == 1 || _idRole == 2;

  /// Check if user is super admin
  bool get isSuperAdmin => _idRole == 2;

  /// Get current user name safely
  String get currentUserName {
    try {
      final name = getJsonField(_agent, r'$[:].name')?.toString() ?? '';
      final lastName =
          getJsonField(_agent, r'$[:].last_name')?.toString() ?? '';
      return '$name $lastName'.trim();
    } catch (e) {
      return 'Usuario';
    }
  }

  /// Clear all state (for logout)
  void clearState() {
    _accountId = '';
    _idRole = 0;
    _agent = null;
    _accountIdFm = '';
    _allDataAccount = null;
    _accountCurrency = [];
    _accountPaymentMethods = [];
    _accountTypesIncrease = [];
    _locationState = '';
    _namePaymentMethods = '';
    _latlngLocation = '';
    _nameLocation = '';
    _addressLocation = '';
    _cityLocation = '';
    _stateLocation = '';
    _countryLocation = '';
    _zipCodeLocation = '';
    _selectRates = false;
    _itemsProducts = null;
    _searchStringState = '';
    _isCreatedinItinerary = false;
    _itemsContact = null;
    _allDataHotel = null;
    _allDataTransfer = null;
    _allDataActivity = null;
    _allDataFlight = null;
    _allDataContact = null;
    _allDataItinerary = null;
    _allDataUser = null;
    _departureState = '';
    _arrivalState = '';
    _typeProduct = 1;
    _imageMain = '';
    _allDataPassenger = null;

    // Clear persisted data
    prefs.clear();

    notifyListeners();
  }
}

