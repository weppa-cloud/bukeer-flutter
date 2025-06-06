# 🚀 Bukeer Flutter - Workflow de Desarrollo

## 📋 Índice

- [🏗️ Setup de Desarrollo](#️-setup-de-desarrollo)
- [🔄 Flujo de Trabajo Diario](#-flujo-de-trabajo-diario)
- [🎯 Patrones de Código](#-patrones-de-código)
- [🧪 Testing Guidelines](#-testing-guidelines)
- [📊 Performance Guidelines](#-performance-guidelines)
- [🔧 Debugging y Troubleshooting](#-debugging-y-troubleshooting)

---

## 🏗️ Setup de Desarrollo

### Prerequisitos
```bash
# Versiones requeridas
Flutter: 3.29.2+
Dart: 3.6.0+
```

### Configuración Inicial
```bash
# 1. Clonar e instalar dependencias
git clone <repo>
cd bukeer-flutter
flutter pub get

# 2. Configurar variables de entorno
cp .env.example .env
# Editar .env con las configuraciones necesarias

# 3. Verificar setup
flutter doctor
flutter test

# 4. Ejecutar en desarrollo
flutter run -d chrome --dart-define-from-file=.env
```

### Estructura de Archivos Recomendada
```
lib/
├── services/           # Servicios principales (NO TOCAR sin revisar)
│   ├── ui_state_service.dart
│   ├── user_service.dart
│   ├── performance_optimized_service.dart
│   └── app_services.dart
├── bukeer/            # Módulos de negocio
│   ├── dashboard/
│   ├── itinerarios/
│   ├── productos/
│   └── contactos/
├── components/        # Componentes reutilizables
└── custom_code/       # Código personalizado FlutterFlow
```

---

## 🔄 Flujo de Trabajo Diario

### 1. **Antes de Empezar a Codificar**
```bash
# Actualizar rama principal
git checkout main
git pull origin main

# Crear rama feature
git checkout -b feature/nombre-descriptivo

# Verificar tests pasan
flutter test
```

### 2. **Durante el Desarrollo**

#### ✅ DO's
- Usar `appServices.serviceName` para acceder a servicios
- Implementar tests para lógica nueva
- Usar `AuthorizedWidget` para permisos
- Seguir patrones existentes de naming
- Usar `Selector` para granular rebuilds

#### ❌ DON'Ts  
- NO usar `FFAppState()` directamente (usar servicios)
- NO crear variables globales nuevas
- NO hacer dispose manual de servicios (automático)
- NO ignorar warnings de performance dashboard
- NO commitear sin ejecutar tests

### 3. **Antes de Hacer Commit**
```bash
# Ejecutar todos los tests
flutter test

# Verificar análisis estático
flutter analyze

# Formatear código
dart format .

# Commit con mensaje descriptivo
git add .
git commit -m "feat: descripción clara del cambio"
```

---

## 🎯 Patrones de Código

### 1. **Acceso a Servicios**

#### ✅ Correcto
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiStateService>(
      builder: (context, uiState, child) {
        return TextField(
          value: uiState.searchQuery,
          onChanged: (value) => uiState.searchQuery = value,
        );
      },
    );
  }
}

// O usando el singleton global
class MyBusinessLogic {
  void searchProducts(String query) {
    appServices.ui.searchQuery = query;
    appServices.product.searchAllProducts(query);
  }
}
```

#### ❌ Incorrecto
```dart
// NO USAR - Patrón obsoleto
FFAppState().searchStringState = query;
FFAppState().notifyListeners();
```

### 2. **Crear Nuevas Páginas/Widgets**

```dart
// 1. Widget básico con servicios
class NewPageWidget extends StatefulWidget {
  const NewPageWidget({Key? key}) : super(key: key);

  @override
  State<NewPageWidget> createState() => _NewPageWidgetState();
}

class _NewPageWidgetState extends State<NewPageWidget> {
  @override
  void initState() {
    super.initState();
    // Inicialización si es necesaria
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Página')),
      body: Column(
        children: [
          // Usar Selector para granular updates
          Selector<UiStateService, String>(
            selector: (context, ui) => ui.searchQuery,
            builder: (context, searchQuery, child) {
              return SearchField(
                value: searchQuery,
                onChanged: (value) => appServices.ui.searchQuery = value,
              );
            },
          ),
          
          // Autorización
          AuthorizedWidget(
            requiredPermissions: ['resource:action'],
            child: ActionButton(),
            fallback: const Text('Sin permisos'),
          ),
        ],
      ),
    );
  }
}
```

### 3. **Manejo de Estados de Carga**

```dart
class DataListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ServiceBuilder<ProductService>(
      service: appServices.product,
      loadingWidget: const CircularProgressIndicator(),
      errorBuilder: (error) => Text('Error: $error'),
      builder: (context, service) {
        return ListView.builder(
          itemCount: service.products.length,
          itemBuilder: (context, index) {
            final product = service.products[index];
            return ProductCard(product: product);
          },
        );
      },
    );
  }
}
```

### 4. **Implementar Autorización**

```dart
// En widgets
AuthorizedButton(
  onPressed: () => deleteItem(),
  requiredRoles: [RoleType.admin],
  requiredPermissions: ['item:delete'],
  child: const Text('Eliminar'),
)

// En lógica de negocio
Future<void> performSensitiveAction() async {
  if (!await appServices.authorization.authorize(
    userId: currentUserUid,
    resourceType: 'item',
    action: 'delete',
  )) {
    throw UnauthorizedException('Sin permisos para esta acción');
  }
  
  // Proceder con la acción
}
```

---

## 🧪 Testing Guidelines

### 1. **Tests Unitarios para Servicios**

```dart
// test/services/my_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/my_service.dart';

void main() {
  group('MyService', () {
    late MyService service;

    setUp(() {
      service = MyService();
    });

    tearDown(() {
      service.dispose();
    });

    test('should initialize correctly', () {
      expect(service.isLoading, isFalse);
      expect(service.data, isEmpty);
    });

    test('should load data successfully', () async {
      await service.loadData();
      
      expect(service.isLoading, isFalse);
      expect(service.data, isNotEmpty);
    });
  });
}
```

### 2. **Tests de Widgets**

```dart
// test/widgets/my_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:bukeer/bukeer/my_widget.dart';
import 'package:bukeer/services/ui_state_service.dart';

void main() {
  group('MyWidget', () {
    late UiStateService uiStateService;

    setUp(() {
      uiStateService = UiStateService();
    });

    tearDown(() {
      uiStateService.dispose();
    });

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: uiStateService),
          ],
          child: MaterialApp(
            home: MyWidget(),
          ),
        ),
      );

      expect(find.byType(MyWidget), findsOneWidget);
    });
  });
}
```

### 3. **Ejecutar Tests**

```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/services/
flutter test test/widgets/my_widget_test.dart

