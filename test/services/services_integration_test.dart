import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:bukeer/services/user_service.dart';
import 'package:bukeer/app_state.dart';

/// Integration tests for core services working together
void main() {
  group('Services Integration Tests', () {
    late UiStateService uiStateService;
    late UserService userService;
    late FFAppState appState;

    setUp(() {
      uiStateService = UiStateService();
      userService = UserService();
      appState = FFAppState();
    });

    tearDown(() {
      uiStateService.clearAll();
      userService.clearUserData();
      // clearState method was removed - state is now managed by services;
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
        expect(uiStateService.currentPage, equals(1));
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

        // These should remain unchanged by clearAll()
        expect(uiStateService.selectedProductType,
            equals('activities')); // Default value
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

    group('FFAppState Core Functionality', () {
      test('should manage account state', () {
        expect(appState.accountId, equals(''));
        expect(appState.idRole, equals(0));

        appState.accountId = 'account-123';
        appState.idRole = 1; // Admin

        expect(appState.accountId, equals('account-123'));
        expect(appState.idRole, equals(1));
      });

      test('should manage agent data', () {
        final agentData = {
          'id': 'agent-123',
          'name': 'Test Agent',
          'role_id': 1,
        };

        appState.agent = agentData;
        expect(appState.agent, equals(agentData));
      });

      test('should clear state correctly', () {
        // Set some state
        appState.accountId = 'test-account';
        appState.idRole = 2;
        appState.agent = {'test': 'agent'};
        appState.allDataAccount = {'test': 'account'};

        // Clear state
        // clearState method was removed - state is now managed by services;

        // Verify cleared
        expect(appState.accountId, equals(''));
        expect(appState.idRole, equals(0));
        expect(appState.agent, isNull);
        expect(appState.allDataAccount, isNull);
      });
    });

    group('Cross-Service Integration', () {
      test('should work together for product management workflow', () {
        // Simulate a product management workflow

        // 1. Set account context
        appState.accountId = 'account-123';
        appState.idRole = 1; // Admin

        // 2. Search for products
        uiStateService.searchQuery = 'beach hotel';
        uiStateService.selectedProductType = 'hotels';

        // 3. Select a product
        uiStateService.selectedProductId = 'hotel-456';

        // 4. Set location for the product
        uiStateService.setSelectedLocation(
          latLng: 'LatLng(25.7617, -80.1918)',
          name: 'Miami Beach Hotel',
          city: 'Miami',
          state: 'FL',
          country: 'USA',
        );

        // 5. Set user context
        userService.setSelectedUser({
          'id': 'user-789',
          'name': 'Product Manager',
          'role': 'admin',
        });

        // Verify all services maintain their state
        expect(appState.accountId, equals('account-123'));
        expect(uiStateService.searchQuery, equals('beach hotel'));
        expect(uiStateService.selectedProductType, equals('hotels'));
        expect(uiStateService.selectedProductId, equals('hotel-456'));
        expect(uiStateService.selectedLocationCity, equals('Miami'));
        expect(userService.selectedUser?['name'], equals('Product Manager'));
      });

      test('should handle cleanup workflow correctly', () {
        // Set up complex state across all services
        appState.accountId = 'test-account';
        appState.agent = {'name': 'Test Agent'};

        uiStateService.searchQuery = 'test search';
        uiStateService.selectedProductId = 'product-123';
        uiStateService.setSelectedLocation(
            name: 'Test Location', city: 'Test City');

        userService.setSelectedUser({'name': 'Test User'});

        // Clear all services
        // clearState method was removed - state is now managed by services;
        uiStateService.clearAll();
        userService.clearUserData();

        // Verify complete cleanup
        expect(appState.accountId, equals(''));
        expect(appState.agent, isNull);
        expect(uiStateService.searchQuery, equals(''));
        expect(uiStateService.selectedProductId, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(userService.selectedUser, isNull);
        expect(userService.hasLoadedData, isFalse);
      });
    });

    group('Performance and Memory Tests', () {
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
          appState.accountId = 'account-$i';
          userService.setSelectedUser({'id': 'user-$i'});

          // Clear state
          uiStateService.clearAll();
          // clearState method was removed - state is now managed by services;
          userService.clearUserData();
        }

        // Verify final clean state
        expect(uiStateService.searchQuery, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(appState.accountId, equals(''));
        expect(userService.selectedUser, isNull);
      });
    });
  });
}
