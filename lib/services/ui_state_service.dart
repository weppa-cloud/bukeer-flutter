import 'package:flutter/material.dart';
import 'dart:async';

/// Service for managing temporary UI state that was previously in FFAppState
/// This includes search queries, form data, temporary selections, etc.
class UiStateService extends ChangeNotifier {
  Timer? _searchDebounceTimer;
  // ===========================================================================
  // SEARCH AND FILTER STATE
  // ===========================================================================

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    if (_searchQuery != value) {
      _searchQuery = value;
      _debouncedNotify();
    }
  }

  // Debounced notification for search
  void _debouncedNotify() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      notifyListeners();
    });
  }

  int _currentPage = 1;
  int get currentPage => _currentPage;
  set currentPage(int value) {
    if (_currentPage != value) {
      _currentPage = value;
      notifyListeners();
    }
  }

  // ===========================================================================
  // PRODUCT SELECTION STATE
  // ===========================================================================

  String _selectedProductId = '';
  String get selectedProductId => _selectedProductId;
  set selectedProductId(String value) {
    if (_selectedProductId != value) {
      _selectedProductId = value;
      notifyListeners();
    }
  }

  String _selectedProductType = 'activities';
  String get selectedProductType => _selectedProductType;
  set selectedProductType(String value) {
    if (_selectedProductType != value) {
      _selectedProductType = value;
      notifyListeners();
    }
  }

  String _locationState = '';
  String get locationState => _locationState;
  set locationState(String value) {
    if (_locationState != value) {
      _locationState = value;
      notifyListeners();
    }
  }

  bool _isSelectingRates = false;
  bool get isSelectingRates => _isSelectingRates;
  set isSelectingRates(bool value) {
    if (_isSelectingRates != value) {
      _isSelectingRates = value;
      notifyListeners();
    }
  }

  // Temporary selected product data (replaces FFAppState.itemsProducts)
  dynamic _itemsProducts;
  dynamic get itemsProducts => _itemsProducts;
  set itemsProducts(dynamic value) {
    if (_itemsProducts != value) {
      _itemsProducts = value;
      notifyListeners();
    }
  }

  // Rate selection state (replaces FFAppState.selectRates)
  bool _selectRates = false;
  bool get selectRates => _selectRates;
  set selectRates(bool value) {
    if (_selectRates != value) {
      _selectRates = value;
      notifyListeners();
    }
  }

  // Contact selection state (replaces FFAppState.itemsContact)
  dynamic _selectedContact;
  dynamic get selectedContact => _selectedContact;
  set selectedContact(dynamic value) {
    if (_selectedContact != value) {
      _selectedContact = value;
      notifyListeners();
    }
  }

  // ===========================================================================
  // NOTE: allData* properties removed - now handled by specialized services:
  // - allDataItinerary → ItineraryService
  // - allDataContact → ContactService
  // - allDataHotel/Activity/Transfer/Flight → ProductService
  // - allDataUser → UserService
  // ===========================================================================

  // ===========================================================================
  // FORM STATE
  // ===========================================================================

  String _selectedImageUrl = '';
  String get selectedImageUrl => _selectedImageUrl;
  set selectedImageUrl(String value) {
    if (_selectedImageUrl != value) {
      _selectedImageUrl = value;
      notifyListeners();
    }
  }

  bool _isCreatingItinerary = false;
  bool get isCreatingItinerary => _isCreatingItinerary;
  set isCreatingItinerary(bool value) {
    if (_isCreatingItinerary != value) {
      _isCreatingItinerary = value;
      notifyListeners();
    }
  }

  // Form creation state (replaces FFAppState.isCreatedinItinerary)
  bool _isCreatedInItinerary = false;
  bool get isCreatedInItinerary => _isCreatedInItinerary;
  set isCreatedInItinerary(bool value) {
    if (_isCreatedInItinerary != value) {
      _isCreatedInItinerary = value;
      notifyListeners();
    }
  }

  // ===========================================================================
  // LOCATION PICKER STATE
  // ===========================================================================

  String _selectedLocationLatLng = '';
  String _selectedLocationName = '';
  String _selectedLocationAddress = '';
  String _selectedLocationCity = '';
  String _selectedLocationState = '';
  String _selectedLocationCountry = '';
  String _selectedLocationZipCode = '';

  String get selectedLocationLatLng => _selectedLocationLatLng;
  String get selectedLocationName => _selectedLocationName;
  String get selectedLocationAddress => _selectedLocationAddress;
  String get selectedLocationCity => _selectedLocationCity;
  String get selectedLocationState => _selectedLocationState;
  String get selectedLocationCountry => _selectedLocationCountry;
  String get selectedLocationZipCode => _selectedLocationZipCode;

  set selectedLocationLatLng(String value) {
    if (_selectedLocationLatLng != value) {
      _selectedLocationLatLng = value;
      notifyListeners();
    }
  }

  set selectedLocationName(String value) {
    if (_selectedLocationName != value) {
      _selectedLocationName = value;
      notifyListeners();
    }
  }

  set selectedLocationAddress(String value) {
    if (_selectedLocationAddress != value) {
      _selectedLocationAddress = value;
      notifyListeners();
    }
  }

  set selectedLocationCity(String value) {
    if (_selectedLocationCity != value) {
      _selectedLocationCity = value;
      notifyListeners();
    }
  }

  set selectedLocationState(String value) {
    if (_selectedLocationState != value) {
      _selectedLocationState = value;
      notifyListeners();
    }
  }

  set selectedLocationCountry(String value) {
    if (_selectedLocationCountry != value) {
      _selectedLocationCountry = value;
      notifyListeners();
    }
  }

  set selectedLocationZipCode(String value) {
    if (_selectedLocationZipCode != value) {
      _selectedLocationZipCode = value;
      notifyListeners();
    }
  }

  void setSelectedLocation({
    String? latLng,
    String? name,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) {
    bool hasChanged = false;

    if (latLng != null && _selectedLocationLatLng != latLng) {
      _selectedLocationLatLng = latLng;
      hasChanged = true;
    }
    if (name != null && _selectedLocationName != name) {
      _selectedLocationName = name;
      hasChanged = true;
    }
    if (address != null && _selectedLocationAddress != address) {
      _selectedLocationAddress = address;
      hasChanged = true;
    }
    if (city != null && _selectedLocationCity != city) {
      _selectedLocationCity = city;
      hasChanged = true;
    }
    if (state != null && _selectedLocationState != state) {
      _selectedLocationState = state;
      hasChanged = true;
    }
    if (country != null && _selectedLocationCountry != country) {
      _selectedLocationCountry = country;
      hasChanged = true;
    }
    if (zipCode != null && _selectedLocationZipCode != zipCode) {
      _selectedLocationZipCode = zipCode;
      hasChanged = true;
    }

    if (hasChanged) {
      notifyListeners();
    }
  }

  void clearSelectedLocation() {
    _selectedLocationLatLng = '';
    _selectedLocationName = '';
    _selectedLocationAddress = '';
    _selectedLocationCity = '';
    _selectedLocationState = '';
    _selectedLocationCountry = '';
    _selectedLocationZipCode = '';
    notifyListeners();
  }

  // ===========================================================================
  // HOTEL RATES CALCULATION STATE
  // ===========================================================================

  double _profitHotelRates = 0.0;
  double _rateUnitCostHotelRates = 0.0;
  double _unitCostHotelRates = 0.0;

  double get profitHotelRates => _profitHotelRates;
  double get rateUnitCostHotelRates => _rateUnitCostHotelRates;
  double get unitCostHotelRates => _unitCostHotelRates;

  void setHotelRatesCalculation({
    double? profit,
    double? rateUnitCost,
    double? unitCost,
  }) {
    bool hasChanged = false;

    if (profit != null && _profitHotelRates != profit) {
      _profitHotelRates = profit;
      hasChanged = true;
    }
    if (rateUnitCost != null && _rateUnitCostHotelRates != rateUnitCost) {
      _rateUnitCostHotelRates = rateUnitCost;
      hasChanged = true;
    }
    if (unitCost != null && _unitCostHotelRates != unitCost) {
      _unitCostHotelRates = unitCost;
      hasChanged = true;
    }

    if (hasChanged) {
      notifyListeners();
    }
  }

  void clearHotelRatesCalculation() {
    _profitHotelRates = 0.0;
    _rateUnitCostHotelRates = 0.0;
    _unitCostHotelRates = 0.0;
    notifyListeners();
  }

  // ===========================================================================
  // GENERAL METHODS
  // ===========================================================================

  /// Clear all temporary state
  void clearAll() {
    _searchDebounceTimer?.cancel();
    _searchQuery = '';
    _currentPage = 1;
    _selectedProductId = '';
    _selectedProductType = 'activities';
    _locationState = '';
    _isSelectingRates = false;
    _selectedImageUrl = '';
    _isCreatingItinerary = false;
    _isCreatedInItinerary = false;
    _selectedContact = null;
    clearSelectedLocation();
    clearHotelRatesCalculation();
    _departureState = '';
    _arrivalState = '';
    _namePaymentMethods = null;
    _accountPaymentMethods = [];
    _accountCurrency = [];
    _accountTypesIncrease = [];
    _allDataAccount = null;
    notifyListeners();
  }

  @override
  // ===========================================================================
  // FLIGHT STATE
  // ===========================================================================

  String _departureState = '';
  String get departureState => _departureState;
  set departureState(String value) {
    if (_departureState != value) {
      _departureState = value;
      notifyListeners();
    }
  }

  String _arrivalState = '';
  String get arrivalState => _arrivalState;
  set arrivalState(String value) {
    if (_arrivalState != value) {
      _arrivalState = value;
      notifyListeners();
    }
  }

  // ===========================================================================
  // PAYMENT METHODS STATE
  // ===========================================================================

  dynamic _namePaymentMethods;
  dynamic get namePaymentMethods => _namePaymentMethods;
  set namePaymentMethods(dynamic value) {
    if (_namePaymentMethods != value) {
      _namePaymentMethods = value;
      notifyListeners();
    }
  }

  List<dynamic> _accountPaymentMethods = [];
  List<dynamic> get accountPaymentMethods => _accountPaymentMethods;
  set accountPaymentMethods(List<dynamic> value) {
    if (_accountPaymentMethods != value) {
      _accountPaymentMethods = value;
      notifyListeners();
    }
  }

  // ===========================================================================
  // ACCOUNT CONFIGURATION STATE (for editing before saving)
  // ===========================================================================

  List<dynamic> _accountCurrency = [];
  List<dynamic> get accountCurrency => _accountCurrency;
  set accountCurrency(List<dynamic> value) {
    if (_accountCurrency != value) {
      _accountCurrency = value;
      notifyListeners();
    }
  }

  List<dynamic> _accountTypesIncrease = [];
  List<dynamic> get accountTypesIncrease => _accountTypesIncrease;
  set accountTypesIncrease(List<dynamic> value) {
    if (_accountTypesIncrease != value) {
      _accountTypesIncrease = value;
      notifyListeners();
    }
  }

  dynamic _allDataAccount;
  dynamic get allDataAccount => _allDataAccount;
  set allDataAccount(dynamic value) {
    if (_allDataAccount != value) {
      _allDataAccount = value;
      notifyListeners();
    }
  }

  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  /// Clear only search-related state
  void clearSearchState() {
    _searchQuery = '';
    _currentPage = 1;
    notifyListeners();
  }

  /// Clear only form-related state
  void clearFormState() {
    _selectedImageUrl = '';
    _isCreatingItinerary = false;
    clearSelectedLocation();
    notifyListeners();
  }
}
