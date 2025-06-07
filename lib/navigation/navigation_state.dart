import 'package:flutter/foundation.dart';

/// Navigation state management for tracking current route and parameters
class NavigationState extends ChangeNotifier {
  static final NavigationState _instance = NavigationState._internal();
  factory NavigationState() => _instance;
  NavigationState._internal();

  String _currentPath = '/';
  Map<String, String> _pathParameters = {};
  Map<String, String> _queryParameters = {};
  String? _previousPath;
  List<String> _navigationHistory = ['/'];

  /// Current route path
  String get currentPath => _currentPath;

  /// Current path parameters
  Map<String, String> get pathParameters => Map.unmodifiable(_pathParameters);

  /// Current query parameters
  Map<String, String> get queryParameters => Map.unmodifiable(_queryParameters);

  /// Previous route path
  String? get previousPath => _previousPath;

  /// Navigation history (last 10 routes)
  List<String> get navigationHistory => List.unmodifiable(_navigationHistory);

  /// Update current route information
  void updateCurrentRoute(
    String path,
    Map<String, String> pathParams,
    Map<String, String> queryParams,
  ) {
    _previousPath = _currentPath;
    _currentPath = path;
    _pathParameters = Map.from(pathParams);
    _queryParameters = Map.from(queryParams);

    // Update navigation history (keep last 10)
    _navigationHistory.add(path);
    if (_navigationHistory.length > 10) {
      _navigationHistory.removeAt(0);
    }

    notifyListeners();
  }

  /// Check if current route matches a pattern
  bool isCurrentRoute(String routePattern) {
    return _currentPath == routePattern;
  }

  /// Check if current route starts with a prefix
  bool isCurrentRoutePrefix(String prefix) {
    return _currentPath.startsWith(prefix);
  }

  /// Get path parameter by key
  String? getPathParameter(String key) {
    return _pathParameters[key];
  }

  /// Get query parameter by key
  String? getQueryParameter(String key) {
    return _queryParameters[key];
  }

  /// Check if user can go back
  bool get canGoBack => _navigationHistory.length > 1;

  /// Get the previous route from history
  String? getPreviousRoute() {
    if (_navigationHistory.length < 2) return null;
    return _navigationHistory[_navigationHistory.length - 2];
  }

  /// Clear navigation history
  void clearHistory() {
    _navigationHistory.clear();
    _navigationHistory.add(_currentPath);
    notifyListeners();
  }

  /// Check if we're in a specific section
  bool get isInItinerariesSection =>
      _currentPath.startsWith('/mainItineraries') ||
      _currentPath.startsWith('/itineraries/');

  bool get isInProductsSection =>
      _currentPath.startsWith('/mainProducts') ||
      _currentPath.startsWith('/products/');

  bool get isInContactsSection => _currentPath.startsWith('/mainContacts');

  bool get isInProfileSection =>
      _currentPath.startsWith('/mainProfilePage') ||
      _currentPath.startsWith('/profile/');

  bool get isInDashboardSection =>
      _currentPath == '/mainHome' || _currentPath.startsWith('/reporte');

  bool get isInAdminSection => _currentPath.startsWith('/admin/');

  /// Get current section name for navigation highlights
  String get currentSection {
    if (isInDashboardSection) return 'dashboard';
    if (isInItinerariesSection) return 'itineraries';
    if (isInProductsSection) return 'products';
    if (isInContactsSection) return 'contacts';
    if (isInProfileSection) return 'profile';
    if (isInAdminSection) return 'admin';
    return 'other';
  }

  /// Check if current route requires authentication
  bool get requiresAuth {
    const publicRoutes = [
      '/authLogin',
      '/authCreate',
      '/forgotPassword',
      '/authResetPassword',
      '/',
    ];

    // Check for preview routes (public)
    if (_currentPath.startsWith('/preview/')) {
      return false;
    }

    return !publicRoutes.contains(_currentPath);
  }

  /// Check if current route is an auth route
  bool get isAuthRoute {
    const authRoutes = [
      '/authLogin',
      '/authCreate',
      '/forgotPassword',
      '/authResetPassword',
    ];

    return authRoutes.contains(_currentPath);
  }

  /// Debug information
  Map<String, dynamic> get debugInfo => {
        'currentPath': _currentPath,
        'previousPath': _previousPath,
        'pathParameters': _pathParameters,
        'queryParameters': _queryParameters,
        'navigationHistory': _navigationHistory,
        'currentSection': currentSection,
        'requiresAuth': requiresAuth,
        'isAuthRoute': isAuthRoute,
      };

  @override
  String toString() {
    return 'NavigationState(currentPath: $_currentPath, section: $currentSection)';
  }
}
