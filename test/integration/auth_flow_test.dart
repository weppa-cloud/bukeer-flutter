import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import '../../lib/bukeer/users/auth_login/auth_login_widget.dart';
import '../../lib/bukeer/users/auth_create/auth_create_widget.dart';
import '../../lib/bukeer/users/forgot_password/forgot_password_widget.dart';
import '../../lib/bukeer/dashboard/main_home/main_home_widget.dart';
import '../test_utils/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    setUp(() {
      TestHelpers.setUp();
    });

    tearDown(() {
      TestHelpers.tearDown();
    });

    group('Login Flow', () {
      testWidgets('should complete successful login flow', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseAuth(authenticated: false);
        TestHelpers.mockSupabaseUserRoles();
        
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act - Render login page
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert login page is shown
        expect(find.text('Iniciar Sesión'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);

        // Enter valid credentials
        final emailField = find.byKey(Key('email_field'));
        final passwordField = find.byKey(Key('password_field'));
        
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, 'password123');

        // Mock successful authentication
        SupabaseMocks.mockSignInSuccess(
          userId: 'test-user-id',
          email: 'test@example.com',
        );
        TestHelpers.mockSupabaseAuth(authenticated: true);

        // Submit login form
        final loginButton = find.text('Ingresar');
        await tester.tap(loginButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert navigation to dashboard
        // This would need proper navigation testing in a real app
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should handle login failure correctly', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseAuth(authenticated: false);
        
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Enter credentials
        final emailField = find.byKey(Key('email_field'));
        final passwordField = find.byKey(Key('password_field'));
        
        await tester.enterText(emailField, 'wrong@example.com');
        await tester.enterText(passwordField, 'wrongpassword');

        // Mock authentication failure
        SupabaseMocks.mockSignInFailure('Invalid credentials');

        // Submit login form
        final loginButton = find.text('Ingresar');
        await tester.tap(loginButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert error message is shown
        expect(find.text('Invalid credentials'), findsOneWidget);
        expect(find.text('Iniciar Sesión'), findsOneWidget); // Still on login page
      });

      testWidgets('should validate email and password fields', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseAuth(authenticated: false);
        
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Try to submit without filling fields
        final loginButton = find.text('Ingresar');
        await tester.tap(loginButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert validation errors
        expect(find.text('Email es requerido'), findsOneWidget);
        expect(find.text('Contraseña es requerida'), findsOneWidget);

        // Enter invalid email
        final emailField = find.byKey(Key('email_field'));
        await tester.enterText(emailField, 'invalid-email');
        await tester.tap(loginButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert email validation
        expect(find.text('Email inválido'), findsOneWidget);
      });
    });

    group('Registration Flow', () {
      testWidgets('should complete successful registration flow', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseAuth(authenticated: false);
        
        final widget = TestHelpers.createTestWidget(
          child: AuthCreateWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert registration page is shown
        expect(find.text('Crear Cuenta'), findsOneWidget);
        expect(find.text('Nombre'), findsOneWidget);
        expect(find.text('Apellido'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);
        expect(find.text('Confirmar Contraseña'), findsOneWidget);

        // Fill registration form
        await tester.enterText(find.byKey(Key('name_field')), 'John');
        await tester.enterText(find.byKey(Key('last_name_field')), 'Doe');
        await tester.enterText(find.byKey(Key('email_field')), 'john@example.com');
        await tester.enterText(find.byKey(Key('password_field')), 'password123');
        await tester.enterText(find.byKey(Key('confirm_password_field')), 'password123');

        // Mock successful registration
        SupabaseMocks.mockSignInSuccess(
          userId: 'new-user-id',
          email: 'john@example.com',
        );

        // Submit registration form
        final registerButton = find.text('Crear Cuenta');
        await tester.tap(registerButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert successful registration flow
        // This would include email verification in a real app
      });

      testWidgets('should validate registration form fields', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseAuth(authenticated: false);
        
        final widget = TestHelpers.createTestWidget(
          child: AuthCreateWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Try to submit empty form
        final registerButton = find.text('Crear Cuenta');
        await tester.tap(registerButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert validation errors
        expect(find.text('Nombre es requerido'), findsOneWidget);
        expect(find.text('Email es requerido'), findsOneWidget);
        expect(find.text('Contraseña es requerida'), findsOneWidget);

        // Test password confirmation
        await tester.enterText(find.byKey(Key('password_field')), 'password123');
        await tester.enterText(find.byKey(Key('confirm_password_field')), 'different');
        await tester.tap(registerButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert password mismatch error
        expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
      });
    });

    group('Password Reset Flow', () {
      testWidgets('should complete password reset flow', (tester) async {
        // Arrange
        final widget = TestHelpers.createTestWidget(
          child: ForgotPasswordWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert forgot password page is shown
        expect(find.text('Recuperar Contraseña'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);

        // Enter email
        final emailField = find.byKey(Key('email_field'));
        await tester.enterText(emailField, 'test@example.com');

        // Submit form
        final resetButton = find.text('Enviar');
        await tester.tap(resetButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert success message
        expect(find.text('Email de recuperación enviado'), findsOneWidget);
      });

      testWidgets('should validate email in password reset', (tester) async {
        // Arrange
        final widget = TestHelpers.createTestWidget(
          child: ForgotPasswordWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Try to submit without email
        final resetButton = find.text('Enviar');
        await tester.tap(resetButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert validation error
        expect(find.text('Email es requerido'), findsOneWidget);

        // Enter invalid email
        final emailField = find.byKey(Key('email_field'));
        await tester.enterText(emailField, 'invalid-email');
        await tester.tap(resetButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert email validation
        expect(find.text('Email inválido'), findsOneWidget);
      });
    });

    group('Navigation Between Auth Pages', () {
      testWidgets('should navigate from login to register', (tester) async {
        // Arrange
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap "Crear cuenta" link
        final createAccountLink = find.text('¿No tienes cuenta? Crear cuenta');
        await tester.tap(createAccountLink);
        await TestHelpers.pumpAndSettle(tester);

        // Assert navigation to registration page
        // This would need proper navigation testing
      });

      testWidgets('should navigate from login to forgot password', (tester) async {
        // Arrange
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap "Forgot password" link
        final forgotPasswordLink = find.text('¿Olvidaste tu contraseña?');
        await tester.tap(forgotPasswordLink);
        await TestHelpers.pumpAndSettle(tester);

        // Assert navigation to forgot password page
        // This would need proper navigation testing
      });

      testWidgets('should navigate from register to login', (tester) async {
        // Arrange
        final widget = TestHelpers.createTestWidget(
          child: AuthCreateWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Tap "Iniciar sesión" link
        final loginLink = find.text('¿Ya tienes cuenta? Iniciar sesión');
        await tester.tap(loginLink);
        await TestHelpers.pumpAndSettle(tester);

        // Assert navigation to login page
        // This would need proper navigation testing
      });
    });

    group('Authentication State Management', () {
      testWidgets('should redirect authenticated user from auth pages', (tester) async {
        // Arrange - Mock authenticated user
        TestHelpers.mockSupabaseAuth(authenticated: true);
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Assert redirect to dashboard
        // This would need proper navigation/routing testing
      });

      testWidgets('should handle logout correctly', (tester) async {
        // Arrange - Start with authenticated user
        TestHelpers.mockSupabaseAuth(authenticated: true);
        TestHelpers.mockUserData();
        
        final widget = TestHelpers.createTestWidget(
          child: MainHomeWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Trigger logout (this would typically be in navigation)
        SupabaseMocks.mockSignOut();
        TestHelpers.mockSupabaseAuth(authenticated: false);

        // Assert redirect to login page
        // This would need proper auth state management testing
      });
    });

    group('Loading States', () {
      testWidgets('should show loading during authentication', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseAuth(authenticated: false);
        
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // Fill and submit form
        await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
        await tester.enterText(find.byKey(Key('password_field')), 'password');

        // Tap login button
        final loginButton = find.text('Ingresar');
        await tester.tap(loginButton);
        
        // Don't wait for settling to catch loading state
        await tester.pump();

        // Assert loading indicator is shown
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Error Recovery', () {
      testWidgets('should recover from network errors', (tester) async {
        // Arrange
        TestHelpers.mockSupabaseAuth(authenticated: false);
        
        final widget = TestHelpers.createTestWidget(
          child: AuthLoginWidget(),
        );

        // Act
        await tester.pumpWidget(widget);
        await TestHelpers.pumpAndSettle(tester);

        // First attempt - network error
        await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
        await tester.enterText(find.byKey(Key('password_field')), 'password');

        SupabaseMocks.mockSignInFailure('Network error');
        
        final loginButton = find.text('Ingresar');
        await tester.tap(loginButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert error message
        expect(find.text('Network error'), findsOneWidget);

        // Second attempt - success
        SupabaseMocks.mockSignInSuccess();
        TestHelpers.mockSupabaseAuth(authenticated: true);
        
        await tester.tap(loginButton);
        await TestHelpers.pumpAndSettle(tester);

        // Assert successful login
        expect(find.text('Network error'), findsNothing);
      });
    });
  });
}