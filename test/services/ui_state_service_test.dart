import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/ui_state_service.dart';

void main() {
  group('UiStateService Tests', () {
    late UiStateService uiStateService;

    setUp(() {
      uiStateService = UiStateService();
    });

    group('Search Query Management', () {
      test('should initialize with empty search query', () {
        expect(uiStateService.searchQuery, equals(''));
      });

      test('should update search query', () {
        const testQuery = 'test search';
        uiStateService.searchQuery = testQuery;
        expect(uiStateService.searchQuery, equals(testQuery));
      });

      test('should clear search query using clearSearchState', () {
        uiStateService.searchQuery = 'test';
        uiStateService.clearSearchState();
        expect(uiStateService.searchQuery, equals(''));
      });
    });

    group('Product Selection Management', () {
      test('should initialize with default product state', () {
        expect(uiStateService.selectedProductId, equals(''));
        expect(uiStateService.selectedProductType, equals('activities'));
        expect(uiStateService.itemsProducts, isNull);
      });

      test('should set and get selected product', () {
        const productId = 'product-123';
        const productType = 'hotels';
        final productData = {'id': productId, 'name': 'Test Hotel'};

        uiStateService.selectedProductId = productId;
        uiStateService.selectedProductType = productType;
        uiStateService.itemsProducts = productData;

        expect(uiStateService.selectedProductId, equals(productId));
        expect(uiStateService.selectedProductType, equals(productType));
        expect(uiStateService.itemsProducts, equals(productData));
      });

      test('should clear selected product state using clearAll', () {
        uiStateService.selectedProductId = 'test';
        uiStateService.selectedProductType = 'hotels';
        uiStateService.itemsProducts = {'test': 'data'};

        uiStateService.clearAll();

        expect(uiStateService.selectedProductId, equals(''));
        expect(uiStateService.selectedProductType, equals('activities'));
        // Note: clearAll() doesn't clear itemsProducts, so it retains its value
        expect(uiStateService.itemsProducts, equals({'test': 'data'}));
      });
    });

    group('Contact Selection Management', () {
      test('should initialize with null selected contact', () {
        expect(uiStateService.selectedContact, isNull);
      });

      test('should set and get selected contact', () {
        final contactData = {'id': 'contact-123', 'name': 'Test Contact'};
        uiStateService.selectedContact = contactData;
        expect(uiStateService.selectedContact, equals(contactData));
      });

      test('should clear selected contact using clearAll', () {
        uiStateService.selectedContact = {'test': 'data'};
        uiStateService.clearAll();
        expect(uiStateService.selectedContact, isNull);
      });
    });

    group('Image Management', () {
      test('should initialize with empty selected image', () {
        expect(uiStateService.selectedImageUrl, equals(''));
      });

      test('should set and get selected image URL', () {
        const imageUrl = 'https://example.com/image.jpg';
        uiStateService.selectedImageUrl = imageUrl;
        expect(uiStateService.selectedImageUrl, equals(imageUrl));
      });

      test('should clear selected image using clearFormState', () {
        uiStateService.selectedImageUrl = 'test-url';
        uiStateService.clearFormState();
        expect(uiStateService.selectedImageUrl, equals(''));
      });
    });

    group('Location Management', () {
      test('should initialize with empty location data', () {
        expect(uiStateService.selectedLocationLatLng, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(uiStateService.selectedLocationAddress, equals(''));
        expect(uiStateService.selectedLocationCity, equals(''));
        expect(uiStateService.selectedLocationState, equals(''));
        expect(uiStateService.selectedLocationCountry, equals(''));
        expect(uiStateService.selectedLocationZipCode, equals(''));
      });

      test('should set complete location data', () {
        uiStateService.setSelectedLocation(
          latLng: 'LatLng(lat: 40.7128, lng: -74.0060)',
          name: 'New York City',
          address: '123 Main St',
          city: 'New York',
          state: 'NY',
          country: 'USA',
          zipCode: '10001',
        );

        expect(uiStateService.selectedLocationLatLng,
            equals('LatLng(lat: 40.7128, lng: -74.0060)'));
        expect(uiStateService.selectedLocationName, equals('New York City'));
        expect(uiStateService.selectedLocationAddress, equals('123 Main St'));
        expect(uiStateService.selectedLocationCity, equals('New York'));
        expect(uiStateService.selectedLocationState, equals('NY'));
        expect(uiStateService.selectedLocationCountry, equals('USA'));
        expect(uiStateService.selectedLocationZipCode, equals('10001'));
      });

      test('should set partial location data without affecting unset fields',
          () {
        uiStateService.setSelectedLocation(
          latLng: 'LatLng(lat: 40.7128, lng: -74.0060)',
          name: 'New York City',
        );

        expect(uiStateService.selectedLocationLatLng,
            equals('LatLng(lat: 40.7128, lng: -74.0060)'));
        expect(uiStateService.selectedLocationName, equals('New York City'));
        expect(uiStateService.selectedLocationAddress, equals(''));
        expect(uiStateService.selectedLocationCity, equals(''));
        expect(uiStateService.selectedLocationState, equals(''));
        expect(uiStateService.selectedLocationCountry, equals(''));
        expect(uiStateService.selectedLocationZipCode, equals(''));
      });

      test('should clear location data', () {
        uiStateService.setSelectedLocation(
          latLng: 'LatLng(lat: 40.7128, lng: -74.0060)',
          name: 'New York City',
          address: '123 Main St',
        );

        uiStateService.clearSelectedLocation();

        expect(uiStateService.selectedLocationLatLng, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(uiStateService.selectedLocationAddress, equals(''));
        expect(uiStateService.selectedLocationCity, equals(''));
        expect(uiStateService.selectedLocationState, equals(''));
        expect(uiStateService.selectedLocationCountry, equals(''));
        expect(uiStateService.selectedLocationZipCode, equals(''));
      });
    });

    group('Itinerary Creation Flag', () {
      test('should initialize with false isCreatedInItinerary', () {
        expect(uiStateService.isCreatedInItinerary, isFalse);
      });

      test('should set and get isCreatedInItinerary', () {
        uiStateService.isCreatedInItinerary = true;
        expect(uiStateService.isCreatedInItinerary, isTrue);

        uiStateService.isCreatedInItinerary = false;
        expect(uiStateService.isCreatedInItinerary, isFalse);
      });
    });

    group('Account Configuration', () {
      test('should initialize with empty account lists', () {
        expect(uiStateService.accountCurrency, isEmpty);
        expect(uiStateService.accountPaymentMethods, isEmpty);
        expect(uiStateService.accountTypesIncrease, isEmpty);
        expect(uiStateService.allDataAccount, isNull);
      });

      test('should set and get account currency', () {
        final currencies = [
          {'code': 'USD', 'name': 'US Dollar'},
          {'code': 'EUR', 'name': 'Euro'}
        ];
        uiStateService.accountCurrency = currencies;
        expect(uiStateService.accountCurrency, equals(currencies));
      });

      test('should set and get account payment methods', () {
        final paymentMethods = [
          {'id': 1, 'name': 'Credit Card'},
          {'id': 2, 'name': 'Cash'}
        ];
        uiStateService.accountPaymentMethods = paymentMethods;
        expect(uiStateService.accountPaymentMethods, equals(paymentMethods));
      });

      test('should set and get account types increase', () {
        final typesIncrease = [
          {'id': 1, 'name': 'Percentage'},
          {'id': 2, 'name': 'Fixed Amount'}
        ];
        uiStateService.accountTypesIncrease = typesIncrease;
        expect(uiStateService.accountTypesIncrease, equals(typesIncrease));
      });

      test('should set and get all data account', () {
        final accountData = {
          'id': 'account-123',
          'name': 'Test Account',
          'settings': {'theme': 'dark'}
        };
        uiStateService.allDataAccount = accountData;
        expect(uiStateService.allDataAccount, equals(accountData));
      });

      test('should clear account configuration using clearAll', () {
        uiStateService.accountCurrency = [
          {'test': 'data'}
        ];
        uiStateService.accountPaymentMethods = [
          {'test': 'data'}
        ];
        uiStateService.accountTypesIncrease = [
          {'test': 'data'}
        ];
        uiStateService.allDataAccount = {'test': 'data'};

        uiStateService.clearAll();

        expect(uiStateService.accountCurrency, isEmpty);
        expect(uiStateService.accountPaymentMethods, isEmpty);
        expect(uiStateService.accountTypesIncrease, isEmpty);
        expect(uiStateService.allDataAccount, isNull);
      });
    });

    group('Payment Methods Management', () {
      test('should initialize with null namePaymentMethods', () {
        expect(uiStateService.namePaymentMethods, isNull);
      });

      test('should set and get namePaymentMethods', () {
        final paymentMethod = {'id': 1, 'name': 'Credit Card'};
        uiStateService.namePaymentMethods = paymentMethod;
        expect(uiStateService.namePaymentMethods, equals(paymentMethod));
      });
    });

    group('Complex State Management', () {
      test('should handle multiple state changes correctly', () {
        // Set various states
        uiStateService.searchQuery = 'hotel search';
        uiStateService.selectedProductType = 'hotels';
        uiStateService.selectedImageUrl = 'https://example.com/hotel.jpg';
        uiStateService.setSelectedLocation(
          latLng: 'LatLng(lat: 40.7128, lng: -74.0060)',
          name: 'Hotel NYC',
        );
        uiStateService.isCreatedInItinerary = true;

        // Verify all states are maintained
        expect(uiStateService.searchQuery, equals('hotel search'));
        expect(uiStateService.selectedProductType, equals('hotels'));
        expect(uiStateService.selectedImageUrl,
            equals('https://example.com/hotel.jpg'));
        expect(uiStateService.selectedLocationLatLng,
            equals('LatLng(lat: 40.7128, lng: -74.0060)'));
        expect(uiStateService.selectedLocationName, equals('Hotel NYC'));
        expect(uiStateService.isCreatedInItinerary, isTrue);
      });

      test('should clear all state correctly', () {
        // Set various states first
        uiStateService.searchQuery = 'test';
        uiStateService.selectedProductId = 'product-123';
        uiStateService.selectedContact = {'test': 'contact'};
        uiStateService.selectedImageUrl = 'test-url';
        uiStateService.setSelectedLocation(
            latLng: 'test-latlng', name: 'test-name');
        uiStateService.isCreatedInItinerary = true;
        uiStateService.accountCurrency = [
          {'test': 'currency'}
        ];
        uiStateService.itemsProducts = {'test': 'product'};
        uiStateService.selectRates = true;

        // Clear all states
        uiStateService.clearAll();

        // Verify appropriate states are cleared (clearAll has specific behavior)
        expect(uiStateService.searchQuery, equals(''));
        expect(uiStateService.selectedProductId, equals(''));
        expect(uiStateService.selectedProductType, equals('activities'));
        // These are NOT cleared by clearAll
        expect(uiStateService.itemsProducts, equals({'test': 'product'}));
        expect(uiStateService.selectRates, isTrue);
        // These ARE cleared by clearAll
        expect(uiStateService.selectedContact, isNull);
        expect(uiStateService.selectedImageUrl, equals(''));
        expect(uiStateService.selectedLocationLatLng, equals(''));
        expect(uiStateService.selectedLocationName, equals(''));
        expect(uiStateService.isCreatedInItinerary, isFalse);
        expect(uiStateService.accountCurrency, isEmpty);
      });
    });

    group('Hotel Rates Calculation', () {
      test('should initialize with zero hotel rates values', () {
        expect(uiStateService.profitHotelRates, equals(0.0));
        expect(uiStateService.rateUnitCostHotelRates, equals(0.0));
        expect(uiStateService.unitCostHotelRates, equals(0.0));
      });

      test('should set hotel rates calculation values', () {
        uiStateService.setHotelRatesCalculation(
          profit: 100.0,
          rateUnitCost: 200.0,
          unitCost: 150.0,
        );

        expect(uiStateService.profitHotelRates, equals(100.0));
        expect(uiStateService.rateUnitCostHotelRates, equals(200.0));
        expect(uiStateService.unitCostHotelRates, equals(150.0));
      });

      test('should clear hotel rates calculation', () {
        uiStateService.setHotelRatesCalculation(
          profit: 100.0,
          rateUnitCost: 200.0,
          unitCost: 150.0,
        );

        uiStateService.clearHotelRatesCalculation();

        expect(uiStateService.profitHotelRates, equals(0.0));
        expect(uiStateService.rateUnitCostHotelRates, equals(0.0));
        expect(uiStateService.unitCostHotelRates, equals(0.0));
      });
    });

    group('Flight State Management', () {
      test('should initialize with empty flight states', () {
        expect(uiStateService.departureState, equals(''));
        expect(uiStateService.arrivalState, equals(''));
      });

      test('should set and get flight states', () {
        uiStateService.departureState = 'New York';
        uiStateService.arrivalState = 'Los Angeles';

        expect(uiStateService.departureState, equals('New York'));
        expect(uiStateService.arrivalState, equals('Los Angeles'));
      });

      test('should clear flight states using clearAll', () {
        uiStateService.departureState = 'New York';
        uiStateService.arrivalState = 'Los Angeles';

        uiStateService.clearAll();

        expect(uiStateService.departureState, equals(''));
        expect(uiStateService.arrivalState, equals(''));
      });
    });

    group('Additional Properties', () {
      test('should manage location state', () {
        expect(uiStateService.locationState, equals(''));

        uiStateService.locationState = 'California';
        expect(uiStateService.locationState, equals('California'));
      });

      test('should manage rate selection state', () {
        expect(uiStateService.selectRates, isFalse);
        expect(uiStateService.isSelectingRates, isFalse);

        uiStateService.selectRates = true;
        uiStateService.isSelectingRates = true;

        expect(uiStateService.selectRates, isTrue);
        expect(uiStateService.isSelectingRates, isTrue);

        // Test that clearAll only clears isSelectingRates, not selectRates
        uiStateService.clearAll();
        expect(uiStateService.selectRates, isTrue); // Not cleared by clearAll
        expect(uiStateService.isSelectingRates, isFalse); // This is cleared
      });

      test('should manage creation states', () {
        expect(uiStateService.isCreatingItinerary, isFalse);
        expect(uiStateService.isCreatedInItinerary, isFalse);

        uiStateService.isCreatingItinerary = true;
        uiStateService.isCreatedInItinerary = true;

        expect(uiStateService.isCreatingItinerary, isTrue);
        expect(uiStateService.isCreatedInItinerary, isTrue);
      });

      test('should manage current page', () {
        expect(uiStateService.currentPage, equals(1));

        uiStateService.currentPage = 5;
        expect(uiStateService.currentPage, equals(5));
      });
    });

    group('State Clearing Methods', () {
      test('should clear search state only', () {
        uiStateService.searchQuery = 'test search';
        uiStateService.currentPage = 5;
        uiStateService.selectedProductId = 'product-123';

        uiStateService.clearSearchState();

        expect(uiStateService.searchQuery, equals(''));
        expect(uiStateService.currentPage, equals(1));
        expect(uiStateService.selectedProductId,
            equals('product-123')); // Should remain unchanged
      });

      test('should clear form state only', () {
        uiStateService.selectedImageUrl = 'test-image';
        uiStateService.isCreatingItinerary = true;
        uiStateService.setSelectedLocation(
            latLng: 'test-coords', name: 'test-location');
        uiStateService.searchQuery = 'test search';

        uiStateService.clearFormState();

        expect(uiStateService.selectedImageUrl, equals(''));
        expect(uiStateService.isCreatingItinerary, isFalse);
        expect(uiStateService.selectedLocationLatLng, equals(''));
        expect(uiStateService.searchQuery,
            equals('test search')); // Should remain unchanged
      });
    });

    group('Notifier Behavior', () {
      test('should notify listeners when non-search state changes', () {
        var notificationCount = 0;
        uiStateService.addListener(() {
          notificationCount++;
        });

        uiStateService.selectedProductType = 'hotels';
        expect(notificationCount, equals(1));

        uiStateService.selectedProductId = 'product-123';
        expect(notificationCount, equals(2));

        // clearAll() calls multiple notify methods, so count will be higher
        final beforeClearCount = notificationCount;
        uiStateService.clearAll();
        expect(notificationCount, greaterThan(beforeClearCount));
      });

      test('should handle search notifications with debouncing', () async {
        var notificationCount = 0;
        uiStateService.addListener(() {
          notificationCount++;
        });

        uiStateService.searchQuery = 'test';
        // Search notifications are debounced, so we need to wait
        await Future.delayed(Duration(milliseconds: 400));
        expect(notificationCount, equals(1));
      });

      test('should not notify listeners when setting same value', () {
        var notificationCount = 0;
        uiStateService.selectedProductType = 'hotels';

        uiStateService.addListener(() {
          notificationCount++;
        });

        uiStateService.selectedProductType = 'hotels'; // Same value
        expect(notificationCount, equals(0));

        uiStateService.selectedProductType = 'activities'; // Different value
        expect(notificationCount, equals(1));
      });
    });
  });
}
