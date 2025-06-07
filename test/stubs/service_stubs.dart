// Test stubs for services that need mocking
import 'package:flutter/foundation.dart';

// Stub for UserService
abstract class UserService extends ChangeNotifier {
  bool get hasLoadedData;
  Map<String, dynamic> get agentInfo;
  Map<String, dynamic> get contactInfo;
  bool get isAdmin;
  bool get isSuperAdmin;
  
  Future<bool> initializeUserData();
  Future<void> refreshUserData();
  void clearData();
  dynamic getAgentInfo(String path);
  dynamic getContactInfo(String path);
}

// Stub for ItineraryService  
abstract class ItineraryService extends ChangeNotifier {
  List<dynamic> get itineraries;
  bool get isLoading;
  String? get error;
  bool get hasData;
  bool get hasValidCache;
  DateTime? get lastFetch;
  
  Future<void> loadItineraries({bool forceRefresh = false});
  Future<int?> createItinerary({
    required String name,
    String? clientName,
    String? startDate,
    String? endDate,
    String? agent,
  });
  Future<void> updateItinerary({required int id, required Map<String, dynamic> updates});
  Future<void> deleteItinerary(int id);
  dynamic getItinerary(int id);
  List<dynamic> getItinerariesByClient(String clientName);
  List<dynamic> searchItineraries(String query);
  List<dynamic> getItinerariesByStatus(String status);
  Map<String, dynamic> getStatistics();
  void clearCache();
}

// Stub for ProductService
abstract class ProductService extends ChangeNotifier {
  List<dynamic> get hotels;
  List<dynamic> get activities;
  List<dynamic> get transfers;
  bool get isLoading;
  String? get error;
  bool get hasData;
  bool get hasValidCache;
  DateTime? get lastFetch;
  
  Future<void> loadAllProducts({bool forceRefresh = false});
  dynamic getHotel(int id);
  dynamic getActivity(int id);
  dynamic getTransfer(int id);
  List<dynamic> getHotelsByLocation(String location);
  List<dynamic> getActivitiesByLocation(String location);
  List<dynamic> getTransfersByVehicleType(String vehicleType);
  List<dynamic> searchHotels(String query);
  List<dynamic> searchActivities(String query);
  Map<String, List<dynamic>> searchAllProducts(String query);
  Future<int?> createHotel(Map<String, dynamic> data);
  Future<void> updateHotel({required int id, required Map<String, dynamic> updates});
  Future<void> deleteHotel(int id);
  Map<String, dynamic> getStatistics();
  void clearCache();
}

// Stub for ContactService
abstract class ContactService extends ChangeNotifier {
  List<dynamic> get contacts;
  bool get isLoading;
  String? get error;
  bool get hasData;
  bool get hasValidCache;
  DateTime? get lastFetch;
  
  Future<void> loadContacts({bool forceRefresh = false});
  dynamic getContact(int id);
  String getContactFullName(int id);
  List<dynamic> getContactsByType(String type);
  List<dynamic> getClients();
  List<dynamic> getProviders();
  List<dynamic> searchContacts(String query);
  List<dynamic> getRecentContacts({int days = 7});
  Map<String, List<dynamic>> getContactsGroupedByType();
  Map<String, List<dynamic>> getContactsGroupedByLetter();
  Future<int?> createContact(Map<String, dynamic> data);
  Future<void> updateContact({required int id, required Map<String, dynamic> updates});
  Future<void> deleteContact(int id);
  bool isValidEmail(String email);
  bool isValidPhone(String phone);
  bool validateContact(Map<String, dynamic> data);
  Map<String, dynamic> getStatistics();
  void clearCache();
}

// Stub for AuthorizationService
enum String { guest, agent, admin, superAdmin }

class UserRole {
  final int id;
  final String name;
  final String type;
  final List<String> permissions;
  final bool isActive;

