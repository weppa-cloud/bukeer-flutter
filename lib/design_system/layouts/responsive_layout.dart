import 'package:flutter/material.dart';
import '../tokens/index.dart';
import '../components/navigation/bukeer_navigation.dart';

/// Responsive layout wrapper for the Bukeer application
/// Provides consistent layout structure across different screen sizes
/// 
/// Features:
/// - Automatic navigation layout (drawer vs sidebar)
/// - Responsive content area sizing
/// - Consistent spacing and padding
/// - Navigation integration
/// - AppBar management
class ResponsiveLayout extends StatelessWidget {
  /// Page title for app bar
  final String? title;
  
  /// Main content widget
  final Widget child;
  
  /// Navigation items
  final List<BukeerNavItem> navigationItems;
  
  /// Current route for navigation highlighting
  final String currentRoute;
  
  /// User information for navigation
  final Map<String, dynamic>? userInfo;
  
  /// Custom app bar (optional)
  final PreferredSizeWidget? appBar;
  
  /// Floating action button (optional)
  final Widget? floatingActionButton;
  
  /// FAB location
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  /// Bottom sheet or bottom navigation (optional)
  final Widget? bottomSheet;
  
  /// Whether to show app bar
  final bool showAppBar;
  
  /// Whether to show navigation
  final bool showNavigation;
  
  /// Navigation callbacks
  final Function(String route)? onNavigate;
  final VoidCallback? onLogout;

  const ResponsiveLayout({
    Key? key,
    this.title,
    required this.child,
    required this.navigationItems,
    required this.currentRoute,
    this.userInfo,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.showAppBar = true,
    this.showNavigation = true,
    this.onNavigate,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (BukeerBreakpoints.shouldUseDrawer(context)) {
      return _buildMobileLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  /// Build mobile/tablet layout with drawer navigation
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: BukeerColors.backgroundSecondary,
      appBar: showAppBar ? _buildAppBar(context) : appBar,
      drawer: showNavigation 
        ? BukeerNavigation(
            currentRoute: currentRoute,
            userInfo: userInfo,
            navigationItems: navigationItems,
            onNavigate: onNavigate,
            onLogout: onLogout,
          )
        : null,
      body: _buildBody(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomSheet: bottomSheet,
    );
  }

  /// Build desktop layout with sidebar navigation
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: BukeerColors.backgroundSecondary,
      body: Row(
        children: [
          // Sidebar navigation
          if (showNavigation)
            BukeerNavigation(
              currentRoute: currentRoute,
              userInfo: userInfo,
              navigationItems: navigationItems,
              onNavigate: onNavigate,
              onLogout: onLogout,
            ),
          
          // Main content area
          Expanded(
            child: Column(
              children: [
                // App bar
                if (showAppBar && appBar == null)
                  _buildDesktopAppBar(context),
                if (appBar != null)
                  appBar!,
                
                // Body content
                Expanded(
                  child: _buildBody(context),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomSheet: bottomSheet,
    );
  }

  /// Build mobile app bar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: BukeerColors.backgroundPrimary,
      elevation: 1.0,
      shadowColor: BukeerColors.shadow33,
      title: title != null 
        ? Text(
            title!,
            style: BukeerTypography.titleMedium,
          )
        : null,
      centerTitle: false,
      leading: showNavigation 
        ? Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: BukeerColors.textPrimary,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
        : null,
    );
  }

  /// Build desktop app bar
  Widget _buildDesktopAppBar(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: BukeerColors.backgroundPrimary,
        border: Border(
          bottom: BorderSide(
            color: BukeerColors.borderPrimary,
            width: 1.0,
          ),
        ),
      ),
      padding: BukeerSpacing.horizontal24,
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: BukeerTypography.titleMedium,
            ),
          const Spacer(),
          // Add any global actions here (notifications, search, etc.)
        ],
      ),
    );
  }

  /// Build main body content with responsive padding
  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: BukeerBreakpoints.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: BukeerBreakpoints.getMaxContentWidth(context),
        ),
        child: child,
      ),
    );
  }
}

/// Responsive grid layout for cards and items
class ResponsiveGrid extends StatelessWidget {
  /// Grid items
  final List<Widget> children;
  
  /// Responsive layout configuration
  final ResponsiveLayoutConfig config;
  
  /// Whether items should have equal height
  final bool crossAxisExtent;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.config = const ResponsiveLayoutConfig(),
    this.crossAxisExtent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = config.getColumns(context);
    final spacing = config.getSpacing(context);

    if (crossAxisExtent) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1.0, // Adjust as needed
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    }
  }
}

/// Responsive wrap layout for flexible item arrangement
class ResponsiveWrap extends StatelessWidget {
  /// Wrap items
  final List<Widget> children;
  
  /// Spacing between items
  final double? spacing;
  
  /// Run spacing (vertical spacing)
  final double? runSpacing;
  
  /// Alignment of items
  final WrapAlignment alignment;

  const ResponsiveWrap({
    Key? key,
    required this.children,
    this.spacing,
    this.runSpacing,
    this.alignment = WrapAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultSpacing = BukeerBreakpoints.isMobile(context) 
      ? BukeerSpacing.sm 
      : BukeerSpacing.md;

    return Wrap(
      spacing: spacing ?? defaultSpacing,
      runSpacing: runSpacing ?? defaultSpacing,
      alignment: alignment,
      children: children,
    );
  }
}

/// Responsive container with max width constraints
class ResponsiveContainer extends StatelessWidget {
  /// Container child
  final Widget child;
  
  /// Custom max width (optional)
  final double? maxWidth;
  
  /// Container padding
  final EdgeInsetsGeometry? padding;
  
  /// Container margin
  final EdgeInsetsGeometry? margin;
  
  /// Container decoration
  final BoxDecoration? decoration;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actualMaxWidth = maxWidth ?? BukeerBreakpoints.getMaxContentWidth(context);
    final actualPadding = padding ?? BukeerBreakpoints.getResponsivePadding(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: actualMaxWidth),
      padding: actualPadding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }
}

/// Responsive column layout with automatic spacing
class ResponsiveColumn extends StatelessWidget {
  /// Column children
  final List<Widget> children;
  
  /// Main axis alignment
  final MainAxisAlignment mainAxisAlignment;
  
  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;
  
  /// Custom spacing between children
  final double? spacing;

  const ResponsiveColumn({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultSpacing = BukeerBreakpoints.isMobile(context) 
      ? BukeerSpacing.md 
      : BukeerSpacing.lg;
    
    final actualSpacing = spacing ?? defaultSpacing;

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildChildrenWithSpacing(actualSpacing),
    );
  }

  List<Widget> _buildChildrenWithSpacing(double spacing) {
    if (children.isEmpty) return [];
    
    final spacedChildren = <Widget>[];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      // Add spacing between items (but not after the last item)
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    
    return spacedChildren;
  }
}