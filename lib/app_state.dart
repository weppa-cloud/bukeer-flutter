import 'package:flutter/material.dart';
import 'backend/schema/structs/index.dart';
import 'backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

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
          print("Can't decode persisted json. Error: $e.");
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
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _searchStringState = '';
  String get searchStringState => _searchStringState;
  set searchStringState(String value) {
    _searchStringState = value;
  }

  String _idProductSelected = '';
  String get idProductSelected => _idProductSelected;
  set idProductSelected(String value) {
    _idProductSelected = value;
  }

  dynamic _itemsHotelRates;
  dynamic get itemsHotelRates => _itemsHotelRates;
  set itemsHotelRates(dynamic value) {
    _itemsHotelRates = value;
  }

  dynamic _itemsProducts;
  dynamic get itemsProducts => _itemsProducts;
  set itemsProducts(dynamic value) {
    _itemsProducts = value;
  }

  dynamic _itemsContact;
  dynamic get itemsContact => _itemsContact;
  set itemsContact(dynamic value) {
    _itemsContact = value;
  }

  String _typeProduct = 'activities';
  String get typeProduct => _typeProduct;
  set typeProduct(String value) {
    _typeProduct = value;
  }

  String _imageMain = '';
  String get imageMain => _imageMain;
  set imageMain(String value) {
    _imageMain = value;
  }

  String _accountId = '';
  String get accountId => _accountId;
  set accountId(String value) {
    _accountId = value;
    prefs.setString('ff_accountId', value);
  }

  double _profitHotelRates = 0.0;
  double get profitHotelRates => _profitHotelRates;
  set profitHotelRates(double value) {
    _profitHotelRates = value;
  }

  double _rateUnitCostHotelRates = 0.0;
  double get rateUnitCostHotelRates => _rateUnitCostHotelRates;
  set rateUnitCostHotelRates(double value) {
    _rateUnitCostHotelRates = value;
  }

  double _unitCostHotelRates = 0.0;
  double get unitCostHotelRates => _unitCostHotelRates;
  set unitCostHotelRates(double value) {
    _unitCostHotelRates = value;
  }

  ItineraryPDFStruct _itineraryPDF = ItineraryPDFStruct();
  ItineraryPDFStruct get itineraryPDF => _itineraryPDF;
  set itineraryPDF(ItineraryPDFStruct value) {
    _itineraryPDF = value;
  }

  void updateItineraryPDFStruct(Function(ItineraryPDFStruct) updateFn) {
    updateFn(_itineraryPDF);
  }

  List<ItemsStruct> _itemsItineraryPDF = [];
  List<ItemsStruct> get itemsItineraryPDF => _itemsItineraryPDF;
  set itemsItineraryPDF(List<ItemsStruct> value) {
    _itemsItineraryPDF = value;
  }

  void addToItemsItineraryPDF(ItemsStruct value) {
    itemsItineraryPDF.add(value);
  }

  void removeFromItemsItineraryPDF(ItemsStruct value) {
    itemsItineraryPDF.remove(value);
  }

  void removeAtIndexFromItemsItineraryPDF(int index) {
    itemsItineraryPDF.removeAt(index);
  }

  void updateItemsItineraryPDFAtIndex(
    int index,
    ItemsStruct Function(ItemsStruct) updateFn,
  ) {
    itemsItineraryPDF[index] = updateFn(_itemsItineraryPDF[index]);
  }

  void insertAtIndexInItemsItineraryPDF(int index, ItemsStruct value) {
    itemsItineraryPDF.insert(index, value);
  }

  bool _isCreatedinItinerary = false;
  bool get isCreatedinItinerary => _isCreatedinItinerary;
  set isCreatedinItinerary(bool value) {
    _isCreatedinItinerary = value;
  }

  dynamic _allDataContact;
  dynamic get allDataContact => _allDataContact;
  set allDataContact(dynamic value) {
    _allDataContact = value;
  }

  dynamic _allDataFlight;
  dynamic get allDataFlight => _allDataFlight;
  set allDataFlight(dynamic value) {
    _allDataFlight = value;
  }

  dynamic _allDataHotel;
  dynamic get allDataHotel => _allDataHotel;
  set allDataHotel(dynamic value) {
    _allDataHotel = value;
  }

  dynamic _allDataActivity;
  dynamic get allDataActivity => _allDataActivity;
  set allDataActivity(dynamic value) {
    _allDataActivity = value;
  }

  dynamic _allDataTransfer;
  dynamic get allDataTransfer => _allDataTransfer;
  set allDataTransfer(dynamic value) {
    _allDataTransfer = value;
  }

  int _idRole = 0;
  int get idRole => _idRole;
  set idRole(int value) {
    _idRole = value;
    prefs.setInt('ff_idRole', value);
  }

  int _nextPage = 0;
  int get nextPage => _nextPage;
  set nextPage(int value) {
    _nextPage = value;
  }

  String _latlngLocation = '';
  String get latlngLocation => _latlngLocation;
  set latlngLocation(String value) {
    _latlngLocation = value;
  }

  String _nameLocation = '';
  String get nameLocation => _nameLocation;
  set nameLocation(String value) {
    _nameLocation = value;
  }

  String _addressLocation = '';
  String get addressLocation => _addressLocation;
  set addressLocation(String value) {
    _addressLocation = value;
  }

  String _cityLocation = '';
  String get cityLocation => _cityLocation;
  set cityLocation(String value) {
    _cityLocation = value;
  }

  String _stateLocation = '';
  String get stateLocation => _stateLocation;
  set stateLocation(String value) {
    _stateLocation = value;
  }

  String _countryLocation = '';
  String get countryLocation => _countryLocation;
  set countryLocation(String value) {
    _countryLocation = value;
  }

  String _zipCodeLocation = '';
  String get zipCodeLocation => _zipCodeLocation;
  set zipCodeLocation(String value) {
    _zipCodeLocation = value;
  }

  bool _Refresh = false;
  bool get Refresh => _Refresh;
  set Refresh(bool value) {
    _Refresh = value;
  }

  dynamic _allDataItinerary;
  dynamic get allDataItinerary => _allDataItinerary;
  set allDataItinerary(dynamic value) {
    _allDataItinerary = value;
  }

  String _locationState = '';
  String get locationState => _locationState;
  set locationState(String value) {
    _locationState = value;
  }

  String _departureState = '';
  String get departureState => _departureState;
  set departureState(String value) {
    _departureState = value;
  }

  String _arrivalState = '';
  String get arrivalState => _arrivalState;
  set arrivalState(String value) {
    _arrivalState = value;
  }

  dynamic _agent;
  dynamic get agent => _agent;
  set agent(dynamic value) {
    _agent = value;
    prefs.setString('ff_agent', jsonEncode(value));
  }

  String _accountIdFm = '';
  String get accountIdFm => _accountIdFm;
  set accountIdFm(String value) {
    _accountIdFm = value;
    prefs.setString('ff_accountIdFm', value);
  }

  dynamic _allDataAccount;
  dynamic get allDataAccount => _allDataAccount;
  set allDataAccount(dynamic value) {
    _allDataAccount = value;
    prefs.setString('ff_allDataAccount', jsonEncode(value));
  }

  List<dynamic> _accountCurrency = [jsonDecode('{}')];
  List<dynamic> get accountCurrency => _accountCurrency;
  set accountCurrency(List<dynamic> value) {
    _accountCurrency = value;
  }

  void addToAccountCurrency(dynamic value) {
    accountCurrency.add(value);
  }

  void removeFromAccountCurrency(dynamic value) {
    accountCurrency.remove(value);
  }

  void removeAtIndexFromAccountCurrency(int index) {
    accountCurrency.removeAt(index);
  }

  void updateAccountCurrencyAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    accountCurrency[index] = updateFn(_accountCurrency[index]);
  }

  void insertAtIndexInAccountCurrency(int index, dynamic value) {
    accountCurrency.insert(index, value);
  }

  dynamic _infoItinerary = jsonDecode('null');
  dynamic get infoItinerary => _infoItinerary;
  set infoItinerary(dynamic value) {
    _infoItinerary = value;
  }

  bool _selectRates = false;
  bool get selectRates => _selectRates;
  set selectRates(bool value) {
    _selectRates = value;
  }

  List<dynamic> _accountTypesIncrease = [jsonDecode('{}')];
  List<dynamic> get accountTypesIncrease => _accountTypesIncrease;
  set accountTypesIncrease(List<dynamic> value) {
    _accountTypesIncrease = value;
  }

  void addToAccountTypesIncrease(dynamic value) {
    accountTypesIncrease.add(value);
  }

  void removeFromAccountTypesIncrease(dynamic value) {
    accountTypesIncrease.remove(value);
  }

  void removeAtIndexFromAccountTypesIncrease(int index) {
    accountTypesIncrease.removeAt(index);
  }

  void updateAccountTypesIncreaseAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    accountTypesIncrease[index] = updateFn(_accountTypesIncrease[index]);
  }

  void insertAtIndexInAccountTypesIncrease(int index, dynamic value) {
    accountTypesIncrease.insert(index, value);
  }

  dynamic _allDataPassenger;
  dynamic get allDataPassenger => _allDataPassenger;
  set allDataPassenger(dynamic value) {
    _allDataPassenger = value;
  }

  dynamic _allDataUser;
  dynamic get allDataUser => _allDataUser;
  set allDataUser(dynamic value) {
    _allDataUser = value;
  }

  List<dynamic> _accountPaymentMethods = [jsonDecode('{}')];
  List<dynamic> get accountPaymentMethods => _accountPaymentMethods;
  set accountPaymentMethods(List<dynamic> value) {
    _accountPaymentMethods = value;
  }

  void addToAccountPaymentMethods(dynamic value) {
    accountPaymentMethods.add(value);
  }

  void removeFromAccountPaymentMethods(dynamic value) {
    accountPaymentMethods.remove(value);
  }

  void removeAtIndexFromAccountPaymentMethods(int index) {
    accountPaymentMethods.removeAt(index);
  }

  void updateAccountPaymentMethodsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    accountPaymentMethods[index] = updateFn(_accountPaymentMethods[index]);
  }

  void insertAtIndexInAccountPaymentMethods(int index, dynamic value) {
    accountPaymentMethods.insert(index, value);
  }

  dynamic _namePaymentMethods;
  dynamic get namePaymentMethods => _namePaymentMethods;
  set namePaymentMethods(dynamic value) {
    _namePaymentMethods = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
