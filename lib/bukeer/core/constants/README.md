# Bukeer Constants Directory

This directory contains all constant values used throughout the Bukeer application. Centralizing constants improves maintainability, reduces errors, and makes the codebase more professional.

## Directory Structure

```
constants/
├── routes.dart          # Navigation route paths and names
├── api_endpoints.dart   # API endpoints and URLs
├── config.dart         # Application configuration constants
├── ui_constants.dart   # UI-related constants (sizes, durations, etc.)
├── storage_keys.dart   # Keys for local storage and preferences
├── index.dart         # Barrel export file
└── README.md          # This file
```

## Usage

### Importing All Constants

```dart
import 'package:bukeer/bukeer/core/constants/index.dart';
```

### Importing Specific Constants

```dart
import 'package:bukeer/bukeer/core/constants/routes.dart';
import 'package:bukeer/bukeer/core/constants/ui_constants.dart';
```

## File Descriptions

### 1. routes.dart
Contains all navigation-related constants:
- **RoutePaths**: URL paths for navigation (e.g., `/login`, `/products`)
- **RouteNames**: Named routes for GoRouter (e.g., `login`, `products`)
- **ServiceTypes**: Service type constants for itinerary services
- **RouteParams**: Parameter names used in routes
- **QueryParams**: Query parameter names

Example:
```dart
// Navigate using route name
context.pushNamed(RouteNames.home);

// Navigate using route path
context.go(RoutePaths.login);

// Build dynamic route
final path = NavigationHelper.itineraryDetailsPath(itineraryId);
```

### 2. api_endpoints.dart
Contains all API-related constants:
- **ApiEndpoints**: All API endpoints and base URLs
- **ApiParams**: Common query parameter names
- **ApiHeaders**: HTTP header constants
- **ApiResponseCodes**: HTTP status codes

Example:
```dart
// Build API URL
final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.contacts}';

// Use with filters
final query = '?${ApiParams.eq}.${contactId}';
```

### 3. config.dart
Contains application-wide configuration:
- **AppConstants**: General app configuration
- Network timeouts and retry settings
- Pagination defaults
- File upload limits
- Date/time formats
- Validation rules
- Feature flags

Example:
```dart
// Check pagination
if (items.length > AppConstants.maxItemsPerPage) {
  // Implement pagination
}

// Validate password
if (password.length < AppConstants.minPasswordLength) {
  // Show error
}
```

### 4. ui_constants.dart
Contains all UI-related constants:
- **UIConstants**: Layout, spacing, sizing constants
- Responsive breakpoints
- Animation durations and curves
- Common padding/margin values
- Icon and button sizes
- Border radius values

Example:
```dart
Container(
  constraints: BoxConstraints(maxWidth: UIConstants.maxContentWidth),
  padding: EdgeInsets.all(UIConstants.paddingMedium),
  decoration: BoxDecoration(
    borderRadius: UIConstants.borderRadiusMd,
  ),
)
```

### 5. storage_keys.dart
Contains all storage-related constants:
- **StorageKeys**: Keys for SharedPreferences/localStorage
- **StorageKeyPrefixes**: Prefixes for organizing keys
- **StorageExpiry**: Cache and session durations

Example:
```dart
// Save user preference
final prefs = await SharedPreferences.getInstance();
await prefs.setString(StorageKeys.theme, 'dark');

// Get cached data
final cached = prefs.getString(StorageKeys.cachedProducts);
```

## Best Practices

1. **Always use constants instead of hardcoded values**
   ```dart
   // ❌ Bad
   if (width < 600) { ... }
   
   // ✅ Good
   if (width < UIConstants.mobileBreakpoint) { ... }
   ```

2. **Group related constants together**
   ```dart
   // All animation-related constants in one place
   static const Duration animationFast = Duration(milliseconds: 200);
   static const Duration animationNormal = Duration(milliseconds: 300);
   ```

3. **Use descriptive names**
   ```dart
   // ❌ Bad
   static const double mb = 600.0;
   
   // ✅ Good
   static const double mobileBreakpoint = 600.0;
   ```

4. **Document complex constants**
   ```dart
   /// Maximum file size for uploads (10 MB in bytes)
   static const int maxFileSize = 10485760;
   ```

5. **Use type-safe constants**
   ```dart
   // Use Duration instead of int for time
   static const Duration animationDuration = Duration(milliseconds: 300);
   
   // Use EdgeInsets for padding
   static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
   ```

## Adding New Constants

When adding new constants:

1. **Determine the appropriate file**
   - Navigation → `routes.dart`
   - API URLs → `api_endpoints.dart`
   - UI values → `ui_constants.dart`
   - Storage → `storage_keys.dart`
   - General config → `config.dart`

2. **Follow the existing pattern**
   - Use `static const` for compile-time constants
   - Group related constants
   - Use appropriate types

3. **Update the barrel export**
   - Add new files to `index.dart`

4. **Document if necessary**
   - Add comments for non-obvious values
   - Update this README for new categories

## Migration Guide

To migrate existing hardcoded values:

1. **Search for magic numbers**
   ```bash
   # Find numeric literals
   grep -r "[0-9]\{2,\}" lib/
   ```

2. **Search for hardcoded strings**
   ```bash
   # Find API URLs
   grep -r "http\|\.com" lib/
   ```

3. **Replace with constants**
   ```dart
   // Before
   padding: EdgeInsets.all(16.0)
   
   // After
   padding: EdgeInsets.all(UIConstants.paddingLg)
   ```

4. **Test thoroughly**
   - Ensure replaced values work correctly
   - Check responsive behavior
   - Verify API calls

## Benefits

- **Maintainability**: Change values in one place
- **Consistency**: Same values used everywhere
- **Type Safety**: Proper types prevent errors
- **Documentation**: Self-documenting code
- **Refactoring**: Easy to update values
- **Testing**: Mock constants easily