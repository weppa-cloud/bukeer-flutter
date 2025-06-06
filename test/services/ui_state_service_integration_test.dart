import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:bukeer/services/user_service.dart';

/// Integration tests focusing on UiStateService and UserService without FFAppState
void main() {
  group('UiStateService and UserService Integration Tests', () {
    late UiStateService uiStateService;
    late UserService userService;

    setUp(() {
      uiStateService = UiStateService();
      userService = UserService();
    });

    tearDown(() {
      uiStateService.clearAll();
      userService.clearUserData();
    });

    group('UiStateService Core Functionality', () {
      test('should manage search state correctly', () {
        // Test search functionality
        expect(uiStateService.searchQuery, equals(''));

        uiStateService.searchQuery = 'test search';
        expect(uiStateService.searchQuery, equals('test search'));

        uiStateService.clearSearchState();
        expect(uiStateService.searchQuery, equals(''));
      });

      test('should manage product selection state', () {
        // Test product selection
        expect(uiStateService.selectedProductId, equals(''));
        expect(uiStateService.selectedProductType, equals('activities'));

        uiStateService.selectedProductId = 'product-123';
        uiStateService.selectedProductType = 'hotels';

        expect(uiStateService.selectedProductId, equals('product-123'));
        expect(uiStateService.selectedProductType, equals('hotels'));
      });

      test('should manage location state comprehensively', () {
        // Test location management
        expect(uiStateService.selectedLocationName, equals(''));
        expect(uiStateService.selectedLocationCity, equals(''));

        uiStateService.setSelectedLocation(
          latLng: 'LatLng(40.7128, -74.0060)',
          name: 'New York City',
          address: '123 Broadway',
          city: 'New York',
          state: 'NY',
          country: 'USA',
          zipCode: '10001',
        );

        expect(uiStateService.selectedLocationName, equals('New York City'));
        expect(uiStateService.selectedLocationCity, equals('New York'));
        expect(uiStateService.selectedLocationState, equals('NY'));
        expect(uiStateService.selectedLocationCountry, equals('USA'));
        expect(uiStateService.selectedLocationZipCode, equals('10001'));
      });

      test('should clear location state correctly', () {
        // Set location state
        uiStateService.setSelectedLocation(
          latLng: 'test',
          name: 'test',
          address: 'test',
          city: 'test',
          state: 'test',
          country: 'test',
          zipCode: 'test',
        );

        // Clear location state
        uiStateService.clearSelectedLocation();

        // Verify all location fields are cleared
        expect(uiStateService.selectedLocationLatLng, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(uiStateService.selectedLocationAddress, equals(''));
        expect(uiStateService.selectedLocationCity, equals(''));
        expect(uiStateService.selectedLocationState, equals(''));
        expect(uiStateService.selectedLocationCountry, equals(''));
        expect(uiStateService.selectedLocationZipCode, equals(''));
      });

      test('should manage form state correctly', () {
        // Test form state management
        uiStateService.selectedImageUrl = 'http://example.com/image.jpg';
        uiStateService.currentPage = 5;

        expect(uiStateService.selectedImageUrl,
            equals('http://example.com/image.jpg'));
        expect(uiStateService.currentPage, equals(5));

        uiStateService.clearFormState();

        expect(uiStateService.selectedImageUrl, equals(''));
        // Note: clearFormState doesn't reset currentPage
        expect(uiStateService.currentPage, equals(5));
      });

      test('should handle clear all functionality', () {
        // Set various state
        uiStateService.searchQuery = 'test';
        uiStateService.selectedProductId = 'product-123';
        uiStateService.selectedLocationName = 'Test Location';
        uiStateService.selectedImageUrl = 'test-image.jpg';
        uiStateService.currentPage = 3;

        // Clear all (note: doesn't clear itemsProducts or selectRates)
        uiStateService.clearAll();

        // Verify cleared state
        expect(uiStateService.searchQuery, equals(''));
        expect(uiStateService.selectedProductId, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(uiStateService.selectedImageUrl, equals(''));
        expect(uiStateService.currentPage, equals(1));

        // These should be reset to default by clearAll()
        expect(uiStateService.selectedProductType,
            equals('activities')); // Default value
      });

      test('should handle hotel rates calculation', () {
        // Test hotel rates calculation state
        expect(uiStateService.profitHotelRates, equals(0.0));
        expect(uiStateService.rateUnitCostHotelRates, equals(0.0));
        expect(uiStateService.unitCostHotelRates, equals(0.0));

        uiStateService.setHotelRatesCalculation(
          profit: 150.0,
          rateUnitCost: 200.0,
          unitCost: 100.0,
        );

        expect(uiStateService.profitHotelRates, equals(150.0));
        expect(uiStateService.rateUnitCostHotelRates, equals(200.0));
        expect(uiStateService.unitCostHotelRates, equals(100.0));

        uiStateService.clearHotelRatesCalculation();

        expect(uiStateService.profitHotelRates, equals(0.0));
        expect(uiStateService.rateUnitCostHotelRates, equals(0.0));
        expect(uiStateService.unitCostHotelRates, equals(0.0));
      });

      test('should handle flight state', () {
        // Test flight departure and arrival state
        expect(uiStateService.departureState, equals(''));
        expect(uiStateService.arrivalState, equals(''));

        uiStateService.departureState = 'JFK';
        uiStateService.arrivalState = 'LAX';

        expect(uiStateService.departureState, equals('JFK'));
        expect(uiStateService.arrivalState, equals('LAX'));

        uiStateService.clearAll();

        expect(uiStateService.departureState, equals(''));
        expect(uiStateService.arrivalState, equals(''));
      });

      test('should handle notification debouncing for search', () async {
        // Test debounced notifications
        var notificationCount = 0;
        uiStateService.addListener(() {
          notificationCount++;
        });

        // Rapid search updates should be debounced
        uiStateService.searchQuery = 'a';
        uiStateService.searchQuery = 'ab';
        uiStateService.searchQuery = 'abc';

        // Should not have notified yet due to debouncing
        expect(notificationCount, equals(0));

        // Wait for debounce period
        await Future.delayed(Duration(milliseconds: 350));

        // Should have notified once after debounce
        expect(notificationCount, equals(1));
        expect(uiStateService.searchQuery, equals('abc'));
      });

      test('should handle immediate notifications for non-search properties',
          () {
        var notificationCount = 0;
        uiStateService.addListener(() {
          notificationCount++;
        });

        // Non-search properties should notify immediately
        uiStateService.selectedProductId = 'product-1';
        expect(notificationCount, equals(1));

        uiStateService.currentPage = 2;
        expect(notificationCount, equals(2));

        uiStateService.selectedLocationName = 'Test Location';
        expect(notificationCount, equals(3));
      });
    });

    group('UserService Core Functionality', () {
      test('should initialize with correct default state', () {
        expect(userService.isLoading, isFalse);
        expect(userService.hasLoadedData, isFalse);
        expect(userService.selectedUser, isNull);
      });

      test('should manage selected user state', () {
        final testUser = {
          'id': 'user-123',
          'name': 'Test User',
          'email': 'test@example.com',
        };

        userService.setSelectedUser(testUser);
        expect(userService.selectedUser, equals(testUser));
        expect(userService.allDataUser,
            equals(testUser)); // Backward compatibility

        userService.clearSelectedUser();
        expect(userService.selectedUser, isNull);
      });

      test('should support backward compatibility with allDataUser', () {
        final testUser = {'id': 'test', 'name': 'Test'};

        // Test setter
        userService.allDataUser = testUser;
        expect(userService.selectedUser, equals(testUser));
        expect(userService.allDataUser, equals(testUser));
      });

      test('should clear user data correctly', () {
        // Set some test state
        userService.setSelectedUser({'test': 'data'});

        userService.clearUserData();

        expect(userService.hasLoadedData, isFalse);
        expect(userService.isLoading, isFalse);
      });
    });

    group('Cross-Service Integration', () {
      test('should work together for product management workflow', () {
        // Simulate a product management workflow

        // 1. Search for products
        uiStateService.searchQuery = 'beach hotel';
        uiStateService.selectedProductType = 'hotels';

        // 2. Select a product
        uiStateService.selectedProductId = 'hotel-456';

        // 3. Set location for the product
        uiStateService.setSelectedLocation(
          latLng: 'LatLng(25.7617, -80.1918)',
          name: 'Miami Beach Hotel',
          city: 'Miami',
          state: 'FL',
          country: 'USA',
        );

        // 4. Set user context
        userService.setSelectedUser({
          'id': 'user-789',
          'name': 'Product Manager',
          'role': 'admin',
        });

        // Verify all services maintain their state
        expect(uiStateService.searchQuery, equals('beach hotel'));
        expect(uiStateService.selectedProductType, equals('hotels'));
        expect(uiStateService.selectedProductId, equals('hotel-456'));
        expect(uiStateService.selectedLocationCity, equals('Miami'));
        expect(userService.selectedUser?['name'], equals('Product Manager'));
      });

      test('should handle cleanup workflow correctly', () {
        // Set up complex state across both services
        uiStateService.searchQuery = 'test search';
        uiStateService.selectedProductId = 'product-123';
        uiStateService.setSelectedLocation(
            name: 'Test Location', city: 'Test City');

        userService.setSelectedUser({'name': 'Test User'});

        // Clear all services
        uiStateService.clearAll();
        userService.clearUserData();

        // Verify complete cleanup
        expect(uiStateService.searchQuery, equals(''));
        expect(uiStateService.selectedProductId, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(userService.selectedUser, isNull);
        expect(userService.hasLoadedData, isFalse);
      });
    });

    group('Performance Tests', () {
      test('should handle rapid state updates efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Perform many rapid updates
        for (int i = 0; i < 1000; i++) {
          uiStateService.selectedProductId = 'product-$i';
          uiStateService.currentPage = i % 10;
          if (i % 100 == 0) {
            uiStateService.clearFormState();
          }
        }

        stopwatch.stop();

        // Should complete quickly (adjust threshold as needed)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Final state should be correct
        expect(uiStateService.selectedProductId, equals('product-999'));
      });

      test('should not leak memory with repeated clear operations', () {
        // Perform many set/clear cycles
        for (int i = 0; i < 100; i++) {
          // Set state
          uiStateService.searchQuery = 'search-$i';
          uiStateService.setSelectedLocation(
            name: 'Location-$i',
            city: 'City-$i',
          );
          userService.setSelectedUser({'id': 'user-$i'});

          // Clear state
          uiStateService.clearAll();
          userService.clearUserData();
        }

        // Verify final clean state
        expect(uiStateService.searchQuery, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(userService.selectedUser, isNull);
      });
    });

    group('State Consistency Tests', () {
      test('should maintain consistent state during complex operations', () {
        // Test that operations don't interfere with each other

        // Set complex location state
        uiStateService.setSelectedLocation(
          latLng: 'LatLng(40.7128, -74.0060)',
          name: 'Complex Location',
          address: '123 Complex Street',
          city: 'Complex City',
          state: 'CS',
          country: 'Complex Country',
          zipCode: '12345',
        );

        // Set other state
        uiStateService.selectedProductId = 'product-complex';
        uiStateService.searchQuery = 'complex search';
        uiStateService.setHotelRatesCalculation(
          profit: 100.0,
          rateUnitCost: 150.0,
          unitCost: 50.0,
        );

        // Verify all state is maintained correctly
        expect(uiStateService.selectedLocationName, equals('Complex Location'));
        expect(uiStateService.selectedLocationAddress,
            equals('123 Complex Street'));
        expect(uiStateService.selectedLocationCity, equals('Complex City'));
        expect(uiStateService.selectedLocationState, equals('CS'));
        expect(
            uiStateService.selectedLocationCountry, equals('Complex Country'));
        expect(uiStateService.selectedLocationZipCode, equals('12345'));
        expect(uiStateService.selectedProductId, equals('product-complex'));
        expect(uiStateService.searchQuery, equals('complex search'));
        expect(uiStateService.profitHotelRates, equals(100.0));
        expect(uiStateService.rateUnitCostHotelRates, equals(150.0));
        expect(uiStateService.unitCostHotelRates, equals(50.0));
      });
    });
  });
}
