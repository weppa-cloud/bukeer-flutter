import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';

/// Unified navigation component for the Bukeer application
/// Replaces both web_nav and mobile_nav with consistent behavior
/// 
/// Features:
/// - Responsive navigation (drawer on mobile/tablet, sidebar on desktop)
/// - Consistent navigation data source
/// - Unified styling and behavior
/// - Role-based navigation items
/// - Active state management
class BukeerNavigation extends StatelessWidget {
  /// Current route path for highlighting active navigation item
  final String currentRoute;
  
  /// User information for profile display
  final Map<String, dynamic>? userInfo;
  
  /// Navigation items to display
  final List<BukeerNavItem> navigationItems;
  
  /// Callback when navigation item is selected
  final Function(String route)? onNavigate;
  
  /// Callback for logout action
  final VoidCallback? onLogout;
  
  /// Custom header widget (optional)
  final Widget? header;
  
  /// Custom footer widget (optional)
  final Widget? footer;

  const BukeerNavigation({
    Key? key,
    required this.currentRoute,
    this.userInfo,
    required this.navigationItems,
    this.onNavigate,
    this.onLogout,
    this.header,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // On mobile/tablet, return drawer content
    if (BukeerBreakpoints.shouldUseDrawer(context)) {
      return _buildDrawerNavigation(context);
    } 
    // On desktop, return persistent navigation
    else {
      return _buildSidebarNavigation(context);
    }
  }

  /// Build drawer navigation for mobile/tablet
  Widget _buildDrawerNavigation(BuildContext context) {
    return Drawer(
      backgroundColor: BukeerColors.backgroundPrimary,
      elevation: BukeerElevation.level4,
      width: BukeerBreakpoints.getSidebarWidth(context),
      child: _buildNavigationContent(context),
    );
  }

  /// Build sidebar navigation for desktop
  Widget _buildSidebarNavigation(BuildContext context) {
    return Container(
      width: BukeerBreakpoints.getSidebarWidth(context),
      decoration: BoxDecoration(
        color: BukeerColors.backgroundPrimary,
        border: Border(
          right: BorderSide(
            color: BukeerColors.borderPrimary,
            width: 1.0,
          ),
        ),
        boxShadow: BukeerElevation.shadow2,
      ),
      child: _buildNavigationContent(context),
    );
  }

  /// Build the main navigation content
  Widget _buildNavigationContent(BuildContext context) {
    return Column(
      children: [
        // Header section
        _buildHeader(context),
        
        // Navigation items
        Expanded(
          child: ListView(
            padding: BukeerSpacing.vertical8,
            children: [
              ...navigationItems.map((item) => _buildNavigationItem(context, item)),
            ],
          ),
        ),
        
        // Footer section
        _buildFooter(context),
      ],
    );
  }

  /// Build navigation header
  Widget _buildHeader(BuildContext context) {
    if (header != null) {
      return header!;
    }

    return Container(
      padding: BukeerSpacing.all24,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BukeerColors.borderPrimary,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo
          _buildLogo(),
          
          if (userInfo != null) ...[
            SizedBox(height: BukeerSpacing.lg),
            _buildUserProfile(context),
          ],
        ],
      ),
    );
  }

  /// Build logo section
  Widget _buildLogo() {
    return Row(
      children: [
        // Logo image placeholder - replace with actual logo
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: BukeerColors.primary,
            borderRadius: BukeerBorderRadius.mediumRadius,
          ),
          child: Icon(
            Icons.business,
            color: BukeerColors.textInverse,
            size: 24.0,
          ),
        ),
        SizedBox(width: BukeerSpacing.md),
        Expanded(
          child: Text(
            'Bukeer',
            style: BukeerTypography.titleLarge.copyWith(
              color: BukeerColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  /// Build user profile section
  Widget _buildUserProfile(BuildContext context) {
    final userName = _getUserName();
    final userRole = _getUserRole();
    
    return Row(
      children: [
        // User avatar
        CircleAvatar(
          radius: 20.0,
          backgroundColor: BukeerColors.primaryLight,
          backgroundImage: _getUserAvatar() != null 
            ? NetworkImage(_getUserAvatar()!) 
            : null,
          child: _getUserAvatar() == null 
            ? Icon(
                Icons.person,
                color: BukeerColors.primary,
                size: 20.0,
              )
            : null,
        ),
        SizedBox(width: BukeerSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: BukeerTypography.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (userRole.isNotEmpty)
                Text(
                  userRole,
                  style: BukeerTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build navigation footer
  Widget _buildFooter(BuildContext context) {
    if (footer != null) {
      return footer!;
    }

    return Container(
      padding: BukeerSpacing.all16,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: BukeerColors.borderPrimary,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logout button
          if (onLogout != null)
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  // Close drawer if on mobile
                  if (BukeerBreakpoints.shouldUseDrawer(context)) {
                    Navigator.of(context).pop();
                  }
                  onLogout?.call();
                },
                icon: Icon(
                  Icons.logout,
                  size: 18.0,
                  color: BukeerColors.error,
                ),
                label: Text(
                  'Cerrar Sesión',
                  style: BukeerTypography.labelLarge.copyWith(
                    color: BukeerColors.error,
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: BukeerSpacing.fromSTEB(12.0, 8.0, 12.0, 8.0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build individual navigation item
  Widget _buildNavigationItem(BuildContext context, BukeerNavItem item) {
    final isActive = _isItemActive(item.route);
    
    return Container(
      margin: BukeerSpacing.fromSTEB(8.0, 2.0, 8.0, 2.0),
      child: Material(
        color: isActive ? BukeerColors.primaryLight.withOpacity(0.1) : Colors.transparent,
        borderRadius: BukeerBorderRadius.mediumRadius,
        child: ListTile(
          leading: Icon(
            item.icon,
            size: 20.0,
            color: isActive ? BukeerColors.primary : BukeerColors.textSecondary,
          ),
          title: Text(
            item.title,
            style: isActive 
              ? BukeerTypography.navItemActive
              : BukeerTypography.navItem,
          ),
          trailing: item.badge != null ? _buildBadge(item.badge!) : null,
          contentPadding: BukeerSpacing.fromSTEB(12.0, 4.0, 12.0, 4.0),
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BukeerBorderRadius.mediumRadius,
          ),
          onTap: () => _handleNavigation(context, item),
        ),
      ),
    );
  }

  /// Build navigation badge
  Widget _buildBadge(String badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: BukeerColors.error,
        borderRadius: BorderRadius.circular(10.0),
      ),
      constraints: const BoxConstraints(minWidth: 16.0, minHeight: 16.0),
      child: Text(
        badge,
        style: BukeerTypography.labelSmall.copyWith(
          color: BukeerColors.textInverse,
          fontSize: 10.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Handle navigation item tap
  void _handleNavigation(BuildContext context, BukeerNavItem item) {
    // Close drawer if on mobile
    if (BukeerBreakpoints.shouldUseDrawer(context)) {
      Navigator.of(context).pop();
    }
    
    // Navigate to route
    if (onNavigate != null) {
      onNavigate!(item.route);
    } else {
      // Default navigation using context.go
      context.go(item.route);
    }
  }

  /// Check if navigation item is active
  bool _isItemActive(String route) {
    // Exact match
    if (currentRoute == route) return true;
    
    // Partial match for nested routes
    if (route != '/' && currentRoute.startsWith(route)) return true;
    
    return false;
  }

  /// Get user name from userInfo
  String _getUserName() {
    if (userInfo == null) return 'Usuario';
    
    final firstName = userInfo!['name']?.toString() ?? '';
    final lastName = userInfo!['last_name']?.toString() ?? '';
    final fullName = '$firstName $lastName'.trim();
    
    return fullName.isNotEmpty ? fullName : 'Usuario';
  }

  /// Get user role from userInfo
  String _getUserRole() {
    if (userInfo == null) return '';
    
    final roleId = userInfo!['role_id'];
    switch (roleId) {
      case 1:
        return 'Administrador';
      case 2:
        return 'Super Administrador';
      case 3:
        return 'Agente';
      default:
        return '';
    }
  }

  /// Get user avatar URL from userInfo
  String? _getUserAvatar() {
    if (userInfo == null) return null;
    return userInfo!['profile_image']?.toString();
  }
}

/// Navigation item data structure
class BukeerNavItem {
  /// Navigation item title
  final String title;
  
  /// Navigation item icon
  final IconData icon;
  
  /// Navigation route
  final String route;
  
  /// Optional badge text (for notifications, etc.)
  final String? badge;
  
  /// Required user roles to see this item
  final List<int>? requiredRoles;

  const BukeerNavItem({
    required this.title,
    required this.icon,
    required this.route,
    this.badge,
    this.requiredRoles,
  });
}

/// Default navigation items for Bukeer application
class BukeerNavigationItems {
  static List<BukeerNavItem> getDefaultItems() {
    return [
      BukeerNavItem(
        title: 'Dashboard',
        icon: Icons.dashboard_outlined,
        route: '/mainHome',
      ),
      BukeerNavItem(
        title: 'Itinerarios',
        icon: Icons.map_outlined,
        route: '/main_itineraries',
      ),
      BukeerNavItem(
        title: 'Productos',
        icon: Icons.inventory_2_outlined,
        route: '/mainProducts',
      ),
      BukeerNavItem(
        title: 'Contactos',
        icon: Icons.contacts_outlined,
        route: '/main_contacts',
      ),
      BukeerNavItem(
        title: 'Usuarios',
        icon: Icons.people_outline,
        route: '/mainUsers',
        requiredRoles: [1, 2], // Admin and Super Admin only
      ),
      BukeerNavItem(
        title: 'Perfil',
        icon: Icons.person_outline,
        route: '/mainProfilePage',
      ),
    ];
  }
}