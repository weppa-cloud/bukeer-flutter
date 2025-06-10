import '../backend/api_requests/api_calls.dart';
import "package:bukeer/legacy/flutter_flow/flutter_flow_util.dart";
import 'base_service.dart';
import 'performance_optimized_service.dart';
import 'smart_cache_service.dart';

class ProductService extends BaseService
    with PerformanceOptimizedService, SmartCacheable {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  // Cached data
  List<dynamic> _hotels = [];
  List<dynamic> _activities = [];
  List<dynamic> _transfers = [];
  List<dynamic> _flights = [];

  // Search results cache with TTL
  final Map<String, _CacheEntry> _searchCache = {};
  static const Duration _searchCacheTimeout = Duration(minutes: 2);

  // Single item data (replacement for allDataHotel, allDataActivity, etc.)
  dynamic _selectedHotel;
  dynamic _selectedActivity;
  dynamic _selectedTransfer;
  dynamic _selectedFlight;

  // Collection getters
  List<dynamic> get hotels => _hotels;
  List<dynamic> get activities => _activities;
  List<dynamic> get transfers => _transfers;
  List<dynamic> get flights => _flights;

  // Selected item getters (replacement for allData*)
  dynamic get selectedHotel => _selectedHotel;
  dynamic get selectedActivity => _selectedActivity;
  dynamic get selectedTransfer => _selectedTransfer;
  dynamic get selectedFlight => _selectedFlight;

  // Backward compatibility getters for allData* pattern
  dynamic get allDataHotel => _selectedHotel;
  dynamic get allDataActivity => _selectedActivity;
  dynamic get allDataTransfer => _selectedTransfer;
  dynamic get allDataFlight => _selectedFlight;

  @override
  Future<void> initialize() async {
    // Load all products in parallel
    await batchLoad([
      loadHotels(),
      loadActivities(),
      loadTransfers(),
      loadFlights(),
    ]);
    // Single notification after all data is loaded
    notifyListeners();
  }

  // Load hotels
  Future<void> loadHotels() async {
    if (isCacheValid && _hotels.isNotEmpty) return;

    await loadData(() async {
      final response = await GetHotelsCall.call();
      if (response.succeeded) {
        _hotels = getJsonField(response.jsonBody, r'$[:]') ?? [];
        // Don't notify here - let batchLoad handle it
      }
    });
  }

  // Load activities
  Future<void> loadActivities() async {
    if (isCacheValid && _activities.isNotEmpty) return;

    await loadData(() async {
      final response = await GetActivitiesCall.call();
      if (response.succeeded) {
        _activities = getJsonField(response.jsonBody, r'$[:]') ?? [];
        // Don't notify here - let batchLoad handle it
      }
    });
  }

  // Load transfers
  Future<void> loadTransfers() async {
    if (isCacheValid && _transfers.isNotEmpty) return;

    await loadData(() async {
      // TODO: Implement proper transfers API call when available
      // For now, use empty list
      _transfers = [];
      // Don't notify here - let batchLoad handle it
    });
  }

  // Load flights
  Future<void> loadFlights() async {
    if (isCacheValid && _flights.isNotEmpty) return;

    await loadData(() async {
      // TODO: Implement proper flights API call when available
      // For now, use empty list
      _flights = [];
      // Don't notify here - let batchLoad handle it
    });
  }

  // Search products across all types with smart caching
  Future<List<dynamic>> searchAllProducts(String query) async {
    if (query.isEmpty) return [];

    return await cache.getOrCompute(
      getCacheKey('searchAll', {'query': query}),
      () async {
        // Search in parallel
        final results = await batchLoad([
          _searchProducts(_hotels, query, 'hotel'),
          _searchProducts(_activities, query, 'activity'),
          _searchProducts(_transfers, query, 'transfer'),
          _searchProducts(_flights, query, 'flight'),
        ]);

        return results.expand((list) => list).toList();
      },
      ttl: _searchCacheTimeout,
    );
  }

  // Generic search within a product list
  Future<List<dynamic>> _searchProducts(
      List<dynamic> products, String query, String type) async {
    final lowercaseQuery = query.toLowerCase();

    return products.where((product) {
      final name = safeGet<String>(product, r'$.name', defaultValue: '');
      final description =
          safeGet<String>(product, r'$.description', defaultValue: '');
      final location =
          safeGet<String>(product, r'$.location_name', defaultValue: '');

      final matches = name!.toLowerCase().contains(lowercaseQuery) ||
          description!.toLowerCase().contains(lowercaseQuery) ||
          location!.toLowerCase().contains(lowercaseQuery);

      if (matches) {
        // Add type to result for identification
        product['product_type'] = type;
      }

      return matches;
    }).toList();
  }

  // Get product by ID and type
  dynamic getProduct(int id, String type) {
    switch (type) {
      case 'hotel':
        return _hotels.firstWhere(
          (h) => safeGet<int>(h, r'$.id') == id,
          orElse: () => null,
        );
      case 'activity':
        return _activities.firstWhere(
          (a) => safeGet<int>(a, r'$.id') == id,
          orElse: () => null,
        );
      case 'transfer':
        return _transfers.firstWhere(
          (t) => safeGet<int>(t, r'$.id') == id,
          orElse: () => null,
        );
      case 'flight':
        return _flights.firstWhere(
          (f) => safeGet<int>(f, r'$.id') == id,
          orElse: () => null,
        );
      default:
        return null;
    }
  }

  // Get products by location
  List<dynamic> getProductsByLocation(int locationId) {
    final results = <dynamic>[];

    results.addAll(
        _hotels.where((h) => safeGet<int>(h, r'$.location_id') == locationId));

    results.addAll(_activities
        .where((a) => safeGet<int>(a, r'$.location_id') == locationId));

    results.addAll(_transfers
        .where((t) => safeGet<int>(t, r'$.location_id') == locationId));

    return results;
  }

  // Create product methods
  Future<int?> createHotel(Map<String, dynamic> hotelData) async {
    return await loadData(() async {
      // TODO: Implement proper create hotel API call when available
      // For now, add to local cache with mock ID
      final newId = DateTime.now().millisecondsSinceEpoch;
      final newHotel = {...hotelData, 'id': newId};
      _hotels.add(newHotel);
      _invalidateCache();
      return newId;
    });
  }

  Future<int?> createActivity(Map<String, dynamic> activityData) async {
    return await loadData(() async {
      // TODO: Implement proper create activity API call when available
      final newId = DateTime.now().millisecondsSinceEpoch;
      final newActivity = {...activityData, 'id': newId};
      _activities.add(newActivity);
      _invalidateCache();
      return newId;
    });
  }

  // Update product methods
  Future<bool> updateProduct(
      int id, String type, Map<String, dynamic> data) async {
    final result = await loadData(() async {
      dynamic response;

      switch (type) {
        case 'hotel':
          response = await UpdateHotelsCall.call(
            id: id.toString(),
            name: data['name'],
            description: data['description'],
            inclutions: data['inclusions'],
            exclutions: data['exclusions'],
          );
          if (response.succeeded) _hotels.clear();
          break;

        case 'activity':
          // TODO: Use proper update activity API call when available
          response = null;
          break;

        case 'transfer':
          // TODO: Use proper update transfer API call when available
          response = null;
          break;

        default:
          return false;
      }

      if (response?.succeeded ?? false) {
        _invalidateCache();
        _searchCache.clear();
        return true;
      }
      return false;
    });

    return result ?? false;
  }

  // Methods to manage selected items with granular notifications
  void setSelectedHotel(dynamic hotel) {
    if (_selectedHotel != hotel) {
      _selectedHotel = hotel;
      batchNotify('selectedHotel');
    }
  }

  void setSelectedActivity(dynamic activity) {
    if (_selectedActivity != activity) {
      _selectedActivity = activity;
      batchNotify('selectedActivity');
    }
  }

  void setSelectedTransfer(dynamic transfer) {
    if (_selectedTransfer != transfer) {
      _selectedTransfer = transfer;
      batchNotify('selectedTransfer');
    }
  }

  void setSelectedFlight(dynamic flight) {
    if (_selectedFlight != flight) {
      _selectedFlight = flight;
      batchNotify('selectedFlight');
    }
  }

  // Backward compatibility setters for allData* pattern
  set allDataHotel(dynamic value) {
    _selectedHotel = value;
    notifyListeners();
  }

  set allDataActivity(dynamic value) {
    _selectedActivity = value;
    notifyListeners();
  }

  set allDataTransfer(dynamic value) {
    _selectedTransfer = value;
    notifyListeners();
  }

  set allDataFlight(dynamic value) {
    _selectedFlight = value;
    notifyListeners();
  }

  // Clear selected items
  void clearSelectedItems() {
    _selectedHotel = null;
    _selectedActivity = null;
    _selectedTransfer = null;
    _selectedFlight = null;
    notifyListeners();
  }

  // Clear all caches
  void clearCache() {
    _hotels.clear();
    _activities.clear();
    _transfers.clear();
    _flights.clear();
    _searchCache.clear();
    clearSelectedItems();
    notifyListeners();
  }

  // Private method to invalidate cache
  void _invalidateCache() {
    _hotels.clear();
    _activities.clear();
    _transfers.clear();
    _flights.clear();
    _searchCache.clear();
    invalidateCache(); // Clear smart cache
    notifyImmediately();
  }

  void _cleanExpiredCache() {
    final now = DateTime.now();
    _searchCache.removeWhere((key, entry) => entry.isExpired);
  }

  // ============= MOCK METHODS FOR TESTING =============
  // These methods are for Widgetbook and testing only

  /// Set mock selected hotel data for testing
  void setAllDataHotel(Map<String, dynamic> data) {
    _selectedHotel = data;
  }
}

// Cache entry with TTL support
class _CacheEntry {
  final List<dynamic> data;
  final DateTime timestamp;

  _CacheEntry(this.data) : timestamp = DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(timestamp) > ProductService._searchCacheTimeout;
}
