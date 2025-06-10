import '../backend/api_requests/api_calls.dart';
import "package:bukeer/legacy/flutter_flow/flutter_flow_util.dart";
import 'base_service.dart';

class ItineraryService extends BaseService {
  static final ItineraryService _instance = ItineraryService._internal();
  factory ItineraryService() => _instance;
  ItineraryService._internal();

  // Cached data
  List<dynamic> _itineraries = [];
  Map<String, dynamic> _itineraryDetails = {};
  Map<String, List<dynamic>> _itineraryItems = {};
  Map<String, List<dynamic>> _itineraryPassengers = {};

  // Selected itinerary data (replacement for allDataItinerary)
  dynamic _selectedItinerary;

  // Selected passenger data (replacement for allDataPassenger)
  dynamic _selectedPassenger;

  // Collection getters
  List<dynamic> get itineraries => _itineraries;

  dynamic getItinerary(String id) => _itineraryDetails[id];
  List<dynamic> getItineraryItems(String id) => _itineraryItems[id] ?? [];
  List<dynamic> getItineraryPassengers(String id) =>
      _itineraryPassengers[id] ?? [];

  // Selected itinerary getters (replacement for allDataItinerary)
  dynamic get selectedItinerary => _selectedItinerary;

  // Selected passenger getters (replacement for allDataPassenger)
  dynamic get selectedPassenger => _selectedPassenger;

  // Backward compatibility getters
  dynamic get allDataItinerary => _selectedItinerary;
  dynamic get allDataPassenger => _selectedPassenger;

  @override
  Future<void> initialize() async {
    // Load initial itineraries list
    await loadItineraries();
  }

  // Load all itineraries
  Future<void> loadItineraries() async {
    if (isCacheValid && _itineraries.isNotEmpty) return;

    await loadData(() async {
      final response = await GetItinerariesCall.call();
      if (response.succeeded) {
        _itineraries = getJsonField(response.jsonBody, r'$[:]') ?? [];
        notifyListeners();
      }
    });
  }

  // Load specific itinerary details
  Future<void> loadItineraryDetails(String itineraryId) async {
    await loadData(() async {
      final response =
          await GetitIneraryDetailsCall.call(itineraryId: itineraryId);
      if (response.succeeded) {
        _itineraryDetails[itineraryId] =
            getJsonField(response.jsonBody, r'$[0]');

        // Also cache items and passengers if included
        final items = getJsonField(response.jsonBody, r'$[0].items');
        if (items != null) {
          _itineraryItems[itineraryId] = items is List ? items : [items];
        }

        final passengers = getJsonField(response.jsonBody, r'$[0].passengers');
        if (passengers != null) {
          _itineraryPassengers[itineraryId] =
              passengers is List ? passengers : [passengers];
        }

        notifyListeners();
      }
    });
  }

  // Create new itinerary
  Future<String?> createItinerary({
    required String name,
    required String startDate,
    required String endDate,
    String? agent,
    String? accountId,
    String? idContact,
    String? currencyType,
    int? passengerCount,
  }) async {
    return await loadData(() async {
      final response = await CreateItineraryForContactCall.call(
        name: name,
        startDate: startDate,
        endDate: endDate,
        agent: agent,
        accountId: accountId,
        idContact: idContact,
        currencyType: currencyType,
        passengerCount: passengerCount,
      );

      if (response.succeeded) {
        // Clear cache to force reload
        _itineraries.clear();
        _invalidateCache();

        final id = getJsonField(response.jsonBody, r'$[0].id')?.toString();
        return id ?? ''; // Return empty string if null
      }
      throw Exception('Failed to create itinerary');
    });
  }

