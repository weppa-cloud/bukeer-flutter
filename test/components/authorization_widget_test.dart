import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart'; // Unused import

import '../../lib/components/authorization_widget.dart';
import '../../lib/services/authorization_service.dart';
import '../test_utils/test_helpers.dart';

void main() {
  group('Authorization Widget Tests', () {
    setUp(() {
      TestHelpers.setUp();
    });

    tearDown(() {
      TestHelpers.tearDown();
    });

    group('AuthorizedWidget', () {
      testWidgets('should show child when user is authorized', (tester) async {
        // Arrange
        TestHelpers.mockAuthorizationResult(result: true);
        TestHelpers.mockUserData(userId: 'test_user');

        const authorizedText = 'Authorized Content';
        const unauthorizedText = 'Unauthorized Content';

        final widget = TestHelpers.createTestWidget(
          child: AuthorizedWidget(
            requiredRoles: ['admin'],
            child: Text(authorizedText),
            fallback: Text(unauthorizedText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        await TestHelpers.verifyAuthorizationWidget(
          tester,
          authorizedText: authorizedText,
          unauthorizedText: unauthorizedText,
          shouldBeAuthorized: true,
        );
      });

      testWidgets('should show fallback when user is not authorized', (tester) async {
        // Arrange
        TestHelpers.mockAuthorizationResult(result: false);
        TestHelpers.mockUserData(userId: 'test_user');

        const authorizedText = 'Authorized Content';
        const unauthorizedText = 'Unauthorized Content';

        final widget = TestHelpers.createTestWidget(
          child: AuthorizedWidget(
            requiredRoles: ['admin'],
            child: Text(authorizedText),
            fallback: Text(unauthorizedText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        await TestHelpers.verifyAuthorizationWidget(
          tester,
          authorizedText: authorizedText,
          unauthorizedText: unauthorizedText,
          shouldBeAuthorized: false,
        );
      });

      testWidgets('should hide content when no fallback and unauthorized', (tester) async {
        // Arrange
        TestHelpers.mockAuthorizationResult(result: false);
        TestHelpers.mockUserData(userId: 'test_user');

        const authorizedText = 'Authorized Content';

        final widget = TestHelpers.createTestWidget(
          child: AuthorizedWidget(
            requiredRoles: ['admin'],
            child: Text(authorizedText),
            // No fallback provided
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text(authorizedText), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget); // Should render empty SizedBox
      });

      testWidgets('should show loading while checking authorization', (tester) async {
        // Arrange - Don't mock the result to keep it in loading state
        TestHelpers.mockUserData(userId: 'test_user');

        final widget = TestHelpers.createTestWidget(
          child: AuthorizedWidget(
            requiredRoles: ['admin'],
            child: Text('Authorized Content'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.pump(); // Don't wait for completion

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('RoleBasedWidget', () {
      testWidgets('should work correctly for admin role', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('admin');
        TestHelpers.mockAuthorizationResult(result: true);

        const adminText = 'Admin Content';

        final widget = TestHelpers.createTestWidget(
          child: RoleBasedWidget(
            requiredRole: 'admin',
            child: Text(adminText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text(adminText), findsOneWidget);
      });

      testWidgets('should hide content for wrong role', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('agent');
        TestHelpers.mockAuthorizationResult(result: false);

        const adminText = 'Admin Content';

        final widget = TestHelpers.createTestWidget(
          child: RoleBasedWidget(
            requiredRole: 'admin',
            child: Text(adminText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text(adminText), findsNothing);
      });
    });

    group('AdminOnlyWidget', () {
      testWidgets('should show content for admin user', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('admin');
        TestHelpers.mockAuthorizationResult(result: true);

        const adminText = 'Admin Only Content';

        final widget = TestHelpers.createTestWidget(
          child: AdminOnlyWidget(
            child: Text(adminText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text(adminText), findsOneWidget);
      });

      testWidgets('should hide content for non-admin user', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('agent');
        TestHelpers.mockAuthorizationResult(result: false);

        const adminText = 'Admin Only Content';

        final widget = TestHelpers.createTestWidget(
          child: AdminOnlyWidget(
            child: Text(adminText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text(adminText), findsNothing);
      });
    });

    group('SuperAdminOnlyWidget', () {
      testWidgets('should show content for super admin user', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('super_admin');
        TestHelpers.mockAuthorizationResult(result: true);

        const superAdminText = 'Super Admin Only Content';

        final widget = TestHelpers.createTestWidget(
          child: SuperAdminOnlyWidget(
            child: Text(superAdminText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text(superAdminText), findsOneWidget);
      });

      testWidgets('should hide content for admin user', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('admin');
        TestHelpers.mockAuthorizationResult(result: false);

        const superAdminText = 'Super Admin Only Content';

        final widget = TestHelpers.createTestWidget(
          child: SuperAdminOnlyWidget(
            child: Text(superAdminText),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text(superAdminText), findsNothing);
      });
    });

    group('AuthorizedButton', () {
      testWidgets('should be enabled when user is authorized', (tester) async {
        // Arrange
        TestHelpers.mockAuthorizationResult(result: true);
        TestHelpers.mockUserData(userId: 'test_user');

        var buttonPressed = false;
        final widget = TestHelpers.createTestWidget(
          child: AuthorizedButton(
            onPressed: () => buttonPressed = true,
            requiredRoles: ['admin'],
            child: Text('Delete'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
        expect(button, CustomMatchers.isEnabled());

        // Test button press
        await tester.tap(button);
        await tester.pump();
        expect(buttonPressed, isTrue);
      });

      testWidgets('should be disabled when user is not authorized', (tester) async {
        // Arrange
        TestHelpers.mockAuthorizationResult(result: false);
        TestHelpers.mockUserData(userId: 'test_user');

        var buttonPressed = false;
        final widget = TestHelpers.createTestWidget(
          child: AuthorizedButton(
            onPressed: () => buttonPressed = true,
            requiredRoles: ['admin'],
            child: Text('Delete'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
        expect(button, CustomMatchers.isDisabled());

        // Button should not be pressable
        expect(buttonPressed, isFalse);
      });

      testWidgets('should show loading indicator while checking authorization', (tester) async {
        // Arrange - Don't mock authorization to keep loading
        TestHelpers.mockUserData(userId: 'test_user');

        final widget = TestHelpers.createTestWidget(
          child: AuthorizedButton(
            onPressed: () {},
            requiredRoles: ['admin'],
            child: Text('Delete'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.pump(); // Don't wait for settling

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show tooltip with permission message', (tester) async {
        // Arrange
        TestHelpers.mockAuthorizationResult(result: false);
        TestHelpers.mockUserData(userId: 'test_user');

        final widget = TestHelpers.createTestWidget(
          child: AuthorizedButton(
            onPressed: () {},
            requiredRoles: ['admin'],
            tooltip: 'Delete item',
            child: Text('Delete'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.byType(Tooltip), findsOneWidget);
        
        // Long press to show tooltip
        await tester.longPress(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        
        expect(find.text('No tienes permisos para esta acción'), findsOneWidget);
      });
    });

    group('ResourceAccessWidget', () {
      testWidgets('should show owner UI for resource owner', (tester) async {
        // Arrange
        TestHelpers.mockUserData(userId: 'owner123');

        final widget = TestHelpers.createTestWidget(
          child: ResourceAccessWidget(
            resourceType: 'itinerary',
            ownerId: 'owner123',
            ownerChild: Text('Owner View'),
            adminChild: Text('Admin View'),
            readOnlyChild: Text('Read Only View'),
            noAccessChild: Text('No Access'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Owner View'), findsOneWidget);
        expect(find.text('Admin View'), findsNothing);
        expect(find.text('Read Only View'), findsNothing);
        expect(find.text('No Access'), findsNothing);
      });

      testWidgets('should show admin UI for admin user', (tester) async {
        // Arrange
        TestHelpers.mockUserData(userId: 'admin123');
        TestHelpers.mockUserWithRole('admin');

        final widget = TestHelpers.createTestWidget(
          child: ResourceAccessWidget(
            resourceType: 'itinerary',
            ownerId: 'other_user',
            ownerChild: Text('Owner View'),
            adminChild: Text('Admin View'),
            readOnlyChild: Text('Read Only View'),
            noAccessChild: Text('No Access'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Admin View'), findsOneWidget);
        expect(find.text('Owner View'), findsNothing);
      });

      testWidgets('should show read-only UI for user with read permission', (tester) async {
        // Arrange
        TestHelpers.mockUserData(userId: 'user123');
        TestHelpers.mockUserWithPermissions(['itinerary:read']);

        final widget = TestHelpers.createTestWidget(
          child: ResourceAccessWidget(
            resourceType: 'itinerary',
            ownerId: 'other_user',
            ownerChild: Text('Owner View'),
            adminChild: Text('Admin View'),
            readOnlyChild: Text('Read Only View'),
            noAccessChild: Text('No Access'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Read Only View'), findsOneWidget);
        expect(find.text('Owner View'), findsNothing);
        expect(find.text('Admin View'), findsNothing);
      });

      testWidgets('should show no access UI for unauthorized user', (tester) async {
        // Arrange
        TestHelpers.mockUserData(userId: 'user123');
        // No roles or permissions

        final widget = TestHelpers.createTestWidget(
          child: ResourceAccessWidget(
            resourceType: 'itinerary',
            ownerId: 'other_user',
            ownerChild: Text('Owner View'),
            adminChild: Text('Admin View'),
            readOnlyChild: Text('Read Only View'),
            noAccessChild: Text('No Access'),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('No Access'), findsOneWidget);
      });

      testWidgets('should show default no access widget when none provided', (tester) async {
        // Arrange
        TestHelpers.mockUserData(userId: 'user123');

        final widget = TestHelpers.createTestWidget(
          child: ResourceAccessWidget(
            resourceType: 'itinerary',
            ownerId: 'other_user',
            ownerChild: Text('Owner View'),
            adminChild: Text('Admin View'),
            readOnlyChild: Text('Read Only View'),
            // No noAccessChild provided
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Sin acceso'), findsOneWidget);
        expect(find.byIcon(Icons.lock), findsOneWidget);
      });
    });

    group('UserRoleBadge', () {
      testWidgets('should display role badge for user with role', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('admin');

        final widget = TestHelpers.createTestWidget(
          child: UserRoleBadge(userId: 'admin123'),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Admin'), findsOneWidget);
      });

      testWidgets('should not display badge for user without roles', (tester) async {
        // Arrange
        // No roles set

        final widget = TestHelpers.createTestWidget(
          child: UserRoleBadge(userId: 'user123'),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.byType(Container), findsNothing);
      });

      testWidgets('should display highest priority role', (tester) async {
        // Arrange
        final roles = [
          UserRole(id: 1, name: 'agent', type: 'agent', permissions: []),
          UserRole(id: 2, name: 'admin', type: 'admin', permissions: []),
        ];
        
        when(TestHelpers.mockAuthService.userRoles).thenReturn(roles);

        final widget = TestHelpers.createTestWidget(
          child: UserRoleBadge(userId: 'user123'),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert - Should show admin (higher priority) not agent
        expect(find.text('Admin'), findsOneWidget);
        expect(find.text('Agente'), findsNothing);
      });
    });
  });
}