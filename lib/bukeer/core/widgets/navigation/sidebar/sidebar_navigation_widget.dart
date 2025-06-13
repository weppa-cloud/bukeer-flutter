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
import 'package:bukeer/bukeer/users/profile/main_account/main_profile_account_widget.dart';
import 'package:bukeer/bukeer/users/profile/main_page/main_profile_page_widget.dart';
import '/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/config/app_config.dart';

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
    final userData = appServices.user.agentData;
    String userEmail = 'usuario@bukeer.com';
    String userName = 'Usuario';
    String userRole = 'Team Member';
    String? userPhoto;

    if (userData != null && userData is List && userData.isNotEmpty) {
      final user = userData[0];
      userEmail = user['email']?.toString() ?? 'usuario@bukeer.com';
      userName = '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
      if (userName.isEmpty) userName = 'Usuario';
      userRole = user['role_name']?.toString() ?? 'Team Member';

      // Get user photo URL - check both user_image and main_image fields
      final photoUrl =
          user['user_image']?.toString() ?? user['main_image']?.toString();
      if (photoUrl != null && photoUrl.isNotEmpty) {
        // Ensure the URL is complete
        if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
          userPhoto = photoUrl;
        } else if (photoUrl.startsWith('/')) {
          // If it's a relative path, prepend the base URL
          userPhoto = '${AppConfig.apiBaseUrl}$photoUrl';
        } else {
          userPhoto = photoUrl;
        }
      }

      debugPrint(
          'SidebarNav: User data loaded - Name: $userName, Email: $userEmail');
      debugPrint(
          'SidebarNav: Photo URL raw: ${user['user_image'] ?? user['main_image']}');
      debugPrint('SidebarNav: Photo URL processed: $userPhoto');
      debugPrint('SidebarNav: Full user data: $user');
    } else {
      debugPrint('SidebarNav: No user data available');
      debugPrint('SidebarNav: userData type: ${userData.runtimeType}');
      debugPrint('SidebarNav: userData content: $userData');
    }

    return Container(
      width:
          260, // TODO: Move to design tokens as BukeerDimensions.sidebarWidth
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
          _buildLogo(context, logoUrl, accountName),
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
                  route: MainProfileAccountWidget.routeName,
                  isActive: currentRoute == MainProfileAccountWidget.routeName,
                  hasChevron: true,
                ),
                SizedBox(height: BukeerSpacing.m),
                // Profile Section
                _buildProfileSection(
                    context, userName, userEmail, userRole, userPhoto),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context, String? logoUrl, String accountName) {
    Widget logoWidget;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      // Use provided logo URL
      debugPrint('Using account logo: $logoUrl');

      logoWidget = Container(
        height:
            BukeerSpacing.xxl + BukeerSpacing.m, // 40px using spacing tokens
        alignment: Alignment.centerLeft,
        child: Image.network(
          logoUrl,
          height:
              BukeerSpacing.xxl + BukeerSpacing.m, // 40px using spacing tokens
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: BukeerSpacing.xxl +
                  BukeerSpacing.m, // 40px using spacing tokens
              width: BukeerSpacing.xxl +
                  BukeerSpacing.m, // 40px using spacing tokens
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  color: BukeerColors.primary,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading account logo: $error');
            // Fallback to default Bukeer logo
            return Image.asset(
              'assets/images/Logo-Bukeer-FullBlanco-03.png',
              height: BukeerSpacing.xxl +
                  BukeerSpacing.m, // 40px using spacing tokens
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _buildTextLogo(accountName);
              },
            );
          },
        ),
      );
    } else {
      // Use default Bukeer logo
      debugPrint('No account logo, using default Bukeer logo');
      logoWidget = Container(
        height:
            BukeerSpacing.xxl + BukeerSpacing.m, // 40px using spacing tokens
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/Logo-Bukeer-FullBlanco-03.png',
          height:
              BukeerSpacing.xxl + BukeerSpacing.m, // 40px using spacing tokens
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Final fallback to text logo
            return _buildTextLogo(accountName);
          },
        ),
      );
    }

    return InkWell(
      borderRadius: BukeerBorders.radiusMedium,
      onTap: () {
        if (currentRoute != MainHomeWidget.routeName) {
          context.goNamed(MainHomeWidget.routeName);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.xs),
        child: logoWidget,
      ),
    );
  }

  Widget _buildTextLogo(String accountName) {
    return Text(
      accountName.toUpperCase(),
      style: BukeerTypography.displaySmall.copyWith(
        color: BukeerColors.primary,
        fontWeight: FontWeight.w700,
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
            if (route != currentRoute) {
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
                  size: BukeerSpacing.xl, // Use spacing token for icon size
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
                    style: isActive
                        ? BukeerTypography.sidebarItemActive
                            .copyWith(color: Colors.white)
                        : BukeerTypography.sidebarItem.copyWith(
                            color: isDark
                                ? BukeerColors.textPrimaryDark
                                : BukeerColors.textPrimary,
                          ),
                  ),
                ),
                if (hasChevron)
                  Icon(
                    Icons.chevron_right,
                    size: BukeerSpacing.xl, // Use spacing token for icon size
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

  Widget _buildProfileSection(BuildContext context, String userName,
      String userEmail, String userRole, String? userPhoto) {
    return InkWell(
      borderRadius: BukeerBorders.radiusMedium,
      onTap: () {
        context.goNamed(MainProfilePageWidget.routeName);
      },
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.xs),
        child: Row(
          children: [
            Container(
              width: 36.0, // Standard profile image size
              height: 36.0, // Standard profile image size
              decoration: BoxDecoration(
                borderRadius: BukeerBorders.radiusFull,
                color: BukeerColors.primary.withOpacity(0.1),
                border: Border.all(
                  color: BukeerColors.primary.withOpacity(0.3),
                  width: BukeerBorders.widthMedium,
                ),
              ),
              child: ClipRRect(
                borderRadius: BukeerBorders.radiusFull,
                child: userPhoto != null && userPhoto.isNotEmpty
                    ? Image.network(
                        userPhoto,
                        width: 36.0, // Standard profile image size
                        height: 36.0, // Standard profile image size
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: BukeerColors.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                              'SidebarNav: Error loading user photo: $error');
                          debugPrint('SidebarNav: Failed URL: $userPhoto');
                          return Center(
                            child: Text(
                              userName.isNotEmpty
                                  ? userName[0].toUpperCase()
                                  : 'U',
                              style: BukeerTypography.titleMedium.copyWith(
                                color: BukeerColors.primary,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: BukeerTypography.titleMedium.copyWith(
                            color: BukeerColors.primary,
                          ),
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
                    style: BukeerTypography.titleSmall.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? BukeerColors.textPrimaryDark
                          : BukeerColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    userRole,
                    style: BukeerTypography.bodySmall.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? BukeerColors.textSecondaryDark
                          : BukeerColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
