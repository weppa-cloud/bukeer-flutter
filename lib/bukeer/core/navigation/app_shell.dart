import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/navigation/sidebar/sidebar_navigation_widget.dart';
import 'package:bukeer/bukeer/dashboard/main_home/main_home_widget.dart';
import 'package:bukeer/bukeer/itineraries/main_itineraries/main_itineraries_widget.dart';
import 'package:bukeer/bukeer/contacts/main_contacts/main_contacts_widget.dart';
import 'package:bukeer/bukeer/products/main_products/main_products_widget.dart';
import 'package:bukeer/bukeer/agenda/main_agenda/main_agenda_widget.dart';
import 'package:bukeer/bukeer/users/main_users/main_users_widget.dart';
import 'package:bukeer/bukeer/users/profile/main_page/main_profile_page_widget.dart';
import 'package:bukeer/bukeer/users/profile/main_account/main_profile_account_widget.dart';

/// Shell route that provides persistent navigation across all pages
class AppShell extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const AppShell({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected index based on current route
    _selectedIndex = _getIndexFromRoute(widget.state.matchedLocation);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentRoute = widget.state.matchedLocation;
    final isDesktop =
        MediaQuery.of(context).size.width >= 991; // Using Bukeer breakpoint
    final isMobile = MediaQuery.of(context).size.width < 479;

    // For desktop, wrap with sidebar
    if (isDesktop) {
      return Scaffold(
        backgroundColor: isDark
            ? BukeerColors.backgroundDark
            : BukeerColors.backgroundPrimary,
        body: Row(
          children: [
            // Fixed sidebar that won't animate
            SidebarNavigationWidget(
              currentRoute: _getRouteNameFromPath(currentRoute),
            ),

            // Only this part will animate during route transitions
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      );
    }

    // For mobile, add bottom navigation
    if (isMobile) {
      return Scaffold(
        backgroundColor: isDark
            ? BukeerColors.backgroundDark
            : BukeerColors.backgroundPrimary,
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(context, index),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          selectedItemColor: FlutterFlowTheme.of(context).primary,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 24.0),
              activeIcon: Icon(Icons.dashboard_rounded, size: 32.0),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 24.0),
              activeIcon: Icon(Icons.account_circle, size: 32.0),
              label: 'Cuenta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts_sharp, size: 24.0),
              activeIcon: Icon(Icons.contacts_sharp, size: 32.0),
              label: 'Contactos',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.boxes, size: 24.0),
              activeIcon: FaIcon(FontAwesomeIcons.boxes, size: 32.0),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.route, size: 24.0),
              activeIcon: FaIcon(FontAwesomeIcons.route, size: 32.0),
              label: 'Itinerarios',
            ),
          ],
        ),
      );
    }

    // For tablet, just show the child with drawer
    return Scaffold(
      backgroundColor:
          isDark ? BukeerColors.backgroundDark : BukeerColors.backgroundPrimary,
      drawer: SidebarDrawer(currentRoute: _getRouteNameFromPath(currentRoute)),
      body: widget.child,
    );
  }

  String _getRouteNameFromPath(String path) {
    // Map paths to route names for navigation highlighting
    // Using the actual route names from the widgets
    if (path.startsWith('/mainHome')) return MainHomeWidget.routeName;
    if (path.startsWith('/mainItineraries') || path.contains('itineraries'))
      return MainItinerariesWidget.routeName;
    if (path.startsWith('/mainContacts')) return MainContactsWidget.routeName;
    if (path.startsWith('/mainProducts')) return MainProductsWidget.routeName;
    if (path.startsWith('/mainAgenda')) return MainAgendaWidget.routeName;
    if (path.startsWith('/mainUsers')) return MainUsersWidget.routeName;
    if (path.startsWith('/mainProfileAccount'))
      return MainProfileAccountWidget.routeName;
    if (path.startsWith('/mainProfilePage'))
      return MainProfilePageWidget.routeName;

    return MainHomeWidget.routeName; // Default
  }

  int _getIndexFromRoute(String path) {
    if (path.startsWith('/mainHome')) return 0;
    if (path.startsWith('/mainProfilePage')) return 1;
    if (path.startsWith('/mainContacts')) return 2;
    if (path.startsWith('/mainProducts')) return 3;
    if (path.startsWith('/mainItineraries')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(MainHomeWidget.routeName);
        break;
      case 1:
        context.goNamed(MainProfilePageWidget.routeName);
        break;
      case 2:
        context.goNamed(MainContactsWidget.routeName);
        break;
      case 3:
        context.goNamed(MainProductsWidget.routeName);
        break;
      case 4:
        context.goNamed(MainItinerariesWidget.routeName);
        break;
    }
  }
}
