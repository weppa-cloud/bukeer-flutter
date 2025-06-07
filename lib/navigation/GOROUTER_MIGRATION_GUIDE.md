# GoRouter Migration Guide

## 🎯 Overview

This guide explains how to migrate from the existing Flutter Flow navigation system to the modern GoRouter implementation in the Bukeer app.

## 📁 New Files Created

### Core Navigation Files
- `lib/navigation/modern_router.dart` - Main router implementation
- `lib/navigation/route_definitions.dart` - Centralized route constants
- `lib/navigation/navigation_state.dart` - Navigation state management
- `lib/navigation/guards/auth_guard.dart` - Authentication guards
- `lib/navigation/guards/permission_guard.dart` - Permission-based guards

## 🚀 Benefits of Modern GoRouter

### 1. Type Safety
- Centralized route definitions prevent typos
- Compile-time route validation
- Type-safe parameter passing

### 2. Enhanced Security
- Granular permission checks
- Role-based access control
- Automatic authentication redirects

### 3. Better Performance
- Declarative routing
- Lazy loading support
- Optimized navigation state management

### 4. Improved Developer Experience
- Clear navigation structure
- Easy debugging with navigation history
- Consistent error handling

## 🔄 Migration Steps

### Step 1: Update main.dart

Replace the existing router in `main.dart`:

```dart
// BEFORE (existing)
import 'flutter_flow/nav/nav.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateNotifier(),
      child: MyAppStateWidget(),
    );
  }
}

class MyAppStateWidget extends StatefulWidget {
  @override
  _MyAppStateWidgetState createState() => _MyAppStateWidgetState();
}

class _MyAppStateWidgetState extends State<MyAppStateWidget> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(context.read<AppStateNotifier>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      // ... other config
    );
  }
}

// AFTER (modern)
import 'navigation/modern_router.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateNotifier(),
      child: MaterialApp.router(
        title: 'Bukeer',
        routerConfig: ModernRouter.router,
        locale: FFLocalizations.of(context).locale,
        localizationsDelegates: [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es')],
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: false,
        ),
      ),
    );
  }
}
```

### Step 2: Update Navigation Calls

Replace old navigation patterns with new type-safe ones:

```dart
// BEFORE (FlutterFlow style)
context.pushNamed('itineraryDetails', pathParameters: {'id': '123'});
context.goNamed('mainProducts');

// AFTER (Modern GoRouter)
import '../navigation/route_definitions.dart';

context.go(NavigationHelper.itineraryDetailsPath('123'));
context.goNamed(RouteNames.products);

// Or using the helper methods
context.go(NavigationHelper.editRatePath(
  'product123',
  rateId: 'rate456',
  type: 'hotel',
  action: 'edit',
));
```

### Step 3: Update Authentication Flows

The new system handles authentication automatically:

```dart
// BEFORE (manual auth checks)
if (!currentUserLoggedIn) {
  context.goNamed('authLogin');
  return;
}

// AFTER (automatic with guards)
// Routes are automatically protected
// Users are redirected to login when needed
// Post-login redirect is handled automatically
```

### Step 4: Use Permission Guards

```dart
// NEW: Permission-based access control
// Routes with permission guards automatically check user roles
// Unauthorized users are redirected appropriately

// Example: Admin-only routes
context.goNamed(RouteNames.users); // Automatically checks admin permission

// Example: Custom permission checking
final canEditProducts = appServices.authorization.hasPermission('product:update');
if (canEditProducts) {
  // Show edit UI
}
```

## 📱 Navigation Patterns

### 1. Type-Safe Navigation
```dart
// Use route constants
context.go(AppRoutes.home);
context.go(AppRoutes.products);

// Use navigation helpers for complex routes
context.go(NavigationHelper.itineraryDetailsPath('itinerary-id'));
```

