# FFAppState Migration Plan - Final Phase

## Current Status
- 837 total FFAppState() references remaining
- Properties to migrate:

### Most Used Properties:
1. **itemsProducts** (47 uses) → ProductService
2. **accountId** (39 uses) → Keep in FFAppState (global)
3. **allDataContact** (32 uses) → ContactService
4. **allDataHotel** (25 uses) → ProductService.hotels
5. **allDataFlight** (25 uses) → ProductService.flights
6. **agent** (22 uses) → Keep in FFAppState (global)
7. **typeProduct** (21 uses) → UiStateService.selectedProductType ✅
8. **searchStringState** (21 uses) → UiStateService.searchQuery ✅
9. **allDataTransfer** (20 uses) → ProductService.transfers
10. **allDataItinerary** (19 uses) → ItineraryService
11. **Location fields** (49 uses total) → UiStateService

## Migration Strategy

### Phase 1: Add missing properties to UiStateService
```dart
// Add to UiStateService:
- itemsProducts (temporary selected product)
- selectRates (boolean flag)
- Location fields (latlngLocation, stateLocation, etc.)
```

### Phase 2: Move data collections to specialized services
```dart
// ProductService should handle:
- allDataHotel → ProductService.hotels
- allDataFlight → ProductService.flights  
- allDataTransfer → ProductService.transfers
- allDataActivity → ProductService.activities

// ContactService should handle:
- allDataContact → ContactService.contacts

// ItineraryService should handle:
- allDataItinerary → ItineraryService.itineraries
```

### Phase 3: Keep in FFAppState (global app state)
```dart
// These should stay in FFAppState:
- accountId (current account)
- agent (current agent/user)
- Any authentication-related state
```

## Files to Focus On:
1. `modal_add_edit_itinerary_widget.dart` (heaviest usage)
2. `dropdown_products_widget.dart` ✅ (already done)
3. Components using location data
4. Components using allData* collections

## Approach:
1. First add missing properties to UiStateService
2. Then migrate components file by file
3. Test each component after migration
4. Update service interfaces as needed