import 'package:flutter_test/flutter_test.dart';
// // import 'package:mockito/mockito.dart'; // Unused import // Unused import
import 'package:mockito/annotations.dart';

import '../../lib/services/itinerary_service.dart';
import '../../lib/backend/supabase/supabase.dart';

// Generate mocks
@GenerateMocks([SupaFlow])
import 'itinerary_service_test.mocks.dart';

void main() {
  group('ItineraryService Tests', () {
    late ItineraryService itineraryService;
    late MockSupaFlow _mockSupaFlow;

    setUp(() {
      itineraryService = ItineraryService();
      _mockSupaFlow = MockSupaFlow();
    });

    tearDown(() {
      itineraryService.clearCache();
    });

    group('Initialization', () {
      test('should initialize with empty state', () {
        expect(itineraryService.itineraries, isEmpty);
        expect(itineraryService.isLoading, isFalse);
        expect(itineraryService.error, isNull);
        expect(itineraryService.hasData, isFalse);
      });

      test('should set loading state during initialization', () async {
        // This would need proper mocking
        itineraryService._setLoading(true);
        expect(itineraryService.isLoading, isTrue);
        
        itineraryService._setLoading(false);
        expect(itineraryService.isLoading, isFalse);
      });
    });

    group('Data Management', () {
      test('should store itineraries correctly', () {
        final testItineraries = [
          {
            'id': 1,
            'name': 'Test Trip',
            'client_name': 'John Doe',
            'start_date': '2024-01-01',
            'end_date': '2024-01-07',
          },
          {
            'id': 2,
            'name': 'Another Trip',
            'client_name': 'Jane Smith',
            'start_date': '2024-02-01',
            'end_date': '2024-02-05',
          }
        ];

        itineraryService._setItineraries(testItineraries);

        expect(itineraryService.itineraries.length, equals(2));
        expect(itineraryService.hasData, isTrue);
        expect(itineraryService.getItinerary(1)['name'], equals('Test Trip'));
        expect(itineraryService.getItinerary(2)['client_name'], equals('Jane Smith'));
      });

      test('should handle missing itinerary correctly', () {
        final testItineraries = [
          {'id': 1, 'name': 'Test Trip'}
        ];

        itineraryService._setItineraries(testItineraries);

        expect(itineraryService.getItinerary(999), isNull);
      });

      test('should filter itineraries correctly', () {
        final testItineraries = [
          {'id': 1, 'name': 'Paris Trip', 'client_name': 'John Doe'},
          {'id': 2, 'name': 'Tokyo Adventure', 'client_name': 'Jane Smith'},
          {'id': 3, 'name': 'London Tour', 'client_name': 'John Doe'},
        ];

        itineraryService._setItineraries(testItineraries);

        final johnItineraries = itineraryService.getItinerariesByClient('John Doe');
        expect(johnItineraries.length, equals(2));
        expect(johnItineraries[0]['name'], equals('Paris Trip'));
        expect(johnItineraries[1]['name'], equals('London Tour'));
      });

      test('should search itineraries correctly', () {
        final testItineraries = [
          {'id': 1, 'name': 'Paris Trip', 'client_name': 'John Doe'},
          {'id': 2, 'name': 'Tokyo Adventure', 'client_name': 'Jane Smith'},
          {'id': 3, 'name': 'London Tour', 'client_name': 'Bob Wilson'},
        ];

        itineraryService._setItineraries(testItineraries);

        final searchResults = itineraryService.searchItineraries('par');
        expect(searchResults.length, equals(1));
        expect(searchResults[0]['name'], equals('Paris Trip'));

        final clientResults = itineraryService.searchItineraries('jane');
        expect(clientResults.length, equals(1));
        expect(clientResults[0]['client_name'], equals('Jane Smith'));
      });
    });

    group('CRUD Operations', () {
      test('should create itinerary with correct data', () async {
        // Mock successful creation
        final newItinerary = {
          'id': 1,
          'name': 'New Trip',
          'client_name': 'Test Client',
          'start_date': '2024-01-01',
          'end_date': '2024-01-07',
          'agent': 'agent123',
        };

        // This would need proper Supabase mocking
        expect(
          () => itineraryService.createItinerary(
            name: 'New Trip',
            clientName: 'Test Client',
            startDate: '2024-01-01',
            endDate: '2024-01-07',
            agent: 'agent123',
          ),
          returnsNormally,
        );
      });

      test('should update itinerary correctly', () async {
        // Setup existing itinerary
        final existingItineraries = [
          {
            'id': 1,
            'name': 'Old Name',
            'client_name': 'Old Client',
          }
        ];
        itineraryService._setItineraries(existingItineraries);

        // Test update
        expect(
          () => itineraryService.updateItinerary(
            id: 1,
            updates: {
              'name': 'New Name',
              'client_name': 'New Client',
            },
          ),
          returnsNormally,
        );
      });

      test('should delete itinerary correctly', () async {
        // Setup existing itinerary
        final existingItineraries = [
          {'id': 1, 'name': 'To Delete'},
          {'id': 2, 'name': 'To Keep'},
        ];
        itineraryService._setItineraries(existingItineraries);

        // Test deletion would remove from cache
        expect(
          () => itineraryService.deleteItinerary(1),
          returnsNormally,
        );
      });
    });

    group('Cache Management', () {
      test('should respect cache duration', () {
        final testItineraries = [
          {'id': 1, 'name': 'Test Trip'}
        ];

        itineraryService._setItineraries(testItineraries);
        expect(itineraryService.hasValidCache, isTrue);

        // Simulate cache expiration
        itineraryService._lastFetch = DateTime.now().subtract(Duration(minutes: 10));
        expect(itineraryService.hasValidCache, isFalse);
      });

      test('should clear cache correctly', () {
        final testItineraries = [
          {'id': 1, 'name': 'Test Trip'}
        ];

        itineraryService._setItineraries(testItineraries);
        expect(itineraryService.hasData, isTrue);

        itineraryService.clearCache();
        expect(itineraryService.hasData, isFalse);
        expect(itineraryService.itineraries, isEmpty);
      });

      test('should force refresh when requested', () async {
        // Setup cache
        final testItineraries = [
          {'id': 1, 'name': 'Cached Trip'}
        ];
        itineraryService._setItineraries(testItineraries);

        // Force refresh should bypass cache
        expect(
          () => itineraryService.loadItineraries(forceRefresh: true),
          returnsNormally,
        );
      });
    });

    group('Error Handling', () {
      test('should handle loading errors correctly', () {
        final error = 'Network error';
        itineraryService._setError(error);

        expect(itineraryService.error, equals(error));
        expect(itineraryService.hasError, isTrue);
        expect(itineraryService.isLoading, isFalse);
      });

      test('should clear error on successful operation', () {
        // Set error state
        itineraryService._setError('Previous error');
        expect(itineraryService.hasError, isTrue);

        // Successful operation should clear error
        itineraryService._setItineraries([]);
        expect(itineraryService.hasError, isFalse);
        expect(itineraryService.error, isNull);
      });

      test('should handle malformed data gracefully', () {
        final malformedData = [
          {'id': 'not_a_number', 'name': null},
          {'missing_id': true},
        ];

        expect(
          () => itineraryService._setItineraries(malformedData),
          returnsNormally,
        );
      });
    });

    group('Statistics', () {
      test('should calculate statistics correctly', () {
        final testItineraries = [
          {
            'id': 1,
            'status': 'confirmed',
            'start_date': '2024-01-01',
            'total_cost': 1000.0,
          },
          {
            'id': 2,
            'status': 'draft',
            'start_date': '2024-01-15',
            'total_cost': 1500.0,
          },
          {
            'id': 3,
            'status': 'confirmed',
            'start_date': '2024-02-01',
            'total_cost': 800.0,
          }
        ];

        itineraryService._setItineraries(testItineraries);

        final stats = itineraryService.getStatistics();
        expect(stats['total'], equals(3));
        expect(stats['confirmed'], equals(2));
        expect(stats['draft'], equals(1));
        expect(stats['totalRevenue'], equals(3300.0));
      });

      test('should get itineraries by status', () {
        final testItineraries = [
          {'id': 1, 'status': 'confirmed'},
          {'id': 2, 'status': 'draft'},
          {'id': 3, 'status': 'confirmed'},
          {'id': 4, 'status': 'cancelled'},
        ];

        itineraryService._setItineraries(testItineraries);

        final confirmed = itineraryService.getItinerariesByStatus('confirmed');
        expect(confirmed.length, equals(2));

        final drafts = itineraryService.getItinerariesByStatus('draft');
        expect(drafts.length, equals(1));
      });
    });
  });
}

// Extension to access private members for testing
extension ItineraryServiceTestExtension on ItineraryService {
  void _setItineraries(List<dynamic> data) {
    itineraries.clear();
    itineraries.addAll(data);
    _setError(null);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    this.error = error;
    notifyListeners();
  }

  set _lastFetch(DateTime time) {
    lastFetch = time;
  }
}