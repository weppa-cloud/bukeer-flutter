# Proyecto Bukeer - Documentación para Claude

## Comandos de Flujo de Desarrollo

### Mapeo de Comandos Cortos

Cuando recibas estos comandos cortos, ejecuta los scripts correspondientes:

### Comandos principales:
- `run` → `./flow.sh run`
- `staging` → `./flow.sh staging`
- `dev [nombre]` → `./flow.sh dev [nombre]`
- `save` → `./flow.sh save`
- `save [mensaje]` → `./flow.sh save "[mensaje]"`
- `test` → `./flow.sh test`
- `pr` → `./flow.sh pr`
- `deploy` → `./flow.sh deploy`
- `status` → `./flow.sh status`
- `sync` → `./flow.sh sync`
- `clean` → `./flow.sh clean`

### Flujo de trabajo para nueva característica:
1. `dev nombre-feature` - Crear rama feature/nombre-feature
2. `save` - Guardar cambios con auto-commit
3. `test` - Ejecutar pruebas
4. `pr` - Crear Pull Request
5. `deploy` - Deploy a producción (después de revisión)

### Comandos de commit:
- Para commit automático: `save`
- Para commit con mensaje personalizado: `save "feat: descripción"`

### Uso
Simplemente escribe el comando corto (ej: "dev mi-feature") y ejecutaré automáticamente el script de flujo correspondiente.

---

## 📚 IMPORTANTE: Gestión de Documentación

### ⚠️ ANTES de crear CUALQUIER documentación nueva:

1. **BUSCAR PRIMERO** si existe documentación relacionada:
```bash
# Buscar documentación existente sobre el tema
find docs -name "*.md" | xargs grep -l "tema_a_documentar"
```

2. **ACTUALIZAR** documentación existente en lugar de crear nueva
3. **SEGUIR** la estructura de carpetas establecida:
```
docs/
├── 01-getting-started/    # Setup y configuración inicial
├── 02-development/        # Flujo de desarrollo y estándares
├── 03-architecture/       # Arquitectura y diseño
├── 04-guides/            # Guías específicas
├── 05-reference/         # Referencias rápidas
└── archive/              # Documentos obsoletos
```

4. **CONSOLIDAR** información duplicada cuando la encuentres
5. **NO CREAR** archivos .md en la raíz del proyecto

### 🛑 Documentación Prohibida de Crear:
- README.md adicionales (usar el existente)
- Guías de setup nuevas (actualizar `01-getting-started/`)
- Flujos de trabajo duplicados (usar `flow.sh` como base)
- Documentación de arquitectura fragmentada

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

## 🎨 SISTEMA DE DISEÑO Y TEMAS (v2.0 - Enero 2025)

### ⚠️ IMPORTANTE: Migración Obligatoria del Sistema de Diseño

**NUNCA usar FlutterFlowTheme** - El proyecto está migrando completamente al sistema de diseño Bukeer. 

#### ❌ NO HACER (Código Legacy):
```dart
// EVITAR - Sistema obsoleto
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
FlutterFlowTheme.of(context).primaryText
FlutterFlowTheme.of(context).bodyMedium
```

#### ✅ HACER (Sistema Nuevo):
```dart
// SIEMPRE usar el sistema de diseño Bukeer
import 'package:bukeer/design_system/index.dart';

// Colores
BukeerColors.textPrimary
BukeerColors.primary
BukeerColors.backgroundPrimary

// Tipografía
BukeerTypography.headlineLarge
BukeerTypography.bodyMedium

// Espaciado
BukeerSpacing.m  // 16px
BukeerSpacing.l  // 24px
```

### 📋 Documentación de Migración
Ver `/docs/DESIGN_SYSTEM_MIGRATION.md` para guía completa de migración de componentes FlutterFlow.

### Sistema de Design Tokens Actualizado
El proyecto ha completado una **actualización masiva del sistema de diseño** basándose en los valores extraídos del diseño de itinerarios, con soporte completo para modo oscuro.

#### 📐 Tokens de Color
- **Primary**: `#4B39EF` (morado principal Bukeer)
- **Secondary**: `#39D2C0` (turquesa)
- **Tertiary**: `#EE8B60` (naranja)
- **Backgrounds Light**: `#F1F4F8` (primary), `#FFFFFF` (secondary)
- **Backgrounds Dark**: `#1A1F24` (primary), `#2B2F33` (secondary)
- **Semánticos**: `#04A24C` (success), `#F9CF58` (warning), `#FF5963` (error)

#### 🔤 Tokens de Tipografía
- **Familias**: `Outfit` (headings), `Readex Pro` (body)
- **Escalas**: 
  - Headlines: 32px/700, 24px/700, 20px/700
  - Titles: 22px/600, 18px/600, 16px/500
  - Body: 16px, 14px, 13px
- **Sistema responsivo** integrado

