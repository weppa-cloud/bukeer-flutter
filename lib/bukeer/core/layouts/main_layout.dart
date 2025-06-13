import 'package:flutter/material.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import '../widgets/navigation/sidebar/sidebar_navigation_widget.dart';

/// Main layout that wraps all pages with persistent navigation
class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? BukeerColors.backgroundDark : BukeerColors.backgroundPrimary,
      drawer: responsiveVisibility(
        context: context,
        tablet: false,
        desktop: false,
      )
          ? SidebarDrawer(currentRoute: currentRoute)
          : null,
      body: Row(
        children: [
          // Fixed sidebar for desktop
          if (responsiveVisibility(
            context: context,
            phone: false,
            tablet: false,
          ))
            SidebarNavigationWidget(
              currentRoute: currentRoute,
            ),

          // Page content
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
