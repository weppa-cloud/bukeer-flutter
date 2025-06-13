import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bukeer/bukeer/users/auth/login/auth_login_widget.dart';
import 'package:bukeer/bukeer/dashboard/main_home/main_home_widget.dart';
import 'package:bukeer/bukeer/itineraries/main_itineraries/main_itineraries_widget.dart';
import 'package:bukeer/bukeer/contacts/main_contacts/main_contacts_widget.dart';
import 'package:bukeer/bukeer/products/main_products/main_products_widget.dart';
import 'package:bukeer/bukeer/agenda/main_agenda/main_agenda_widget.dart';
import 'package:bukeer/bukeer/users/main_users/main_users_widget.dart';
import 'package:bukeer/bukeer/users/profile/main_page/main_profile_page_widget.dart';
import 'package:bukeer/bukeer/users/profile/main_account/main_profile_account_widget.dart';
import 'package:bukeer/bukeer/itineraries/itinerary_details/itinerary_details_widget.dart';
import 'package:bukeer/legacy/flutter_flow/nav/nav.dart';
import 'app_shell.dart';

/// Extension to add ShellRoute support to existing router
extension BukeerRouterExtension on GoRouter {
  /// Creates slide transition for page navigation
  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  /// Creates a new router with shell route for main navigation
  static GoRouter createWithShell(AppStateNotifier appStateNotifier) {
    return GoRouter(
      initialLocation: '/mainHome',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? MainHomeWidget() : AuthLoginWidget(),
      routes: [
        // Auth routes (outside shell)
        GoRoute(
          path: '/authLogin',
          name: 'authLogin',
          builder: (context, state) => AuthLoginWidget(),
        ),

        // Main shell route for navigation
        ShellRoute(
          navigatorKey: GlobalKey<NavigatorState>(),
          builder: (context, state, child) => AppShell(
            child: child,
            state: state,
          ),
          routes: [
            GoRoute(
              path: '/mainHome',
              name: MainHomeWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainHomeWidget(),
                transitionsBuilder: _slideTransition,
              ),
            ),
            GoRoute(
              path: '/mainItineraries',
              name: MainItinerariesWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainItinerariesWidget(),
                transitionsBuilder: _slideTransition,
              ),
              routes: [
                GoRoute(
                  path: 'details/:id',
                  name: ItineraryDetailsWidget.routeName,
                  builder: (context, state) => ItineraryDetailsWidget(
                    id: state.pathParameters['id'],
                    allDateHotel: state.extra,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/mainContacts',
              name: MainContactsWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainContactsWidget(),
                transitionsBuilder: _slideTransition,
              ),
            ),
            GoRoute(
              path: '/mainProducts',
              name: MainProductsWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainProductsWidget(),
                transitionsBuilder: _slideTransition,
              ),
            ),
            GoRoute(
              path: '/mainAgenda',
              name: MainAgendaWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainAgendaWidget(),
                transitionsBuilder: _slideTransition,
              ),
            ),
            GoRoute(
              path: '/mainUsers',
              name: MainUsersWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainUsersWidget(),
                transitionsBuilder: _slideTransition,
              ),
            ),
            GoRoute(
              path: '/mainProfilePage',
              name: MainProfilePageWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainProfilePageWidget(),
                transitionsBuilder: _slideTransition,
              ),
            ),
            GoRoute(
              path: '/mainProfileAccount',
              name: MainProfileAccountWidget.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainProfileAccountWidget(),
                transitionsBuilder: _slideTransition,
              ),
            ),
          ],
        ),

        // Redirect from root to mainHome
        GoRoute(
          path: '/',
          redirect: (context, state) =>
              appStateNotifier.loggedIn ? '/mainHome' : '/authLogin',
        ),
      ],
      redirect: (context, state) {
        final loggedIn = appStateNotifier.loggedIn;
        final loggingIn = state.matchedLocation == '/authLogin';

        if (!loggedIn && !loggingIn) {
          return '/authLogin';
        }

        if (loggedIn && loggingIn) {
          return '/mainHome';
        }

        return null;
      },
    );
  }
}
