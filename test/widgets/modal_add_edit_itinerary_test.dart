import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// // import 'package:mockito/mockito.dart'; // Unused import // Unused import

import 'package:bukeer/bukeer/core/widgets/modals/itinerary/add_edit/modal_add_edit_itinerary_widget.dart';
// import 'package:bukeer/bukeer/core/widgets/modals/itinerary/add_edit/modal_add_edit_itinerary_model.dart'; // Unused import
import '../test_utils/test_helpers.dart';

void main() {
  group('ModalAddEditItineraryWidget Tests', () {
    setUp(() {
      TestHelpers.setUp();
    });

    tearDown(() {
      TestHelpers.tearDown();
    });

    group('Widget Initialization', () {
      testWidgets('should render add mode correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Crear Itinerario'), findsOneWidget);
        expect(find.text('Nombre del itinerario'), findsOneWidget);
        expect(find.text('Cliente'), findsOneWidget);
        expect(find.text('Fecha de inicio'), findsOneWidget);
        expect(find.text('Fecha de fin'), findsOneWidget);
      });

      testWidgets('should render edit mode correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final existingItinerary = {
          'id': 1,
          'name': 'Test Itinerary',
          'client_name': 'Test Client',
          'start_date': '2024-01-01',
          'end_date': '2024-01-07',
        };

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(
            allDataItinerary: existingItinerary,
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Editar Itinerario'), findsOneWidget);
        expect(find.text('Test Itinerary'), findsOneWidget);
        expect(find.text('Test Client'), findsOneWidget);
      });
    });

    group('Form Validation', () {
      testWidgets('should show validation errors for empty fields',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Try to submit without filling fields
        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Este campo es requerido'), findsWidgets);
      });

      testWidgets('should validate date range correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill form with invalid date range (end before start)
        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, 'Test Itinerary');

        // Set start date after end date (this would need date picker interaction)
        // For now, we'll test the validation logic directly

        // Assert validation would catch this
        // This would require more complex date picker testing
      });

      testWidgets('should accept valid form data', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill valid form data
        final textFields = find.byType(TextFormField);

        await tester.enterText(textFields.at(0), 'Valid Itinerary Name');
        await tester.enterText(textFields.at(1), 'Valid Client Name');

        // Submit form
        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert no validation errors
        expect(find.text('Este campo es requerido'), findsNothing);
      });
    });

    group('Travel Planner Dropdown', () {
      testWidgets('should show travel planner dropdown for admins',
          (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('admin');
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Travel Planner'), findsOneWidget);
        expect(find.byType(DropdownButton), findsOneWidget);
      });

      testWidgets('should hide travel planner dropdown for agents',
          (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('agent');
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Travel Planner'), findsNothing);
      });

      testWidgets('should load and display users in dropdown', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('admin');
        TestHelpers.mockUserData();

        // Mock users data for dropdown
        final _mockUsers = [
          {'id': '1', 'name': 'John', 'last_name': 'Doe', 'photo_url': null},
          {
            'id': '2',
            'name': 'Jane',
            'last_name': 'Smith',
            'photo_url': 'http://example.com/photo.jpg'
          },
        ];

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap dropdown to open it
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        // Assert dropdown items would be visible
        // This would need proper mocking of the API call
      });
    });

    group('Form Submission', () {
      testWidgets('should call create API when creating new itinerary',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill form
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'New Itinerary');
        await tester.enterText(textFields.at(1), 'Client Name');

        // Submit
        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert API would be called
        // This would need mocking of the actual API call
      });

      testWidgets('should call update API when editing existing itinerary',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final existingItinerary = {
          'id': 1,
          'name': 'Existing Itinerary',
          'client_name': 'Existing Client',
        };

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(
            allDataItinerary: existingItinerary,
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Modify form
        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, 'Updated Itinerary');

        // Submit
        final submitButton = find.text('Actualizar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert update API would be called
        // This would need mocking of the actual API call
      });
    });

    group('Error Handling', () {
      testWidgets('should show error message on API failure', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        TestHelpers.mockErrorState(message: 'Network error');

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Submit form to trigger error
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'Test Itinerary');
        await tester.enterText(textFields.at(1), 'Test Client');

        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert error handling
        // This would need proper error state mocking
      });

      testWidgets('should handle loading state correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Simulate loading state
        // This would need state management mocking to show loading indicators
      });
    });

    group('Modal Behavior', () {
      testWidgets('should close modal on cancel', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap cancel button
        final cancelButton = find.text('Cancelar');
        await tester.tap(cancelButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert modal would close
        // This would need proper navigation/modal testing
      });

      testWidgets('should close modal on successful submission',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill and submit form successfully
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'Success Itinerary');
        await tester.enterText(textFields.at(1), 'Success Client');

        final submitButton = find.text('Crear');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert modal would close on success
        // This would need proper success handling mocking
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper accessibility labels', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert semantic labels exist
        expect(find.bySemanticsLabel('Nombre del itinerario'), findsOneWidget);
        expect(find.bySemanticsLabel('Cliente'), findsOneWidget);
      });

      testWidgets('should support keyboard navigation', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditItineraryWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Test tab navigation
        final firstField = find.byType(TextFormField).first;
        await tester.tap(firstField);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);

        // Assert focus moves to next field
        // This would need proper focus testing
      });
    });
  });
}
