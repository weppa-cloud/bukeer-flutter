/// API endpoint constants for the Bukeer application
/// All API endpoints should be defined here to avoid hardcoding URLs
///
/// Usage:
/// ```dart
/// import 'package:bukeer/bukeer/core/constants/api_endpoints.dart';
///
/// final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.contacts}';
/// ```

class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  // Base URLs (these should come from AppConfig)
  static const String supabaseUrl = 'https://wzlxbpicdcdvxvdcvgas.supabase.co';
  static const String apiVersion = '/rest/v1';
  static const String baseUrl = '$supabaseUrl$apiVersion';

  // Auth endpoints
  static const String auth = '/auth/v1';
  static const String signIn = '$auth/token?grant_type=password';
  static const String signUp = '$auth/signup';
  static const String signOut = '$auth/logout';
  static const String resetPassword = '$auth/recover';
  static const String updatePassword = '$auth/user';
  static const String refreshToken = '$auth/token?grant_type=refresh_token';

  // Database tables endpoints
  static const String accounts = '/accounts';
  static const String activities = '/activities';
  static const String activitiesRates = '/activities_rates';
  static const String activitiesView = '/activities_view';
  static const String airlines = '/airlines';
  static const String airports = '/airports';
  static const String airportsView = '/airports_view';
  static const String contacts = '/contacts';
  static const String flights = '/flights';
  static const String hotelRates = '/hotel_rates';
  static const String hotels = '/hotels';
  static const String hotelsView = '/hotels_view';
  static const String images = '/images';
  static const String itineraries = '/itineraries';
  static const String itineraryItems = '/itinerary_items';
  static const String locations = '/locations';
  static const String nationalities = '/nationalities';
  static const String notes = '/notes';
  static const String passengers = '/passenger';
  static const String pointsOfInterest = '/points_of_interest';
  static const String regions = '/regions';
  static const String roles = '/roles';
  static const String transactions = '/transactions';
  static const String transferRates = '/transfer_rates';
  static const String transfers = '/transfers';
  static const String transfersView = '/transfers_view';
  static const String userContactInfo = '/user_contact_info';
  static const String userContactInfoAdmin = '/user_contact_info_admin';
  static const String userRoles = '/user_roles';
  static const String userRolesView = '/user_roles_view';

  // RPC function endpoints
  static const String rpc = '/rpc';
  static const String functionGetContactsSearch =
      '$rpc/function_get_contacts_search';
  static const String functionGetItinerariesSearch =
      '$rpc/function_get_itineraries_search';
  static const String functionGetProductsSearch =
      '$rpc/function_get_products_search';
  static const String functionGetUsersSearch = '$rpc/function_get_users_search';
  static const String functionCalculateTotals =
      '$rpc/function_calculate_totals';
  static const String functionGetDashboardStats =
      '$rpc/function_get_dashboard_stats';

  // Storage endpoints
  static const String storage = '/storage/v1';
  static const String storageBuckets = '$storage/buckets';
  static const String storageObjects = '$storage/object';

  // Storage buckets
  static const String bucketImages = 'images';
  static const String bucketDocuments = 'documents';
  static const String bucketProfiles = 'profiles';
  static const String bucketProducts = 'products';

  // External APIs
  static const String googleMapsApi = 'https://maps.googleapis.com/maps/api';
  static const String googlePlacesApi = '$googleMapsApi/place';
  static const String googleGeocodingApi = '$googleMapsApi/geocode';

  // PDF generation endpoints
  static const String pdfGenerator = '/functions/v1/pdf-generator';
  static const String pdfItinerary = '$pdfGenerator/itinerary';
  static const String pdfVoucher = '$pdfGenerator/voucher';
  static const String pdfInvoice = '$pdfGenerator/invoice';
}

/// API query parameters
class ApiParams {
  ApiParams._();

  // Common query parameters
  static const String select = 'select';
  static const String order = 'order';
  static const String limit = 'limit';
  static const String offset = 'offset';
  static const String or = 'or';
  static const String and = 'and';

  // Filter operators
  static const String eq = 'eq';
  static const String neq = 'neq';
  static const String gt = 'gt';
  static const String gte = 'gte';
  static const String lt = 'lt';
  static const String lte = 'lte';
  static const String like = 'like';
  static const String ilike = 'ilike';
  static const String in$ = 'in';
  static const String is$ = 'is';
  static const String not = 'not';

  // Special parameters
  static const String returning = 'returning';
  static const String onConflict = 'on_conflict';
  static const String ignoreDuplicates = 'ignoreDuplicates';
  static const String count = 'count';
  static const String preferCount = 'Prefer';
}

/// API headers
class ApiHeaders {
  ApiHeaders._();

  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String apiKey = 'apikey';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String preferReturn = 'Prefer';

  // Content types
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String textPlain = 'text/plain';

  // Prefer header values
  static const String returnMinimal = 'return=minimal';
  static const String returnRepresentation = 'return=representation';
  static const String countExact = 'count=exact';
  static const String countPlanned = 'count=planned';
  static const String countEstimated = 'count=estimated';
}

/// API response codes
class ApiResponseCodes {
  ApiResponseCodes._();

  // Success codes
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // Client error codes
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  // Server error codes
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}
