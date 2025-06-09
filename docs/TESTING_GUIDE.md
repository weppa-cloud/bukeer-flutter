# Testing Guide - Bukeer Flutter

**Last Updated**: January 9, 2025  
**Version**: 2.0  
**Status**: ✅ Active Development

## Table of Contents
1. [Current Testing Status](#current-testing-status)
2. [Testing Strategy](#testing-strategy)
3. [Writing Tests](#writing-tests)
4. [Running Tests](#running-tests)
5. [Best Practices](#best-practices)
6. [Coverage Metrics](#coverage-metrics)
7. [Troubleshooting](#troubleshooting)
8. [Roadmap](#roadmap)

## Current Testing Status

### Overview
- **Total Tests**: 585
- **Passing Rate**: 92.3% (540 passing, 45 failing)
- **Core Tests**: 98.5% passing
- **Architecture**: Successfully migrated to service-based architecture
- **Coverage**: ~60% overall (target: 80%)

### Test Distribution
- **Unit Tests**: 420 (71.8%)
- **Widget Tests**: 120 (20.5%)
- **Integration Tests**: 45 (7.7%)

## Testing Strategy

### 1. Test Pyramid
```
         /\
        /  \  Integration (10%)
       /----\
      /      \  Widget Tests (20%)
     /--------\
    /          \  Unit Tests (70%)
   --------------
```

### 2. Priority Order
1. **Critical Business Logic** (services, calculations)
2. **Core UI Components** (forms, navigation)
3. **Integration Flows** (auth, payments)
4. **Edge Cases** (error handling)

### 3. Coverage Goals
- **Services**: 90% minimum
- **Core Widgets**: 80% minimum
- **Utilities**: 95% minimum
- **Overall**: 80% target

## Writing Tests

### Unit Tests - Services

```dart
// test/services/user_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bukeer/services/user_service.dart';

@GenerateMocks([SupabaseClient])
void main() {
  late UserService userService;
  late MockSupabaseClient mockSupabase;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    userService = UserService();
    userService.supabase = mockSupabase;
  });

  group('UserService', () {
    test('should fetch user data successfully', () async {
      // Arrange
      when(mockSupabase.from('users').select().eq('id', '123'))
          .thenAnswer((_) async => {'id': '123', 'name': 'Test User'});

      // Act
      final result = await userService.getUserById('123');

      // Assert
      expect(result['name'], equals('Test User'));
      verify(mockSupabase.from('users').select().eq('id', '123')).called(1);
    });

    test('should handle errors gracefully', () async {
      // Arrange
      when(mockSupabase.from('users').select().eq('id', '123'))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => userService.getUserById('123'),
        throwsException,
      );
    });
  });
}
```

### Widget Tests

```dart
// test/widgets/core/buttons/bukeer_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/design_system/components/buttons/bukeer_button.dart';

void main() {
  group('BukeerButton', () {
    testWidgets('renders correctly and handles tap', (tester) async {
      // Arrange
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BukeerButton(
              text: 'Test Button',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Assert initial state
      expect(find.text('Test Button'), findsOneWidget);
      expect(wasPressed, isFalse);

      // Act
      await tester.tap(find.byType(BukeerButton));
      await tester.pump();

      // Assert
      expect(wasPressed, isTrue);
    });

    testWidgets('shows loading state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BukeerButton(
              text: 'Test Button',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });
  });
}
```

### Integration Tests

```dart
// test/integration/auth_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bukeer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration', () {
    testWidgets('complete login flow', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Enter credentials
      await tester.enterText(
        find.byKey(Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(Key('password_field')),
        'password123',
      );

      // Submit
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byKey(Key('home_screen')), findsOneWidget);
    });
  });
}
```

## Running Tests

### Basic Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/user_service_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run tests in watch mode
flutter test --watch
```

### Coverage Reports

```bash
# Generate coverage report
flutter test --coverage

# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html

# Check coverage percentage
lcov --summary coverage/lcov.info
```

### Useful Scripts

```bash
# Run core tests only
flutter test test/services test/core

# Run tests with custom reporter
flutter test --reporter expanded

# Run tests in parallel
flutter test -j 4

# Generate mocks
flutter pub run build_runner build --delete-conflicting-outputs
```

## Best Practices

### 1. Test Organization

```
test/
├── services/           # Service tests
├── widgets/           
│   ├── core/          # Core widget tests
│   └── features/      # Feature-specific widgets
├── integration/       # Integration tests
├── mocks/            # Shared mocks
├── test_utils/       # Test helpers
└── fixtures/         # Test data
```

### 2. Naming Conventions

```dart
// Test file: {file_name}_test.dart
// Test groups: describe what is being tested
// Test names: should + expected behavior

group('UserService', () {
  group('getUserById', () {
    test('should return user data when ID exists', () {});
    test('should throw exception when ID not found', () {});
  });
});
```

### 3. Test Helpers

```dart
// test/test_utils/test_helpers.dart
class TestHelpers {
  static Widget wrapWithMaterial(Widget widget) {
    return MaterialApp(
      home: Scaffold(body: widget),
    );
  }

  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(timeout);
  }
}
```

### 4. Mock Best Practices

```dart
// Use @GenerateMocks for type-safe mocks
@GenerateMocks([
  SupabaseClient,
  UserService,
  ProductService,
])
void main() {
  // Always reset mocks in tearDown
  tearDown(() {
    reset(mockService);
  });
}
```

### 5. Async Testing

```dart
// Always use async/await properly
test('async operation', () async {
  // ✅ Good
  final result = await service.fetchData();
  expect(result, isNotNull);

  // ❌ Bad - missing await
  // expect(service.fetchData(), completion(isNotNull));
});
```

## Coverage Metrics

### Current Coverage by Module

| Module | Coverage | Target |
|--------|----------|--------|
| Services | 75% | 90% |
| Core Widgets | 65% | 80% |
| Utils | 85% | 95% |
| Features | 45% | 70% |
| **Overall** | **60%** | **80%** |

### Coverage Guidelines

1. **New Code**: Minimum 80% coverage
2. **Critical Paths**: 95% coverage required
3. **UI Components**: 70% minimum
4. **Utilities**: 95% minimum

## Troubleshooting

### Common Issues

#### 1. Import Conflicts
```bash
# Fix duplicate imports
dart run scripts/fix_duplicate_imports.dart
```

#### 2. Mock Generation Fails
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. Timing Issues
```dart
// Use pumpAndSettle with timeout
await tester.pumpAndSettle(
  const Duration(seconds: 5),
);
```

#### 4. State Not Updating
```dart
// Ensure proper state management
await tester.runAsync(() async {
  // Async operations here
});
await tester.pumpAndSettle();
```

### Known Issues

1. **Supabase 2.3.0 Mock Issues**
   - Solution: Update mock generation annotations
   - See: `test/mocks/supabase_mocks.dart`

2. **Widget Test Overflow**
   - Solution: Wrap in sized containers
   - Use: `TestHelpers.wrapWithConstraints()`

3. **Integration Test Flakiness**
   - Solution: Add proper waits
   - Use: `tester.pumpAndSettle()` liberally

## Roadmap

### Q1 2025
- [ ] Achieve 80% overall coverage
- [ ] Implement E2E tests with Maestro
- [ ] Add performance testing suite
- [ ] Create test data factories

### Q2 2025
- [ ] Achieve 90% service coverage
- [ ] Add visual regression tests
- [ ] Implement mutation testing
- [ ] Create testing dashboard

### Best Practices Evolution
- [ ] Document new patterns monthly
- [ ] Update mock strategies
- [ ] Review and refactor test utilities
- [ ] Maintain test performance

---

For questions or contributions, see [CONTRIBUTING.md](./CONTRIBUTING.md)