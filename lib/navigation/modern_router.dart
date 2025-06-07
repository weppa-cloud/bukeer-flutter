import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/error_service.dart';
import '../components/error_aware_app.dart';
import '../components/error_feedback_system.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/nav/nav.dart';
import 'route_definitions.dart';
import 'navigation_state.dart';
import 'guards/auth_guard.dart';
import 'guards/permission_guard.dart';

// Import existing widgets
import '../bukeer/users/auth_login/auth_login_widget.dart';
import '../bukeer/users/auth_create/auth_create_widget.dart';
import '../bukeer/users/forgot_password/forgot_password_widget.dart';
import '../bukeer/users/auth_reset_password/auth_reset_password_widget.dart';
import '../bukeer/dashboard/main_home/main_home_widget.dart';
import '../bukeer/dashboard/reporte_ventas/reporte_ventas_widget.dart';
import '../bukeer/dashboard/reporte_cuentas_por_pagar/reporte_cuentas_por_pagar_widget.dart';
import '../bukeer/dashboard/reporte_cuentas_por_cobrar/reporte_cuentas_por_cobrar_widget.dart';
import '../bukeer/itinerarios/main_itineraries/main_itineraries_widget.dart';
import '../bukeer/itinerarios/itinerary_details/itinerary_details_widget.dart';
import '../bukeer/itinerarios/servicios/add_hotel/add_hotel_widget.dart';
import '../bukeer/itinerarios/servicios/add_activities/add_activities_widget.dart';
import '../bukeer/itinerarios/servicios/add_flights/add_flights_widget.dart';
import '../bukeer/itinerarios/servicios/add_transfer/add_transfer_widget.dart';
import '../bukeer/itinerarios/add_passengers_itinerary/add_passengers_itinerary_widget.dart';
import '../bukeer/agenda/main_agenda/main_agenda_widget.dart';
import '../bukeer/productos/main_products/main_products_widget.dart';
import '../bukeer/productos/add_edit_tarifa/add_edit_tarifa_widget.dart';
import '../bukeer/productos/demo/booking/booking_widget.dart';
import '../bukeer/productos/edit_payment_methods/edit_payment_methods_widget.dart';
import '../bukeer/contactos/main_contacts/main_contacts_widget.dart';
import '../bukeer/users/main_profile_page/main_profile_page_widget.dart';
import '../bukeer/users/demo/edit_profile/edit_profile_widget.dart';
import '../bukeer/users/edit_personal_profile/edit_personal_profile_widget.dart';
import '../bukeer/users/main_profile_account/main_profile_account_widget.dart';
import '../bukeer/users/main_users/main_users_widget.dart';
import '../bukeer/itinerarios/preview/preview_itinerary_u_r_l/preview_itinerary_u_r_l_widget.dart';
import '../components/error_monitoring_dashboard.dart';
import '../main.dart';

/// Modern GoRouter implementation with type safety and enhanced features
class ModernRouter {
  static final ModernRouter _instance = ModernRouter._internal();
  factory ModernRouter() => _instance;
  ModernRouter._internal();

  static GoRouter? _router;
  static final NavigationState _navigationState = NavigationState();

  /// Get the configured router instance
  static GoRouter get router {
    _router ??= _createRouter();
    return _router!;
  }

  /// Navigation state for tracking current route and parameters
  static NavigationState get navigationState => _navigationState;

  static GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,

      // Refresh when auth state changes
      refreshListenable: AppStateNotifier.instance,

      // Error handling
      errorBuilder: (context, state) => _buildErrorPage(context, state),

      // Global redirect logic
      redirect: (context, state) => _handleGlobalRedirect(context, state),

