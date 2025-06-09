import 'package:flutter_test/flutter_test.dart';
// // import 'package:mockito/mockito.dart'; // Unused import // Unused import
import 'package:mockito/annotations.dart';

import 'package:bukeer/services/authorization_service.dart';
import 'package:bukeer/backend/supabase/supabase.dart';

// Generate mocks
@GenerateMocks([SupaFlow])
import 'authorization_service_test.mocks.dart';

void main() {
  group('AuthorizationService Tests', () {
    late AuthorizationService authService;
    late MockSupaFlow _mockSupaFlow;

    setUp(() {
      authService = AuthorizationService();
      _mockSupaFlow = MockSupaFlow();
    });

    tearDown(() {
      authService.clearRoles();
    });

    group('Permission Checking', () {
      test('should check single permission correctly', () {
        // Arrange - Mock user with specific permissions using extension
        authService.setUserPermissionsForTesting(
            {'itinerary:create', 'itinerary:read', 'contact:read'});

        // Act & Assert
        expect(authService.hasPermission('itinerary:create'), isTrue);
        expect(authService.hasPermission('itinerary:delete'), isFalse);
        expect(authService.hasPermission('contact:read'), isTrue);
      });

      test('should check multiple permissions correctly', () {
        // Arrange
        authService.setUserPermissionsForTesting(
            {'itinerary:create', 'itinerary:read', 'contact:read'});

        // Act & Assert
        expect(
          authService.hasAnyPermission(['itinerary:create', 'user:delete']),
          isTrue,
        );
        expect(
          authService.hasAllPermissions(['itinerary:create', 'itinerary:read']),
          isTrue,
        );
        expect(
          authService.hasAllPermissions(['itinerary:create', 'user:delete']),
          isFalse,
        );
      });
    });

    group('Role Checking', () {
      test('should check single role correctly', () {
        // Arrange
        final adminRole = UserRole(
          id: 1,
          name: 'admin',
          type: RoleType.admin,
          permissions: ['itinerary:create'],
        );
        authService.setUserRolesForTesting([adminRole]);

        // Act & Assert
        expect(authService.hasRole(RoleType.admin), isTrue);
        expect(authService.hasRole(RoleType.superAdmin), isFalse);
        expect(authService.isAdmin, isTrue);
        expect(authService.isSuperAdmin, isFalse);
      });

      test('should check multiple roles correctly', () {
        // Arrange
        final roles = [
          UserRole(id: 1, name: 'admin', type: RoleType.admin, permissions: []),
          UserRole(id: 2, name: 'agent', type: RoleType.agent, permissions: []),
        ];
        authService.setUserRolesForTesting(roles);

        // Act & Assert
        expect(
          authService.hasAnyRole([RoleType.admin, RoleType.superAdmin]),
          isTrue,
        );
        expect(
          authService.hasAllRoles([RoleType.admin, RoleType.agent]),
          isTrue,
        );
        expect(
          authService.hasAllRoles([RoleType.admin, RoleType.superAdmin]),
          isFalse,
        );
      });
    });

    group('Resource Access', () {
      test('should allow owner access to resource', () {
        // Arrange
        const userId = 'user123';
        const ownerId = 'user123';

        // Act
        final canAccess = authService.canAccessResource(
          'itinerary',
          'update',
          ownerId: ownerId,
          currentUserId: userId,
        );

        // Assert
        expect(canAccess, isTrue);
      });

      test('should allow admin access to any resource', () {
        // Arrange
        authService.setUserRolesForTesting([
          UserRole(id: 1, name: 'admin', type: RoleType.admin, permissions: [])
        ]);

        // Act
        final canAccess = authService.canAccessResource(
          'itinerary',
          'delete',
          ownerId: 'other_user',
          currentUserId: 'admin_user',
        );

        // Assert
        expect(canAccess, isTrue);
      });

      test('should deny access without proper permissions', () {
        // Arrange
        authService.setUserRolesForTesting([
          UserRole(id: 1, name: 'agent', type: RoleType.agent, permissions: [])
        ]);

        // Act
        final canAccess = authService.canAccessResource(
          'user',
          'delete',
          ownerId: 'other_user',
          currentUserId: 'agent_user',
        );

        // Assert
        expect(canAccess, isFalse);
      });
    });

    group('Authorization Scenarios', () {
      test('should authorize based on role requirements', () async {
        // Arrange
        authService.setUserRolesForTesting([
          UserRole(id: 1, name: 'admin', type: RoleType.admin, permissions: [])
        ]);

        // Act
        final isAuthorized = await authService.authorize(
          userId: 'user123',
          requiredRoles: [RoleType.admin, RoleType.superAdmin],
        );

        // Assert
        expect(isAuthorized, isTrue);
      });

      test('should authorize based on permission requirements', () async {
        // Arrange
        authService
            .setUserPermissionsForTesting({'itinerary:create', 'contact:read'});

        // Act
        final isAuthorized = await authService.authorize(
          userId: 'user123',
          requiredPermissions: ['itinerary:create'],
        );

        // Assert
        expect(isAuthorized, isTrue);
      });

      test('should authorize resource owner', () async {
        // Act
        final isAuthorized = await authService.authorize(
          userId: 'user123',
          ownerId: 'user123',
          resourceType: 'itinerary',
          action: 'update',
        );

        // Assert
        expect(isAuthorized, isTrue);
      });

      test('should deny authorization without proper credentials', () async {
        // Arrange - no roles or permissions

        // Act
        final isAuthorized = await authService.authorize(
          userId: 'user123',
          requiredRoles: [RoleType.admin],
          requiredPermissions: ['itinerary:delete'],
        );

        // Assert
        expect(isAuthorized, isFalse);
      });
    });

    group('Role Level Calculation', () {
      test('should calculate correct role levels', () {
        // Test Super Admin
        authService.setUserRolesForTesting([
          UserRole(
              id: 1,
              name: 'super_admin',
              type: RoleType.superAdmin,
              permissions: [])
        ]);
        expect(authService.roleLevel, equals(3));

        // Test Admin
        authService.setUserRolesForTesting([
          UserRole(id: 1, name: 'admin', type: RoleType.admin, permissions: [])
        ]);
        expect(authService.roleLevel, equals(2));

        // Test Agent
        authService.setUserRolesForTesting([
          UserRole(id: 1, name: 'agent', type: RoleType.agent, permissions: [])
        ]);
        expect(authService.roleLevel, equals(1));

        // Test No Role
        authService.setUserRolesForTesting([]);
        expect(authService.roleLevel, equals(0));
      });
    });

    group('Cache Management', () {
      test('should clear roles correctly', () {
        // Arrange
        authService.setUserRolesForTesting([
          UserRole(id: 1, name: 'admin', type: RoleType.admin, permissions: [])
        ]);
        authService.setUserPermissionsForTesting({'test:permission'});

        // Act
        authService.clearRoles();

        // Assert
        expect(authService.userRoles, isEmpty);
        expect(authService.userPermissions, isEmpty);
        expect(authService.hasLoadedRoles, isFalse);
      });
    });
  });
}
