/// Route constants for the Bukeer application
/// These constants are used throughout the application for navigation
///
/// Usage:
/// ```dart
/// import 'package:bukeer/bukeer/core/constants/routes.dart';
///
/// // Navigate to a route
/// context.pushNamed(RouteNames.home);
///
/// // Use route path
/// context.go(RoutePaths.login);
/// ```

class RoutePaths {
  // Prevent instantiation
  RoutePaths._();

  // Auth routes
  static const String splash = '/';
  static const String login = '/authLogin';
  static const String register = '/authCreate';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/authResetPassword';

  // Dashboard/Home routes
  static const String home = '/mainHome';
  static const String reportSales = '/reporteVentas';
  static const String reportPayable = '/reporteCuentasPorPagar';
  static const String reportReceivable = '/reporteCuentasPorCobrar';

  // Itinerary routes
  static const String itineraries = '/mainItineraries';
  static const String itineraryDetails = '/itineraries/details/:id';
  static const String agenda = '/mainAgenda';

  // Product routes
  static const String products = '/mainProducts';
  static const String editRate = '/products/rate/:id';
  static const String booking = '/products/booking';
  static const String paymentMethods = '/editPaymentMethods';

  // Contact routes
  static const String contacts = '/mainContacts';

  // User/Profile routes
  static const String profile = '/mainProfilePage';
  static const String editProfile = '/profile/edit';
  static const String editPersonalProfile = '/profile/personal';
  static const String profileAccount = '/profile/account';
  static const String users = '/mainUsers';

  // Admin routes
  static const String adminDashboard = '/admin/dashboard';

  // Public routes
  static const String previewItinerary = '/preview/:id';
}

class RouteNames {
  // Prevent instantiation
  RouteNames._();

  // Auth routes
  static const String splash = 'splash';
  static const String login = 'authLogin';
  static const String register = 'authCreate';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'authResetPassword';

  // Dashboard/Home routes
  static const String home = 'mainHome';
  static const String reportSales = 'reporteVentas';
  static const String reportPayable = 'reporteCuentasPorPagar';
  static const String reportReceivable = 'reporteCuentasPorCobrar';

  // Itinerary routes
  static const String itineraries = 'mainItineraries';
  static const String itineraryDetails = 'itineraryDetails';
  static const String addHotel = 'addHotel';
  static const String addActivity = 'addActivity';
  static const String addFlight = 'addFlight';
  static const String addTransfer = 'addTransfer';
  static const String addPassengers = 'addPassengers';
  static const String agenda = 'mainAgenda';

  // Product routes
  static const String products = 'mainProducts';
  static const String editRate = 'editRate';
  static const String booking = 'booking';
  static const String paymentMethods = 'editPaymentMethods';

  // Contact routes
  static const String contacts = 'mainContacts';

  // User/Profile routes
  static const String profile = 'mainProfilePage';
  static const String editProfile = 'editProfile';
  static const String editPersonalProfile = 'editPersonalProfile';
  static const String profileAccount = 'profileAccount';
  static const String users = 'mainUsers';

  // Admin routes
  static const String adminDashboard = 'adminDashboard';

  // Public routes
  static const String previewItinerary = 'previewItinerary';
}

/// Service type constants for itinerary services
class ServiceTypes {
  ServiceTypes._();

  static const String hotel = 'hotel';
  static const String activity = 'activity';
  static const String flight = 'flight';
  static const String transfer = 'transfer';
  static const String passengers = 'passengers';
}

/// Route parameter names
class RouteParams {
  RouteParams._();

  static const String id = 'id';
  static const String itineraryId = 'itineraryId';
  static const String productId = 'productId';
  static const String rateId = 'rateId';
  static const String type = 'type';
  static const String action = 'action';
  static const String name = 'name';
  static const String cost = 'cost';
  static const String profit = 'profit';
  static const String total = 'total';
}

/// Query parameter names
class QueryParams {
  QueryParams._();

  static const String search = 'search';
  static const String filter = 'filter';
  static const String page = 'page';
  static const String pageSize = 'pageSize';
  static const String sortBy = 'sortBy';
  static const String sortOrder = 'sortOrder';
  static const String status = 'status';
  static const String dateFrom = 'dateFrom';
  static const String dateTo = 'dateTo';
}
