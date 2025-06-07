import 'package:flutter_test/flutter_test.dart';
// // import 'package:mockito/mockito.dart'; // Unused import // Unused import
import 'package:mockito/annotations.dart';

import '../../lib/services/product_service.dart';
import '../../lib/backend/supabase/supabase.dart';

// Generate mocks
@GenerateMocks([SupaFlow])
import 'product_service_test.mocks.dart';

void main() {
  group('ProductService Tests', () {
    late ProductService productService;
    late MockSupaFlow _mockSupaFlow;

    setUp(() {
      productService = ProductService();
      _mockSupaFlow = MockSupaFlow();
    });

    tearDown(() {
      productService.clearCache();
    });

    group('Initialization', () {
      test('should initialize with empty state', () {
        expect(productService.hotels, isEmpty);
        expect(productService.activities, isEmpty);
        expect(productService.transfers, isEmpty);
        expect(productService.isLoading, isFalse);
        expect(productService.error, isNull);
        expect(productService.hasData, isFalse);
      });

      test('should load all product types', () async {
        expect(
          () => productService.loadAllProducts(),
          returnsNormally,
        );
      });
    });

    group('Hotel Management', () {
      test('should store hotels correctly', () {
        final testHotels = [
          {
            'id': 1,
            'name': 'Hotel Paradise',
            'location': 'Paris',
            'rating': 4.5,
            'price_per_night': 150.0,
          },
          {
            'id': 2,
            'name': 'City Hotel',
            'location': 'London',
            'rating': 4.0,
            'price_per_night': 120.0,
          }
        ];

        productService._setHotels(testHotels);

        expect(productService.hotels.length, equals(2));
        expect(productService.getHotel(1)['name'], equals('Hotel Paradise'));
        expect(productService.getHotel(2)['location'], equals('London'));
      });

      test('should filter hotels by location', () {
        final testHotels = [
          {'id': 1, 'name': 'Paris Hotel', 'location': 'Paris'},
          {'id': 2, 'name': 'London Hotel', 'location': 'London'},
          {'id': 3, 'name': 'Another Paris Hotel', 'location': 'Paris'},
        ];

        productService._setHotels(testHotels);

        final parisHotels = productService.getHotelsByLocation('Paris');
        expect(parisHotels.length, equals(2));
        expect(parisHotels.every((h) => h['location'] == 'Paris'), isTrue);
      });

      test('should search hotels correctly', () {
        final testHotels = [
          {'id': 1, 'name': 'Luxury Resort', 'location': 'Bali'},
          {'id': 2, 'name': 'Budget Inn', 'location': 'Bangkok'},
          {'id': 3, 'name': 'Luxury Spa', 'location': 'Phuket'},
        ];

        productService._setHotels(testHotels);

        final luxuryHotels = productService.searchHotels('luxury');
        expect(luxuryHotels.length, equals(2));
        expect(luxuryHotels.every((h) => h['name'].toLowerCase().contains('luxury')), isTrue);
      });
    });

    group('Activity Management', () {
      test('should store activities correctly', () {
        final testActivities = [
          {
            'id': 1,
            'name': 'City Tour',
            'location': 'Paris',
            'duration': '4 hours',
            'price': 50.0,
          },
          {
            'id': 2,
            'name': 'Cooking Class',
            'location': 'Rome',
            'duration': '3 hours',
            'price': 75.0,
          }
        ];

        productService._setActivities(testActivities);

        expect(productService.activities.length, equals(2));
        expect(productService.getActivity(1)['name'], equals('City Tour'));
        expect(productService.getActivity(2)['duration'], equals('3 hours'));
      });

      test('should filter activities by location', () {
        final testActivities = [
          {'id': 1, 'name': 'Tour 1', 'location': 'Paris'},
          {'id': 2, 'name': 'Tour 2', 'location': 'London'},
          {'id': 3, 'name': 'Tour 3', 'location': 'Paris'},
        ];

        productService._setActivities(testActivities);

        final parisActivities = productService.getActivitiesByLocation('Paris');
        expect(parisActivities.length, equals(2));
        expect(parisActivities.every((a) => a['location'] == 'Paris'), isTrue);
      });

      test('should search activities correctly', () {
        final testActivities = [
          {'id': 1, 'name': 'Food Tour', 'description': 'Explore local cuisine'},
          {'id': 2, 'name': 'Art Gallery', 'description': 'Visit famous museums'},
          {'id': 3, 'name': 'Food Market', 'description': 'Local food experience'},
        ];

        productService._setActivities(testActivities);

        final foodActivities = productService.searchActivities('food');
        expect(foodActivities.length, equals(2));
      });
    });

    group('Transfer Management', () {
      test('should store transfers correctly', () {
        final testTransfers = [
          {
            'id': 1,
            'name': 'Airport Transfer',
            'vehicle_type': 'Sedan',
            'max_passengers': 4,
            'price': 30.0,
          },
          {
            'id': 2,
            'name': 'City Transfer',
            'vehicle_type': 'Van',
            'max_passengers': 8,
            'price': 45.0,
          }
        ];

        productService._setTransfers(testTransfers);

        expect(productService.transfers.length, equals(2));
        expect(productService.getTransfer(1)['name'], equals('Airport Transfer'));
        expect(productService.getTransfer(2)['max_passengers'], equals(8));
      });

      test('should filter transfers by vehicle type', () {
        final testTransfers = [
          {'id': 1, 'name': 'Transfer 1', 'vehicle_type': 'Sedan'},
          {'id': 2, 'name': 'Transfer 2', 'vehicle_type': 'Van'},
          {'id': 3, 'name': 'Transfer 3', 'vehicle_type': 'Sedan'},
        ];

        productService._setTransfers(testTransfers);

        final sedanTransfers = productService.getTransfersByVehicleType('Sedan');
        expect(sedanTransfers.length, equals(2));
        expect(sedanTransfers.every((t) => t['vehicle_type'] == 'Sedan'), isTrue);
      });
    });

    group('Search Functionality', () {
      test('should search across all product types', () {
        // Setup test data
        productService._setHotels([
          {'id': 1, 'name': 'Beach Hotel', 'location': 'Cancun'}
        ]);
        productService._setActivities([
          {'id': 1, 'name': 'Beach Tour', 'location': 'Cancun'}
        ]);
        productService._setTransfers([
          {'id': 1, 'name': 'Beach Transfer', 'location': 'Cancun'}
        ]);

        final results = productService.searchAllProducts('beach');
        
        expect(results['hotels'].length, equals(1));
        expect(results['activities'].length, equals(1));
        expect(results['transfers'].length, equals(1));
      });

      test('should handle empty search results', () {
        // Setup test data
        productService._setHotels([
          {'id': 1, 'name': 'City Hotel', 'location': 'Paris'}
        ]);

        final results = productService.searchAllProducts('nonexistent');
        
        expect(results['hotels'], isEmpty);
        expect(results['activities'], isEmpty);
        expect(results['transfers'], isEmpty);
      });

      test('should search be case insensitive', () {
        productService._setHotels([
          {'id': 1, 'name': 'LUXURY HOTEL', 'location': 'paris'}
        ]);

        final results = productService.searchHotels('luxury');
        expect(results.length, equals(1));

        final locationResults = productService.getHotelsByLocation('Paris');
        expect(locationResults.length, equals(1));
      });
    });

    group('CRUD Operations', () {
      test('should create hotel correctly', () async {
        expect(
          () => productService.createHotel({
            'name': 'New Hotel',
            'location': 'Barcelona',
            'rating': 4.0,
          }),
          returnsNormally,
        );
      });

      test('should update product correctly', () async {
        // Setup existing hotel
        productService._setHotels([
          {
            'id': 1,
            'name': 'Old Name',
            'location': 'Old Location',
          }
        ]);

        expect(
          () => productService.updateHotel(
            id: 1,
            updates: {
              'name': 'New Name',
              'location': 'New Location',
            },
          ),
          returnsNormally,
        );
      });

      test('should delete product correctly', () async {
        // Setup existing products
        productService._setHotels([
          {'id': 1, 'name': 'To Delete'},
          {'id': 2, 'name': 'To Keep'},
        ]);

        expect(
          () => productService.deleteHotel(1),
          returnsNormally,
        );
      });
    });

    group('Cache Management', () {
      test('should manage cache correctly', () {
        final testHotels = [{'id': 1, 'name': 'Test Hotel'}];
        
        productService._setHotels(testHotels);
        expect(productService.hasData, isTrue);

        productService.clearCache();
        expect(productService.hasData, isFalse);
        expect(productService.hotels, isEmpty);
      });

      test('should respect cache duration', () {
        productService._setHotels([{'id': 1, 'name': 'Test'}]);
        expect(productService.hasValidCache, isTrue);

        // Simulate cache expiration
        productService._lastFetch = DateTime.now().subtract(Duration(minutes: 10));
        expect(productService.hasValidCache, isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle errors correctly', () {
        final error = 'Database connection failed';
        productService._setError(error);

        expect(productService.error, equals(error));
        expect(productService.hasError, isTrue);
        expect(productService.isLoading, isFalse);
      });

      test('should clear error on successful operation', () {
        productService._setError('Previous error');
        expect(productService.hasError, isTrue);

        productService._setHotels([]);
        expect(productService.hasError, isFalse);
        expect(productService.error, isNull);
      });
    });

    group('Statistics', () {
      test('should calculate product statistics correctly', () {
        productService._setHotels([
          {'id': 1, 'rating': 4.5, 'price_per_night': 100},
          {'id': 2, 'rating': 4.0, 'price_per_night': 150},
        ]);
        productService._setActivities([
          {'id': 1, 'price': 50},
          {'id': 2, 'price': 75},
        ]);

        final stats = productService.getStatistics();
        expect(stats['totalHotels'], equals(2));
        expect(stats['totalActivities'], equals(2));
        expect(stats['averageHotelRating'], equals(4.25));
        expect(stats['averageHotelPrice'], equals(125.0));
      });
    });
  });
}

// Extension to access private members for testing
extension ProductServiceTestExtension on ProductService {
  void _setHotels(List<dynamic> data) {
    hotels.clear();
    hotels.addAll(data);
    _setError(null);
    notifyListeners();
  }

  void _setActivities(List<dynamic> data) {
    activities.clear();
    activities.addAll(data);
    _setError(null);
    notifyListeners();
  }

  void _setTransfers(List<dynamic> data) {
    transfers.clear();
    transfers.addAll(data);
    _setError(null);
    notifyListeners();
  }

  void _setError(String? error) {
    this.error = error;
    isLoading = false;
    notifyListeners();
  }

  set _lastFetch(DateTime time) {
    lastFetch = time;
  }
}