// Test de verificación funcional rápida para servicios migrados
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import de servicios
import 'lib/services/product_service.dart';
import 'lib/services/contact_service.dart';
import 'lib/services/itinerary_service.dart';
import 'lib/services/user_service.dart';
import 'lib/services/ui_state_service.dart';

void main() {
  print('🧪 Iniciando Runtime Test de Servicios Migrados...\n');
  
  runTestSuite();
}

void runTestSuite() {
  try {
    // Test 1: Instanciación de servicios
    print('📋 Test 1: Instanciación de servicios');
    testServiceInstantiation();
    
    // Test 2: Funcionalidad allData* migrada
    print('\n📋 Test 2: Funcionalidad allData* migrada');
    testAllDataMigration();
    
    // Test 3: UiStateService
    print('\n📋 Test 3: UiStateService');
    testUiStateService();
    
    // Test 4: Notificación de cambios
    print('\n📋 Test 4: Notificación de cambios');
    testChangeNotification();
    
    print('\n🎉 ¡Todos los tests pasaron exitosamente!');
    print('✅ La migración de servicios está funcionando correctamente');
    
  } catch (e) {
    print('\n❌ Error en runtime test: $e');
  }
}

void testServiceInstantiation() {
  // Test que todos los servicios se puedan instanciar
  final productService = ProductService();
  final contactService = ContactService();
  final itineraryService = ItineraryService();
  final userService = UserService();
  final uiStateService = UiStateService();
  
  assert(productService != null, 'ProductService no se pudo instanciar');
  assert(contactService != null, 'ContactService no se pudo instanciar');
  assert(itineraryService != null, 'ItineraryService no se pudo instanciar');
  assert(userService != null, 'UserService no se pudo instanciar');
  assert(uiStateService != null, 'UiStateService no se pudo instanciar');
  
  print('  ✅ Todos los servicios se instanciaron correctamente');
}

void testAllDataMigration() {
  final productService = ProductService();
  final contactService = ContactService();
  final itineraryService = ItineraryService();
  final userService = UserService();
  
  // Test ProductService allData* properties
  final testHotel = {'id': 1, 'name': 'Test Hotel'};
  productService.allDataHotel = testHotel;
  assert(productService.allDataHotel == testHotel, 'allDataHotel no funciona');
  
  final testActivity = {'id': 1, 'name': 'Test Activity'};
  productService.allDataActivity = testActivity;
  assert(productService.allDataActivity == testActivity, 'allDataActivity no funciona');
  
  final testTransfer = {'id': 1, 'name': 'Test Transfer'};
  productService.allDataTransfer = testTransfer;
  assert(productService.allDataTransfer == testTransfer, 'allDataTransfer no funciona');
  
  final testFlight = {'id': 1, 'name': 'Test Flight'};
  productService.allDataFlight = testFlight;
  assert(productService.allDataFlight == testFlight, 'allDataFlight no funciona');
  
  print('  ✅ ProductService: allData* properties funcionan');
  
  // Test ContactService
  final testContact = {'id': 1, 'name': 'Test Contact'};
  contactService.allDataContact = testContact;
  assert(contactService.allDataContact == testContact, 'allDataContact no funciona');
  
  print('  ✅ ContactService: allDataContact funciona');
  
  // Test ItineraryService
  final testItinerary = {'id': 1, 'name': 'Test Itinerary'};
  itineraryService.allDataItinerary = testItinerary;
  assert(itineraryService.allDataItinerary == testItinerary, 'allDataItinerary no funciona');
  
  final testPassenger = {'id': 1, 'name': 'Test Passenger'};
  itineraryService.allDataPassenger = testPassenger;
  assert(itineraryService.allDataPassenger == testPassenger, 'allDataPassenger no funciona');
  
  print('  ✅ ItineraryService: allData* properties funcionan');
  
  // Test UserService
  final testUser = {'id': 1, 'name': 'Test User'};
  userService.allDataUser = testUser;
  assert(userService.allDataUser == testUser, 'allDataUser no funciona');
  
  print('  ✅ UserService: allDataUser funciona');
}

void testUiStateService() {
  final uiStateService = UiStateService();
  
  // Test searchQuery
  uiStateService.searchQuery = 'test search';
  assert(uiStateService.searchQuery == 'test search', 'searchQuery no funciona');
  
  // Test selectedProductType
  uiStateService.selectedProductType = 'hotels';
  assert(uiStateService.selectedProductType == 'hotels', 'selectedProductType no funciona');
  
  // Test locationState (nueva migración)
  uiStateService.locationState = 'test location';
  assert(uiStateService.locationState == 'test location', 'locationState no funciona');
  
  // Test selectedImageUrl
  uiStateService.selectedImageUrl = 'https://test.com/image.jpg';
  assert(uiStateService.selectedImageUrl == 'https://test.com/image.jpg', 'selectedImageUrl no funciona');
  
  // Test location properties
  uiStateService.selectedLocationName = 'Test Location';
  assert(uiStateService.selectedLocationName == 'Test Location', 'selectedLocationName no funciona');
  
  print('  ✅ UiStateService: todas las propiedades funcionan');
  
  // Test clearAll method
  uiStateService.clearAll();
  assert(uiStateService.searchQuery == '', 'clearAll no limpió searchQuery');
  assert(uiStateService.locationState == '', 'clearAll no limpió locationState');
  assert(uiStateService.selectedImageUrl == '', 'clearAll no limpió selectedImageUrl');
  
  print('  ✅ UiStateService: clearAll() funciona correctamente');
}

void testChangeNotification() {
  final productService = ProductService();
  bool notificationReceived = false;
  
  // Test que las notificaciones se disparen
  productService.addListener(() {
    notificationReceived = true;
  });
  
  productService.allDataHotel = {'id': 1, 'name': 'Test Hotel'};
  assert(notificationReceived, 'ChangeNotifier no funcionó en ProductService');
  
  print('  ✅ ChangeNotifier: notificaciones funcionan correctamente');
}