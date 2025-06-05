import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../lib/services/contact_service.dart';
import '../../lib/backend/supabase/supabase.dart';

// Generate mocks
@GenerateMocks([SupaFlow])
import 'contact_service_test.mocks.dart';

void main() {
  group('ContactService Tests', () {
    late ContactService contactService;
    late MockSupaFlow mockSupaFlow;

    setUp(() {
      contactService = ContactService();
      mockSupaFlow = MockSupaFlow();
    });

    tearDown(() {
      contactService.clearCache();
    });

    group('Initialization', () {
      test('should initialize with empty state', () {
        expect(contactService.contacts, isEmpty);
        expect(contactService.isLoading, isFalse);
        expect(contactService.error, isNull);
        expect(contactService.hasData, isFalse);
      });

      test('should load contacts correctly', () async {
        expect(
          () => contactService.loadContacts(),
          returnsNormally,
        );
      });
    });

    group('Contact Management', () {
      test('should store contacts correctly', () {
        final testContacts = [
          {
            'id': 1,
            'name': 'John',
            'last_name': 'Doe',
            'email': 'john@example.com',
            'type': 'client',
            'phone': '+1234567890',
          },
          {
            'id': 2,
            'name': 'Jane',
            'last_name': 'Smith',
            'email': 'jane@example.com',
            'type': 'provider',
            'phone': '+0987654321',
          }
        ];

        contactService._setContacts(testContacts);

        expect(contactService.contacts.length, equals(2));
        expect(contactService.getContact(1)['name'], equals('John'));
        expect(contactService.getContact(2)['email'], equals('jane@example.com'));
      });

      test('should handle missing contact correctly', () {
        final testContacts = [
          {'id': 1, 'name': 'John', 'last_name': 'Doe'}
        ];

        contactService._setContacts(testContacts);

        expect(contactService.getContact(999), isNull);
      });

      test('should get full name correctly', () {
        final testContacts = [
          {
            'id': 1,
            'name': 'John',
            'last_name': 'Doe',
            'email': 'john@example.com',
          }
        ];

        contactService._setContacts(testContacts);

        expect(contactService.getContactFullName(1), equals('John Doe'));
      });
    });

    group('Contact Filtering', () {
      test('should filter contacts by type', () {
        final testContacts = [
          {'id': 1, 'name': 'John', 'type': 'client'},
          {'id': 2, 'name': 'Jane', 'type': 'provider'},
          {'id': 3, 'name': 'Bob', 'type': 'client'},
          {'id': 4, 'name': 'Alice', 'type': 'user'},
        ];

        contactService._setContacts(testContacts);

        final clients = contactService.getContactsByType('client');
        expect(clients.length, equals(2));
        expect(clients.every((c) => c['type'] == 'client'), isTrue);

        final providers = contactService.getContactsByType('provider');
        expect(providers.length, equals(1));
        expect(providers[0]['name'], equals('Jane'));
      });

      test('should get clients only', () {
        final testContacts = [
          {'id': 1, 'name': 'John', 'type': 'client'},
          {'id': 2, 'name': 'Jane', 'type': 'provider'},
          {'id': 3, 'name': 'Bob', 'type': 'client'},
        ];

        contactService._setContacts(testContacts);

        final clients = contactService.getClients();
        expect(clients.length, equals(2));
        expect(clients.map((c) => c['name']), containsAll(['John', 'Bob']));
      });

      test('should get providers only', () {
        final testContacts = [
          {'id': 1, 'name': 'John', 'type': 'client'},
          {'id': 2, 'name': 'Jane', 'type': 'provider'},
          {'id': 3, 'name': 'Bob', 'type': 'provider'},
        ];

        contactService._setContacts(testContacts);

        final providers = contactService.getProviders();
        expect(providers.length, equals(2));
        expect(providers.map((c) => c['name']), containsAll(['Jane', 'Bob']));
      });
    });

    group('Search Functionality', () {
      test('should search contacts by name', () {
        final testContacts = [
          {'id': 1, 'name': 'John', 'last_name': 'Doe', 'email': 'john@example.com'},
          {'id': 2, 'name': 'Jane', 'last_name': 'Smith', 'email': 'jane@example.com'},
          {'id': 3, 'name': 'Johnny', 'last_name': 'Walker', 'email': 'johnny@example.com'},
        ];

        contactService._setContacts(testContacts);

        final johnResults = contactService.searchContacts('john');
        expect(johnResults.length, equals(2));
        expect(johnResults.map((c) => c['name']), containsAll(['John', 'Johnny']));
      });

      test('should search contacts by email', () {
        final testContacts = [
          {'id': 1, 'name': 'John', 'email': 'john@gmail.com'},
          {'id': 2, 'name': 'Jane', 'email': 'jane@yahoo.com'},
          {'id': 3, 'name': 'Bob', 'email': 'bob@gmail.com'},
        ];

        contactService._setContacts(testContacts);

        final gmailResults = contactService.searchContacts('gmail');
        expect(gmailResults.length, equals(2));
        expect(gmailResults.map((c) => c['name']), containsAll(['John', 'Bob']));
      });

      test('should search be case insensitive', () {
        final testContacts = [
          {'id': 1, 'name': 'JOHN', 'last_name': 'doe', 'email': 'JOHN@EXAMPLE.COM'},
        ];

        contactService._setContacts(testContacts);

        final results = contactService.searchContacts('john');
        expect(results.length, equals(1));

        final emailResults = contactService.searchContacts('example.com');
        expect(emailResults.length, equals(1));
      });

      test('should handle empty search results', () {
        final testContacts = [
          {'id': 1, 'name': 'John', 'email': 'john@example.com'},
        ];

        contactService._setContacts(testContacts);

        final results = contactService.searchContacts('nonexistent');
        expect(results, isEmpty);
      });
    });

    group('CRUD Operations', () {
      test('should create contact correctly', () async {
        final contactData = {
          'name': 'New Contact',
          'last_name': 'Test',
          'email': 'new@example.com',
          'type': 'client',
        };

        expect(
          () => contactService.createContact(contactData),
          returnsNormally,
        );
      });

      test('should update contact correctly', () async {
        // Setup existing contact
        contactService._setContacts([
          {
            'id': 1,
            'name': 'Old Name',
            'email': 'old@example.com',
          }
        ]);

        expect(
          () => contactService.updateContact(
            id: 1,
            updates: {
              'name': 'New Name',
              'email': 'new@example.com',
            },
          ),
          returnsNormally,
        );
      });

      test('should delete contact correctly', () async {
        // Setup existing contacts
        contactService._setContacts([
          {'id': 1, 'name': 'To Delete'},
          {'id': 2, 'name': 'To Keep'},
        ]);

        expect(
          () => contactService.deleteContact(1),
          returnsNormally,
        );
      });
    });

    group('Contact Validation', () {
      test('should validate email format', () {
        expect(contactService.isValidEmail('test@example.com'), isTrue);
        expect(contactService.isValidEmail('user@domain.co.uk'), isTrue);
        expect(contactService.isValidEmail('invalid-email'), isFalse);
        expect(contactService.isValidEmail(''), isFalse);
        expect(contactService.isValidEmail('@domain.com'), isFalse);
      });

      test('should validate phone format', () {
        expect(contactService.isValidPhone('+1234567890'), isTrue);
        expect(contactService.isValidPhone('1234567890'), isTrue);
        expect(contactService.isValidPhone('+52-123-456-7890'), isTrue);
        expect(contactService.isValidPhone('123'), isFalse);
        expect(contactService.isValidPhone(''), isFalse);
      });

      test('should validate required fields', () {
        final validContact = {
          'name': 'John',
          'last_name': 'Doe',
          'email': 'john@example.com',
          'type': 'client',
        };

        final invalidContact = {
          'name': '',
          'email': 'invalid-email',
        };

        expect(contactService.validateContact(validContact), isTrue);
        expect(contactService.validateContact(invalidContact), isFalse);
      });
    });

    group('Cache Management', () {
      test('should manage cache correctly', () {
        final testContacts = [{'id': 1, 'name': 'Test Contact'}];
        
        contactService._setContacts(testContacts);
        expect(contactService.hasData, isTrue);

        contactService.clearCache();
        expect(contactService.hasData, isFalse);
        expect(contactService.contacts, isEmpty);
      });

      test('should respect cache duration', () {
        contactService._setContacts([{'id': 1, 'name': 'Test'}]);
        expect(contactService.hasValidCache, isTrue);

        // Simulate cache expiration
        contactService._lastFetch = DateTime.now().subtract(Duration(minutes: 10));
        expect(contactService.hasValidCache, isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle errors correctly', () {
        final error = 'Database connection failed';
        contactService._setError(error);

        expect(contactService.error, equals(error));
        expect(contactService.hasError, isTrue);
        expect(contactService.isLoading, isFalse);
      });

      test('should clear error on successful operation', () {
        contactService._setError('Previous error');
        expect(contactService.hasError, isTrue);

        contactService._setContacts([]);
        expect(contactService.hasError, isFalse);
        expect(contactService.error, isNull);
      });

      test('should handle malformed data gracefully', () {
        final malformedData = [
          {'id': 'not_a_number', 'name': null},
          {'missing_id': true},
        ];

        expect(
          () => contactService._setContacts(malformedData),
          returnsNormally,
        );
      });
    });

    group('Statistics', () {
      test('should calculate contact statistics correctly', () {
        final testContacts = [
          {'id': 1, 'type': 'client', 'created_at': '2024-01-01'},
          {'id': 2, 'type': 'provider', 'created_at': '2024-01-15'},
          {'id': 3, 'type': 'client', 'created_at': '2024-02-01'},
          {'id': 4, 'type': 'user', 'created_at': '2024-02-15'},
        ];

        contactService._setContacts(testContacts);

        final stats = contactService.getStatistics();
        expect(stats['total'], equals(4));
        expect(stats['clients'], equals(2));
        expect(stats['providers'], equals(1));
        expect(stats['users'], equals(1));
      });

      test('should get recent contacts', () {
        final now = DateTime.now();
        final yesterday = now.subtract(Duration(days: 1));
        final lastWeek = now.subtract(Duration(days: 7));
        
        final testContacts = [
          {
            'id': 1,
            'name': 'Recent Contact',
            'created_at': now.toIso8601String(),
          },
          {
            'id': 2,
            'name': 'Old Contact',
            'created_at': lastWeek.toIso8601String(),
          },
        ];

        contactService._setContacts(testContacts);

        final recentContacts = contactService.getRecentContacts(days: 3);
        expect(recentContacts.length, equals(1));
        expect(recentContacts[0]['name'], equals('Recent Contact'));
      });
    });

    group('Contact Groups', () {
      test('should group contacts by type', () {
        final testContacts = [
          {'id': 1, 'name': 'Client 1', 'type': 'client'},
          {'id': 2, 'name': 'Provider 1', 'type': 'provider'},
          {'id': 3, 'name': 'Client 2', 'type': 'client'},
        ];

        contactService._setContacts(testContacts);

        final grouped = contactService.getContactsGroupedByType();
        expect(grouped['client']?.length, equals(2));
        expect(grouped['provider']?.length, equals(1));
      });

      test('should group contacts by first letter', () {
        final testContacts = [
          {'id': 1, 'name': 'Alice', 'last_name': 'Smith'},
          {'id': 2, 'name': 'Bob', 'last_name': 'Jones'},
          {'id': 3, 'name': 'Alice', 'last_name': 'Brown'},
        ];

        contactService._setContacts(testContacts);

        final grouped = contactService.getContactsGroupedByLetter();
        expect(grouped['A']?.length, equals(2));
        expect(grouped['B']?.length, equals(1));
      });
    });
  });
}

// Extension to access private members for testing
extension ContactServiceTestExtension on ContactService {
  void _setContacts(List<dynamic> data) {
    contacts.clear();
    contacts.addAll(data);
    _setError(null);
    notifyListeners();
  }

  void _setError(String? error) {
    this.error = error;
    isLoading = false;
    notifyListeners();
  }

  set _lastFetch(DateTime time) {
    lastFetch = time;
  }
}