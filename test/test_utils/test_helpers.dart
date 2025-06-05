import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../lib/services/authorization_service.dart';
import '../../lib/services/error_service.dart';
import '../../lib/services/user_service.dart';
import '../../lib/services/itinerary_service.dart';
import '../../lib/app_state_clean.dart';
import '../mocks/supabase_mocks.dart';

// Generate mocks with build_runner
@GenerateMocks([
  AuthorizationService,
  ErrorService,
  UserService,
  ItineraryService,
])
import 'test_helpers.mocks.dart';

/// Test utilities and helpers for Bukeer app testing
class TestHelpers {
  // Mock services
  static late MockAuthorizationService mockAuthService;
  static late MockErrorService mockErrorService;
  static late MockUserService mockUserService;
  static late MockItineraryService mockItineraryService;
  static late FFAppState mockAppState;

  /// Initialize all mocks before each test
  static void setUp() {
    mockAuthService = MockAuthorizationService();
    mockErrorService = MockErrorService();
    mockUserService = MockUserService();
    mockItineraryService = MockItineraryService();
    mockAppState = FFAppState();
    
    // Initialize Supabase mocks
    SupabaseMocks.setUp();
  }

  /// Clean up after each test
  static void tearDown() {
    // Reset any global state if needed
    mockAppState.clearState();
    
    // Clean up Supabase mocks
    SupabaseMocks.tearDown();
  }

