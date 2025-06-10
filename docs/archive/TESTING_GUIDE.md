# 📖 Guía de Testing - Bukeer Flutter

**Última actualización**: 6 de Enero de 2025  
**Versión**: 1.0  
**Estado**: ✅ Sistema de testing funcional post-migración

## 📊 Estado Actual del Sistema de Testing

### Resumen de Métricas
- **Tests totales**: 585 (227 testWidgets + 358 test)
- **Tasa de éxito**: 92.3% (migración a nueva arquitectura completada)
- **Cobertura estimada**: 85%+
- **Tests core funcionando**: 98.5% (64/65 pasando)
- **Servicios con tests**: 7/7 servicios principales

### Migración Completada
- ✅ **94% reducción** en referencias FFAppState
- ✅ **62+ tests automatizados** funcionando
- ✅ **Arquitectura de servicios** completamente operativa
- ✅ **Sistema de notificaciones optimizado** (batching 16ms)

## 🏗️ Estructura del Sistema de Testing

```
test/
├── api/                    # Tests de API y llamadas HTTP
├── components/             # Tests de componentes generales
├── custom_actions/         # Tests de acciones personalizadas
├── error_handling/         # Tests de manejo de errores
├── forms/                  # Tests de validación de formularios
├── integration/            # Tests de integración end-to-end
├── mocks/                  # Mocks compartidos con Mockito
├── performance/            # Tests de rendimiento y memoria
├── services/               # Tests de servicios (arquitectura nueva)
├── stubs/                  # Stubs de servicios para testing
├── test_utils/             # Utilidades y helpers de testing
└── widgets/                # Tests de widgets
    └── core/              # Tests de widgets del core
        ├── buttons/       # Tests de botones
        ├── forms/         # Tests de formularios
        └── navigation/    # Tests de navegación
```

## 🎯 Cómo Escribir Tests

### 1. Tests de Servicios (Nueva Arquitectura)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/services/ui_state_service.dart';

void main() {
  late AppServices appServices;
  late UiStateService uiService;

  setUp(() {
    // Inicializar servicios para testing
    appServices = AppServices();
    uiService = appServices.ui;
  });

  tearDown(() {
    // Limpiar recursos
    uiService.dispose();
  });

  group('UiStateService', () {
    test('should update search query with debouncing', () async {
      // Arrange
      final results = <String>[];
      uiService.addListener(() {
        results.add(uiService.searchQuery);
      });

      // Act
      uiService.searchQuery = 'hotel';
      uiService.searchQuery = 'hotel en';
      uiService.searchQuery = 'hotel en playa';

      // Assert - debouncing debe resultar en una sola notificación
      await Future.delayed(Duration(milliseconds: 350));
      expect(results.length, 1);
      expect(results.last, 'hotel en playa');
    });
  });
}
```

### 2. Tests de Widgets

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:bukeer/bukeer/core/widgets/buttons/btn_create/btn_create_widget.dart';
import 'package:bukeer/services/app_services.dart';

void main() {
  late AppServices appServices;

  setUp(() {
    appServices = AppServices();
  });

  tearDown(() {
    appServices.dispose();
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appServices.ui),
        ChangeNotifierProvider.value(value: appServices.user),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('BtnCreateWidget displays correctly', (tester) async {
    // Arrange & Act
    await tester.pumpWidget(createTestWidget(BtnCreateWidget()));

    // Assert
    expect(find.byType(BtnCreateWidget), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
```

