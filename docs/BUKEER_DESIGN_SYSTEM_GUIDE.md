# 🎨 Guía Completa del Sistema de Diseño Bukeer

## 📋 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Tokens de Diseño](#tokens-de-diseño)
4. [Componentes](#componentes)
5. [Guía de Migración](#guía-de-migración)
6. [Patrones de Uso](#patrones-de-uso)
7. [Herramientas y Recursos](#herramientas-y-recursos)
8. [Estado Actual](#estado-actual)

---

## 📖 Introducción

El Sistema de Diseño Bukeer es un conjunto completo de tokens, componentes y patrones que garantizan consistencia visual y facilitan el desarrollo en toda la aplicación. 

### Versión Actual: 2.0 (Enero 2025)

### ✨ Características Principales
- **Tokens de diseño** basados en el diseño de itinerarios
- **Componentes reutilizables** con soporte para modo oscuro
- **Sistema responsivo** integrado
- **Animaciones estandarizadas**
- **Herramientas de migración** automatizadas

---

## 🏗️ Arquitectura del Sistema

```
design_system/
├── tokens/                    # Design tokens
│   ├── animations.dart       # Duraciones y curvas
│   ├── borders.dart         # Estilos de bordes
│   ├── breakpoints.dart     # Puntos de quiebre responsive
│   ├── colors.dart          # Paleta de colores
│   ├── elevation.dart       # Sombras y elevación
│   ├── iconography.dart     # Sistema de iconos
│   ├── shadows.dart         # Definiciones de sombras
│   ├── spacing.dart         # Sistema de espaciado
│   └── typography.dart      # Estilos tipográficos
├── components/               # Componentes reutilizables
│   ├── buttons/             # Botones estándar
│   ├── cards/              # Tarjetas de servicio
│   ├── chips/              # Chips de metadata
│   ├── containers/         # Contenedores especiales
│   ├── forms/              # Campos de formulario
│   ├── modals/             # Modales y diálogos
│   └── navigation/         # Navegación
├── layouts/                 # Layouts responsivos
├── themes/                  # Temas light/dark
└── tools/                   # Herramientas de migración
```

---

## 🎨 Tokens de Diseño

### 🎨 Colores

#### Colores Principales
```dart
primary:    #4B39EF  // Morado principal
secondary:  #39D2C0  // Turquesa
tertiary:   #EE8B60  // Naranja
```

#### Backgrounds
```dart
// Modo Claro
backgroundPrimary:    #F1F4F8
backgroundSecondary:  #FFFFFF

// Modo Oscuro
backgroundDark:          #1A1F24
backgroundDarkSecondary: #2B2F33
```

#### Semánticos
```dart
success: #04A24C
warning: #F9CF58
error:   #FF5963
info:    #4B39EF
```

### 📐 Tipografía

#### Familias
- **Headings**: Outfit
- **Body**: Readex Pro

#### Escala Tipográfica
```dart
// Headlines (Outfit)
headlineLarge:  32px, weight: 700
headlineMedium: 24px, weight: 700
headlineSmall:  20px, weight: 700

// Titles (Outfit)
titleLarge:  22px, weight: 600
titleMedium: 18px, weight: 600
titleSmall:  16px, weight: 500

// Body (Readex Pro)
bodyLarge:  16px, weight: 400
bodyMedium: 14px, weight: 400
bodySmall:  13px, weight: 400
```

### 📏 Espaciado (Sistema 4px)

```dart
xs:   4px   // spacing-xs
s:    8px   // spacing-sm
sm:   12px  // spacing-md
m:    16px  // spacing-lg
ml:   20px  // spacing-xl
l:    24px  // spacing-2xl
xl:   32px  // spacing-3xl
xxl:  48px  // spacing-4xl
xxxl: 64px  // spacing-5xl
```

### 🎭 Elevación y Sombras

```dart
shadow1: BoxShadow(0, 2, 6, #1A000000)   // 10% opacity
shadow2: BoxShadow(0, 4, 8, #25000000)   // 15% opacity
shadow3: BoxShadow(0, 6, 12, #30000000)  // 19% opacity
```

### 🔲 Bordes

#### Border Radius
```dart
xs:  4px    // Pequeños detalles
sm:  6px    // Chips, pequeños botones
md:  8px    // Botones, tarjetas
lg:  12px   // Modales, contenedores
xl:  16px   // Contenedores grandes
xxl: 20px   // Elementos especiales
full: 9999px // Circular
```

#### Border Width
```dart
thin:   1px  // Bordes sutiles
medium: 2px  // Bordes estándar
thick:  3px  // Bordes enfatizados
```

### ⚡ Animaciones

#### Duraciones
```dart
instant: 0ms    // Sin animación
fast:    200ms  // Cambios rápidos
medium:  300ms  // Transiciones estándar
slow:    500ms  // Transiciones lentas
```

#### Curvas
```dart
standard:    Curves.easeInOut      // Más común
accelerate:  Curves.easeIn         // Entrada
decelerate:  Curves.easeOut        // Salida
smooth:      Curves.easeInOutCubic // Elegante
```

### 📱 Breakpoints

```dart
mobile:     < 479px
tablet:     479px - 991px
desktop:    >= 992px
widescreen: >= 1280px
```

---

## 🧩 Componentes

### Componentes Implementados

#### 1. **BukeerServiceCard**
Tarjeta para mostrar servicios (vuelos, hoteles, actividades, transfers).

```dart
BukeerServiceCard(
  type: ServiceCardType.flight,
  data: flightData,
  onEdit: () => handleEdit(),
  onDelete: () => handleDelete(),
)
```

#### 2. **BukeerFlightCard** 
Implementación específica para vuelos.

```dart
BukeerFlightCard(
  airline: 'JetSmart',
  origin: 'BOG',
  destination: 'MDE',
  departureTime: '09:04',
  arrivalTime: '10:09',
  date: '07 Jul 2025',
  passengers: 5,
  netRate: 250000,
  markupPercent: 18,
  totalPrice: 295000,
)
```

#### 3. **BukeerMetaChip**
Chips para mostrar metadata con iconos.

```dart
// Chip individual
BukeerMetaChip(
  icon: Icons.date_range,
  text: '08 Jun 2025',
  isActive: true,
)

// Set de chips con estilos predefinidos
BukeerMetaChipSet(
  chips: [
    BukeerMetaChipStyles.tag(text: 'ID 1-6180'),
    BukeerMetaChipStyles.person(text: '5 adultos'),
    BukeerMetaChipStyles.date(text: '08 Jun - 12 Jun'),
  ],
)
```

#### 4. **BukeerPriceContainer**
Contenedor destacado para información de precios.

```dart
BukeerPriceContainer(
  totalPrice: 7450100,
  pricePerPerson: 1490020,
  margin: 1179100,
  currency: 'COP',
  showMargin: true,
  orientation: Axis.vertical,
)
```

#### 5. **BukeerButton**
Sistema de botones unificado.

```dart
BukeerButton(
  text: 'Guardar',
  onPressed: () => handleSave(),
  variant: BukeerButtonVariant.primary,
  size: BukeerButtonSize.medium,
  icon: Icons.save,
)
```

#### 6. **BukeerIconButton**
Botones de solo icono.

```dart
BukeerIconButton(
  icon: Icons.edit,
  onPressed: () => handleEdit(),
  variant: BukeerIconButtonVariant.outline,
  size: BukeerIconButtonSize.medium,
)
```

#### 7. **BukeerTextField**
Campos de formulario estandarizados.

```dart
BukeerTextField(
  label: 'Email',
  controller: emailController,
  validator: (value) => validateEmail(value),
  keyboardType: TextInputType.emailAddress,
)
```

---

## 🔄 Guía de Migración

### Paso 1: Importar el Sistema

```dart
// En cada archivo que necesite migración
import 'package:bukeer/design_system/index.dart';
```

### Paso 2: Reemplazar Valores Hardcodeados

#### ❌ Antes
```dart
// Colores hardcodeados
Color(0xFF4B39EF)
Color(0x33000000)

// Espaciado hardcodeado
EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16)
EdgeInsets.all(16.0)

// Tipografía inconsistente
TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)

// Border radius aleatorio
BorderRadius.circular(8.0)
```

#### ✅ Después
```dart
// Colores con tokens
BukeerColors.primary
BukeerColors.shadow33

// Espaciado con tokens
BukeerSpacing.all16
EdgeInsets.all(BukeerSpacing.m)

// Tipografía estandarizada
BukeerTypography.titleMedium

// Border radius consistente
BorderRadius.circular(BukeerBorderRadius.md)
```

### Paso 3: Usar Componentes Reutilizables

#### ❌ Antes - Implementación manual
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  ),
  child: Row(
    children: [
      Icon(Icons.flight),
      Text('American Airlines AA123'),
      // ... más implementación manual
    ],
  ),
)
```

#### ✅ Después - Componente reutilizable
```dart
BukeerServiceCard(
  type: ServiceCardType.flight,
  data: flightData,
  onEdit: () => handleEdit(),
)
```

### Herramienta de Migración Automática

```dart
// Analizar un archivo
final report = await MigrationHelper.analyzeFile('path/to/widget.dart');

// Migrar un archivo
final migratedContent = await MigrationHelper.migrateFile('path/to/widget.dart');

// Migrar directorio completo
final results = await MigrationHelper.migrateDirectory('lib/bukeer/', dryRun: true);
```

---

## 💡 Patrones de Uso

### Acceder a Tokens con Context

```dart
// Colores
final colors = BukeerColors.of(context);
Container(color: colors.primary)

// Tipografía
final typography = BukeerTypography.of(context);
Text('Hola', style: typography.headlineMedium)

// Espaciado
final spacing = BukeerSpacing.of(context);
Padding(padding: spacing.all16)

// Sombras
final shadows = BukeerShadows.of(context);
BoxDecoration(boxShadow: [shadows.card])
```

### Modo Oscuro

```dart
// Detectar tema actual
final isDark = Theme.of(context).brightness == Brightness.dark;

// Colores adaptativos
final bgColor = isDark 
  ? BukeerColors.backgroundDark 
  : BukeerColors.backgroundPrimary;

// Usar helpers
final textColor = BukeerColors.getTextColor(context);
final borderColor = BukeerColors.getBorderColor(context);
```

### Sistema Responsivo

```dart
// Detectar tipo de dispositivo
if (BukeerBreakpoints.isMobile(context)) {
  return MobileLayout();
} else if (BukeerBreakpoints.isTablet(context)) {
  return TabletLayout();
} else {
  return DesktopLayout();
}

// Valores responsivos
final padding = BukeerBreakpoints.getResponsivePadding(context);
final columns = BukeerBreakpoints.getGridColumns(context);
```

---

## 🛠️ Herramientas y Recursos

### Widgetbook (Catálogo de Componentes)

```dart
// lib/widgetbook/main.dart
flutter run -t lib/widgetbook/main.dart -d chrome
```

### Scripts de Análisis

```bash
# Analizar uso de design tokens
dart run lib/design_system/tools/analyze_usage.dart

# Generar reporte de migración
dart run lib/design_system/tools/migration_report.dart
```

### Extensiones VS Code Recomendadas

1. **Flutter Design System** - Autocompletado de tokens
2. **Color Highlight** - Visualización de colores
3. **Flutter Snippets** - Snippets para componentes

---

## 📊 Estado Actual

### ✅ Completado (v2.0)
- Sistema de tokens completo (10 archivos)
- 6 componentes nuevos implementados
- Herramienta de migración automática
- Documentación completa
- Soporte para modo oscuro
- Sistema responsivo

### 🔄 En Progreso
- Migración de componentes existentes
- Catálogo Widgetbook
- Tests automatizados
- Componentes adicionales (HotelCard, ActivityCard, etc.)

### 📈 Métricas
- **Archivos de tokens**: 10 implementados
- **Componentes nuevos**: 6 creados
- **Archivos por migrar**: ~100+
- **Cobertura actual**: ~5%

---

## 📚 Referencias

### Documentación Interna
- [README Sistema de Diseño](/lib/design_system/README.md)
- [Guía de Migración Detallada](/lib/design_system/MIGRATION_GUIDE.md)
- [Reporte de Implementación](/docs/DESIGN_SYSTEM_IMPLEMENTATION_REPORT.md)
- [Extracción de Tokens](/docs/ITINERARY_DESIGN_TOKENS_EXTRACTION.md)

### Documentación de Componentes
- [Core Widgets](/lib/bukeer/core/widgets/README.md)
- [API Reference](/lib/bukeer/core/widgets/API_REFERENCE.md)
- [Naming Conventions](/lib/bukeer/core/NAMING_CONVENTIONS.md)

### Recursos Externos
- [Material Design 3](https://m3.material.io/)
- [Flutter Design Guidelines](https://docs.flutter.dev/ui/design)

---

## 🤝 Contribuir

1. **Siempre usar design tokens** en componentes nuevos
2. **Migrar valores hardcodeados** al editar componentes existentes
3. **Documentar nuevos tokens** en esta guía
4. **Mantener consistencia** con Material Design 3
5. **Añadir tests** para nuevos componentes

---

**Última actualización**: Enero 2025 | **Versión**: 2.0 | **Mantenedor**: Equipo Bukeer