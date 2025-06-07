/// Route definitions for the Bukeer application
/// Centralized constants for all route paths and names
class AppRoutes {
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

/// Navigation helper class for type-safe navigation
class NavigationHelper {
  /// Navigate to itinerary details with ID
  static String itineraryDetailsPath(String id) => '/itineraries/details/$id';

  /// Navigate to edit rate with product ID and optional parameters
  static String editRatePath(
    String productId, {
    String? rateId,
    String? type,
    String? action,
    String? name,
    String? cost,
    String? profit,
    String? total,
  }) {
    var path = '/products/rate/$productId';
    final queryParams = <String, String>{};

    if (rateId != null) queryParams['rateId'] = rateId;
    if (type != null) queryParams['type'] = type;
    if (action != null) queryParams['action'] = action;
    if (name != null) queryParams['name'] = name;
    if (cost != null) queryParams['cost'] = cost;
    if (profit != null) queryParams['profit'] = profit;
    if (total != null) queryParams['total'] = total;

    if (queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      path += '?$query';
    }

    return path;
  }

  /// Navigate to payment methods with optional name
  static String paymentMethodsPath({String? name}) {
    var path = '/editPaymentMethods';
    if (name != null) {
      path += '?name=${Uri.encodeComponent(name)}';
    }
    return path;
  }

  /// Navigate to preview itinerary with ID
  static String previewItineraryPath(String id) => '/preview/$id';

  /// Get path for itinerary service action
  static String itineraryServicePath(String itineraryId, String service) {
    switch (service) {
      case 'hotel':
        return '/itineraries/details/$itineraryId/add-hotel';
      case 'activity':
        return '/itineraries/details/$itineraryId/add-activity';
      case 'flight':
        return '/itineraries/details/$itineraryId/add-flight';
      case 'transfer':
        return '/itineraries/details/$itineraryId/add-transfer';
      case 'passengers':
        return '/itineraries/details/$itineraryId/passengers';
      default:
        return '/itineraries/details/$itineraryId';
    }
  }
}