# Tests con coverage
flutter test --coverage
```

---

## 📊 Performance Guidelines

### 1. **Monitoreo de Performance**

```dart
// Activar en desarrollo
void main() {
  if (kDebugMode) {
    MemoryManager.instance.startMonitoring();
  }
  runApp(PerformanceAwareApp(child: MyApp()));
}
```

### 2. **Optimización de Widgets**

#### ✅ Usar Selector para Updates Granulares
```dart
// En lugar de escuchar todo el servicio
Selector<UiStateService, String>(
  selector: (context, ui) => ui.searchQuery,
  builder: (context, searchQuery, child) => Text(searchQuery),
)
```

#### ✅ Usar PerformanceSelector
```dart
PerformanceSelector<ProductService, List<Product>>(
  listenable: appServices.product,
  selector: (service) => service.filteredProducts,
  builder: (context, products) => ProductList(products: products),
)
```

### 3. **Métricas a Monitorear**

- **Widget Rebuilds**: >10 rebuilds indica problema
- **Notification Efficiency**: Target >80% batching
- **Memory Usage**: Crecimiento estable
- **Cache Hit Rate**: Target >70%

---

## 🔧 Debugging y Troubleshooting

### 1. **Performance Dashboard**

```dart
// Solo aparece en modo debug
// Floating button naranja en la esquina superior derecha
// Muestra en tiempo real:
// - Estadísticas de servicios
// - Widget rebuilds frecuentes  
// - Uso de memoria y cache
// - Tiempos de operaciones
```

### 2. **Comandos de Debug Útiles**

```bash
# Logs detallados de Flutter
flutter logs

# Restart completo
flutter restart

# Hot reload
r (en terminal de flutter run)

# Limpiar y reconstruir
flutter clean && flutter pub get && flutter run
```

### 3. **Problemas Comunes y Soluciones**

#### ❌ Error: "No se puede acceder al servicio"
```dart
// Solución: Verificar que el servicio esté registrado en Providers
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UiStateService()),
    Provider(create: (_) => UserService()),
  ],
)
```

#### ❌ Widget rebuilding demasiado
```dart
// Problema: Listening al servicio completo
Consumer<UiStateService>(builder: ...)

// Solución: Usar Selector granular
Selector<UiStateService, String>(
  selector: (context, ui) => ui.specificProperty,
  builder: (context, value, child) => ...,
)
```

#### ❌ Memory leaks
```dart
// Problema: No dispose de listeners
@override
void dispose() {
  // Falta cleanup
  super.dispose();
}

// Solución: Los servicios optimizados se autolimpian
// O usar addManagedTimer/addManagedSubscription
```

### 4. **Logs Útiles para Debug**

```dart
// Performance stats de servicios
if (kDebugMode) {
  final stats = appServices.ui.getPerformanceStats();
  debugPrint('🎯 UiStateService: $stats');
}

// Memory monitoring
final memStats = MemoryManager.instance.getStats();
debugPrint('📊 Memory: $memStats');

// Widget rebuild tracking
final rebuilds = WidgetRebuildTracker.getRebuildStats();
debugPrint('🔄 Rebuilds: $rebuilds');
```

---

## 🎯 Checklist de Desarrollo

### Antes de crear PR:
- [ ] Tests unitarios pasan
- [ ] Tests de integración pasan
- [ ] Flutter analyze sin warnings críticos
- [ ] Performance dashboard sin alertas rojas
- [ ] Código formateado con `dart format`
- [ ] Documentación actualizada si necesario
- [ ] Autorización implementada para features sensibles

### Code Review Checklist:
- [ ] ¿Usa servicios en lugar de FFAppState?
- [ ] ¿Implementa autorización donde necesario?
- [ ] ¿Usa Selector para updates granulares?
- [ ] ¿Tiene tests para lógica nueva?
- [ ] ¿Sigue patrones de naming consistentes?
- [ ] ¿Maneja estados de error apropiadamente?

---

*Última actualización: $(date)*
*Para dudas técnicas, consultar NEW_ARCHITECTURE_GUIDE.md*