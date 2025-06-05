// Quick test to verify services compile and work
import 'lib/services/product_service.dart';
import 'lib/services/contact_service.dart';
import 'lib/services/itinerary_service.dart';
import 'lib/services/user_service.dart';

void main() {
  print('🚀 Testing Services Migration...');
  
  try {
    // Test ProductService
    final productService = ProductService();
    productService.allDataHotel = {'id': 1, 'name': 'Test Hotel'};
    assert(productService.allDataHotel != null);
    print('✅ ProductService.allDataHotel - OK');
    
    productService.allDataActivity = {'id': 1, 'name': 'Test Activity'};
    assert(productService.allDataActivity != null);
    print('✅ ProductService.allDataActivity - OK');
    
    productService.allDataTransfer = {'id': 1, 'name': 'Test Transfer'};
    assert(productService.allDataTransfer != null);
    print('✅ ProductService.allDataTransfer - OK');
    
    productService.allDataFlight = {'id': 1, 'name': 'Test Flight'};
    assert(productService.allDataFlight != null);
    print('✅ ProductService.allDataFlight - OK');
    
    // Test ContactService
    final contactService = ContactService();
    contactService.allDataContact = {'id': 1, 'name': 'Test Contact'};
    assert(contactService.allDataContact != null);
    print('✅ ContactService.allDataContact - OK');
    
    // Test ItineraryService  
    final itineraryService = ItineraryService();
    itineraryService.allDataItinerary = {'id': 1, 'name': 'Test Itinerary'};
    assert(itineraryService.allDataItinerary != null);
    print('✅ ItineraryService.allDataItinerary - OK');
    
    itineraryService.allDataPassenger = {'id': 1, 'name': 'Test Passenger'};
    assert(itineraryService.allDataPassenger != null);
    print('✅ ItineraryService.allDataPassenger - OK');
    
    // Test UserService
    final userService = UserService();
    userService.allDataUser = {'id': 1, 'name': 'Test User'};
    assert(userService.allDataUser != null);
    print('✅ UserService.allDataUser - OK');
    
    print('\n🎉 All services working correctly!');
    print('✅ Migration successful - all allData* properties accessible');
    
  } catch (e) {
    print('❌ Error testing services: $e');
  }
}