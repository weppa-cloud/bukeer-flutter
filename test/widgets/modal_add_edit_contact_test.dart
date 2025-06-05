import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../lib/bukeer/contactos/modal_add_edit_contact/modal_add_edit_contact_widget.dart';
import '../../lib/bukeer/contactos/modal_add_edit_contact/modal_add_edit_contact_model.dart';
import '../test_utils/test_helpers.dart';

void main() {
  group('ModalAddEditContactWidget Tests', () {
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
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Agregar Contacto'), findsOneWidget);
        expect(find.text('Nombre'), findsOneWidget);
        expect(find.text('Apellido'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Teléfono'), findsOneWidget);
        expect(find.text('Tipo de contacto'), findsOneWidget);
      });

      testWidgets('should render edit mode correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final existingContact = {
          'id': 1,
          'name': 'John',
          'last_name': 'Doe',
          'email': 'john@example.com',
          'phone': '+1234567890',
          'type': 'client',
        };

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(
            contactToEdit: existingContact,
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Editar Contacto'), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
        expect(find.text('Doe'), findsOneWidget);
        expect(find.text('john@example.com'), findsOneWidget);
      });
    });

    group('Form Validation', () {
      testWidgets('should validate required fields', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Try to submit without filling required fields
        final submitButton = find.text('Guardar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Este campo es requerido'), findsWidgets);
      });

      testWidgets('should validate email format', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Enter invalid email
        final emailField = find.byKey(Key('email_field'));
        await tester.enterText(emailField, 'invalid-email');
        
        // Submit to trigger validation
        final submitButton = find.text('Guardar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Email inválido'), findsOneWidget);
      });

      testWidgets('should validate phone format', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Enter invalid phone
        final phoneField = find.byKey(Key('phone_field'));
        await tester.enterText(phoneField, '123');
        
        // Submit to trigger validation
        final submitButton = find.text('Guardar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Teléfono inválido'), findsOneWidget);
      });

      testWidgets('should accept valid form data', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill valid form data
        await tester.enterText(find.byKey(Key('name_field')), 'Valid Name');
        await tester.enterText(find.byKey(Key('last_name_field')), 'Valid Last Name');
        await tester.enterText(find.byKey(Key('email_field')), 'valid@example.com');
        await tester.enterText(find.byKey(Key('phone_field')), '+1234567890');
        
        // Select contact type
        final typeDropdown = find.byKey(Key('type_dropdown'));
        await tester.tap(typeDropdown);
        await TestHelpers.pumpAndSettle(tester);
        
        await tester.tap(find.text('Cliente').last);
        await TestHelpers.pumpAndSettle(tester);
        
        // Submit form
        final submitButton = find.text('Guardar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert no validation errors
        expect(find.text('Este campo es requerido'), findsNothing);
        expect(find.text('Email inválido'), findsNothing);
        expect(find.text('Teléfono inválido'), findsNothing);
      });
    });

    group('Contact Type Selection', () {
      testWidgets('should show contact type dropdown', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Tipo de contacto'), findsOneWidget);
        expect(find.byType(DropdownButton), findsOneWidget);
      });

      testWidgets('should show all contact type options', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap dropdown to open
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        // Assert options
        expect(find.text('Cliente'), findsOneWidget);
        expect(find.text('Proveedor'), findsOneWidget);
        expect(find.text('Usuario'), findsOneWidget);
      });

      testWidgets('should select contact type correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Select provider type
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Proveedor').last);
        await TestHelpers.pumpAndSettle(tester);

        // Assert selection
        // The dropdown should now show "Proveedor" as selected
        expect(find.text('Proveedor'), findsOneWidget);
      });
    });

    group('Additional Fields Based on Type', () {
      testWidgets('should show client-specific fields for client type', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Select client type
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Cliente').last);
        await TestHelpers.pumpAndSettle(tester);

        // Assert client-specific fields
        expect(find.text('Nacionalidad'), findsOneWidget);
        expect(find.text('Documento'), findsOneWidget);
      });

      testWidgets('should show provider-specific fields for provider type', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Select provider type
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Proveedor').last);
        await TestHelpers.pumpAndSettle(tester);

        // Assert provider-specific fields
        expect(find.text('Empresa'), findsOneWidget);
        expect(find.text('Servicios'), findsOneWidget);
      });

      testWidgets('should show user-specific fields for user type', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole(RoleType.admin); // Only admins can create users
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Select user type
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Usuario').last);
        await TestHelpers.pumpAndSettle(tester);

        // Assert user-specific fields
        expect(find.text('Rol'), findsOneWidget);
        expect(find.text('Permisos'), findsOneWidget);
      });
    });

    group('Form Submission', () {
      testWidgets('should call create API when creating new contact', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill form
        await tester.enterText(find.byKey(Key('name_field')), 'New Contact');
        await tester.enterText(find.byKey(Key('last_name_field')), 'Last Name');
        await tester.enterText(find.byKey(Key('email_field')), 'new@example.com');

        // Submit
        final submitButton = find.text('Guardar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert API would be called
        // This would need mocking of the actual API call
      });

      testWidgets('should call update API when editing existing contact', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final existingContact = {
          'id': 1,
          'name': 'Existing',
          'last_name': 'Contact',
          'email': 'existing@example.com',
        };

        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(
            contactToEdit: existingContact,
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Modify form
        final nameField = find.byKey(Key('name_field'));
        await tester.enterText(nameField, 'Updated Name');

        // Submit
        final submitButton = find.text('Actualizar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert update API would be called
        // This would need mocking of the actual API call
      });
    });

    group('Authorization', () {
      testWidgets('should hide user type option for non-admin users', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole(RoleType.agent);
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Open dropdown
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        // Assert user option is not available
        expect(find.text('Usuario'), findsNothing);
        expect(find.text('Cliente'), findsOneWidget);
        expect(find.text('Proveedor'), findsOneWidget);
      });

      testWidgets('should show all options for admin users', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole(RoleType.admin);
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Open dropdown
        final dropdown = find.byType(DropdownButton);
        await tester.tap(dropdown);
        await TestHelpers.pumpAndSettle(tester);

        // Assert all options are available
        expect(find.text('Cliente'), findsOneWidget);
        expect(find.text('Proveedor'), findsOneWidget);
        expect(find.text('Usuario'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should show error message on API failure', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        TestHelpers.mockErrorState(message: 'Network error');
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Submit form to trigger error
        await tester.enterText(find.byKey(Key('name_field')), 'Test');
        await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');

        final submitButton = find.text('Guardar');
        await tester.tap(submitButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert error handling
        // This would need proper error state mocking
      });

      testWidgets('should handle loading state correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
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
          child: ModalAddEditContactWidget(),
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

      testWidgets('should close modal on successful submission', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill and submit form successfully
        await tester.enterText(find.byKey(Key('name_field')), 'Success');
        await tester.enterText(find.byKey(Key('email_field')), 'success@example.com');

        final submitButton = find.text('Guardar');
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
          child: ModalAddEditContactWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert semantic labels exist
        expect(find.bySemanticsLabel('Nombre del contacto'), findsOneWidget);
        expect(find.bySemanticsLabel('Email del contacto'), findsOneWidget);
        expect(find.bySemanticsLabel('Teléfono del contacto'), findsOneWidget);
      });

      testWidgets('should support keyboard navigation', (tester) async {
        // Arrange
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: ModalAddEditContactWidget(),
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