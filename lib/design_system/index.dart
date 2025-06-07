/// Bukeer Design System
///
/// Complete design system for the Bukeer application including:
/// - Design tokens (colors, spacing, typography, elevation, breakpoints)
/// - Standardized components (buttons, navigation, modals, forms)
/// - Responsive layouts and containers
/// - Consistent styling and behavior patterns
///
/// ## Quick Start
///
/// ```dart
/// import 'package:bukeer/design_system/index.dart';
///
/// // Use design tokens
/// Container(
///   color: BukeerColors.primary,
///   padding: BukeerSpacing.all16,
///   child: Text(
///     'Hello World',
///     style: BukeerTypography.headlineLarge,
///   ),
/// )
///
/// // Use components
/// BukeerButton.primary(
///   text: 'Save',
///   onPressed: () {},
/// )
///
/// // Use responsive layouts
/// ResponsiveLayout(
///   title: 'Dashboard',
///   child: content,
///   navigationItems: BukeerNavigationItems.getDefaultItems(),
///   currentRoute: '/dashboard',
/// )
/// ```
///
/// ## Migration from FlutterFlow Code
///
/// ### Replace hardcoded values:
/// ```dart
/// // Before (FlutterFlow generated)
/// EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16)
/// Color(0xFF4B39EF)
///
/// // After (Design System)
/// BukeerSpacing.all16
/// BukeerColors.primary
/// ```
///
/// ### Replace inconsistent components:
/// ```dart
/// // Before (Multiple button implementations)
/// FFButtonWidget(...)
/// ElevatedButton(...)
/// TextButton(...)
///
/// // After (Unified button system)
/// BukeerButton.primary(...)
/// BukeerButton.outlined(...)
/// BukeerButton.text(...)
/// ```
///
/// ### Use responsive layouts:
/// ```dart
/// // Before (Fixed layouts)
/// Container(width: 270.0, ...)
///
/// // After (Responsive layouts)
/// ResponsiveContainer(child: ...)
/// BukeerBreakpoints.getSidebarWidth(context)
/// ```

// Design Tokens
export 'tokens/index.dart';

// Themes
export 'themes/theme_data.dart';

// Components
export 'components/index.dart';

// Layouts
export 'layouts/responsive_layout.dart';

// Tools
export 'tools/migration_helper.dart';
