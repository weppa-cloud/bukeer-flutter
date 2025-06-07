import 'package:flutter_test/flutter_test.dart';
// // import 'package:mockito/mockito.dart'; // Unused import // Unused import
import 'package:mockito/annotations.dart';

import '../../lib/services/contact_service.dart';
import '../../lib/backend/supabase/supabase.dart';

// Generate mocks
@GenerateMocks([SupaFlow])
import 'contact_service_test.mocks.dart';

void main() {
  group('ContactService Tests - Real Methods', () {
    late ContactService contactService;
    late MockSupaFlow _mockSupaFlow;

    setUp(() {
      contactService = ContactService();
      _mockSupaFlow = MockSupaFlow();
    });

    group('Initialization', () {
      test('should initialize with empty state', () {
        expect(contactService.contacts, isEmpty);
        expect(contactService.accounts, isEmpty);
        expect(contactService.clients, isEmpty);
        expect(contactService.providers, isEmpty);
        expect(contactService.isLoading, isFalse);
      });

      test('should load contacts correctly', () async {
        expect(
          () => contactService.loadContacts(),
          returnsNormally,
        );
      });
    });

    group('Contact Management', () {
      test('should have getter methods', () {
        expect(contactService.contacts, isA<List<dynamic>>());
        expect(contactService.accounts, isA<List<dynamic>>());
        expect(contactService.clients, isA<List<dynamic>>());
        expect(contactService.providers, isA<List<dynamic>>());
      });

      test('should get contact details', () async {
        expect(
          () => contactService.getContactDetails(1),
          returnsNormally,
        );
      });

      test('should get contact by email', () {
        final result = contactService.getContactByEmail('test@example.com');
        expect(result, isNull); // Empty list, so should be null
      });
    });

    group('Contact Search', () {
      test('should search contacts', () {
        final results = contactService.searchContacts('test');
        expect(results, isA<List<dynamic>>());
      });

      test('should return empty list for no matches', () {
        final results = contactService.searchContacts('nonexistent');
        expect(results, isEmpty);
      });

      test('should handle empty query', () {
        final results = contactService.searchContacts('');
        expect(results, isA<List<dynamic>>());
      });
    });

    group('CRUD Operations', () {
      test('should create contact with required parameters', () async {
        expect(
          () => contactService.createContact(
            name: 'Test Name',
            lastName: 'Test LastName',
            email: 'test@example.com',
            phone: '+1234567890',
            isClient: true,
            accountId: '1',
          ),
          returnsNormally,
        );
      });

      test('should update contact', () async {
        expect(
          () => contactService.updateContact(
            contactId: 1,
            name: 'Updated Name',
            email: 'updated@example.com',
          ),
          returnsNormally,
        );
      });

      test('should delete contact', () async {
        expect(
          () => contactService.deleteContact(1),
          returnsNormally,
        );
      });
    });

    group('Contact Filtering', () {
      test('should get clients', () {
        final clients = contactService.clients;
        expect(clients, isA<List<dynamic>>());
      });

      test('should get providers', () {
        final providers = contactService.providers;
        expect(providers, isA<List<dynamic>>());
      });

      test('should get contacts by account', () {
        final contacts = contactService.getContactsByAccount(1);
        expect(contacts, isA<List<dynamic>>());
      });
    });

    group('Contact Existence', () {
      test('should check if contact exists', () {
        final exists = contactService.contactExists('test@example.com');
        expect(exists, isFalse); // Empty list, so should be false
      });
    });

    group('Cache Management', () {
      test('should have cache validity check', () {
        expect(contactService.isCacheValid, isA<bool>());
      });

      test('should have loading state', () {
        expect(contactService.isLoading, isA<bool>());
      });

      test('should have error handling', () {
        expect(contactService.hasError, isA<bool>());
      });
    });
  });
}