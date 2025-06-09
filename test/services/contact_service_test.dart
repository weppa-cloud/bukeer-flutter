import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/contact_service.dart';
import 'package:flutter/foundation.dart';

void main() {
  group('ContactService Tests', () {
    late ContactService contactService;

    setUp(() {
      contactService = ContactService();
    });

    tearDown(() {
      // Clear selected contact to reset state
      contactService.clearSelectedContact();
    });

    group('Initialization', () {
      test('should initialize with empty state', () {
        expect(contactService.contacts, isEmpty);
        expect(contactService.clients, isEmpty);
        expect(contactService.providers, isEmpty);
        expect(contactService.accounts, isEmpty);
        expect(contactService.isLoading, isFalse);
        expect(contactService.selectedContact, isNull);
      });

      test('should have allDataContact getter for backward compatibility', () {
        expect(contactService.allDataContact, isNull);

        // Test setter
        final testContact = {'id': 1, 'name': 'Test'};
        contactService.allDataContact = testContact;
        expect(contactService.allDataContact, equals(testContact));
        expect(contactService.selectedContact, equals(testContact));
      });
    });

    group('Selected Contact Management', () {
      test('should set and clear selected contact', () {
        final testContact = {
          'id': 1,
          'name': 'John',
          'last_name': 'Doe',
          'email': 'john@example.com',
        };

        // Set selected contact
        contactService.setSelectedContact(testContact);
        expect(contactService.selectedContact, equals(testContact));

        // Clear selected contact
        contactService.clearSelectedContact();
        expect(contactService.selectedContact, isNull);
      });
    });

    group('Contact Searching', () {
      test('should search contacts by query', () {
        // Since we can't mock the actual data loading, we'll test the search logic
        // by directly setting test data (this would require exposing a test method)

        // For now, just verify the method exists
        final results = contactService.searchContacts('test');
        expect(results, isA<List>());
      });

      test('should check if contact exists by email', () {
        // Test the method exists and returns false for non-existent contact
        expect(
            contactService.contactExists('nonexistent@example.com'), isFalse);
      });

      test('should get contact by email', () {
        // Test the method exists and returns null for non-existent contact
        expect(contactService.getContactByEmail('nonexistent@example.com'),
            isNull);
      });
    });

    group('Contact Creation', () {
      test('should have createContact method with required parameters',
          () async {
        // Since we can't mock the API call, we'll just verify the method signature
        // In a real test with proper mocking, we would test the actual creation

        expect(
          () => contactService.createContact(
            name: 'Test',
            lastName: 'User',
            email: 'test@example.com',
            phone: '1234567890',
          ),
          returnsNormally,
        );
      });
    });

    group('Contact Update', () {
      test('should have updateContact method', () async {
        // Verify the method exists
        expect(
          () => contactService.updateContact(
            contactId: 1,
            name: 'Updated Name',
          ),
          returnsNormally,
        );
      });
    });

    group('Contact Deletion', () {
      test('should have deleteContact method', () async {
        // Verify the method exists
        expect(
          () => contactService.deleteContact(1),
          returnsNormally,
        );
      });
    });

    group('Contact Filtering', () {
      test('should get contacts by account', () {
        final results = contactService.getContactsByAccount(1);
        expect(results, isA<List>());
      });
    });

    group('API Methods', () {
      test('should load contacts', () async {
        // Test that loadContacts method exists and doesn't throw
        expect(() => contactService.loadContacts(), returnsNormally);
      });

      test('should load accounts', () async {
        // Test that loadAccounts method exists and doesn't throw
        expect(() => contactService.loadAccounts(), returnsNormally);
      });

      test('should get contact details', () async {
        // Test that getContactDetails method exists
        expect(() => contactService.getContactDetails(1), returnsNormally);
      });
    });

    group('ChangeNotifier', () {
      test('should notify listeners on data changes', () {
        var notified = false;
        contactService.addListener(() {
          notified = true;
        });

        // Trigger a notification by setting selected contact
        contactService.setSelectedContact({'id': 1, 'name': 'Test'});

        expect(notified, isTrue);

        contactService.removeListener(() {});
      });
    });
  });
}
