import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/user_service.dart';

void main() {
  group('UserService Tests', () {
    late UserService userService;

    setUp(() {
      userService = UserService();
    });

    tearDown(() {
      userService.clearUserData();
    });

    group('Initialization', () {
      test('should initialize with no data loaded', () {
        expect(userService.hasLoadedData, isFalse);
        expect(userService.selectedUser, isNull);
        expect(userService.agentData, isNull);
        expect(userService.isLoading, isFalse);
        expect(userService.roleId, isNull);
      });

      test('should have backward compatibility with allDataUser', () {
        expect(userService.allDataUser, isNull);

        // Test setter
        final testUser = {'id': 1, 'name': 'Test'};
        userService.allDataUser = testUser;
        expect(userService.allDataUser, equals(testUser));
        expect(userService.selectedUser, equals(testUser));
      });
    });

    group('Role Management', () {
      test('should set and check user roles', () async {
        // Test initial state
        expect(userService.roleId, isNull);
        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isFalse);

        // Set admin role
        await userService.setUserRole('1');
        expect(userService.roleId, equals('1'));
        expect(userService.isAdmin, isTrue);
        expect(userService.isSuperAdmin, isFalse);

        // Set super admin role
        await userService.setUserRole('2');
        expect(userService.roleId, equals('2'));
        expect(userService.isAdmin, isFalse);
        expect(userService.isSuperAdmin, isTrue);
      });

      test('should check specific role IDs', () async {
        // Test with no role
        expect(userService.hasRole(1), isFalse);
        expect(userService.hasRole(2), isFalse);

        // Set role and test
        await userService.setUserRole('1');
        expect(userService.hasRole(1), isTrue);
        expect(userService.hasRole(2), isFalse);
      });
    });

    group('User Data Management', () {
      test('should set and clear selected user', () {
        final testUser = {
          'id': '123',
          'name': 'Test User',
          'email': 'test@example.com',
        };

        // Set selected user
        userService.setSelectedUser(testUser);
        expect(userService.selectedUser, equals(testUser));

        // Clear selected user
        userService.clearSelectedUser();
        expect(userService.selectedUser, isNull);

        // Clear all user data
        userService.setSelectedUser(testUser);
        userService.clearUserData();
        expect(userService.selectedUser, isNull);
        expect(userService.hasLoadedData, isFalse);
      });
    });

    group('Agent Data', () {
      test('should get agent info using JSONPath', () {
        // Test with no agent data
        expect(userService.getAgentInfo(r'$.name'), isNull);

        // Note: We can't set agent data directly in the test
        // as it's loaded from API. This is a limitation of the current design.
      });
    });

    group('Account Info', () {
      test('should have accountIdFm getter', () {
        // This now returns empty string as it's delegated to AccountService
        expect(userService.accountIdFm, equals(''));
      });

      test('should have accountIdFm setter for backward compatibility', () {
        // This is deprecated but should not throw
        expect(() => userService.accountIdFm = 'test', returnsNormally);
      });

      test('should delegate getAccountInfo to AccountService', () {
        // This method now returns null and logs a deprecation message
        expect(userService.getAccountInfo(r'$.id'), isNull);
      });
    });

    group('Data Loading', () {
      test('should have initializeUserData method', () async {
        // Without authentication, this will return false
        final result = await userService.initializeUserData();
        expect(result, isFalse);

        // Should prevent multiple initializations
        final result2 = await userService.initializeUserData();
        expect(result2, isFalse);
      });

      test('should have refreshUserData method', () async {
        // Without authentication, this will return false
        final result = await userService.refreshUserData();
        expect(result, isFalse);
      });

      test('should track loading state', () {
        // Initial state
        expect(userService.isLoading, isFalse);

        // Note: We can't test actual loading state changes without mocking
        // the API calls, which would require more complex setup
      });
    });
  });
}
