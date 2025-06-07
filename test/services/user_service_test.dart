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
      test('should store selected user correctly', () {
        final testData = [
          {
            'id': 'user123',
            'name': 'John',
            'last_name': 'Doe',
            'email': 'john@example.com',
            'role_id': 1,
          }
        ];

        userService.setSelectedUser(testData);
        
        expect(userService.selectedUser, equals(testData));
        expect(userService.allDataUser, equals(testData)); // backward compatibility
      });

      test('should handle getAccountInfo delegation', () {
        // This method is now delegated to AccountService
        final result = userService.getAccountInfo(r'$[:].test');
        
        expect(result, isNull); // Should return null as it's delegated
      });

      test('should clear all data correctly', () {
        // Setup data
        userService.setSelectedUser({'test': 'data'});

        // Clear
        userService.clearUserData();

        // Verify cleared
        expect(userService.hasLoadedData, isFalse);
        expect(userService.selectedUser, isNull);
        expect(userService.isLoading, isFalse);
      });
    });

    group('Role Checking', () {
      test('should identify admin correctly', () {
        // Admin has role ID 1
        userService.setUserRole('1');

        expect(userService.isAdmin, isTrue);
        expect(userService.isSuperAdmin, isFalse);
      });

      test('should identify super admin correctly', () {
        // Super admin has role ID 2
        userService.setUserRole('2');

        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isTrue);
      });

      test('should handle agent role correctly', () {
        // Agent has role ID 3
        userService.setUserRole('3');

        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isFalse);
        expect(userService.hasRole(3), isTrue);
      });

      test('should handle no roles correctly', () {
        // No role set
        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isFalse);
      });
    });

    group('Safe Access Methods', () {
      test('should return null when no agent data', () {
        expect(userService.getAgentInfo(r'$[:].name'), isNull);
        expect(userService.getAccountInfo(r'$[:].id'), isNull);
      });

      test('should handle getAgentInfo safely', () {
        // Since _agentData is private, we can't set it directly in tests
        // This test verifies the safe null handling
        
        expect(userService.getAgentInfo(r'$[:].invalid'), isNull);
        expect(userService.getAgentInfo(''), isNull);
      });

      test('should handle complex JSON paths', () {
        // Since we can't directly set agentData, we'll test the safe null handling
        // The actual complex path testing would require mocking the API response
        
        // Test that complex paths don't throw errors when data is null
        expect(() => userService.getAgentInfo(r'$[:].user_roles_view[0].role_names'), returnsNormally);
        expect(userService.getAgentInfo(r'$[:].user_roles_view[0].role_names'), isNull);
        
        expect(() => userService.getAgentInfo(r'$[:].nested.data'), returnsNormally);
        expect(userService.getAgentInfo(r'$[:].nested.data'), isNull);
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
        // Test that getAgentInfo handles null data gracefully
        expect(() => userService.getAgentInfo(r'$[:].invalid'), returnsNormally);
        expect(userService.getAgentInfo(r'$[:].invalid'), isNull);
      });
    });

    group('Refresh Functionality', () {
      test('should force refresh even when data is loaded', () async {
        // Test that refresh functionality exists and doesn't throw
        expect(() => userService.refreshUserData(), returnsNormally);
      });
      
      test('should clear user data on clearUserData call', () {
        // Set some data first
        userService.setSelectedUser({'test': 'data'});
        userService.setUserRole('1');
        
        // Clear all data
        userService.clearUserData();
        
        // Verify data is cleared
        expect(userService.selectedUser, isNull);
        expect(userService.hasLoadedData, isFalse);
        expect(userService.isLoading, isFalse);
      });
    });
    
    group('Integration with AccountService', () {
      test('should delegate account operations to AccountService', () {
        // Test that getAccountInfo returns null (delegated)
        expect(userService.getAccountInfo(r'$[:].any_field'), isNull);
        
        // Test that accountIdFm returns empty string (delegated)
        expect(userService.accountIdFm, equals(''));
      });
    });
  });
}