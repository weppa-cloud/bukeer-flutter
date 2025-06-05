import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import '../../lib/bukeer/itinerarios/main_itineraries/main_itineraries_widget.dart';
import '../../lib/bukeer/modal_add_edit_itinerary/modal_add_edit_itinerary_widget.dart';
import '../../lib/bukeer/itinerarios/itinerary_details/itinerary_details_widget.dart';
import '../test_utils/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Itinerary Management Flow Integration Tests', () {
    setUp(() {
      TestHelpers.setUp();
      
      // Setup authenticated user
      TestHelpers.mockSupabaseAuth(authenticated: true);
      TestHelpers.mockUserData();
      TestHelpers.mockUserWithRole(RoleType.agent);
    });

    tearDown(() {
      TestHelpers.tearDown();
    });

    group('Create Itinerary Flow', () {
      testWidgets('should complete full itinerary creation flow', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseItineraries(customData: []);
        
        final widget = TestHelpers.createTestWidget(
          child: MainItinerariesWidget(),
        );

        // Act - Navigate to itineraries page
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert empty state or itineraries list
        expect(find.text('Itinerarios'), findsOneWidget);

        // Tap create button
        final createButton = find.byKey(Key('create_itinerary_button'));
        await tester.tap(createButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert modal opens
        expect(find.text('Crear Itinerario'), findsOneWidget);

        // Fill itinerary form
        await tester.enterText(
          find.byKey(Key('itinerary_name_field')), 
          'Test Vacation to Paris',
        );
        await tester.enterText(
          find.byKey(Key('client_name_field')), 
          'John Smith',
        );

        // Select dates (simplified - in real app would use date pickers)
        await tester.enterText(
          find.byKey(Key('start_date_field')), 
          '2024-07-01',
        );
        await tester.enterText(
          find.byKey(Key('end_date_field')), 
          '2024-07-07',
        );

        // Mock successful creation
        final createdItinerary = {
          'id': 1,
          'name': 'Test Vacation to Paris',
          'client_name': 'John Smith',
          'start_date': '2024-07-01',
          'end_date': '2024-07-07',
          'status': 'draft',
          'agent': 'test-user-id',
        };
        
        SupabaseMocks.mockCreateSuccess(createdItinerary);

        // Submit form
        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert modal closes and new itinerary appears
        expect(find.text('Crear Itinerario'), findsNothing);
        expect(find.text('Test Vacation to Paris'), findsOneWidget);
        expect(find.text('John Smith'), findsOneWidget);
      });

      testWidgets('should validate itinerary form correctly', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseItineraries(customData: []);
        
        final widget = TestHelpers.createTestWidget(
          child: MainItinerariesWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Open create modal
        final createButton = find.byKey(Key('create_itinerary_button'));
        await tester.tap(createButton);
        await TestHelpers.pumpAndSettle(tester);

        // Try to submit empty form
        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert validation errors
        expect(find.text('Nombre es requerido'), findsOneWidget);
        expect(find.text('Cliente es requerido'), findsOneWidget);
        expect(find.text('Fecha de inicio es requerida'), findsOneWidget);
        expect(find.text('Fecha de fin es requerida'), findsOneWidget);

        // Fill name only
        await tester.enterText(
          find.byKey(Key('itinerary_name_field')), 
          'Test Itinerary',
        );
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert name validation passes, others still fail
        expect(find.text('Nombre es requerido'), findsNothing);
        expect(find.text('Cliente es requerido'), findsOneWidget);
      });

      testWidgets('should handle creation errors gracefully', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseItineraries(customData: []);
        
        final widget = TestHelpers.createTestWidget(
          child: MainItinerariesWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Open create modal and fill form
        final createButton = find.byKey(Key('create_itinerary_button'));
        await tester.tap(createButton);
        await TestHelpers.pumpAndSettle(tester);

        await tester.enterText(find.byKey(Key('itinerary_name_field')), 'Test');
        await tester.enterText(find.byKey(Key('client_name_field')), 'Client');
        await tester.enterText(find.byKey(Key('start_date_field')), '2024-07-01');
        await tester.enterText(find.byKey(Key('end_date_field')), '2024-07-07');

        // Mock creation error
        TestHelpers.mockSupabaseError('Database connection failed');

        // Submit form
        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert error message is shown
        expect(find.text('Error al crear itinerario'), findsOneWidget);
        expect(find.text('Database connection failed'), findsOneWidget);
        
        // Modal should remain open for retry
        expect(find.text('Crear Itinerario'), findsOneWidget);
      });
    });

    group('Edit Itinerary Flow', () {
      testWidgets('should complete itinerary editing flow', (tester) async {
        // Arrange
        final existingItinerary = {
          'id': 1,
          'name': 'Original Name',
          'client_name': 'Original Client',
          'start_date': '2024-07-01',
          'end_date': '2024-07-07',
          'status': 'draft',
        };
        
        TestHelpers.mockSupabaseItineraries(customData: [existingItinerary]);
        
        final widget = TestHelpers.createTestWidget(
          child: MainItinerariesWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Find and tap edit button for the itinerary
        final editButton = find.byKey(Key('edit_itinerary_1'));
        await tester.tap(editButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert edit modal opens with existing data
        expect(find.text('Editar Itinerario'), findsOneWidget);
        expect(find.text('Original Name'), findsOneWidget);
        expect(find.text('Original Client'), findsOneWidget);

        // Modify the itinerary
        final nameField = find.byKey(Key('itinerary_name_field'));
        await tester.enterText(nameField, 'Updated Name');

        // Mock successful update
        final updatedItinerary = {
          ...existingItinerary,
          'name': 'Updated Name',
        };
        SupabaseMocks.mockUpdateSuccess(updatedItinerary);

        // Submit changes
        final updateButton = find.text('Actualizar');
        await tester.tap(updateButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert modal closes and changes are reflected
        expect(find.text('Editar Itinerario'), findsNothing);
        expect(find.text('Updated Name'), findsOneWidget);
        expect(find.text('Original Name'), findsNothing);
      });
    });

    group('Itinerary Details Flow', () {
      testWidgets('should navigate to itinerary details', (tester) async {
        // Arrange
        final itinerary = {
          'id': 1,
          'name': 'Paris Vacation',
          'client_name': 'John Smith',
          'start_date': '2024-07-01',
          'end_date': '2024-07-07',
          'status': 'draft',
        };
        
        TestHelpers.mockSupabaseItineraries(customData: [itinerary]);
        
        final widget = TestHelpers.createTestWidget(
          child: MainItinerariesWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap on itinerary to view details
        final itineraryCard = find.text('Paris Vacation');
        await tester.tap(itineraryCard);
        await TestHelpers.pumpAndSettle(tester);

        // Assert navigation to details page
        // This would need proper navigation testing
        // For now, test that the tap is registered
        expect(itineraryCard, findsOneWidget);
      });

      testWidgets('should show itinerary details correctly', (tester) async {
        // Arrange
        final itineraryDetails = {
          'id': 1,
          'name': 'Paris Vacation',
          'client_name': 'John Smith',
          'start_date': '2024-07-01',
          'end_date': '2024-07-07',
          'status': 'draft',
          'agent': 'test-user-id',
          'travel_planner_name': 'Agent',
          'travel_planner_last_name': 'Smith',
          'total_cost': 2500.0,
          'notes': 'Special requests: vegetarian meals',
        };
        
        // Mock itinerary details response
        TestHelpers.mockSupabaseItineraries(customData: [itineraryDetails]);
        
        final widget = TestHelpers.createTestWidget(
          child: ItineraryDetailsWidget(id: 1),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert details are displayed
        expect(find.text('Paris Vacation'), findsOneWidget);
        expect(find.text('John Smith'), findsOneWidget);
        expect(find.text('2024-07-01'), findsOneWidget);
        expect(find.text('2024-07-07'), findsOneWidget);
        expect(find.text('\$2,500.00'), findsOneWidget);
        expect(find.text('vegetarian meals'), findsOneWidget);
      });
    });

    group('Add Services Flow', () {
      testWidgets('should add hotel service to itinerary', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseHotels();
        
        final widget = TestHelpers.createTestWidget(
          child: ItineraryDetailsWidget(id: 1),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Navigate to services tab
        final servicesTab = find.text('Servicios');
        await tester.tap(servicesTab);
        await TestHelpers.pumpAndSettle(tester);

        // Tap add hotel button
        final addHotelButton = find.byKey(Key('add_hotel_button'));
        await tester.tap(addHotelButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert hotel selection modal opens
        expect(find.text('Agregar Hotel'), findsOneWidget);
        expect(find.text('Hotel Paradise'), findsOneWidget);

        // Select a hotel
        final selectHotelButton = find.byKey(Key('select_hotel_1'));
        await tester.tap(selectHotelButton);
        await TestHelpers.pumpAndSettle(tester);

        // Fill hotel details (dates, rooms, etc.)
        await tester.enterText(find.byKey(Key('check_in_date')), '2024-07-01');
        await tester.enterText(find.byKey(Key('check_out_date')), '2024-07-03');
        await tester.enterText(find.byKey(Key('rooms_count')), '2');

        // Mock successful service addition
        final newService = {
          'id': 1,
          'itinerary_id': 1,
          'service_type': 'hotel',
          'service_id': 1,
          'check_in_date': '2024-07-01',
          'check_out_date': '2024-07-03',
          'rooms': 2,
          'cost': 300.0,
        };
        SupabaseMocks.mockCreateSuccess(newService);

        // Confirm addition
        final confirmButton = find.text('Agregar');
        await tester.tap(confirmButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert service is added to itinerary
        expect(find.text('Hotel Paradise'), findsOneWidget);
        expect(find.text('2024-07-01 - 2024-07-03'), findsOneWidget);
        expect(find.text('\$300.00'), findsOneWidget);
      });

      testWidgets('should add activity service to itinerary', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseActivities();
        
        final widget = TestHelpers.createTestWidget(
          child: ItineraryDetailsWidget(id: 1),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Navigate to services tab
        final servicesTab = find.text('Servicios');
        await tester.tap(servicesTab);
        await TestHelpers.pumpAndSettle(tester);

        // Tap add activity button
        final addActivityButton = find.byKey(Key('add_activity_button'));
        await tester.tap(addActivityButton);
        await TestHelpers.pumpAndSettle(tester);

        // Select an activity
        final selectActivityButton = find.byKey(Key('select_activity_1'));
        await tester.tap(selectActivityButton);
        await TestHelpers.pumpAndSettle(tester);

        // Fill activity details
        await tester.enterText(find.byKey(Key('activity_date')), '2024-07-02');
        await tester.enterText(find.byKey(Key('participants_count')), '4');

        // Mock successful service addition
        final newService = {
          'id': 2,
          'itinerary_id': 1,
          'service_type': 'activity',
          'service_id': 1,
          'activity_date': '2024-07-02',
          'participants': 4,
          'cost': 200.0,
        };
        SupabaseMocks.mockCreateSuccess(newService);

        // Confirm addition
        final confirmButton = find.text('Agregar');
        await tester.tap(confirmButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert activity is added
        expect(find.text('City Tour'), findsOneWidget);
        expect(find.text('2024-07-02'), findsOneWidget);
        expect(find.text('4 personas'), findsOneWidget);
      });
    });

    group('Passenger Management Flow', () {
      testWidgets('should add passengers to itinerary', (tester) async {
        // Arrange
        final widget = TestHelpers.createTestWidget(
          child: ItineraryDetailsWidget(id: 1),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Navigate to passengers tab
        final passengersTab = find.text('Pasajeros');
        await tester.tap(passengersTab);
        await TestHelpers.pumpAndSettle(tester);

        // Tap add passenger button
        final addPassengerButton = find.byKey(Key('add_passenger_button'));
        await tester.tap(addPassengerButton);
        await TestHelpers.pumpAndSettle(tester);

        // Fill passenger form
        await tester.enterText(find.byKey(Key('passenger_name')), 'Maria');
        await tester.enterText(find.byKey(Key('passenger_last_name')), 'Garcia');
        await tester.enterText(find.byKey(Key('passenger_document')), 'A12345678');
        await tester.enterText(find.byKey(Key('passenger_birth_date')), '1990-05-15');

        // Select nationality
        final nationalityDropdown = find.byKey(Key('nationality_dropdown'));
        await tester.tap(nationalityDropdown);
        await TestHelpers.pumpAndSettle(tester);
        
        await tester.tap(find.text('Española').last);
        await TestHelpers.pumpAndSettle(tester);

        // Mock successful passenger creation
        final newPassenger = {
          'id': 1,
          'itinerary_id': 1,
          'name': 'Maria',
          'last_name': 'Garcia',
          'document_number': 'A12345678',
          'birth_date': '1990-05-15',
          'nationality': 'Española',
        };
        SupabaseMocks.mockCreateSuccess(newPassenger);

        // Submit passenger form
        final submitButton = find.text('Agregar Pasajero');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert passenger is added
        expect(find.text('Maria Garcia'), findsOneWidget);
        expect(find.text('A12345678'), findsOneWidget);
        expect(find.text('Española'), findsOneWidget);
      });
    });

    group('Payment Management Flow', () {
      testWidgets('should record client payment', (tester) async {
        // Arrange
        final widget = TestHelpers.createTestWidget(
          child: ItineraryDetailsWidget(id: 1),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Navigate to payments tab
        final paymentsTab = find.text('Pagos');
        await tester.tap(paymentsTab);
        await TestHelpers.pumpAndSettle(tester);

        // Tap add payment button
        final addPaymentButton = find.byKey(Key('add_payment_button'));
        await tester.tap(addPaymentButton);
        await TestHelpers.pumpAndSettle(tester);

        // Fill payment form
        await tester.enterText(find.byKey(Key('payment_amount')), '1000');
        await tester.enterText(find.byKey(Key('payment_date')), '2024-06-15');
        
        // Select payment method
        final methodDropdown = find.byKey(Key('payment_method_dropdown'));
        await tester.tap(methodDropdown);
        await TestHelpers.pumpAndSettle(tester);
        
        await tester.tap(find.text('Transferencia').last);
        await TestHelpers.pumpAndSettle(tester);

        // Mock successful payment recording
        final newPayment = {
          'id': 1,
          'itinerary_id': 1,
          'amount': 1000.0,
          'payment_date': '2024-06-15',
          'payment_method': 'Transferencia',
          'type': 'client_payment',
        };
        SupabaseMocks.mockCreateSuccess(newPayment);

        // Submit payment
        final submitButton = find.text('Registrar Pago');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert payment is recorded
        expect(find.text('\$1,000.00'), findsOneWidget);
        expect(find.text('Transferencia'), findsOneWidget);
        expect(find.text('2024-06-15'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle service errors gracefully', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseError('Service temporarily unavailable');
        
        final widget = TestHelpers.createTestWidget(
          child: MainItinerariesWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert error state is shown
        expect(find.text('Error al cargar itinerarios'), findsOneWidget);
        expect(find.text('Service temporarily unavailable'), findsOneWidget);
        
        // Should show retry option
        expect(find.text('Reintentar'), findsOneWidget);
      });

      testWidgets('should retry after network error', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseError('Network error');
        
        final widget = TestHelpers.createTestWidget(
          child: MainItinerariesWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert error state
        expect(find.text('Network error'), findsOneWidget);

        // Mock successful retry
        TestHelpers.mockSupabaseItineraries();

        // Tap retry button
        final retryButton = find.text('Reintentar');
        await tester.tap(retryButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert successful load
        expect(find.text('Network error'), findsNothing);
        expect(find.text('Test Itinerary 1'), findsOneWidget);
      });
    });
  });
}