### 2. Navigation State Tracking
```dart
// Access navigation state
final navState = ModernRouter.navigationState;

// Check current section
if (navState.isInItinerariesSection) {
  // Update UI for itineraries section
}

// Get navigation history
final history = navState.navigationHistory;
final canGoBack = navState.canGoBack;
```

### 3. Error Handling
```dart
// Automatic error pages for invalid routes
// Custom error handling with user feedback
// Integration with the error handling system
```

## 🔐 Security Features

### Authentication Guards
- Automatic login redirects
- Post-login redirect preservation
- User data initialization

### Permission Guards
- Role-based access control
- Granular permission checking
- Resource ownership validation

### Route Protection
```dart
// Public routes (no auth required)
- /authLogin
- /authCreate
- /forgotPassword
- /preview/:id (itinerary previews)

// Protected routes (authentication required)
- /mainHome
- /mainItineraries
- /mainProducts
- /mainContacts

// Admin routes (admin permission required)
- /mainUsers
- /admin/dashboard

// Super admin routes (super admin permission required)
- /admin/dashboard (error monitoring)
```

## 🎯 Migration Checklist

### Phase 1: Setup (Low Risk)
- [ ] Create navigation files
- [ ] Test compilation
- [ ] Verify all imports resolve

### Phase 2: Integration (Medium Risk)
- [ ] Update main.dart to use ModernRouter
- [ ] Test basic navigation flows
- [ ] Verify authentication works

### Phase 3: Migration (High Risk)
- [ ] Replace navigation calls throughout the app
- [ ] Update deep linking
- [ ] Test all user flows

### Phase 4: Cleanup (Low Risk)
- [ ] Remove old navigation code
- [ ] Update documentation
- [ ] Performance testing

## 🧪 Testing

### Navigation Testing
```dart
// Test route definitions
testWidgets('Route definitions are valid', (tester) async {
  // Test each route can be built
  expect(AppRoutes.home, equals('/mainHome'));
  expect(RouteNames.home, equals('mainHome'));
});

// Test navigation
testWidgets('Navigation works', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Test navigation to different sections
  final router = ModernRouter.router;
  router.go(AppRoutes.products);
  
  expect(find.byType(MainProductsWidget), findsOneWidget);
});
```

### Permission Testing
```dart
testWidgets('Permission guards work', (tester) async {
  // Test admin route access
  // Test unauthorized access redirects
  // Test permission-based UI
});
```

## 🔄 Rollback Plan

If issues arise, you can quickly rollback:

1. **Revert main.dart** to use the original router
2. **Keep both systems** running in parallel during migration
3. **Gradual migration** by route section

```dart
// Rollback configuration
class MyApp extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // Use feature flag to switch between routers
    final useModernRouter = AppConfig.useModernRouter;
    
    return MaterialApp.router(
      routerConfig: useModernRouter 
        ? ModernRouter.router 
        : createRouter(context.read<AppStateNotifier>()),
    );
  }
}
```

## 📈 Performance Benefits

### Before Migration
- Large single router file (500+ lines)
- Mixed navigation patterns
- Manual authentication checks
- No navigation state tracking

### After Migration
- Modular router architecture
- Consistent navigation patterns
- Automatic authentication handling
- Complete navigation state management
- Performance monitoring integration

## 🎉 Next Steps

1. **Implement the migration** following this guide
2. **Test thoroughly** in development environment
3. **Monitor performance** using the existing dashboard
4. **Gather user feedback** on navigation experience
5. **Optimize further** based on usage patterns

---

## ✅ Migration Complete Benefits

Once migrated, the app will have:

- **🔒 Enhanced Security**: Automatic auth and permission checking
- **🎯 Type Safety**: Compile-time route validation
- **📊 Better Analytics**: Navigation tracking and user flow insights
- **🚀 Improved Performance**: Optimized routing and state management
- **🛠️ Developer Experience**: Easier debugging and maintenance
- **🎨 Consistent UX**: Standardized navigation patterns

The modern GoRouter implementation provides a solid foundation for future navigation enhancements and maintains compatibility with the existing Bukeer architecture.