import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:postgrest/postgrest.dart';
import 'package:supabase/supabase.dart';

import '../../lib/backend/supabase/supabase.dart';

// Mock Supabase client and related classes
@GenerateMocks([
  SupabaseClient,
  PostgrestClient,
  PostgrestFilterBuilder,
  PostgrestQueryBuilder,
  PostgrestBuilder,
  PostgrestResponse,
  GoTrueClient,
  User,
  Session,
])
import 'supabase_mocks.mocks.dart';

/// Mock implementations for Supabase operations
class SupabaseMocks {
  static late MockSupabaseClient mockClient;
  static late MockPostgrestClient mockPostgrest;
  static late MockPostgrestQueryBuilder mockQueryBuilder;
  static late MockPostgrestFilterBuilder mockFilterBuilder;
  static late MockPostgrestBuilder mockBuilder;
  static late MockGoTrueClient mockAuth;
  static late MockUser mockUser;
  static late MockSession mockSession;

  /// Initialize all mocks
  static void setUp() {
    mockClient = MockSupabaseClient();
    mockPostgrest = MockPostgrestClient();
    mockQueryBuilder = MockPostgrestQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();
    mockBuilder = MockPostgrestBuilder();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    mockSession = MockSession();

    // Setup basic mock relationships
    when(mockClient.from(any)).thenReturn(mockQueryBuilder);
    when(mockClient.auth).thenReturn(mockAuth);
    
    // Setup query builder chain
    when(mockQueryBuilder.select(any)).thenReturn(mockFilterBuilder);
    when(mockQueryBuilder.insert(any)).thenReturn(mockBuilder);
    when(mockQueryBuilder.update(any)).thenReturn(mockFilterBuilder);
    when(mockQueryBuilder.delete()).thenReturn(mockFilterBuilder);
    
    // Setup filter builder chain
    when(mockFilterBuilder.eq(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.neq(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.gt(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.gte(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.lt(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.lte(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.like(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.ilike(any, any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.order(any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.limit(any)).thenReturn(mockFilterBuilder);
    when(mockFilterBuilder.range(any, any)).thenReturn(mockFilterBuilder);
    
    // Setup default auth user
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockAuth.currentSession).thenReturn(mockSession);
    when(mockUser.id).thenReturn('test-user-id');
    when(mockUser.email).thenReturn('test@example.com');
  }

  /// Mock successful data response
  static void mockSuccessResponse(List<Map<String, dynamic>> data) {
    final response = PostgrestResponse(
      data: data,
      count: data.length,
    );
    
    when(mockFilterBuilder).thenAnswer((_) async => response);
    when(mockBuilder).thenAnswer((_) async => response);
  }

  /// Mock error response
  static void mockErrorResponse(String message, {int statusCode = 400}) {
    final error = PostgrestException(
      message: message,
      code: statusCode.toString(),
    );
    
    when(mockFilterBuilder.then()).thenThrow(error);
    when(mockBuilder.then()).thenThrow(error);
  }

  /// Mock itineraries data
  static void mockItinerariesData({
    List<Map<String, dynamic>>? customData,
  }) {
    final data = customData ?? [
      {
        'id': 1,
        'name': 'Test Itinerary 1',
        'client_name': 'John Doe',
        'start_date': '2024-01-01',
        'end_date': '2024-01-07',
        'status': 'draft',
        'agent': 'test-user-id',
        'total_cost': 1500.0,
        'created_at': '2024-01-01T00:00:00Z',
      },
      {
        'id': 2,
        'name': 'Test Itinerary 2',
        'client_name': 'Jane Smith',
        'start_date': '2024-02-01',
        'end_date': '2024-02-05',
        'status': 'confirmed',
        'agent': 'test-user-id',
        'total_cost': 2000.0,
        'created_at': '2024-01-02T00:00:00Z',
      }
    ];
    
    mockSuccessResponse(data);
  }

  /// Mock contacts data
  static void mockContactsData({
    List<Map<String, dynamic>>? customData,
  }) {
    final data = customData ?? [
      {
        'id': 1,
        'name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'type': 'client',
        'created_at': '2024-01-01T00:00:00Z',
      },
      {
        'id': 2,
        'name': 'Jane',
        'last_name': 'Smith',
        'email': 'jane@example.com',
        'phone': '+0987654321',
        'type': 'provider',
        'created_at': '2024-01-02T00:00:00Z',
      }
    ];
    
    mockSuccessResponse(data);
  }

  /// Mock hotels data
  static void mockHotelsData({
    List<Map<String, dynamic>>? customData,
  }) {
    final data = customData ?? [
      {
        'id': 1,
        'name': 'Hotel Paradise',
        'location': 'Paris',
        'rating': 4.5,
        'price_per_night': 150.0,
        'description': 'Luxury hotel in the heart of Paris',
        'created_at': '2024-01-01T00:00:00Z',
      },
      {
        'id': 2,
        'name': 'City Hotel',
        'location': 'London',
        'rating': 4.0,
        'price_per_night': 120.0,
        'description': 'Modern hotel near city center',
        'created_at': '2024-01-02T00:00:00Z',
      }
    ];
    
    mockSuccessResponse(data);
  }

  /// Mock activities data
  static void mockActivitiesData({
    List<Map<String, dynamic>>? customData,
  }) {
    final data = customData ?? [
      {
        'id': 1,
        'name': 'City Tour',
        'location': 'Paris',
        'duration': '4 hours',
        'price': 50.0,
        'description': 'Guided tour of the city',
        'created_at': '2024-01-01T00:00:00Z',
      },
      {
        'id': 2,
        'name': 'Cooking Class',
        'location': 'Rome',
        'duration': '3 hours',
        'price': 75.0,
        'description': 'Learn to cook Italian cuisine',
        'created_at': '2024-01-02T00:00:00Z',
      }
    ];
    
    mockSuccessResponse(data);
  }

  /// Mock transfers data
  static void mockTransfersData({
    List<Map<String, dynamic>>? customData,
  }) {
    final data = customData ?? [
      {
        'id': 1,
        'name': 'Airport Transfer',
        'vehicle_type': 'Sedan',
        'max_passengers': 4,
        'price': 30.0,
        'description': 'Transfer from/to airport',
        'created_at': '2024-01-01T00:00:00Z',
      },
      {
        'id': 2,
        'name': 'City Transfer',
        'vehicle_type': 'Van',
        'max_passengers': 8,
        'price': 45.0,
        'description': 'City to city transfer',
        'created_at': '2024-01-02T00:00:00Z',
      }
    ];
    
    mockSuccessResponse(data);
  }

  /// Mock user roles data
  static void mockUserRolesData({
    List<Map<String, dynamic>>? customData,
  }) {
    final data = customData ?? [
      {
        'id': 1,
        'user_id': 'test-user-id',
        'role_id': 2,
        'role_name': 'admin',
        'role_description': 'Administrator',
        'role_names': 'admin',
        'is_active': true,
        'created_at': '2024-01-01T00:00:00Z',
      }
    ];
    
    mockSuccessResponse(data);
  }

  /// Mock user data
  static void mockUserData({
    Map<String, dynamic>? customData,
  }) {
    final data = [
      customData ?? {
        'id': 'test-user-id',
        'name': 'Test',
        'last_name': 'User',
        'email': 'test@example.com',
        'photo_url': null,
        'created_at': '2024-01-01T00:00:00Z',
        'user_roles_view': [
          {
            'role_name': 'admin',
            'role_names': 'admin',
            'is_active': true,
          }
        ],
      }
    ];
    
    mockSuccessResponse(data);
  }

  /// Mock authentication state
  static void mockAuthenticatedUser({
    String userId = 'test-user-id',
    String email = 'test@example.com',
  }) {
    when(mockUser.id).thenReturn(userId);
    when(mockUser.email).thenReturn(email);
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockAuth.currentSession).thenReturn(mockSession);
  }

  /// Mock unauthenticated state
  static void mockUnauthenticatedUser() {
    when(mockAuth.currentUser).thenReturn(null);
    when(mockAuth.currentSession).thenReturn(null);
  }

  /// Mock sign in success
  static void mockSignInSuccess({
    String userId = 'test-user-id',
    String email = 'test@example.com',
  }) {
    final authResponse = AuthResponse(
      user: mockUser,
      session: mockSession,
    );
    
    when(mockUser.id).thenReturn(userId);
    when(mockUser.email).thenReturn(email);
    
    when(mockAuth.signInWithPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => authResponse);
  }

  /// Mock sign in failure
  static void mockSignInFailure(String message) {
    when(mockAuth.signInWithPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(AuthException(message));
  }

  /// Mock sign out
  static void mockSignOut() {
    when(mockAuth.signOut()).thenAnswer((_) async {});
  }

  /// Mock create operation
  static void mockCreateSuccess(Map<String, dynamic> createdItem) {
    final response = PostgrestResponse(
      data: [createdItem],
      count: 1,
    );
    
    when(mockBuilder).thenAnswer((_) async => response);
  }

  /// Mock update operation
  static void mockUpdateSuccess(Map<String, dynamic> updatedItem) {
    final response = PostgrestResponse(
      data: [updatedItem],
      count: 1,
    );
    
    when(mockFilterBuilder).thenAnswer((_) async => response);
  }

  /// Mock delete operation
  static void mockDeleteSuccess() {
    final response = PostgrestResponse(
      data: [],
      count: 0,
    );
    
    when(mockFilterBuilder).thenAnswer((_) async => response);
  }

  /// Mock specific table queries
  static void mockTableQuery(
    String tableName,
    List<Map<String, dynamic>> data,
  ) {
    final queryBuilder = MockPostgrestQueryBuilder();
    final filterBuilder = MockPostgrestFilterBuilder();
    
    when(mockClient.from(tableName)).thenReturn(queryBuilder);
    when(queryBuilder.select(any)).thenReturn(filterBuilder);
    
    final response = PostgrestResponse(
      data: data,
      count: data.length,
    );
    
    when(filterBuilder).thenAnswer((_) async => response);
  }

  /// Clean up mocks
  static void tearDown() {
    reset(mockClient);
    reset(mockPostgrest);
    reset(mockQueryBuilder);
    reset(mockFilterBuilder);
    reset(mockBuilder);
    reset(mockAuth);
    reset(mockUser);
    reset(mockSession);
  }
}

/// Extension to help with common mock scenarios
extension SupabaseMockHelpers on MockSupabaseClient {
  /// Mock a simple select query
  void mockSelect(String table, List<Map<String, dynamic>> data) {
    SupabaseMocks.mockTableQuery(table, data);
  }

  /// Mock an insert operation
  void mockInsert(String table, Map<String, dynamic> item) {
    final queryBuilder = MockPostgrestQueryBuilder();
    final builder = MockPostgrestBuilder();
    
    when(this.from(table)).thenReturn(queryBuilder);
    when(queryBuilder.insert(any)).thenReturn(builder);
    
    SupabaseMocks.mockCreateSuccess(item);
  }

  /// Mock an update operation
  void mockUpdate(String table, Map<String, dynamic> item) {
    final queryBuilder = MockPostgrestQueryBuilder();
    final filterBuilder = MockPostgrestFilterBuilder();
    
    when(this.from(table)).thenReturn(queryBuilder);
    when(queryBuilder.update(any)).thenReturn(filterBuilder);
    
    SupabaseMocks.mockUpdateSuccess(item);
  }

  /// Mock a delete operation
  void mockDelete(String table) {
    final queryBuilder = MockPostgrestQueryBuilder();
    final filterBuilder = MockPostgrestFilterBuilder();
    
    when(this.from(table)).thenReturn(queryBuilder);
    when(queryBuilder.delete()).thenReturn(filterBuilder);
    
    SupabaseMocks.mockDeleteSuccess();
  }
}