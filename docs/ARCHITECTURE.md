# Arquitectura del Proyecto Bukeer

## Índice

1. [Estructura de Carpetas](#estructura-de-carpetas)
2. [Convenciones de Nomenclatura](#convenciones-de-nomenclatura)
3. [Arquitectura de Servicios](#arquitectura-de-servicios)
4. [Plan de Reorganización](#plan-de-reorganización)
5. [Principios de Diseño](#principios-de-diseño)
6. [Patrones de Desarrollo](#patrones-de-desarrollo)
7. [Flujo de Datos](#flujo-de-datos)
8. [Testing](#testing)
9. [Performance](#performance)
10. [Seguridad](#seguridad)

## Estructura de Carpetas

### Estructura Actual (2024)

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
├── design_system/            # Sistema de diseño unificado
├── flutter_flow/             # Utilidades de FlutterFlow
├── navigation/               # Navegación con GoRouter
├── providers/                # Providers de la aplicación
└── services/                 # NUEVA ARQUITECTURA - Servicios modulares
```

## Convenciones de Nomenclatura

### Carpetas
- **snake_case**: Todas las carpetas usan snake_case
- **Prefijos por tipo**:
  - `main_` - Páginas principales
  - `modal_` - Componentes modales
  - `component_` - Componentes reutilizables
  - `dropdown_` - Componentes de selección

### Archivos
- **Patrón estándar**: `[nombre]_widget.dart` y `[nombre]_model.dart`
- **Un componente por carpeta**: Cada componente tiene su propia carpeta

## Arquitectura de Servicios (Nueva)

### Servicios Principales

```dart
// Acceso centralizado a servicios
final appServices = AppServices();

// Servicios disponibles:
- appServices.ui           // Estado temporal de UI
- appServices.user         // Gestión de usuarios
- appServices.itinerary    // Gestión de itinerarios
- appServices.product      // Gestión de productos
- appServices.contact      // Gestión de contactos
- appServices.authorization // Control de acceso
- appServices.error        // Manejo de errores
```

### Migración de FFAppState

El proyecto migró de un estado global monolítico (FFAppState) a servicios especializados:

- **Antes**: `FFAppState().searchStringState`
- **Ahora**: `appServices.ui.searchQuery`

## Plan de Reorganización Futura

### Fase 1: Cambios Inmediatos (Completados ✓)
- [x] Eliminar archivos .bak
- [x] Mover `component_container_activities` → `productos/widgets/`
- [x] Mover `modal_add_edit_itinerary` → `itinerarios/modals/`

### Fase 2: Estructura Core (Completada ✅)
Crear estructura para componentes compartidos:

#### Progreso de Migración:
- [x] Crear estructura `/core/widgets/`
- [x] Implementar sistema de exports centralizados
- [x] Migrar todos los botones → `/core/widgets/buttons/`
- [x] Migrar componentes de navegación → `/core/widgets/navigation/`
- [x] Migrar componentes de formularios → `/core/widgets/forms/`
- [x] Crear archivo de compatibilidad en `/componentes/index.dart`

```
lib/bukeer/
├── core/                     # Nuevo: componentes compartidos
│   ├── widgets/
│   │   ├── navigation/       # web_nav, mobile_nav
│   │   ├── forms/           # date_picker, place_picker
│   │   ├── buttons/         # back, create, menu
│   │   └── containers/      # contenedores genéricos
│   └── utils/
```

### Fase 3: Limpieza y Optimización (Completada ✅)
- [x] Consolidar carpetas "demo" → `/examples/`
- [x] Simplificar nombres redundantes:
  - component_container_activities → activities_container
  - component_container_accounts → accounts_container
  - component_container_contacts → contacts_container
  - component_container_itineraries → itineraries_container
  - component_container_flights → flights_container
  - component_container_hotels → hotels_container
  - component_container_transfers → transfers_container
- [x] Verificar rutas y navegación

### Fase 4: Estandarización (Pendiente - Largo Plazo)
- [ ] Migración gradual a nombres en inglés
- [ ] Unificar convenciones de nomenclatura
- [ ] Documentar patrones de desarrollo

## Principios de Diseño

1. **Modularidad**: Cada módulo de negocio es independiente
2. **Reutilización**: Componentes compartidos en `/core/`
3. **Escalabilidad**: Estructura que permite crecimiento sin refactoring mayor
4. **Claridad**: Nombres descriptivos y organización lógica
5. **Consistencia**: Patrones uniformes en toda la aplicación

## Flujo de Datos

```
Usuario → UI Component → Service → Supabase → PostgreSQL
            ↓               ↓
         UI Model      App State
```

## Testing

- Tests unitarios en `/test/`
- Estructura espejo de `/lib/`
- Mocks generados con Mockito
- Coverage mínimo esperado: 70%

## Performance

- Lazy loading de módulos
- Smart caching en servicios
- Gestión de memoria con cleanup automático
- Optimización de rebuilds con state management eficiente

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