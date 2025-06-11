import '../backend/api_requests/api_calls.dart';
import "package:bukeer/legacy/flutter_flow/flutter_flow_util.dart";
import '../auth/supabase_auth/auth_util.dart';
import '../backend/supabase/supabase.dart';
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

  // Optimized getters for grouped data
  Map<String, dynamic>? getCompleteItineraryData(String id) =>
      _itineraryDetails[id];

  List<dynamic> getItineraryItemsByType(String id, String productType) {
    final data = _itineraryDetails[id];
    if (data == null || data['items_grouped'] == null) return [];

    final itemsGrouped = data['items_grouped'] as Map<String, dynamic>;
    switch (productType.toLowerCase()) {
      case 'flight':
      case 'vuelos':
        return itemsGrouped['flights'] ?? [];
      case 'hotel':
      case 'hoteles':
        return itemsGrouped['hotels'] ?? [];
      case 'activity':
      case 'servicios':
        return itemsGrouped['activities'] ?? [];
      case 'transfer':
      case 'transporte':
        return itemsGrouped['transfers'] ?? [];
      default:
        return [];
    }
  }

  double getItineraryTotalByType(String id, String productType) {
    final data = _itineraryDetails[id];
    if (data == null || data['items_grouped'] == null) return 0.0;

    final totals = data['items_grouped']['totals'] as Map<String, dynamic>?;
    if (totals == null) return 0.0;

    switch (productType.toLowerCase()) {
      case 'flight':
      case 'vuelos':
        return totals['flights'] ?? 0.0;
      case 'hotel':
      case 'hoteles':
        return totals['hotels'] ?? 0.0;
      case 'activity':
      case 'servicios':
        return totals['activities'] ?? 0.0;
      case 'transfer':
      case 'transporte':
        return totals['transfers'] ?? 0.0;
      default:
        return 0.0;
    }
  }

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
      final response = await GetItinerariesCall.call(
        authToken: currentJwtToken,
      );
      if (response.succeeded) {
        _itineraries = getJsonField(response.jsonBody, r'$[:]') ?? [];
        notifyListeners();
      }
    });
  }

  // Load specific itinerary details - OPTIMIZED VERSION
  Future<Map<String, dynamic>?> loadItineraryDetailsOptimized(
      String itineraryId) async {
    print(
        'ItineraryService: Loading complete itinerary data for: $itineraryId');

    try {
      // Load all data in parallel for better performance
      final results = await Future.wait([
        // 1. Load itinerary with contact info
        _loadItineraryWithContact(itineraryId),
        // 2. Load all items
        _loadItemsGrouped(itineraryId),
        // 3. Load passengers
        _loadPassengersData(itineraryId),
        // 4. Load payments/transactions
        _loadTransactionsData(itineraryId),
      ]);

      final itineraryData = results[0] as Map<String, dynamic>?;
      final itemsData = results[1] as Map<String, dynamic>;
      final passengersData = results[2] as List<dynamic>;
      final transactionsData = results[3] as List<dynamic>;

      if (itineraryData == null) {
        return null;
      }

      // Build complete response object
      final completeData = {
        ...itineraryData,
        'items_grouped': itemsData,
        'passengers': passengersData,
        'transactions': transactionsData,
        // Calculated fields
        'total_items': itemsData['all_items'].length,
        'has_flights': itemsData['flights'].isNotEmpty,
        'has_hotels': itemsData['hotels'].isNotEmpty,
        'has_activities': itemsData['activities'].isNotEmpty,
        'has_transfers': itemsData['transfers'].isNotEmpty,
      };

      // Cache the complete data
      _itineraryDetails[itineraryId] = completeData;
      _itineraryItems[itineraryId] = itemsData['all_items'];
      _itineraryPassengers[itineraryId] = passengersData;

      notifyListeners();
      return completeData;
    } catch (e) {
      print('ItineraryService: Error loading complete data: $e');
      return null;
    }
  }

  // Load specific itinerary details (mantener para compatibilidad)
  Future<void> loadItineraryDetails(String itineraryId) async {
    await loadItineraryDetailsOptimized(itineraryId);
  }

  // Load items directly from database
  Future<void> _loadItineraryItemsDirectly(String itineraryId) async {
    try {
      print('ItineraryService: Loading items directly for: $itineraryId');
      final items = await ItineraryItemsTable().queryRows(
        queryFn: (q) => q.eq('id_itinerary', itineraryId).order('date'),
      );

      print('ItineraryService: Loaded ${items.length} items from database');
      // Map the items to include all necessary fields
      _itineraryItems[itineraryId] = items.map((item) {
        return {
          'id': item.id,
          'id_itinerary': item.idItinerary,
          'product_type': item.productType,
          'product_name': item.productName,
          'rate_name': item.rateName,
          'date': item.date?.toIso8601String(),
          'destination': item.destination,
          'unit_cost': item.unitCost,
          'unit_price': item.unitPrice,
          'quantity': item.quantity,
          'total_cost': item.totalCost,
          'total_price': item.totalPrice,
          'profit': item.profit,
          'profit_percentage': item.profitPercentage,
          'hotel_nights': item.hotelNights,
          // Flight specific fields
          'flight_departure': item.flightDeparture,
          'flight_arrival': item.flightArrival,
          'departure_time': item.departureTime,
          'arrival_time': item.arrivalTime,
          'flight_number': item.flightNumber,
          'airline': item.airline,
          // Additional fields
          'start_time': item.startTime?.toIso8601String(),
          'end_time': item.endTime?.toIso8601String(),
          'day_number': item.dayNumber,
          'order': item.order,
          'reservation_status': item.reservationStatus ?? false,
          'created_at': item.createdAt.toIso8601String(),
          'updated_at': item.updatedAt.toIso8601String(),
        };
      }).toList();
    } catch (e) {
      print('ItineraryService: Error loading items: $e');
    }
  }

  // Load passengers directly from database
  Future<void> _loadItineraryPassengersDirectly(String itineraryId) async {
    try {
      print('ItineraryService: Loading passengers for: $itineraryId');
      final passengers = await PassengerTable().queryRows(
        queryFn: (q) => q.eq('itinerary_id', itineraryId),
      );

      print('ItineraryService: Loaded ${passengers.length} passengers');
      _itineraryPassengers[itineraryId] =
          passengers.map((p) => p.data).toList();
    } catch (e) {
      print('ItineraryService: Error loading passengers: $e');
    }
  }

  // ============= OPTIMIZED HELPER METHODS =============

  // Load itinerary with contact info in one query
  Future<Map<String, dynamic>?> _loadItineraryWithContact(
      String itineraryId) async {
    try {
      final itineraryRows = await ItinerariesTable().queryRows(
        queryFn: (q) => q.eq('id', itineraryId),
      );

      if (itineraryRows.isEmpty) return null;

      final itinerary = itineraryRows.first;

      // Get contact info if available
      String? contactName;
      if (itinerary.idContact != null) {
        final contacts = await ContactsTable().queryRows(
          queryFn: (q) => q.eq('id', itinerary.idContact!),
        );
        if (contacts.isNotEmpty) {
          contactName = contacts.first.name;
        }
      }

      return {
        'id': itinerary.id,
        'name': itinerary.name,
        'start_date': itinerary.startDate.toIso8601String(),
        'end_date': itinerary.endDate.toIso8601String(),
        'status': itinerary.status,
        'passenger_count': itinerary.passengerCount,
        'currency_type': itinerary.currencyType,
        'total_amount': itinerary.totalAmount,
        'total_cost': itinerary.totalCost,
        'total_markup': itinerary.totalMarkup,
        'agent': itinerary.agent,
        'id_fm': itinerary.idFm,
        'language': itinerary.language,
        'valid_until': itinerary.validUntil?.toIso8601String(),
        'rates_visibility': itinerary.ratesVisibility,
        'itinerary_visibility': itinerary.itineraryVisibility,
        'contact_name': contactName,
        'contact_id': itinerary.idContact,
        'created_at': itinerary.createdAt?.toIso8601String(),
      };
    } catch (e) {
      print('Error loading itinerary: $e');
      return null;
    }
  }

  // Load and group items by type
  Future<Map<String, dynamic>> _loadItemsGrouped(String itineraryId) async {
    try {
      final items = await ItineraryItemsTable().queryRows(
        queryFn: (q) => q.eq('id_itinerary', itineraryId).order('date'),
      );

      final allItems = items
          .map((item) => {
                'id': item.id,
                'product_type': item.productType,
                'product_name': item.productName,
                'rate_name': item.rateName,
                'date': item.date?.toIso8601String(),
                'destination': item.destination,
                'unit_cost': item.unitCost,
                'unit_price': item.unitPrice,
                'quantity': item.quantity,
                'total_cost': item.totalCost,
                'total_price': item.totalPrice,
                'profit': item.profit,
                'profit_percentage': item.profitPercentage,
                'hotel_nights': item.hotelNights,
                'flight_departure': item.flightDeparture,
                'flight_arrival': item.flightArrival,
                'departure_time': item.departureTime,
                'arrival_time': item.arrivalTime,
                'flight_number': item.flightNumber,
                'airline': item.airline,
                'reservation_status': item.reservationStatus,
              })
          .toList();

      // Group by type for easy access
      return {
        'all_items': allItems,
        'flights':
            allItems.where((item) => item['product_type'] == 'Vuelos').toList(),
        'hotels': allItems
            .where((item) => item['product_type'] == 'Hoteles')
            .toList(),
        'activities': allItems
            .where((item) => item['product_type'] == 'Servicios')
            .toList(),
        'transfers': allItems
            .where((item) => item['product_type'] == 'Transporte')
            .toList(),
        // Totals by type
        'totals': {
          'flights': _calculateTypeTotal(allItems, 'Vuelos'),
          'hotels': _calculateTypeTotal(allItems, 'Hoteles'),
          'activities': _calculateTypeTotal(allItems, 'Servicios'),
          'transfers': _calculateTypeTotal(allItems, 'Transporte'),
        }
      };
    } catch (e) {
      print('Error loading items: $e');
      return {
        'all_items': [],
        'flights': [],
        'hotels': [],
        'activities': [],
        'transfers': [],
        'totals': {
          'flights': 0.0,
          'hotels': 0.0,
          'activities': 0.0,
          'transfers': 0.0
        }
      };
    }
  }

  // Load passengers data
  Future<List<dynamic>> _loadPassengersData(String itineraryId) async {
    try {
      final passengers = await PassengerTable().queryRows(
        queryFn: (q) => q.eq('itinerary_id', itineraryId),
      );

      return passengers
          .map((p) => {
                'id': p.id,
                'name': p.name,
                'last_name': p.lastName,
                'type_id': p.typeId,
                'number_id': p.numberId,
                'nationality': p.nationality,
                'birth_date': p.birthDate.toIso8601String(),
                'full_name': '${p.name} ${p.lastName}',
              })
          .toList();
    } catch (e) {
      print('Error loading passengers: $e');
      return [];
    }
  }

  // Load transactions data
  Future<List<dynamic>> _loadTransactionsData(String itineraryId) async {
    try {
      final transactions = await SupaFlow.client
          .from('transactions')
          .select()
          .eq('id_itinerary', itineraryId)
          .order('created_at', ascending: false);

      return transactions;
    } catch (e) {
      print('Error loading transactions: $e');
      return [];
    }
  }

  // Calculate total for a specific product type
  double _calculateTypeTotal(List<dynamic> items, String productType) {
    return items
        .where((item) => item['product_type'] == productType)
        .fold(0.0, (sum, item) => sum + (item['total_price'] ?? 0.0));
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

  // Set itinerary items directly
  void setItineraryItems(String itineraryId, List<dynamic> items) {
    _itineraryItems[itineraryId] = items;
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
