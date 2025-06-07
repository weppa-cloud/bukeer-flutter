import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// // import 'package:mockito/mockito.dart'; // Unused import // Unused import

import 'package:bukeer/bukeer/componentes/web_nav/web_nav_widget.dart';
// import 'package:bukeer/bukeer/componentes/web_nav/web_nav_model.dart'; // Unused import
import 'package:bukeer/services/authorization_service.dart';
import '../test_utils/test_helpers.dart';

void main() {
  group('WebNavWidget Tests', () {
    setUp(() {
      TestHelpers.setUp();
    });

    tearDown(() {
      TestHelpers.tearDown();
    });

    group('Widget Rendering', () {
      testWidgets('should render navigation correctly', (tester) async {
        // Arrange
        TestHelpers.mockUserData(
          name: 'John',
          email: 'john@example.com',
        );

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.text('Itinerarios'), findsOneWidget);
        expect(find.text('Productos'), findsOneWidget);
        expect(find.text('Contactos'), findsOneWidget);
      });

      testWidgets('should show user info when data is loaded', (tester) async {
        // Arrange
        TestHelpers.mockUserData(
          name: 'John',
          email: 'john@example.com',
        );

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('John'), findsOneWidget);
        expect(find.text('john@example.com'), findsOneWidget);
      });

      testWidgets('should show loading when user data is not available',
          (tester) async {
        // Arrange - Don't mock user data to simulate loading

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.pump(); // Don't wait for settling to catch loading state

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Role-Based Navigation', () {
      testWidgets('should show admin menu items for admin users',
          (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('admin');
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Usuarios'), findsOneWidget);
        expect(find.text('Reportes'), findsOneWidget);
      });

      testWidgets('should hide admin menu items for agent users',
          (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('agent');
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Usuarios'), findsNothing);
        expect(find.text('Reportes'), findsNothing);
      });

      testWidgets('should show all menu items for super admin', (tester) async {
        // Arrange
        TestHelpers.mockUserWithRole('super_admin');
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Usuarios'), findsOneWidget);
        expect(find.text('Reportes'), findsOneWidget);
        expect(find.text('Configuración'), findsOneWidget);
      });
    });

    group('User Profile Section', () {
      testWidgets('should display user avatar and info', (tester) async {
        // Arrange
        TestHelpers.mockUserData(
          name: 'Jane',
          email: 'jane@example.com',
          userData: {
            'photo_url': 'https://example.com/avatar.jpg',
            'name': 'Jane',
            'last_name': 'Doe',
            'email': 'jane@example.com',
          },
        );

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.text('jane@example.com'), findsOneWidget);
        expect(find.byType(CircleAvatar), findsOneWidget);
      });

      testWidgets('should show profile dropdown on user section tap',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap on user section
        final userSection = find.byType(CircleAvatar);
        await tester.tap(userSection);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Perfil'), findsOneWidget);
        expect(find.text('Configuración'), findsOneWidget);
        expect(find.text('Cerrar Sesión'), findsOneWidget);
      });
    });

    group('Navigation Actions', () {
      testWidgets('should navigate to dashboard on dashboard tap',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap dashboard
        final dashboardItem = find.text('Dashboard');
        await tester.tap(dashboardItem);
        await TestHelpers.pumpAndSettle(tester);

        // Assert navigation would occur
        // This would need proper navigation testing/mocking
      });

      testWidgets('should navigate to itineraries on itineraries tap',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap itineraries
        final itinerariesItem = find.text('Itinerarios');
        await tester.tap(itinerariesItem);
        await TestHelpers.pumpAndSettle(tester);

        // Assert navigation would occur
        // This would need proper navigation testing/mocking
      });

      testWidgets('should logout on logout tap', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Open profile dropdown
        final userSection = find.byType(CircleAvatar);
        await tester.tap(userSection);
        await TestHelpers.pumpAndSettle(tester);

        // Tap logout
        final logoutItem = find.text('Cerrar Sesión');
        await tester.tap(logoutItem);
        await TestHelpers.pumpAndSettle(tester);

        // Assert logout would occur
        // This would need proper auth service mocking
      });
    });

    group('Active Route Highlighting', () {
      testWidgets('should highlight active route', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(
            selectedNav: 1,
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        // Dashboard should be highlighted as active
        // This would need proper styling/theme testing
        final dashboardContainer = find.ancestor(
          of: find.text('Dashboard'),
          matching: find.byType(Container),
        );
        expect(dashboardContainer, findsOneWidget);
      });

      testWidgets('should not highlight inactive routes', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(
            selectedNav: 2,
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        // Dashboard should NOT be highlighted
        // Itinerarios should be highlighted
        // This would need proper styling testing
      });
    });

    group('Error Handling', () {
      testWidgets('should handle user data loading errors', (tester) async {
        // Arrange
        TestHelpers.mockErrorState(message: 'Failed to load user data');

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        // Should show fallback or error state
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should show default avatar when photo fails to load',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData(
          userData: {
            'photo_url': 'invalid-url',
            'name': 'John',
            'last_name': 'Doe',
          },
        );

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.byType(CircleAvatar), findsOneWidget);
        // Should show default avatar or initials
      });
    });

    group('Responsive Behavior', () {
      testWidgets('should adapt to different screen sizes', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        // Set small screen size
        await tester.binding.setSurfaceSize(Size(600, 800));

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert responsive behavior
        // This would need proper responsive design testing

        // Reset screen size
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should show mobile navigation on small screens',
          (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        // Set mobile screen size
        await tester.binding.setSurfaceSize(Size(400, 800));

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert mobile navigation elements
        // This would need proper mobile nav testing

        // Reset screen size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper accessibility labels', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert semantic labels
        expect(find.bySemanticsLabel('Navegación principal'), findsOneWidget);
        expect(find.bySemanticsLabel('Ir a Dashboard'), findsOneWidget);
        expect(find.bySemanticsLabel('Ir a Itinerarios'), findsOneWidget);
      });

      testWidgets('should support keyboard navigation', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        final widget = TestHelpers.createTestWidget(
          child: WebNavWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Test keyboard navigation
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        // Assert keyboard navigation works
        // This would need proper focus testing
      });
    });

    group('Performance', () {
      testWidgets('should not rebuild unnecessarily', (tester) async {
        // Arrange
        TestHelpers.mockUserData();

        var buildCount = 0;
        final widget = TestHelpers.createTestWidget(
          child: Builder(
            builder: (context) {
              buildCount++;
              return WebNavWidget();
            },
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        final initialBuildCount = buildCount;

        // Trigger some state change that shouldn't affect nav
        await tester.pump();

        // Assert minimal rebuilds
        expect(buildCount, equals(initialBuildCount));
      });
    });
  });
}
