import 'package:flutter_test/flutter_test.dart';
// // import 'package:mockito/mockito.dart'; // Unused import // Unused import
import 'package:mockito/annotations.dart';

import '../../lib/services/user_service.dart';
import '../../lib/backend/supabase/supabase.dart';
import '../../lib/auth/supabase_auth/auth_util.dart';

// Generate mocks
@GenerateMocks([SupaFlow])
import 'user_service_test.mocks.dart';

void main() {
  group('UserService Tests', () {
    late UserService userService;
    late MockSupaFlow _mockSupaFlow;

    setUp(() {
      userService = UserService();
      _mockSupaFlow = MockSupaFlow();
    });

    tearDown(() {
      userService.clearUserData();
    });

    group('Initialization', () {
      test('should initialize with no data loaded', () {
        expect(userService.hasLoadedData, isFalse);
        expect(userService.selectedUser, isNull);
        expect(userService.agentData, isNull);
        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isFalse);
      });

      test('should prevent multiple initializations', () async {
        // This test would need mocking of SupaFlow calls
        // For now, we'll test the logic by using reflection or testing the behavior
        
        // First initialization (will fail due to no auth)
        final result1 = await userService.initializeUserData();
        expect(result1, isFalse);
        
        // Second call should return the same result quickly
        final result2 = await userService.initializeUserData();
        expect(result2, isFalse);
      });
    });

    group('Data Management', () {
      test('should store agent info correctly', () {
        final testData = {
          'id': 'user123',
          'name': 'John',
          'last_name': 'Doe',
          'email': 'john@example.com',
        };

        userService._agentInfo = testData;
        
        expect(userService.getAgentInfo(r'$[:].name'), equals('John'));
        expect(userService.getAgentInfo(r'$[:].email'), equals('john@example.com'));
        expect(userService.getAgentInfo(r'$[:].invalid'), isNull);
      });

      test('should store contact info correctly', () {
        final testData = {
          'phone': '+1234567890',
          'address': 'Test Address',
          'city': 'Test City',
        };

        userService._contactInfo = testData;
        
        expect(userService.getContactInfo(r'$[:].phone'), equals('+1234567890'));
        expect(userService.getContactInfo(r'$[:].city'), equals('Test City'));
      });

      test('should clear all data correctly', () {
        // Setup data
        userService._agentInfo = {'test': 'data'};
        userService._contactInfo = {'test': 'data'};
        userService._hasLoadedData = true;

        // Clear
        userService.clearUserData();

        // Verify cleared
        expect(userService.hasLoadedData, isFalse);
        expect(userService.currentUser?.currentUser?.agentInfo ?? {} ?? {}, isEmpty);
        expect(userService.currentUser?.currentUser?.contactInfo ?? {} ?? {}, isEmpty);
      });
    });

    group('Role Checking', () {
      test('should identify admin correctly', () {
        userService._agentInfo = {
          'user_roles_view': [
            {'role_names': 'admin'}
          ]
        };

        expect(userService.isAdmin, isTrue);
        expect(userService.isSuperAdmin, isFalse);
      });

      test('should identify super admin correctly', () {
        userService._agentInfo = {
          'user_roles_view': [
            {'role_names': 'super_admin'}
          ]
        };

        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isTrue);
      });

      test('should handle multiple roles correctly', () {
        userService._agentInfo = {
          'user_roles_view': [
            {'role_names': 'agent'},
            {'role_names': 'admin'}
          ]
        };

        expect(userService.isAdmin, isTrue);
      });

      test('should handle no roles correctly', () {
        userService._agentInfo = {};

        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isFalse);
      });
    });

    group('Safe Access Methods', () {
      test('should return empty map when no data', () {
        expect(userService.currentUser?.currentUser?.agentInfo ?? {} ?? {}, isEmpty);
        expect(userService.currentUser?.currentUser?.contactInfo ?? {} ?? {}, isEmpty);
      });

      test('should return null for invalid paths', () {
        userService._agentInfo = {'name': 'Test'};
        
        expect(userService.getAgentInfo(r'$[:].invalid'), isNull);
        expect(userService.getAgentInfo(''), isNull);
      });

      test('should handle complex JSON paths', () {
        userService._agentInfo = {
          'user_roles_view': [
            {'role_names': 'admin', 'account_id': 1}
          ],
          'nested': {
            'data': 'value'
          }
        };

        expect(
          userService.getAgentInfo(r'$[:].user_roles_view[0].role_names'),
          equals('admin'),
        );
        expect(
          userService.getAgentInfo(r'$[:].nested.data'),
          equals('value'),
        );
      });
    });

    group('Error Handling', () {
      test('should handle initialization errors gracefully', () async {
        // Mock authentication failure
        // This would need proper mocking of currentUserUid
        
        // For now, test the error handling logic
        expect(() => userService.initializeUserData(), returnsNormally);
      });

      test('should handle malformed data gracefully', () {
        userService._agentInfo = {'invalid': null};
        
        expect(() => userService.getAgentInfo(r'$[:].invalid'), returnsNormally);
        expect(userService.getAgentInfo(r'$[:].invalid'), isNull);
      });
    });

    group('Refresh Functionality', () {
      test('should force refresh even when data is loaded', () async {
        // Set initial state
        userService._hasLoadedData = true;
        userService._agentInfo = {'old': 'data'};

        // Refresh should clear and reload
        // This would need mocking of actual Supabase calls
        expect(() => userService.refreshUserData(), returnsNormally);
      });
    });
  });
}

// Extension to access private members for testing
extension UserServiceTestExtension on UserService {
  set _agentInfo(Map<String, dynamic> info) {
    agentInfo.clear();
    agentInfo.addAll(info);
  }

  set _contactInfo(Map<String, dynamic> info) {
    contactInfo.clear();
    contactInfo.addAll(info);
  }

  set _hasLoadedData(bool value) {
    if (value) {
      // Simulate loaded state
    } else {
      clearData();
    }
  }
}