  UserRole({
    required this.id,
    required this.name,
    required this.type,
    required this.permissions,
    this.isActive = true,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['role_id'] ?? json['id'] ?? 0,
      name: json['role_name'] ?? json['name'] ?? '',
      type: _parseString(json['role_name'] ?? json['name'] ?? ''),
      permissions: _parsePermissions(json['role_names'] ?? ''),
      isActive: json['is_active'] ?? true,
    );
  }

  static String _parseString(String roleName) {
    switch (roleName.toLowerCase()) {
      case 'super_admin':
      case 'superadmin':
        return 'super_admin';
      case 'admin':
        return 'admin';
      case 'agent':
        return 'agent';
      default:
        return String.guest;
    }
  }

  static List<String> _parsePermissions(String roleNames) {
    final List<String> permissions = [];
    final roles = roleNames.split(',');
    
    for (final role in roles) {
      switch (role.trim().toLowerCase()) {
        case 'super_admin':
        case 'superadmin':
          permissions.addAll([
            'itinerary:*', 'contact:*', 'product:*', 
            'user:*', 'payment:*', 'report:*'
          ]);
          break;
        case 'admin':
          permissions.addAll([
            'itinerary:create', 'itinerary:read', 'itinerary:update', 'itinerary:delete',
            'contact:create', 'contact:read', 'contact:update', 'contact:delete',
            'product:create', 'product:read', 'product:update', 'product:delete',
            'user:read', 'user:update',
            'payment:create', 'payment:read', 'payment:update',
            'report:read', 'report:export'
          ]);
          break;
        case 'agent':
          permissions.addAll([
            'itinerary:create', 'itinerary:read', 'itinerary:update',
            'contact:create', 'contact:read', 'contact:update',
            'product:read', 'user:read', 'payment:read', 'report:read'
          ]);
          break;
      }
    }
    
    return permissions.toSet().toList();
  }
}

abstract class AuthorizationService extends ChangeNotifier {
  List<UserRole> get userRoles;
  Set<String> get userPermissions;
  bool get hasLoadedRoles;
  bool get isAdmin;
  bool get isSuperAdmin;
  int get roleLevel;
  
  Future<bool> loadUserRoles(String userId);
  Future<bool> authorize({
    required String userId,
    List<String>? requiredRoles,
    List<String>? requiredPermissions,
    String? resourceType,
    String? action,
    String? ownerId,
  });
  bool hasRole(String role);
  bool hasAnyRole(List<String> roles);
  bool hasAllRoles(List<String> roles);
  bool hasPermission(String permission);
  bool hasAnyPermission(List<String> permissions);
  bool hasAllPermissions(List<String> permissions);
  bool canAccessResource(String resourceType, String action, {String? ownerId, String? currentUserId});
  void clearRoles();
}

// Stub for ErrorService
enum ErrorType { 
  unknown, network, authentication, validation, 
  business, api, permission, timeout 
}

enum ErrorSeverity { low, medium, high }

class AppError {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final ErrorType type;
  final ErrorSeverity severity;
  final DateTime timestamp;
  final String? context;
  final Map<String, dynamic> metadata;

  AppError({
    required this.message,
    this.originalError,
    this.stackTrace,
    required this.type,
    required this.severity,
    required this.timestamp,
    this.context,
    this.metadata = const {},
  });
}

class ErrorAction {
  final String label;
  final VoidCallback onPressed;
  final String? icon;

  ErrorAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });
}

abstract class ErrorService extends ChangeNotifier {
  AppError? get currentError;
  bool get hasError;
  List<AppError> get errorHistory;
  
  void handleError(dynamic error, {
    ErrorType? type,
    ErrorSeverity? severity,
    String? context,
    Map<String, dynamic>? metadata,
  });
  void handleApiError(String message, {
    String? endpoint,
    int? statusCode,
    String? method,
    dynamic requestData,
  });
  void handleValidationError(String message, {
    String? field,
    dynamic value,
  });
  void handleBusinessError(String message, {
    String? operation,
    Map<String, dynamic>? context,
  });
  void clearError();
  void clearAllErrors();
  String getUserMessage(AppError error);
  List<ErrorAction> getSuggestedActions(AppError error);
  void setErrorCallback(Function(AppError) callback);
}