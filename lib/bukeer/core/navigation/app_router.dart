import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bukeer/bukeer/core/navigation/app_shell.dart';
import 'package:bukeer/bukeer/dashboard/main_home/main_home_widget.dart';
import 'package:bukeer/bukeer/itineraries/main_itineraries/main_itineraries_widget.dart';
import 'package:bukeer/bukeer/contacts/main_contacts/main_contacts_widget.dart';
import 'package:bukeer/bukeer/products/main_products/main_products_widget.dart';
import 'package:bukeer/bukeer/agenda/main_agenda/main_agenda_widget.dart';
import 'package:bukeer/bukeer/users/main_users/main_users_widget.dart';
import 'package:bukeer/bukeer/users/profile/main_page/main_profile_page_widget.dart';
import 'package:bukeer/bukeer/users/profile/main_account/main_profile_account_widget.dart';

/// Creates a shell route configuration for main navigation pages
/// This keeps the navigation bar fixed while only animating page content
ShellRoute createMainShellRoute() {
  return ShellRoute(
    builder: (context, state, child) => AppShell(
      child: child,
      state: state,
    ),
    routes: [
      GoRoute(
        name: MainHomeWidget.routeName,
        path: '/${MainHomeWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainHomeWidget(),
        ),
      ),
      GoRoute(
        name: MainItinerariesWidget.routeName,
        path: '/${MainItinerariesWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainItinerariesWidget(),
        ),
      ),
      GoRoute(
        name: MainContactsWidget.routeName,
        path: '/${MainContactsWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainContactsWidget(),
        ),
      ),
      GoRoute(
        name: MainProductsWidget.routeName,
        path: '/${MainProductsWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainProductsWidget(),
        ),
      ),
      GoRoute(
        name: MainAgendaWidget.routeName,
        path: '/${MainAgendaWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainAgendaWidget(),
        ),
      ),
      GoRoute(
        name: MainUsersWidget.routeName,
        path: '/${MainUsersWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainUsersWidget(),
        ),
      ),
      GoRoute(
        name: MainProfilePageWidget.routeName,
        path: '/${MainProfilePageWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainProfilePageWidget(),
        ),
      ),
      GoRoute(
        name: MainProfileAccountWidget.routeName,
        path: '/${MainProfileAccountWidget.routePath}',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: MainProfileAccountWidget(),
        ),
      ),
    ],
  );
}