  /// Create a test widget with all necessary providers
  static Widget createTestWidget({
    required Widget child,
    AuthorizationService? authService,
    ErrorService? errorService,
    UserService? userService,
    ItineraryService? itineraryService,
    FFAppState? appState,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FFAppState>.value(
          value: appState ?? mockAppState,
        ),
        ChangeNotifierProvider<AuthorizationService>.value(
          value: authService ?? mockAuthService,
        ),
        ChangeNotifierProvider<ErrorService>.value(
          value: errorService ?? mockErrorService,
        ),
        ChangeNotifierProvider<UserService>.value(
          value: userService ?? mockUserService,
        ),
        ChangeNotifierProvider<ItineraryService>.value(
          value: itineraryService ?? mockItineraryService,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  /// Mock user with specific role
  static void mockUserWithRole(RoleType role) {
    final userRoles = [
      UserRole(
        id: 1,
        name: role.name,
        type: role,
        permissions: _getPermissionsForRole(role),
      ),
    ];

    when(mockAuthService.userRoles).thenReturn(userRoles);
    when(mockAuthService.hasRole(role)).thenReturn(true);
    when(mockAuthService.isAdmin).thenReturn(
      role == RoleType.admin || role == RoleType.superAdmin,
    );
    when(mockAuthService.isSuperAdmin).thenReturn(role == RoleType.superAdmin);
  }

  /// Mock user with specific permissions
  static void mockUserWithPermissions(List<String> permissions) {
    when(mockAuthService.userPermissions).thenReturn(permissions.toSet());
    for (final permission in permissions) {
      when(mockAuthService.hasPermission(permission)).thenReturn(true);
    }
  }

  /// Mock authorization result
  static void mockAuthorizationResult({
    required bool result,
    String? userId,
    List<RoleType>? requiredRoles,
    List<String>? requiredPermissions,
    String? resourceType,
    String? action,
    String? ownerId,
  }) {
    when(mockAuthService.authorize(
      userId: userId ?? anyNamed('userId'),
      requiredRoles: requiredRoles ?? anyNamed('requiredRoles'),
      requiredPermissions: requiredPermissions ?? anyNamed('requiredPermissions'),
      resourceType: resourceType ?? anyNamed('resourceType'),
      action: action ?? anyNamed('action'),
      ownerId: ownerId ?? anyNamed('ownerId'),
    )).thenAnswer((_) async => result);
  }

  /// Mock error state
  static void mockErrorState({
    String? message,
    ErrorType type = ErrorType.unknown,
    ErrorSeverity severity = ErrorSeverity.medium,
  }) {
    final error = AppError(
      message: message ?? 'Test error',
      originalError: Exception(message ?? 'Test error'),
      stackTrace: StackTrace.current,
      type: type,
      severity: severity,
      timestamp: DateTime.now(),
      metadata: {},
    );

    when(mockErrorService.currentError).thenReturn(error);
    when(mockErrorService.hasError).thenReturn(true);
  }

  /// Mock user data
  static void mockUserData({
    String? userId,
    String? name,
    String? email,
    Map<String, dynamic>? userData,
  }) {
    final defaultUserData = {
      'id': userId ?? 'test_user_123',
      'name': name ?? 'Test User',
      'email': email ?? 'test@example.com',
      'last_name': 'Last Name',
    };

    final finalUserData = userData ?? defaultUserData;

    when(mockUserService.hasLoadedData).thenReturn(true);
    when(mockUserService.getAgentInfo(any)).thenReturn(finalUserData);
    when(mockUserService.isAdmin).thenReturn(false);
    when(mockUserService.isSuperAdmin).thenReturn(false);
  }

  /// Mock itinerary data
  static void mockItineraryData({
    String? itineraryId,
    List<dynamic>? itineraries,
    dynamic itineraryDetails,
  }) {
    final defaultItineraries = [
      {
        'id': itineraryId ?? '1',
        'name': 'Test Itinerary',
        'client_name': 'Test Client',
        'start_date': '2024-01-01',
        'end_date': '2024-01-07',
        'status': 'draft',
      }
    ];

    when(mockItineraryService.itineraries).thenReturn(itineraries ?? defaultItineraries);
    
    if (itineraryDetails != null && itineraryId != null) {
      when(mockItineraryService.getItinerary(int.parse(itineraryId)))
          .thenReturn(itineraryDetails);
    }
  }

  /// Wait for async operations to complete
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
    // Wait a bit more for async operations
    await Future.delayed(Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  }

  /// Find widget by text with timeout
  static Future<Finder> findByTextWithTimeout(
    WidgetTester tester,
    String text, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(Duration(milliseconds: 100));
      final finder = find.text(text);
      if (finder.evaluate().isNotEmpty) {
        return finder;
      }
    }
    
    throw Exception('Widget with text "$text" not found within timeout');
  }

  /// Verify that a widget is conditionally shown based on authorization
  static Future<void> verifyAuthorizationWidget(
    WidgetTester tester, {
    required String authorizedText,
    required String unauthorizedText,
    required bool shouldBeAuthorized,
  }) async {
    await pumpAndSettle(tester);

    if (shouldBeAuthorized) {
      expect(find.text(authorizedText), findsOneWidget);
      expect(find.text(unauthorizedText), findsNothing);
    } else {
      expect(find.text(authorizedText), findsNothing);
      expect(find.text(unauthorizedText), findsOneWidget);
    }
  }

  /// Mock Supabase data for different scenarios
  static void mockSupabaseItineraries({
    List<Map<String, dynamic>>? customData,
  }) {
    SupabaseMocks.mockItinerariesData(customData: customData);
  }

  static void mockSupabaseContacts({
    List<Map<String, dynamic>>? customData,
  }) {
    SupabaseMocks.mockContactsData(customData: customData);
  }

  static void mockSupabaseHotels({
    List<Map<String, dynamic>>? customData,
  }) {
    SupabaseMocks.mockHotelsData(customData: customData);
  }

  static void mockSupabaseActivities({
    List<Map<String, dynamic>>? customData,
  }) {
    SupabaseMocks.mockActivitiesData(customData: customData);
  }

  static void mockSupabaseTransfers({
    List<Map<String, dynamic>>? customData,
  }) {
    SupabaseMocks.mockTransfersData(customData: customData);
  }

  static void mockSupabaseUserRoles({
    List<Map<String, dynamic>>? customData,
  }) {
    SupabaseMocks.mockUserRolesData(customData: customData);
  }

  static void mockSupabaseError(String message, {int statusCode = 400}) {
    SupabaseMocks.mockErrorResponse(message, statusCode: statusCode);
  }

  static void mockSupabaseAuth({
    bool authenticated = true,
    String userId = 'test-user-id',
    String email = 'test@example.com',
  }) {
    if (authenticated) {
      SupabaseMocks.mockAuthenticatedUser(userId: userId, email: email);
    } else {
      SupabaseMocks.mockUnauthenticatedUser();
    }
  }

  /// Get permissions for a role (helper)
  static List<String> _getPermissionsForRole(RoleType role) {
    switch (role) {
      case RoleType.superAdmin:
        return [
          'itinerary:*', 'contact:*', 'product:*', 
          'user:*', 'payment:*', 'report:*'
        ];
      case RoleType.admin:
        return [
          'itinerary:create', 'itinerary:read', 'itinerary:update', 'itinerary:delete',
          'contact:create', 'contact:read', 'contact:update', 'contact:delete',
          'product:create', 'product:read', 'product:update', 'product:delete',
          'user:read', 'user:update',
          'payment:create', 'payment:read', 'payment:update',
          'report:read', 'report:export'
        ];
      case RoleType.agent:
        return [
          'itinerary:create', 'itinerary:read', 'itinerary:update',
          'contact:create', 'contact:read', 'contact:update',
          'product:read', 'user:read', 'payment:read', 'report:read'
        ];
      default:
        return [];
    }
  }
}

/// Custom matchers for testing
class CustomMatchers {
  /// Matcher for checking if a widget is enabled
  static Matcher isEnabled() => _IsEnabledMatcher();
  
  /// Matcher for checking if a widget is disabled
  static Matcher isDisabled() => _IsDisabledMatcher();
}

class _IsEnabledMatcher extends Matcher {
  @override
  Description describe(Description description) =>
      description.add('is enabled');

  @override
  bool matches(item, Map matchState) {
    if (item is Finder) {
      final widget = item.evaluate().first.widget;
      if (widget is ElevatedButton) {
        return widget.onPressed != null;
      }
    }
    return false;
  }
}

class _IsDisabledMatcher extends Matcher {
  @override
  Description describe(Description description) =>
      description.add('is disabled');

  @override
  bool matches(item, Map matchState) {
    if (item is Finder) {
      final widget = item.evaluate().first.widget;
      if (widget is ElevatedButton) {
        return widget.onPressed == null;
      }
    }
    return false;
  }
}