      routes: [
        // Splash and initial route
        GoRoute(
          path: AppRoutes.splash,
          name: RouteNames.splash,
          builder: (context, state) => _buildSplashPage(context),
        ),

        // Authentication routes
        ..._buildAuthRoutes(),

        // Main app shell with bottom navigation
        ShellRoute(
          builder: (context, state, child) =>
              _buildAppShell(context, state, child),
          routes: [
            // Dashboard/Home routes
            ..._buildDashboardRoutes(),

            // Itinerary routes
            ..._buildItineraryRoutes(),

            // Product routes
            ..._buildProductRoutes(),

            // Contact routes
            ..._buildContactRoutes(),

            // User/Profile routes
            ..._buildUserRoutes(),
          ],
        ),

        // Public routes (no auth required)
        ..._buildPublicRoutes(),

        // Admin routes
        ShellRoute(
          builder: (context, state, child) =>
              _buildAdminShell(context, state, child),
          routes: _buildAdminRoutes(),
        ),
      ],
    );
  }

  // Route builders
  static List<GoRoute> _buildAuthRoutes() {
    return [
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => const AuthLoginWidget(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: RouteNames.register,
        builder: (context, state) => const AuthCreateWidget(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordWidget(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: RouteNames.resetPassword,
        builder: (context, state) => const AuthResetPasswordWidget(),
      ),
    ];
  }

  static List<GoRoute> _buildDashboardRoutes() {
    return [
      GoRoute(
        path: AppRoutes.home,
        name: RouteNames.home,
        builder: (context, state) => const MainHomeWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
      ),
      GoRoute(
        path: AppRoutes.reportSales,
        name: RouteNames.reportSales,
        builder: (context, state) => const ReporteVentasWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
      ),
      GoRoute(
        path: AppRoutes.reportPayable,
        name: RouteNames.reportPayable,
        builder: (context, state) => const ReporteCuentasPorPagarWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
      ),
      GoRoute(
        path: AppRoutes.reportReceivable,
        name: RouteNames.reportReceivable,
        builder: (context, state) => const ReporteCuentasPorCobrarWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
      ),
    ];
  }

  static List<GoRoute> _buildItineraryRoutes() {
    return [
      GoRoute(
        path: AppRoutes.itineraries,
        name: RouteNames.itineraries,
        builder: (context, state) => const MainItinerariesWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
        routes: [
          GoRoute(
            path: 'details/:id',
            name: RouteNames.itineraryDetails,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ItineraryDetailsWidget(id: id);
            },
            redirect: (context, state) => AuthGuard.check(context, state),
            routes: [
              GoRoute(
                path: 'add-hotel',
                name: RouteNames.addHotel,
                builder: (context, state) {
                  final itineraryId = state.pathParameters['id']!;
                  final isEdit = state.uri.queryParameters['edit'] == 'true';
                  return AddHotelWidget(
                    itineraryId: itineraryId,
                    isEdit: isEdit,
                  );
                },
              ),
              GoRoute(
                path: 'add-activity',
                name: RouteNames.addActivity,
                builder: (context, state) {
                  final itineraryId = state.pathParameters['id']!;
                  final isEdit = state.uri.queryParameters['edit'] == 'true';
                  return AddActivitiesWidget(
                    itineraryId: itineraryId,
                    isEdit: isEdit,
                  );
                },
              ),
              GoRoute(
                path: 'add-flight',
                name: RouteNames.addFlight,
                builder: (context, state) {
                  final itineraryId = state.pathParameters['id']!;
                  final isEdit = state.uri.queryParameters['edit'] == 'true';
                  return AddFlightsWidget(
                    itineraryId: itineraryId,
                    isEdit: isEdit,
                  );
                },
              ),
              GoRoute(
                path: 'add-transfer',
                name: RouteNames.addTransfer,
                builder: (context, state) {
                  final itineraryId = state.pathParameters['id']!;
                  final isEdit = state.uri.queryParameters['edit'] == 'true';
                  return AddTransferWidget(
                    itineraryId: itineraryId,
                    isEdit: isEdit,
                  );
                },
              ),
              GoRoute(
                path: 'passengers',
                name: RouteNames.addPassengers,
                builder: (context, state) {
                  final itineraryId = state.pathParameters['id']!;
                  final allDateHotel = state.extra as dynamic;
                  return AddPassengersItineraryWidget(
                    id: itineraryId,
                    allDateHotel: allDateHotel,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.agenda,
        name: RouteNames.agenda,
        builder: (context, state) => const MainAgendaWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
      ),
    ];
  }

  static List<GoRoute> _buildProductRoutes() {
    return [
      GoRoute(
        path: AppRoutes.products,
        name: RouteNames.products,
        builder: (context, state) => const MainProductsWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
        routes: [
          GoRoute(
            path: 'rate/:id',
            name: RouteNames.editRate,
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              final queryParams = state.uri.queryParameters;

              return AddEditTarifaWidget(
                idProduct: productId,
                id: queryParams['rateId'],
                typeProduct: queryParams['type'],
                typeAction: queryParams['action'],
                name: queryParams['name'],
                initialCost: double.tryParse(queryParams['cost'] ?? '0'),
                initialProfit: double.tryParse(queryParams['profit'] ?? '0'),
                initialTotal: double.tryParse(queryParams['total'] ?? '0'),
              );
            },
          ),
          GoRoute(
            path: 'booking',
            name: RouteNames.booking,
            builder: (context, state) => const BookingWidget(),
            redirect: (context, state) =>
                PermissionGuard.checkProducts(context, state),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.paymentMethods,
        name: RouteNames.paymentMethods,
        builder: (context, state) {
          final name = state.uri.queryParameters['name'];
          return EditPaymentMethodsWidget(name: name);
        },
        redirect: (context, state) => AuthGuard.check(context, state),
      ),
    ];
  }

  static List<GoRoute> _buildContactRoutes() {
    return [
      GoRoute(
        path: AppRoutes.contacts,
        name: RouteNames.contacts,
        builder: (context, state) => const MainContactsWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
      ),
    ];
  }

  static List<GoRoute> _buildUserRoutes() {
    return [
      GoRoute(
        path: AppRoutes.profile,
        name: RouteNames.profile,
        builder: (context, state) => const MainProfilePageWidget(),
        redirect: (context, state) => AuthGuard.check(context, state),
        routes: [
          GoRoute(
            path: 'edit',
            name: RouteNames.editProfile,
            builder: (context, state) => const EditProfileWidget(),
          ),
          GoRoute(
            path: 'personal',
            name: RouteNames.editPersonalProfile,
            builder: (context, state) => const EditPersonalProfileWidget(),
          ),
          GoRoute(
            path: 'account',
            name: RouteNames.profileAccount,
            builder: (context, state) => const MainProfileAccountWidget(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.users,
        name: RouteNames.users,
        builder: (context, state) => const MainUsersWidget(),
        redirect: (context, state) =>
            PermissionGuard.checkAdmin(context, state),
      ),
    ];
  }

  static List<GoRoute> _buildPublicRoutes() {
    return [
      GoRoute(
        path: '/preview/:id',
        name: RouteNames.previewItinerary,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PreviewItineraryURLWidget(id: id);
        },
      ),
    ];
  }

  static List<GoRoute> _buildAdminRoutes() {
    return [
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: RouteNames.adminDashboard,
        builder: (context, state) => const ErrorMonitoringDashboard(),
        redirect: (context, state) =>
            PermissionGuard.checkSuperAdmin(context, state),
      ),
    ];
  }

  // Shell builders
  static Widget _buildAppShell(
      BuildContext context, GoRouterState state, Widget child) {
    return ErrorAwareApp(
      child: NavBarPage(
        initialPage: _getPageNameFromRoute(state.uri.path),
        page: child,
      ),
    );
  }

  static Widget _buildAdminShell(
      BuildContext context, GoRouterState state, Widget child) {
    return ErrorAwareApp(
      child: AdminLayout(child: child),
    );
  }

  // Helper methods
  static String? _handleGlobalRedirect(
      BuildContext context, GoRouterState state) {
    final appState = AppStateNotifier.instance;

    // Handle app initialization
    if (appState.loading) {
      return AppRoutes.splash;
    }

    // Handle authentication redirects
    if (!appState.loggedIn && _requiresAuth(state.uri.path)) {
      return AppRoutes.login;
    }

    // Handle post-login redirects
    if (appState.shouldRedirect) {
      final redirectLocation = appState.getRedirectLocation();
      appState.clearRedirectLocation();
      return redirectLocation;
    }

    // Update navigation state
    _navigationState.updateCurrentRoute(
      state.uri.path,
      state.pathParameters,
      state.uri.queryParameters,
    );

    return null;
  }

  static bool _requiresAuth(String path) {
    final publicPaths = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
      AppRoutes.resetPassword,
      AppRoutes.splash,
    ];

    // Check if path starts with /preview (public itinerary views)
    if (path.startsWith('/preview/')) {
      return false;
    }

    return !publicPaths.contains(path);
  }

  static String _getPageNameFromRoute(String path) {
    final routeMap = {
      AppRoutes.home: 'Main_Home',
      AppRoutes.itineraries: 'main_itineraries',
      AppRoutes.products: 'main_products',
      AppRoutes.contacts: 'main_contacts',
      AppRoutes.profile: 'Main_profilePage',
    };

    return routeMap[path] ?? 'Main_Home';
  }

  static Widget _buildSplashPage(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo-Bukeer-02.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    final error = AppError(
      message: 'Página no encontrada: ${state.uri.path}',
      originalError: 'Navigation error',
      stackTrace: StackTrace.current,
      severity: ErrorSeverity.medium,
      type: ErrorType.navigation,
      timestamp: DateTime.now(),
      metadata: {
        'path': state.uri.path,
        'query_parameters': state.uri.queryParameters,
      },
    );

    return ErrorFeedbackSystem.buildErrorPage(
      error,
      onRetry: () => context.go(AppRoutes.home),
      onGoHome: () => context.go(AppRoutes.home),
      showDetails: true,
    );
  }
}

/// Admin layout wrapper
class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administración'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
      body: child,
    );
  }
}