  // Update itinerary
  Future<bool> updateItinerary({
    required String itineraryId,
    String? name,
    String? startDate,
    String? endDate,
    String? agent,
    int? contact,
    String? currency,
  }) async {
    final result = await loadData(() async {
      final response = await UpdateItineraryCall.call(
        id: itineraryId,
        name: name,
        startDate: startDate,
        endDate: endDate,
        agent: agent,
        idContact: contact?.toString(),
        currencyType: currency,
      );

      if (response.succeeded) {
        // Clear specific itinerary cache
        _itineraryDetails.remove(itineraryId);
        _itineraries.clear();
        _invalidateCache();

        return true;
      }
      return false;
    });

    return result ?? false;
  }

  // Add item to itinerary
  Future<bool> addItineraryItem({
    required String itineraryId,
    required String type,
    required Map<String, dynamic> itemData,
  }) async {
    final result = await loadData(() async {
      // This would call the appropriate API based on type
      // For now, returning true as placeholder

      // Clear items cache for this itinerary
      _itineraryItems.remove(itineraryId);

      return true;
    });

    return result ?? false;
  }

  // Delete itinerary
  Future<bool> deleteItinerary(String itineraryId) async {
    final result = await loadData(() async {
      // TODO: Implement proper delete API call when available
      // For now, just remove from local cache
      _itineraries.removeWhere(
          (item) => getJsonField(item, r'$.id')?.toString() == itineraryId);
      _itineraryDetails.remove(itineraryId);
      _itineraryItems.remove(itineraryId);
      _itineraryPassengers.remove(itineraryId);

      notifyListeners();
      return true;
    });

    return result ?? false;
  }

  // Set selected itinerary (replacement for allDataItinerary assignment)
  void setSelectedItinerary(dynamic itinerary) {
    _selectedItinerary = itinerary;
    notifyListeners();
  }

  // Set selected passenger (replacement for allDataPassenger assignment)
  void setSelectedPassenger(dynamic passenger) {
    _selectedPassenger = passenger;
    notifyListeners();
  }

  // Search itineraries
  List<dynamic> searchItineraries(String query) {
    if (query.isEmpty) return _itineraries;

    final lowercaseQuery = query.toLowerCase();
    return _itineraries.where((itinerary) {
      final name = safeGet<String>(itinerary, r'$.name', defaultValue: '');
      final clientName =
          safeGet<String>(itinerary, r'$.client_name', defaultValue: '');
      final agentName =
          safeGet<String>(itinerary, r'$.agent_name', defaultValue: '');

      return name!.toLowerCase().contains(lowercaseQuery) ||
          clientName!.toLowerCase().contains(lowercaseQuery) ||
          agentName!.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get itineraries by status
  List<dynamic> getItinerariesByStatus(String status) {
    return _itineraries.where((itinerary) {
      return safeGet<String>(itinerary, r'$.status') == status;
    }).toList();
  }

  // Calculate totals
  Map<String, double> calculateItineraryTotals(String itineraryId) {
    final items = getItineraryItems(itineraryId);
    double totalCost = 0;
    double totalPrice = 0;

    for (final item in items) {
      totalCost += safeGet<double>(item, r'$.cost', defaultValue: 0) ?? 0;
      totalPrice += safeGet<double>(item, r'$.price', defaultValue: 0) ?? 0;
    }

    return {
      'cost': totalCost,
      'price': totalPrice,
      'profit': totalPrice - totalCost,
    };
  }

  // Backward compatibility setters
  set allDataItinerary(dynamic value) {
    _selectedItinerary = value;
    notifyListeners();
  }

  set allDataPassenger(dynamic value) {
    _selectedPassenger = value;
    notifyListeners();
  }

  // Private method to invalidate cache
  void _invalidateCache() {
    _itineraries.clear();
    _itineraryDetails.clear();
    _itineraryItems.clear();
    _itineraryPassengers.clear();
    _selectedItinerary = null;
    _selectedPassenger = null;
    notifyListeners();
  }

  // ============= MOCK METHODS FOR TESTING =============
  // These methods are for Widgetbook and testing only

  /// Set mock selected itinerary data for testing
  void setAllDataItinerary(Map<String, dynamic> data) {
    _selectedItinerary = data;
  }
}
