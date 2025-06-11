import 'package:flutter/material.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/services/authorization_service.dart';
import 'package:bukeer/bukeer/dashboard/main_home/main_home_widget.dart';
import 'package:bukeer/bukeer/itineraries/main_itineraries/main_itineraries_widget.dart';
import 'package:bukeer/bukeer/contacts/main_contacts/main_contacts_widget.dart';
import 'package:bukeer/bukeer/products/main_products/main_products_widget.dart';
import 'package:bukeer/bukeer/agenda/main_agenda/main_agenda_widget.dart';
import 'package:bukeer/bukeer/users/main_users/main_users_widget.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart';

/// Sidebar navigation component following Bukeer design system
class SidebarNavigationWidget extends StatelessWidget {
  final String currentRoute;
  final VoidCallback? onMenuTap;

  const SidebarNavigationWidget({
    super.key,
    required this.currentRoute,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountData = appServices.account.accountData;
    final logoUrl = accountData?['logo_url'] as String?;
    final accountName = accountData?['name'] as String? ?? 'BUKEER';

    // Get current user data
    final userData = appServices.user.selectedUser;
    final userEmail = userData != null
        ? getJsonField(userData, r'$[:].email')?.toString() ??
            'usuario@bukeer.com'
        : 'usuario@bukeer.com';
    final userName = userData != null
        ? getJsonField(userData, r'$[:].full_name')?.toString() ?? 'Usuario'
        : 'Usuario';
    final userRole = userData != null
        ? getJsonField(userData, r'$[:].role_name')?.toString() ?? 'Team Member'
        : 'Team Member';

    return Container(
      width: 260,
      padding: EdgeInsets.all(BukeerSpacing.l),
      decoration: BoxDecoration(
        color: isDark ? BukeerColors.surfacePrimaryDark : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? BukeerColors.dividerDark : BukeerColors.divider,
            width: BukeerBorders.widthThin,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo or Brand Name
          _buildLogo(logoUrl, accountName),
          SizedBox(height: BukeerSpacing.xxl),

          // Navigation Items
          Expanded(
            child: Column(
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  route: MainHomeWidget.routeName,
                  isActive: currentRoute == MainHomeWidget.routeName,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.receipt_long,
                  label: 'Itinerarios',
                  route: MainItinerariesWidget.routeName,
                  isActive: currentRoute == MainItinerariesWidget.routeName,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.contacts,
                  label: 'Contactos',
                  route: MainContactsWidget.routeName,
                  isActive: currentRoute == MainContactsWidget.routeName,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.inventory_2,
                  label: 'Productos',
                  route: MainProductsWidget.routeName,
                  isActive: currentRoute == MainProductsWidget.routeName,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.calendar_today,
                  label: 'Agenda',
                  route: MainAgendaWidget.routeName,
                  isActive: currentRoute == MainAgendaWidget.routeName,
                ),
                // Only show users if user has admin role
                if (appServices.authorization
                    .hasAnyRole([RoleType.admin, RoleType.superAdmin]))
                  _buildNavItem(
                    context: context,
                    icon: Icons.group,
                    label: 'Usuarios',
                    route: MainUsersWidget.routeName,
                    isActive: currentRoute == MainUsersWidget.routeName,
                  ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.only(top: BukeerSpacing.m),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                  width: BukeerBorders.widthThin,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.settings,
                  label: 'Ajustes',
                  route: 'settings',
                  isActive: false,
                  hasChevron: true,
                ),
                SizedBox(height: BukeerSpacing.m),
                // Profile Section
                _buildProfileSection(userName, userEmail, userRole),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String? logoUrl, String accountName) {
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return Container(
        height: 40,
        alignment: Alignment.centerLeft,
        child: Image.network(
          logoUrl,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildTextLogo(accountName);
          },
        ),
      );
    }
    return _buildTextLogo(accountName);
  }

  Widget _buildTextLogo(String accountName) {
    return Text(
      accountName.toUpperCase(),
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: BukeerColors.primary,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    bool hasChevron = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: BukeerSpacing.s),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BukeerBorders.radiusMedium,
          onTap: () {
            if (route != 'settings' && route != currentRoute) {
              context.goNamed(route);
            }
          },
          child: AnimatedContainer(
            duration: BukeerAnimations.fast,
            curve: BukeerAnimations.standard,
            padding: EdgeInsets.symmetric(
              horizontal: BukeerSpacing.m,
              vertical: BukeerSpacing.s,
            ),
            decoration: BoxDecoration(
              color: isActive ? BukeerColors.primary : Colors.transparent,
              borderRadius: BukeerBorders.radiusMedium,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive
                      ? Colors.white
                      : (isDark
                          ? BukeerColors.textSecondaryDark
                          : BukeerColors.textSecondary),
                ),
                SizedBox(width: BukeerSpacing.m),
                Expanded(
                  child: Text(
                    label,
                    style: BukeerTypography.bodyLarge.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? Colors.white
                          : (isDark
                              ? BukeerColors.textPrimaryDark
                              : BukeerColors.textPrimary),
                    ),
                  ),
                ),
                if (hasChevron)
                  Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: isActive
                        ? Colors.white
                        : (isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(
      String userName, String userEmail, String userRole) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BukeerBorders.radiusFull,
            color: BukeerColors.primary.withOpacity(0.1),
            border: Border.all(
              color: BukeerColors.primary.withOpacity(0.3),
              width: BukeerBorders.widthMedium,
            ),
          ),
          child: Center(
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: BukeerTypography.titleMedium.copyWith(
                color: BukeerColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: BukeerSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: BukeerTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                userRole,
                style: BukeerTypography.bodySmall.copyWith(
                  color: BukeerColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mobile drawer version of the sidebar
class SidebarDrawer extends StatelessWidget {
  final String currentRoute;

  const SidebarDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SidebarNavigationWidget(
        currentRoute: currentRoute,
      ),
    );
  }
}
