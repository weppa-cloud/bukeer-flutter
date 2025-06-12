# Arquitectura del Proyecto Bukeer

## Visión General

Bukeer es una plataforma integral de gestión de viajes y turismo desarrollada con Flutter. Es un sistema diseñado para agencias de viajes que permite gestionar itinerarios personalizados, productos turísticos, clientes, reservas y pagos.

### Stack Tecnológico
- **Frontend**: Flutter 3.32.0 (Web, iOS, Android, macOS)
- **Backend**: Supabase (PostgreSQL + Auth + Storage + Edge Functions)
- **Navegación**: GoRouter 13.2.0
- **Estado**: Provider 6.0 + Servicios modulares
- **UI/UX**: Sistema de diseño propio + FlutterFlow (legacy)
- **PWA**: Service Workers + Web APIs modernas

## Índice

1. [Estructura de Carpetas](#estructura-de-carpetas)
2. [Arquitectura de Servicios](#arquitectura-de-servicios)
3. [Sistema de Diseño](#sistema-de-diseño)
4. [Gestión de Estado](#gestión-de-estado)
5. [Sistema de Navegación](#sistema-de-navegación)
6. [Sistema de Errores](#sistema-de-errores)
7. [Optimización de Performance](#optimización-de-performance)
8. [Progressive Web App (PWA)](#progressive-web-app-pwa)
9. [Integración con Supabase](#integración-con-supabase)
10. [Testing](#testing)
11. [Deployment](#deployment)
12. [Flujo de Desarrollo](#flujo-de-desarrollo)
13. [Convenciones y Patrones](#convenciones-y-patrones)
14. [Seguridad](#seguridad)
15. [Migraciones Completadas](#migraciones-completadas)

## Estructura de Carpetas

### Estructura Actual (2025)

```
lib/
├── bukeer/                    # Módulos principales de la aplicación
│   ├── agenda/               # Gestión de agenda
│   ├── componentes/          # Componentes compartidos globales
│   ├── contactos/            # Gestión de contactos y cuentas
│   ├── dashboard/            # Paneles de control y reportes
│   ├── itinerarios/          # Gestión de itinerarios (módulo más complejo)
│   ├── productos/            # Gestión de productos turísticos
│   └── users/                # Gestión de usuarios y autenticación
│
├── app_state.dart            # Estado global (DEPRECATED - usar servicios)
├── auth/                     # Autenticación con Supabase
├── backend/                  # Esquemas y APIs
├── components/               # Componentes nuevos del sistema
├── config/                   # Configuración de la app
├── custom_code/              # Acciones y widgets personalizados
├── design_system/            # Sistema de diseño Bukeer v2.0
├── legacy/                   # Código legacy de FlutterFlow (en desuso)
│   └── flutter_flow/         # Utilidades FlutterFlow originales
├── navigation/               # Navegación con GoRouter + guards
├── providers/                # Providers de la aplicación
├── services/                 # Arquitectura de servicios modular
└── components/               # Componentes compartidos globales
    ├── pwa/                  # Componentes PWA
    └── error_handling/       # Componentes de manejo de errores
```

## Arquitectura de Servicios

### Servicios Core

La aplicación utiliza una arquitectura basada en servicios que centraliza la lógica de negocio y el estado:

```dart
final appServices = AppServices();

// Servicios disponibles:
appServices.ui           // UiStateService - Estado temporal de UI
appServices.user         // UserService - Gestión de usuarios
appServices.itinerary    // ItineraryService - Gestión de itinerarios
appServices.product      // ProductService - Gestión de productos
appServices.contact      // ContactService - Gestión de contactos
appServices.authorization // AuthorizationService - Control de acceso
appServices.error        // ErrorService - Manejo centralizado de errores
appServices.performance  // PerformanceService - Monitoreo y optimización
appServices.cache        // SmartCacheService - Cache inteligente
appServices.pwa          // PWAService - Funcionalidades PWA
```

### Performance Optimized Service

Mixin que proporciona optimización automática a los servicios:

```dart
// Características:
- Batched notifications (agrupa notifyListeners)
- Rate limiting configurable
- Widget rebuild tracking
- Memory monitoring
- Performance metrics
```

## Sistema de Diseño

### Design System v2.0

Sistema completo de design tokens y componentes reutilizables:

#### Estructura
```
design_system/
├── tokens/              # Design tokens
│   ├── colors.dart      # Paleta de colores + modo oscuro
│   ├── typography.dart  # Sistema tipográfico
│   ├── spacing.dart     # Sistema de espaciado (4px base)
│   ├── elevation.dart   # Sombras y elevación
│   ├── borders.dart     # Radios y bordes
│   └── animations.dart  # Duraciones y curvas
├── components/          # Componentes del sistema
│   ├── buttons/         # BukeerButton, BukeerIconButton, BukeerFAB
│   ├── cards/           # BukeerServiceCard, BukeerItineraryCard
│   ├── forms/           # BukeerTextField, validadores
│   └── navigation/      # BukeerNavigation responsive
└── themes/              # Temas light/dark
```

#### Uso
```dart
import 'package:bukeer/design_system/index.dart';

// Tokens
BukeerColors.primary
BukeerTypography.headlineLarge
BukeerSpacing.m  // 16px
BukeerElevation.shadow1
BukeerBorderRadius.md  // 8px

// Responsive
if (BukeerBreakpoints.isMobile(context)) { }
```

## Gestión de Estado

### Arquitectura de Estado

1. **Estado Global**: Servicios con ChangeNotifier
2. **Estado Local**: FlutterFlowModel para componentes
3. **Estado UI Temporal**: UiStateService
4. **Cache**: SmartCacheService con TTL

### Migración desde FFAppState

Migración completada con 94% de reducción en estado global:

```dart
// ❌ Antiguo (evitar)
FFAppState().searchStringState = 'query';

// ✅ Nuevo
appServices.ui.searchQuery = 'query';
```

### Performance

- Batched notifications reduce rebuilds en 50-70%
- Smart cache evita queries redundantes
- Memory manager limpia recursos automáticamente

## Sistema de Navegación

### GoRouter Implementation

```dart
// Configuración en modern_router.dart
final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  observers: [NavigationObserver()],
  redirect: (context, state) => authGuard(context, state),
  routes: [
    ShellRoute(
      builder: (context, state, child) => NavigationShell(child: child),
      routes: appRoutes,
    ),
  ],
);
```

### Navegación Responsive

- **Desktop**: Sidebar persistente
- **Mobile**: Bottom navigation + drawer
- **Tablet**: Sidebar colapsable

### Guards y Redirecciones

```dart
// Auth guard
if (!currentUser.loggedIn) return '/login';

// Permission guard  
if (!appServices.authorization.canAccess('admin')) {
  return '/unauthorized';
}
```
## Sistema de Errores

### ErrorService Architecture

```dart
// Categorización de errores
enum ErrorCategory {
  network,      // Problemas de conexión
  api,          // Errores de API/Supabase
  validation,   // Validación de datos
  permission,   // Permisos insuficientes
  notFound,     // Recursos no encontrados
  unknown       // Errores no categorizados
}

// Manejo centralizado
appServices.error.handleError(
  error,
  context,
  category: ErrorCategory.api,
  severity: ErrorSeverity.medium,
  userMessage: 'No se pudo cargar los productos',
  suggestedAction: 'Verificar conexión',
);
```

### UI Components

- **ErrorAwareApp**: Wrapper global para catching
- **ErrorHandlerWidget**: Display de errores inline
- **ErrorFeedbackSystem**: Reporte de usuarios
- **ErrorMonitoringDashboard**: Analytics en tiempo real

## Optimización de Performance

### PerformanceOptimizedService Mixin

```dart
// Features automáticas para servicios
- Batched notifications (100ms default)
- Rate limiting configurable
- Memory leak detection
- Widget rebuild tracking
- Performance metrics collection
```

### BoundedCache Implementation

```dart
// Cache con límite de memoria
class BoundedCache<K, V> {
  final int maxEntries;
  final Duration? ttl;
  
  // LRU eviction cuando se alcanza límite
  // TTL automático para entradas
  // Memory-aware sizing
}
```

### Memory Manager

```dart
// Monitoreo y limpieza automática
- Tracking de memoria por servicio
- Cleanup automático en dispose
- Alertas de memory leaks
- GC hints optimization
```
## Progressive Web App (PWA)

### Capacidades Implementadas

```dart
// PWAService features
- Install prompts (A2HS)
- Update notifications
- Push notifications
- Offline mode
- Web Share API
- File System Access
- Clipboard API
- Screen Wake Lock
```

### Service Worker

```javascript
// sw_custom.js estrategias
- Cache First: Assets estáticos
- Network First: API calls
- Stale While Revalidate: Imágenes
- Background Sync: Offline actions
```

### Components

- **PWAWrapper**: Container principal
- **PWAInstallBanner**: Prompt de instalación
- **PWAUpdateBanner**: Notificación de updates

## Integración con Supabase

### Arquitectura

```dart
// Cliente singleton
final supabase = Supabase.instance.client;

// RPC optimizadas
final response = await supabase
  .rpc('get_complete_itinerary_details', params: {
    'itinerary_id': id,
  });
```

### RPC Functions

1. **get_complete_itinerary_details**
   - Join optimizado de 15+ tablas
   - Datos paralelos en una query
   - 80% reducción en latencia

2. **get_dashboard_metrics**
   - Agregaciones precalculadas
   - Cache en DB por 5 minutos

### Storage

```dart
// Buckets organizados
- images/products/
- images/itineraries/
- documents/invoices/
- documents/vouchers/
```
## Testing

### Estructura de Tests

```
test/
├── unit/           # Tests unitarios
├── widget/         # Tests de widgets
├── integration/    # Tests E2E
├── services/       # Tests de servicios
└── mocks/          # Mocks compartidos
```

### Stack de Testing

- **Unit**: Flutter test + Mockito
- **Widget**: WidgetTester + golden tests
- **Integration**: Patrol (mobile) + integration_test
- **E2E Web**: Playwright
- **E2E Mobile**: Maestro

### Coverage

- Objetivo: 80% coverage
- CI/CD: Tests obligatorios en PR
- Reporte: LCOV + Codecov

## Deployment

### CapRover Configuration

```dockerfile
# Multi-stage build
FROM debian:latest AS build
# Build Flutter web

FROM nginx:alpine
# Serve static files
# Runtime config injection
```

### Environments

1. **Development**: Local con hot reload
2. **Staging**: CapRover staging instance
3. **Production**: CapRover production cluster

### CI/CD Pipeline

```bash
flow.sh deploy  # Deploy automático
- Build optimization
- Test execution
- Docker build
- CapRover deploy
- Health check
```

## Flujo de Desarrollo

### flow.sh Script

```bash
# Comandos principales
flow dev     # Hot reload desarrollo
flow save    # Auto-commit + push
flow test    # Run all tests
flow pr      # Create pull request
flow deploy  # Deploy a producción
```

### Git Workflow

1. **Feature branches**: `feature/nombre-feature`
2. **Auto-commit**: Mensajes descriptivos automáticos
3. **PR template**: Checklist obligatorio
4. **Protected main**: Reviews requeridos

## Convenciones y Patrones

### Convenciones de Nomenclatura

#### Carpetas
- **snake_case**: Todas las carpetas
- **Prefijos**: `main_`, `modal_`, `component_`

#### Archivos  
- **Widgets**: `nombre_widget.dart`
- **Models**: `nombre_model.dart`
- **Services**: `nombre_service.dart`

#### Clases
- **PascalCase**: `BukeerButton`
- **Sufijos**: `Widget`, `Model`, `Service`

### Principios de Diseño

1. **Modularidad**: Servicios independientes
2. **Reutilización**: Design system components
3. **Performance**: Optimización by default
4. **Accesibilidad**: WCAG AA compliance
5. **Responsive**: Mobile-first approach

### Patrones de Código

```dart
// Service pattern
class ProductService extends ChangeNotifier 
    with PerformanceOptimizedService {
  // Estado privado
  List<Product> _products = [];
  
  // Getters públicos
  List<Product> get products => List.unmodifiable(_products);
  
  // Métodos async
  Future<void> loadProducts() async {
    try {
      _products = await _fetchProducts();
      notifyListeners(); // Batched automáticamente
    } catch (e) {
      appServices.error.handleError(e, context);
    }
  }
}
```

## Seguridad

### Autenticación y Autorización

```dart
// Multi-layer security
1. Supabase Auth (JWT)
2. Row Level Security (RLS) 
3. AuthorizationService (permisos locales)
4. Route Guards (navegación)
```

### Mejores Prácticas

- No hardcodear API keys
- Usar web/config.js para runtime config
- Validación en cliente y servidor
- Sanitización de inputs
- HTTPS obligatorio
- CSP headers configurados

## Migraciones Completadas

### 2024-2025 Timeline

1. **FFAppState → Services** (Completado)
   - 94% reducción estado global
   - 50-70% mejora performance

2. **IDs Integer → String** (Completado)
   - Itinerarios migrados a UUIDs
   - Consistencia con Supabase

3. **FlutterFlow → Native** (En progreso)
   - 80% widgets migrados
   - Design system implementado

4. **Performance Optimization** (Completado)
   - Batched notifications
   - Smart caching
   - Memory management

5. **PWA Implementation** (Completado)
   - Instalable
   - Offline mode
   - Push notifications

## Patrones de Desarrollo

### 1. Componentes Reutilizables

#### Patrón Widget + Model
Cada componente complejo debe seguir el patrón de separación entre UI (Widget) y lógica (Model):

```dart
// widget.dart - Solo UI
class MiComponenteWidget extends StatefulWidget {
  // Props inmutables
  final String titulo;
  final VoidCallback? onTap;
}

// model.dart - Lógica y estado
class MiComponenteModel extends FlutterFlowModel<MiComponenteWidget> {
  // Estado mutable
  String? valorSeleccionado;
  
  // Métodos de negocio
  void procesarDatos() { }
}
```

#### Composición sobre Herencia
Prefiere componer widgets pequeños en lugar de crear jerarquías complejas:

```dart
// ✅ Bueno - Composición
class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ProductImage(...),
          ProductTitle(...),
          ProductPrice(...),
          AddToCartButton(...),
        ],
      ),
    );
  }
}

// ❌ Evitar - Herencia profunda
class ProductCard extends BaseCard extends CustomWidget extends... { }
```

### 2. Gestión de Estado

#### Estado Global con Servicios
Usa los servicios centralizados para estado compartido:

```dart
// Para datos del usuario
final userName = appServices.user.getAgentInfo(r'$[:].name');

// Para UI temporal
appServices.ui.searchQuery = 'búsqueda';
appServices.ui.setSelectedLocation(name: 'Miami');

// Para datos de negocio
final products = await appServices.product.searchAllProducts('hotel');
```

#### Estado Local con Model
Para estado específico del componente:

```dart
class SearchBoxModel extends FlutterFlowModel<SearchBoxWidget> {
  // Estado local del componente
  final searchController = TextEditingController();
  String lastSearch = '';
  
  void onSearch(String query) {
    if (query != lastSearch) {
      lastSearch = query;
      // Actualizar servicio global
      appServices.ui.searchQuery = query;
    }
  }
}
```

### 3. Manejo de Errores

#### Try-Catch Consistente
```dart
Future<void> loadData() async {
  try {
    _model.isLoading = true;
    final data = await appServices.product.getProducts();
    _model.products = data;
  } catch (e) {
    appServices.error.handleError(e, context);
  } finally {
    _model.isLoading = false;
    setState(() {});
  }
}
```

#### Validación de Datos
```dart
// Validar antes de procesar
if (formKey.currentState?.validate() ?? false) {
  // Procesar datos válidos
  await submitForm();
} else {
  // Mostrar errores de validación
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Por favor corrige los errores')),
  );
}
```

### 4. Navegación y Rutas

#### Navegación Declarativa
```dart
// Usar nombres de rutas constantes
context.pushNamed(
  RouteNames.productDetails,
  pathParameters: {'id': product.id},
  queryParameters: {'edit': 'true'},
);

// Con datos complejos
context.pushNamed(
  RouteNames.itineraryDetails,
  extra: itineraryData, // Objetos complejos en 'extra'
);
```

#### Guards de Navegación
```dart
// En route_definitions.dart
GoRoute(
  path: '/admin',
  builder: (context, state) => AdminPage(),
  redirect: (context, state) {
    if (!appServices.user.isAdmin) {
      return '/unauthorized';
    }
    return null;
  },
),
```

### 5. Formularios

#### Validación Consistente
```dart
TextFormField(
  controller: _model.emailController,
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'Email requerido';
    }
    if (!EmailValidator.validate(value!)) {
      return 'Email inválido';
    }
    return null;
  },
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'ejemplo@correo.com',
  ),
)
```

#### Manejo de Focus
```dart
// Definir FocusNodes
final emailFocus = FocusNode();
final passwordFocus = FocusNode();

// Navegar entre campos
TextFormField(
  focusNode: emailFocus,
  textInputAction: TextInputAction.next,
  onFieldSubmitted: (_) {
    FocusScope.of(context).requestFocus(passwordFocus);
  },
)
```

### 6. Listas y Performance

#### ListView.builder para Listas Grandes
```dart
// ✅ Eficiente - Solo construye items visibles
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)

// ❌ Ineficiente para listas grandes
Column(
  children: products.map((p) => ProductCard(product: p)).toList(),
)
```

#### Optimización con Keys
```dart
// Usar keys para preservar estado en listas dinámicas
ListView.builder(
  itemBuilder: (context, index) {
    final item = items[index];
    return ProductCard(
      key: ValueKey(item.id), // Preserva estado al reordenar
      product: item,
    );
  },
)
```

### 7. Async/Await y Futures

#### Manejo de Operaciones Asíncronas
```dart
// Cargar datos en initState
@override
void initState() {
  super.initState();
  // No bloquear initState
  SchedulerBinding.instance.addPostFrameCallback((_) {
    loadInitialData();
  });
}

Future<void> loadInitialData() async {
  try {
    await Future.wait([
      loadProducts(),
      loadCategories(),
      loadUserPreferences(),
    ]);
  } catch (e) {
    // Manejar error
  }
}
```

### 8. Widgets Responsivos

#### Breakpoints Consistentes
```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    if (responsiveVisibility(
      context: context,
      phone: false,
      desktop: true,
    )) {
      return desktop;
    } else if (tablet != null && responsiveVisibility(
      context: context,
      phone: false,
      tablet: true,
    )) {
      return tablet!;
    }
    return mobile;
  }
}
```

## Seguridad

- Autenticación via Supabase Auth
- Row Level Security (RLS) en PostgreSQL
- Validación de permisos en AuthorizationService
- No hardcodear API keys (usar web/config.js)