### 3. Tests de Integración

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bukeer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo de Login', () {
    testWidgets('Usuario puede hacer login exitosamente', (tester) async {
      // Iniciar app
      app.main();
      await tester.pumpAndSettle();

      // Encontrar campos de login
      final emailField = find.byKey(Key('emailField'));
      final passwordField = find.byKey(Key('passwordField'));
      final loginButton = find.byKey(Key('loginButton'));

      // Ingresar credenciales
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verificar navegación exitosa
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
```

### 4. Tests con Mocks

```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bukeer/backend/supabase/supabase.dart';

@GenerateMocks([SupaFlow])
void main() {
  late MockSupaFlow mockSupabase;

  setUp(() {
    mockSupabase = MockSupaFlow();
  });

  test('should fetch itineraries from Supabase', () async {
    // Arrange
    when(mockSupabase.client).thenReturn(mockClient);
    when(mockClient.from('itineraries').select())
        .thenAnswer((_) async => [
              {'id': '1', 'name': 'Test Itinerary'}
            ]);

    // Act & Assert
    final result = await service.fetchItineraries();
    expect(result.length, 1);
    expect(result.first['name'], 'Test Itinerary');
  });
}
```

## 📋 Estrategia de Testing

### Niveles de Testing

1. **Unit Tests** (70% del esfuerzo)
   - Tests de servicios individuales
   - Tests de funciones utilitarias
   - Tests de lógica de negocio
   - Validaciones y cálculos

2. **Widget Tests** (20% del esfuerzo)
   - Tests de renderizado de componentes
   - Tests de interacción de usuario
   - Tests de estados de widgets
   - Tests de navegación

3. **Integration Tests** (10% del esfuerzo)
   - Flujos completos de usuario
   - Tests end-to-end
   - Tests de performance
   - Tests de regresión

### Prioridad de Testing

#### Alta Prioridad
- ✅ Servicios core (UiStateService, UserService, etc.)
- ✅ Flujos críticos (login, creación de itinerarios)
- ✅ Cálculos financieros y validaciones
- ✅ Manejo de errores

#### Media Prioridad
- ⚡ Componentes de UI reutilizables
- ⚡ Integraciones con APIs externas
- ⚡ Flujos secundarios de usuario
- ⚡ Performance optimizations

#### Baja Prioridad
- 📌 Componentes puramente visuales
- 📌 Animaciones y transiciones
- 📌 Features experimentales

## 🛠️ Comandos Útiles

### Ejecutar Tests

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ejecutar tests de un archivo específico
flutter test test/services/ui_state_service_test.dart

# Ejecutar tests con más detalle
flutter test --reporter expanded

# Ejecutar solo tests que coincidan con un patrón
flutter test --name "should update search"

# Ejecutar tests en modo watch
flutter test --watch
```

### Tests de Integración

```bash
# Ejecutar tests de integración
flutter test integration_test/

# Ejecutar en un dispositivo específico
flutter test integration_test/ -d chrome
flutter test integration_test/ -d ios

# Con screenshots en fallos
flutter test integration_test/ --screenshot
```

### Análisis de Cobertura

```bash
# Generar reporte de cobertura
flutter test --coverage

# Ver cobertura en HTML (requiere lcov)
genhtml coverage/lcov.info -o coverage/html

# Abrir reporte en navegador
open coverage/html/index.html
```

### Generación de Mocks

```bash
# Generar mocks con build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode para regenerar automáticamente
flutter pub run build_runner watch
```

## 📊 Mejores Prácticas

### 1. Organización de Tests

```dart
void main() {
  group('NombreDelServicio', () {
    group('funcionalidad específica', () {
      test('descripción clara del comportamiento esperado', () {
        // Arrange - preparar datos
        // Act - ejecutar acción
        // Assert - verificar resultado
      });
    });
  });
}
```

### 2. Naming Convention

- **Archivos**: `nombre_servicio_test.dart`
- **Groups**: Descriptivos del módulo/feature
- **Tests**: "should [comportamiento esperado] when [condición]"

### 3. Setup y Teardown

```dart
setUp(() {
  // Inicializar antes de cada test
});

tearDown(() {
  // Limpiar después de cada test
  // MUY IMPORTANTE: dispose de timers y subscriptions
});

setUpAll(() {
  // Inicializar una vez antes de todos los tests
});

tearDownAll(() {
  // Limpiar una vez después de todos los tests
});
```

### 4. Helpers de Testing

```dart
// test_utils/test_helpers.dart
class TestHelpers {
  static Widget wrapWithProviders(Widget child) {
    final appServices = AppServices();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appServices.ui),
        ChangeNotifierProvider.value(value: appServices.user),
        // ... otros providers
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
  
  static Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    // Implementación de pump hasta encontrar widget
  }
}
```

### 5. Testing de Estados Async

```dart
test('should handle async operations', () async {
  // Para Futures
  expect(service.fetchData(), completion(equals(expectedData)));
  
  // Para Streams
  expect(
    service.dataStream,
    emitsInOrder([data1, data2, data3]),
  );
  
  // Con timeout
  await expectLater(
    service.longOperation(),
    completes,
    timeout: Timeout(Duration(seconds: 30)),
  );
});
```

## 🐛 Problemas Conocidos y Soluciones

### 1. Imports Duplicados

**Problema**: Conflicto entre imports absolutos y de paquete
```dart
// PROBLEMA
import '/design_system/tokens/colors.dart';
import 'package:bukeer/design_system/tokens/colors.dart';
```

**Solución**: Usar script de corrección
```bash
python fix_duplicate_imports.py lib/
```

### 2. APIs de Widgets Obsoletas

**Problema**: Tests usando APIs antiguas de widgets
```dart
// PROBLEMA
textField.decoration?.hintText  // No funciona
```

**Solución**: Actualizar a nueva API
```dart
// CORRECTO
final TextField textField = tester.widget(find.byType(TextField));
final InputDecoration? decoration = textField.decoration;
expect(decoration?.hintText, 'Expected hint');
```

### 3. Timing Issues en Tests

**Problema**: Tests fallan por timing en operaciones async

**Solución**: Usar delays apropiados
```dart
// Para debouncing (300ms)
await Future.delayed(Duration(milliseconds: 350));

// Para batching (16ms)
await Future.delayed(Duration(milliseconds: 20));

// Para animaciones
await tester.pumpAndSettle();
```

## 📈 Métricas de Cobertura Actuales

### Por Módulo

| Módulo | Cobertura | Tests | Estado |
|--------|-----------|-------|--------|
| Services | 92% | 65 | ✅ Excelente |
| Custom Actions | 88% | 21 | ✅ Muy Bueno |
| API | 75% | 15 | ⚡ Bueno |
| Widgets | 60% | 40 | ⚠️ Mejorable |
| Forms | 85% | 12 | ✅ Muy Bueno |
| Error Handling | 95% | 8 | ✅ Excelente |

### Objetivos de Cobertura

- **Mínimo aceptable**: 70%
- **Objetivo**: 85%
- **Ideal**: 95%+ para código crítico

## 🚀 Roadmap de Testing

### Q1 2025
- [ ] Completar migración de widget tests
- [ ] Alcanzar 85% de cobertura global
- [ ] Implementar tests de performance automatizados
- [ ] CI/CD con ejecución automática de tests

### Q2 2025
- [ ] Tests de integración para todos los flujos principales
- [ ] Tests de accesibilidad
- [ ] Tests de localización
- [ ] Benchmarks de performance

### Q3 2025
- [ ] Tests de seguridad
- [ ] Tests de compatibilidad multi-plataforma
- [ ] Tests de regresión visual
- [ ] Monitoreo de tests en producción

## 📚 Recursos Adicionales

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Integration Test Package](https://pub.dev/packages/integration_test)
- [Coverage Package](https://pub.dev/packages/coverage)

## 🤝 Contribuir al Sistema de Testing

1. **Antes de crear un PR**: Asegurar que todos los tests pasen
2. **Nuevas features**: Incluir tests unitarios y de widget
3. **Bug fixes**: Incluir test que reproduzca el bug
4. **Refactoring**: Mantener o mejorar cobertura existente

---

**Última actualización**: 6 de Enero de 2025  
**Mantenido por**: Equipo de Desarrollo Bukeer