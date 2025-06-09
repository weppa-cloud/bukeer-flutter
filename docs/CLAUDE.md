# Proyecto Bukeer - Documentación para Claude

## Resumen del Proyecto

Bukeer es una plataforma integral de gestión de viajes y turismo desarrollada con Flutter. Es un sistema diseñado para agencias de viajes que permite gestionar itinerarios personalizados, productos turísticos, clientes, reservas y pagos.

## Tecnologías Principales

- **Frontend**: Flutter 3.29.2 (Web, iOS, Android, macOS)
- **Backend**: Supabase (BaaS)
- **Base de Datos**: PostgreSQL (via Supabase)
- **Autenticación**: Supabase Auth
- **Storage**: Supabase Storage
- **Framework UI**: FlutterFlow
- **Navegación**: Go Router
- **Estado Global**: **NUEVA ARQUITECTURA DE SERVICIOS** (Migración completada de FFAppState)

## 🚀 NUEVA ARQUITECTURA (2024) - MIGRACIÓN COMPLETADA

### ⚡ Cambio Arquitectural Fundamental
El proyecto ha completado una **migración masiva** de un sistema monolítico `FFAppState` a una **arquitectura de servicios modular y optimizada**.

#### 🏆 Logros de la Migración:
- ✅ **Reducción del 94%** en referencias de estado global
- ✅ **Mejora del 50-70%** en performance de UI
- ✅ **62+ tests automatizados** implementados
- ✅ **Gestión de memoria optimizada** con cleanup automático
- ✅ **Monitoreo de performance** en tiempo real

### 🏗️ Servicios Principales (USAR ESTOS)

```dart
// Acceso global a todos los servicios
final appServices = AppServices();

// Servicios disponibles:
appServices.ui           // UiStateService - Estado temporal de UI
appServices.user         // UserService - Datos del usuario
appServices.itinerary    // ItineraryService - Gestión de itinerarios  
appServices.product      // ProductService - Gestión de productos
appServices.contact      // ContactService - Gestión de contactos
appServices.authorization // AuthorizationService - Control de acceso
appServices.error        // ErrorService - Manejo de errores
```

#### ✅ Usar (Nuevo Patrón)
```dart
// Estado temporal de UI
appServices.ui.searchQuery = 'hotel en playa';
appServices.ui.selectedProductType = 'hotels';
appServices.ui.setSelectedLocation(name: 'Miami', city: 'Miami');

// Datos del usuario
final userName = appServices.user.getAgentInfo(r'$[:].name');
final isAdmin = appServices.user.isAdmin;

// Gestión de productos
final products = await appServices.product.searchAllProducts('beach');
```

#### ❌ NO Usar (Patrón Obsoleto)
```dart
// EVITAR - Solo para compatibilidad temporal
FFAppState().searchStringState = 'query';
FFAppState().idProductSelected = 'id';
FFAppState().typeProduct = 'hotels';
```

## 🎨 SISTEMA DE DISEÑO Y TEMAS (Actualizado 2025)

### Migración del Tema FlutterFlow
El proyecto ha sido actualizado para usar el tema original de FlutterFlow con las siguientes características:

#### 📐 Colores Principales
- **Primary**: `#7C57B3` (morado FlutterFlow)
- **Secondary**: `#102877` (azul oscuro)
- **Secondary Dark**: `#68E0F8` (cyan para modo oscuro)
- **Tertiary**: `#4098F8` (azul claro)
- **Alternate**: `#B7BAC3` (gris claro para bordes)

#### 🔤 Tipografía
- **Headers**: `outfitSemiBold` (displays y headlines)
- **Body/Títulos**: `Plus Jakarta Sans` (via Google Fonts)
- **Tamaños**: Ajustados para coincidir con FlutterFlow original

#### 🌓 Modo Oscuro Optimizado
- Navegación con fondo `backgroundDarkSecondary`
- Bordes de formularios semi-transparentes para mejor visibilidad
- Contraste mejorado en textos secundarios

#### 📝 Formularios
- Sin relleno por defecto (`filled: false`)
- Bordes con color `alternate` y grosor 2px
- Estados focus/error claramente diferenciados