#### 📏 Tokens de Espaciado (Sistema 4px)
```dart
xs: 4px    // spacing-xs
s: 8px     // spacing-sm
sm: 12px   // spacing-md
m: 16px    // spacing-lg
ml: 20px   // spacing-xl
l: 24px    // spacing-2xl
xl: 32px   // spacing-3xl
xxl: 48px  // spacing-4xl
xxxl: 64px // spacing-5xl
```

#### 🎭 Nuevos Tokens
- **Elevación**: 3 niveles de sombra simplificados
- **Bordes**: Radios (4-20px) y anchos (1-3px)
- **Animaciones**: Duraciones (0-500ms) y curvas estandarizadas
- **Breakpoints**: Mobile (<479px), Tablet (479-991px), Desktop (≥992px)

### Componentes Reutilizables Nuevos

```dart
// Tarjeta de servicio (vuelos, hoteles, etc.)
BukeerFlightCard(
  airline: 'JetSmart',
  origin: 'BOG',
  destination: 'MDE',
  departureTime: '09:04',
  arrivalTime: '10:09',
  passengers: 5,
  totalPrice: 295000,
);

// Chips de metadata
BukeerMetaChipSet(
  chips: [
    BukeerMetaChipStyles.tag(text: 'ID 1-6180'),
    BukeerMetaChipStyles.person(text: '5 adultos'),
    BukeerMetaChipStyles.date(text: '08 Jun 2025'),
  ],
);

// Contenedor de precio
BukeerPriceContainer(
  totalPrice: 7450100,
  pricePerPerson: 1490020,
  margin: 1179100,
  currency: 'COP',
);
```

### Uso del Sistema de Diseño v2.0

```dart
// Importar todo el sistema
import 'package:bukeer/design_system/index.dart';

// Acceder a tokens
BukeerColors.primary          // Colores
BukeerTypography.headlineLarge // Tipografía
BukeerSpacing.m               // Espaciado (16px)
BukeerElevation.shadow1       // Sombras
BukeerBorderRadius.md         // Border radius (8px)
BukeerAnimations.medium       // Animaciones (300ms)

// Helpers responsivos
if (BukeerBreakpoints.isMobile(context)) { }
BukeerBreakpoints.getResponsivePadding(context);
```

### 📚 Documentación Completa del Sistema de Diseño

#### 🎯 Documento Principal
- **[Guía Completa Unificada](/docs/BUKEER_DESIGN_SYSTEM_GUIDE.md)** - TODO sobre el sistema de diseño en un solo lugar

#### 📂 Documentación Adicional
- [Índice de Documentación](/docs/DESIGN_SYSTEM_INDEX.md) - Mapa completo de toda la documentación
- [README del Sistema](/lib/design_system/README.md) - Introducción y estructura
- [Guía de Migración](/lib/design_system/MIGRATION_GUIDE.md) - Cómo migrar componentes existentes
- [Reporte de Implementación](/docs/DESIGN_SYSTEM_IMPLEMENTATION_REPORT.md) - Cambios realizados en v2.0

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

## 🌐 Ambientes de Desarrollo

### Configuración de Ambientes
El proyecto soporta múltiples ambientes mediante `flow.sh`:

```bash
# Development (default)
./flow.sh run                  # Chrome en development
./flow.sh run ios              # iOS en development

# Staging
./flow.sh staging              # Chrome en staging (atajo rápido)
./flow.sh run chrome staging   # Chrome en staging
./flow.sh run ios staging      # iOS en staging
./flow.sh run android staging  # Android en staging
```

### URLs por Ambiente
- **Development**: 
  - API: `https://bukeer.bukeerpro.com/api`
  - Supabase: `https://wzlxbpicdcdvxvdcvgas.supabase.co`
  
- **Staging**: 
  - API: `https://bukeer-staging.bukeerpro.com/api`
  - Supabase: `https://wzlxbpicdcdvxvdcvgas.supabase.co` (mismo)

### Configuración Automática
`flow.sh` actualiza automáticamente `web/config.js` según el ambiente seleccionado.

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

## 📖 Documentación Principal

### Para encontrar información específica:

1. **Setup y Configuración**: `/docs/01-getting-started/quick-start.md`
2. **Desarrollo con flow.sh**: `/docs/02-development/workflow.md` ⭐ PRINCIPAL
3. **Arquitectura**: `/docs/03-architecture/` (pendiente migración)
4. **Onboarding Junior**: `/docs/04-guides/junior-onboarding.md`
5. **Referencias Rápidas**: `/docs/05-reference/` (pendiente organización)

### Documentos clave actualizados:
- **flow.sh** - Script central para todo el desarrollo
- **/docs/02-development/workflow.md** - Flujo de desarrollo completo
- **/docs/04-guides/junior-onboarding.md** - Onboarding simplificado (3 días)
- **/docs/CODE_REVIEW_CHECKLIST.md** - Lista de verificación para PRs

## 🔍 Búsqueda de Documentación

Antes de preguntar o crear documentación:
```bash
# Buscar en toda la documentación
grep -r "tema_buscar" docs/

# Buscar archivos por nombre
find docs -name "*onboarding*" -o -name "*setup*"

# Ver estructura de documentación
tree docs -L 2
```