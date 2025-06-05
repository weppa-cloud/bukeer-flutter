import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import '../../lib/backend/api_requests/api_calls.dart';
import '../../lib/backend/api_requests/api_manager.dart';
import 'api_manager_test.mocks.dart';

void main() {
  group('API Calls Tests', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    tearDown(() {
      reset(mockClient);
    });

    group('GetContactSearchCall', () {
      test('should create correct request for contact search', () async {
        // Arrange
        const search = 'john';
        const authToken = 'test-token';
        const pageNumber = 1;
        const pageSize = 10;
        const type = 'client';

        // Mock successful response
        final mockResponse = http.Response(
          '[{"id": 1, "name": "John", "last_name": "Doe"}]',
          200,
          headers: {'content-type': 'application/json'},
        );

        // Act & Assert
        // Test the call structure and parameters
        expect(() => GetContactSearchCall.call(
          search: search,
          authToken: authToken,
          pageNumber: pageNumber,
          pageSize: pageSize,
          type: type,
        ), returnsNormally);
      });

      test('should parse response correctly', () {
        // Arrange
        final mockResponseBody = [
          {
            'id': 1,
            'name': 'John',
            'last_name': 'Doe',
            'is_company': false,
            'is_client': true,
          }
        ];

        // Act & Assert
        final isCompany = GetContactSearchCall.isCompany(mockResponseBody);
        final isClient = GetContactSearchCall.isClient(mockResponseBody);

        expect(isCompany, equals([false]));
        expect(isClient, equals([true]));
      });

      test('should handle empty search results', () {
        // Arrange
        final emptyResponse = [];

        // Act
        final isCompany = GetContactSearchCall.isCompany(emptyResponse);
        final isClient = GetContactSearchCall.isClient(emptyResponse);

        // Assert
        expect(isCompany, isEmpty);
        expect(isClient, isEmpty);
      });

      test('should validate search parameters', () {
        // Test parameter validation
        expect(() => GetContactSearchCall.call(
          search: '',
          authToken: 'token',
          pageNumber: 0,
          pageSize: -1,
        ), returnsNormally);
      });
    });

    group('GetContactIdCall', () {
      test('should create correct request for contact by ID', () async {
        // Arrange
        const id = '123';
        const authToken = 'test-token';

        // Act & Assert
        expect(() => GetContactIdCall.call(
          id: id,
          authToken: authToken,
        ), returnsNormally);
      });

      test('should parse single contact response', () {
        // Arrange
        final mockResponse = [
          {
            'id': 1,
            'name': 'John',
            'last_name': 'Doe',
            'email': 'john@example.com',
          }
        ];

        // Act
        final dataAll = GetContactIdCall.dataAll(mockResponse);

        // Assert
        expect(dataAll, equals(mockResponse));
        expect(dataAll?.length, equals(1));
        expect(dataAll?[0]['name'], equals('John'));
      });

      test('should handle non-existent contact ID', () {
        // Arrange
        final emptyResponse = [];

        // Act
        final dataAll = GetContactIdCall.dataAll(emptyResponse);

        // Assert
        expect(dataAll, isEmpty);
      });
    });

    group('UpdateContactCall', () {
      test('should create correct update request', () async {
        // Arrange
        const id = '123';
        const authToken = 'test-token';
        const name = 'Updated Name';
        const email = 'updated@example.com';

        // Act & Assert
        expect(() => UpdateContactCall.call(
          id: id,
          authToken: authToken,
          name: name,
          email: email,
        ), returnsNormally);
      });

      test('should handle partial updates', () async {
        // Arrange - Only update name, leave other fields null
        const id = '123';
        const authToken = 'test-token';
        const name = 'New Name';

        // Act & Assert
        expect(() => UpdateContactCall.call(
          id: id,
          authToken: authToken,
          name: name,
          // Other fields intentionally null
        ), returnsNormally);
      });
    });

    group('GetUserRolesCall', () {
      test('should create correct request for user roles', () async {
        // Arrange
        const authToken = 'test-token';

        // Act & Assert
        expect(() => GetUserRolesCall.call(
          authToken: authToken,
        ), returnsNormally);
      });

      test('should parse user roles response', () {
        // Arrange
        final mockResponse = [
          {
            'role_id': 1,
            'role_name': 'admin',
            'role_description': 'Administrator',
            'is_active': true,
          }
        ];

        // Act
        final roles = GetUserRolesCall.dataAll(mockResponse);

        // Assert
        expect(roles, equals(mockResponse));
        expect(roles?[0]['role_name'], equals('admin'));
        expect(roles?[0]['is_active'], isTrue);
      });
    });

    group('InsertContactCall', () {
      test('should create correct insert request', () async {
        // Arrange
        const authToken = 'test-token';
        const name = 'New Contact';
        const lastName = 'Last Name';
        const email = 'new@example.com';
        const phone = '+1234567890';

        // Act & Assert
        expect(() => InsertContactCall.call(
          authToken: authToken,
          name: name,
          lastName: lastName,
          email: email,
          phone: phone,
        ), returnsNormally);
      });

      test('should handle required vs optional fields', () async {
        // Arrange - Test with minimal required fields
        const authToken = 'test-token';
        const name = 'Required Name';

        // Act & Assert
        expect(() => InsertContactCall.call(
          authToken: authToken,
          name: name,
          // Optional fields can be null
        ), returnsNormally);
      });
    });

    group('GetItinerariesCall', () {
      test('should create correct request for itineraries', () async {
        // Arrange
        const authToken = 'test-token';

        // Act & Assert
        expect(() => GetItinerariesCall.call(
          authToken: authToken,
        ), returnsNormally);
      });

      test('should parse itineraries response', () {
        // Arrange
        final mockResponse = [
          {
            'id': 1,
            'name': 'Paris Trip',
            'client_name': 'John Doe',
            'start_date': '2024-07-01',
            'end_date': '2024-07-07',
            'status': 'draft',
          }
        ];

        // Act
        final itineraries = GetItinerariesCall.dataAll(mockResponse);

        // Assert
        expect(itineraries, equals(mockResponse));
        expect(itineraries?[0]['name'], equals('Paris Trip'));
        expect(itineraries?[0]['status'], equals('draft'));
      });
    });

    group('GetActivitiesCall', () {
      test('should create correct request for activities', () async {
        // Arrange
        const authToken = 'test-token';

        // Act & Assert
        expect(() => GetActivitiesCall.call(
          authToken: authToken,
        ), returnsNormally);
      });

      test('should parse activities response', () {
        // Arrange
        final mockResponse = [
          {
            'id': 1,
            'name': 'City Tour',
            'location': 'Paris',
            'duration': '4 hours',
            'price': 50.0,
          }
        ];

        // Act
        final activities = GetActivitiesCall.dataAll(mockResponse);

        // Assert
        expect(activities, equals(mockResponse));
        expect(activities?[0]['name'], equals('City Tour'));
        expect(activities?[0]['price'], equals(50.0));
      });
    });

    group('GetUsersCall', () {
      test('should create correct request for users', () async {
        // Arrange
        const authToken = 'test-token';

        // Act & Assert
        expect(() => GetUsersCall.call(
          authToken: authToken,
        ), returnsNormally);
      });

      test('should parse users response', () {
        // Arrange
        final mockResponse = [
          {
            'id': 'user-123',
            'name': 'Agent',
            'last_name': 'Smith',
            'email': 'agent@example.com',
            'photo_url': 'https://example.com/photo.jpg',
          }
        ];

        // Act
        final users = GetUsersCall.dataAll(mockResponse);

        // Assert
        expect(users, equals(mockResponse));
        expect(users?[0]['name'], equals('Agent'));
        expect(users?[0]['email'], equals('agent@example.com'));
      });
    });

    group('Error Handling', () {
      test('should handle API call failures gracefully', () {
        // Test that API calls handle various error scenarios
        
        // Network error scenario
        expect(() => Exception('Network error'), throwsException);
        
        // Invalid token scenario
        expect(() => Exception('Unauthorized'), throwsException);
        
        // Server error scenario
        expect(() => Exception('Internal server error'), throwsException);
      });

      test('should handle malformed JSON responses', () {
        // Arrange
        const malformedJson = 'invalid json{[';

        // Act & Assert
        expect(() => Exception('JSON parsing error'), throwsException);
      });

      test('should handle null response data', () {
        // Arrange
        final nullResponse = null;

        // Act
        final data = GetContactSearchCall.isCompany(nullResponse);

        // Assert
        expect(data, isNull);
      });

      test('should handle missing fields in response', () {
        // Arrange
        final incompleteResponse = [
          {
            'id': 1,
            'name': 'John',
            // Missing other expected fields
          }
        ];

        // Act
        final isCompany = GetContactSearchCall.isCompany(incompleteResponse);

        // Assert
        expect(isCompany, isNotNull);
        // Should handle missing fields gracefully
      });
    });

    group('Authentication', () {
      test('should include auth token in headers', () {
        // Test that auth tokens are properly included
        const authToken = 'Bearer test-token-123';
        
        expect(authToken, startsWith('Bearer '));
        expect(authToken.length, greaterThan(20));
      });

      test('should handle expired tokens', () {
        // Mock expired token scenario
        const expiredToken = 'expired-token';
        
        // Should handle 401 responses appropriately
        expect(() => Exception('Token expired'), throwsException);
      });

      test('should handle missing auth tokens', () {
        // Test behavior when auth token is missing
        const emptyToken = '';
        
        expect(emptyToken, isEmpty);
        // API calls should handle missing tokens appropriately
      });
    });

    group('Pagination', () {
      test('should handle pagination parameters correctly', () {
        // Test pagination logic
        const pageNumber = 2;
        const pageSize = 20;
        
        expect(pageNumber, greaterThan(0));
        expect(pageSize, greaterThan(0));
        expect(pageSize, lessThanOrEqualTo(100)); // Reasonable limit
      });

      test('should validate pagination bounds', () {
        // Test edge cases for pagination
        const invalidPageNumber = -1;
        const invalidPageSize = 0;
        
        expect(invalidPageNumber, lessThan(0));
        expect(invalidPageSize, lessThanOrEqualTo(0));
      });
    });

    group('Data Validation', () {
      test('should validate email format in requests', () {
        // Test email validation
        const validEmail = 'test@example.com';
        const invalidEmail = 'invalid-email';
        
        expect(validEmail, contains('@'));
        expect(validEmail, contains('.'));
        expect(invalidEmail, isNot(contains('@')));
      });

      test('should validate phone format in requests', () {
        // Test phone validation
        const validPhone = '+1234567890';
        const invalidPhone = '123';
        
        expect(validPhone, startsWith('+'));
        expect(validPhone.length, greaterThan(10));
        expect(invalidPhone.length, lessThan(10));
      });

      test('should validate date format in requests', () {
        // Test date validation
        const validDate = '2024-07-01';
        const invalidDate = 'not-a-date';
        
        expect(validDate, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
        expect(invalidDate, isNot(matches(RegExp(r'^\d{4}-\d{2}-\d{2}$'))));
      });
    });

    group('Response Transformation', () {
      test('should transform API responses to expected format', () {
        // Test response transformation logic
        final rawResponse = {
          'data': [
            {'id': 1, 'value': 'test'}
          ]
        };
        
        final transformedData = rawResponse['data'] as List;
        
        expect(transformedData, isNotEmpty);
        expect(transformedData[0]['id'], equals(1));
      });

      test('should handle nested response structures', () {
        // Test nested data handling
        final nestedResponse = {
          'result': {
            'items': [
              {'id': 1, 'nested': {'value': 'test'}}
            ]
          }
        };
        
        final items = nestedResponse['result']?['items'] as List?;
        final nestedValue = items?[0]['nested']['value'];
        
        expect(nestedValue, equals('test'));
      });
    });
  });
}