### Uso del Sistema de Diseño

```dart
// Acceder a colores
BukeerColors.primary
BukeerColors.secondary
BukeerColors.tertiary
BukeerColors.alternate

// Tema adaptativo
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.headlineLarge

// Helpers de color
BukeerColors.getTextColor(context)
BukeerColors.getBackground(context)
BukeerColors.getBorderColor(context)
```

## 🧪 SISTEMA DE PRUEBAS (Actualizado Enero 2025)

### Estado Actual
- **585 casos de test** distribuidos en 39 archivos de test
- **~85% de tests compilando** correctamente después de migración
- **Test helpers actualizados** para usar AppServices en lugar de FFAppState
- **Documentación completa** en `/docs/TEST_SYSTEM_STATUS_REPORT.md`

### Estructura de Tests
```
test/
├── api/                # Tests de API calls
├── components/         # Tests de componentes UI
├── services/          # Tests de servicios (AppServices)
├── integration/       # Tests de flujos completos
├── widgets/core/      # Tests de widgets del design system
└── mocks/            # Mocks compartidos con Mockito
```

### Tests Conocidos que Requieren Actualización
1. **Widget Tests con APIs obsoletas** - Algunos tests usan propiedades deprecated
2. **BtnCreateWidget tests** - API del widget cambió, tests necesitan actualización
3. **SearchBox tests** - Interfaz de UiStateService cambió

### Ejecutar Tests
```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests específicos
flutter test test/services/

# Ejecutar con coverage
flutter test --coverage
```

## 📁 Estructura del Proyecto

```
lib/
├── app_state.dart              # Estado global (OBSOLETO - usar AppServices)
├── auth/                       # Autenticación
├── backend/                    # API y esquemas
├── bukeer/                     # Módulos principales
│   ├── core/                   # Componentes y utilidades compartidas
│   │   ├── constants/         # Constantes y configuración
│   │   ├── utils/            # Utilidades (currency, date, pdf, validation)
│   │   └── widgets/          # Widgets reutilizables organizados
│   ├── agenda/                # Módulo de agenda
│   ├── contactos/            # Gestión de contactos
│   ├── dashboard/            # Dashboards y reportes
│   ├── itinerarios/          # Gestión de itinerarios
│   ├── productos/            # Gestión de productos
│   └── users/                # Gestión de usuarios
├── components/                 # Componentes generales
├── design_system/             # Sistema de diseño Bukeer
├── navigation/                # Navegación moderna con GoRouter
└── services/                  # Servicios de la aplicación

## 🔧 Comandos Útiles

```bash
# Desarrollo
flutter run -d chrome          # Ejecutar en Chrome
flutter run -d macos           # Ejecutar en macOS

# Tests
flutter test                   # Ejecutar todos los tests
flutter test --coverage        # Generar reporte de cobertura

# Build
flutter build web              # Build para web
flutter build macos           # Build para macOS

# Análisis
flutter analyze               # Análisis estático
dart fix --apply             # Aplicar fixes automáticos
```

## 🚨 Consideraciones Importantes

1. **SIEMPRE usar AppServices** en lugar de FFAppState
2. **Seguir convenciones de nombres** en `/lib/bukeer/core/NAMING_CONVENTIONS.md`
3. **Usar design tokens** en lugar de valores hardcodeados
4. **Tests deben usar** los helpers actualizados en `/test/widgets/core/test_helpers.dart`
5. **Performance**: Los servicios implementan batching automático de notificaciones

## 📊 Métricas de Calidad

- **Reducción de estado global**: 94%
- **Mejora de performance**: 50-70%
- **Tests automatizados**: 585 casos
- **Cobertura de tests**: Por determinar
- **Tiempo de compilación web**: ~30 segundos

## 🔄 Migración en Progreso

Si encuentras código legacy usando FFAppState:
1. Identificar el tipo de dato almacenado
2. Encontrar el servicio correspondiente en AppServices
3. Migrar siguiendo los patrones documentados
4. Actualizar tests relacionados

Documentación detallada de migración en:
- `/docs/historical/FFAPPSTATE_MIGRATION_REPORT.md`
- `/MIGRATION_STATUS_REPORT.md`