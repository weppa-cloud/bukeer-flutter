# 🎨 Bukeer Design System

Un sistema de diseño unificado para la aplicación Bukeer que reemplaza valores hardcodeados con tokens consistentes y mantenibles.

> 📚 **Documentación Completa**: Ver la [Guía Completa del Sistema de Diseño](/docs/BUKEER_DESIGN_SYSTEM_GUIDE.md) para documentación detallada, ejemplos y mejores prácticas.

## 📁 Estructura

```
design_system/
├── index.dart                    # Exportaciones centralizadas
├── README.md                     # Esta documentación
├── MIGRATION_GUIDE.md           # Guía detallada de migración
├── components/                   # Componentes reutilizables
│   ├── index.dart
│   ├── buttons/
│   │   ├── bukeer_button.dart   # Botón estándar
│   │   ├── bukeer_fab.dart      # Floating Action Button
│   │   └── bukeer_icon_button.dart # Botón de icono
│   ├── cards/
│   │   └── bukeer_service_card.dart # Tarjetas de servicios (vuelos, hoteles)
│   ├── chips/
│   │   └── bukeer_meta_chip.dart # Chips de metadata con iconos
│   ├── containers/
│   │   └── bukeer_price_container.dart # Contenedores de precio
│   ├── forms/
│   │   └── bukeer_text_field.dart # Campo de texto estandarizado
│   ├── modals/
│   │   └── bukeer_modal.dart    # Modal base
│   └── navigation/
│       └── bukeer_navigation.dart # Navegación estandarizada
├── layouts/
│   └── responsive_layout.dart    # Sistema responsive
├── tokens/                       # Design tokens
│   ├── index.dart
│   ├── animations.dart          # Duraciones y curvas de animación
│   ├── borders.dart             # Estilos y anchos de bordes
│   ├── breakpoints.dart         # Puntos de quiebre responsive
│   ├── colors.dart              # Paleta de colores
│   ├── elevation.dart           # Niveles de elevación y radios
│   ├── iconography.dart         # Sistema de iconos
│   ├── shadows.dart             # Sistema de sombras
│   ├── spacing.dart             # Sistema de espaciado
│   └── typography.dart          # Tipografía
├── tools/
│   └── migration_helper.dart    # Herramienta de migración automática
└── examples/
    └── migrated_web_nav.dart    # Ejemplo de componente migrado
```

## 🚀 Uso Rápido

### Importar el Sistema

```dart
import 'package:bukeer/design_system/index.dart';
// O usando ruta relativa:
import '../../../design_system/index.dart';
```

### Ejemplos de Uso

```dart
// ❌ Antes (valores hardcodeados)
Container(
  padding: EdgeInsets.all(16.0),
  margin: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 0.0),
  decoration: BoxDecoration(
    color: Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 2),
        blurRadius: 4.0,
      ),
    ],
  ),
  child: Text(
    'Hola mundo',
    style: TextStyle(fontSize: 16.0, color: Color(0xFF000000)),
  ),
)

// ✅ Después (design tokens)
Container(
  padding: EdgeInsets.all(BukeerSpacing.m),
  margin: EdgeInsets.fromLTRB(BukeerSpacing.s, BukeerSpacing.sm, BukeerSpacing.s, 0),
  decoration: BoxDecoration(
    color: BukeerColors.backgroundSecondary,
    borderRadius: BorderRadius.circular(BukeerBorderRadius.lg),
    boxShadow: BukeerElevation.shadow1,
  ),
  child: Text(
    'Hola mundo',
    style: BukeerTypography.bodyMedium.copyWith(
      color: BukeerColors.textPrimary,
    ),
  ),
)
```

## 🎨 Design Tokens

### Espaciado (BukeerSpacing)
- `BukeerSpacing.xs` = 4.0px - spacing-xs
- `BukeerSpacing.s` = 8.0px - spacing-sm  
- `BukeerSpacing.sm` = 12.0px - spacing-md
- `BukeerSpacing.m` = 16.0px - spacing-lg
- `BukeerSpacing.ml` = 20.0px - spacing-xl
- `BukeerSpacing.l` = 24.0px - spacing-2xl
- `BukeerSpacing.xl` = 32.0px - spacing-3xl
- `BukeerSpacing.xxl` = 48.0px - spacing-4xl
- `BukeerSpacing.xxxl` = 64.0px - spacing-5xl

### Colores (BukeerColors)
- **Primarios**: `primary` (#4B39EF), `secondary` (#39D2C0), `tertiary` (#EE8B60)
- **Backgrounds**: 
  - Light: `backgroundPrimary` (#F1F4F8), `backgroundSecondary` (#FFFFFF)
  - Dark: `backgroundDark` (#1A1F24), `backgroundDarkSecondary` (#2B2F33)
- **Texto**: 
  - Light: `textPrimary` (#14181B), `textSecondary` (#57636C)
  - Dark: `textPrimaryDark` (#FFFFFF), `textSecondaryDark` (#95A1AC)
- **Semánticos**: `success` (#04A24C), `warning` (#F9CF58), `error` (#FF5963), `info` (#4B39EF)
- **Bordes**: `alternate` (#E0E3E7), `alternateDark` (#404449)

### Tipografía (BukeerTypography)
- **Display**: `displayLarge` (57px), `displayMedium` (45px), `displaySmall` (36px)
- **Headline**: `headlineLarge` (32px/700), `headlineMedium` (24px/700), `headlineSmall` (20px/700)
- **Title**: `titleLarge` (22px/600), `titleMedium` (18px/600), `titleSmall` (16px/500)
- **Body**: `bodyLarge` (16px), `bodyMedium` (14px), `bodySmall` (13px)
- **Label**: `labelLarge` (14px/500), `labelMedium` (12px/500), `labelSmall` (11px/400)
- **Familias**: `Outfit` (headings), `Readex Pro` (body)

### Elevación y Bordes
**Sombras (BukeerElevation)**
- `shadow1` - BoxShadow(0, 2, 6, #1A000000)
- `shadow2` - BoxShadow(0, 4, 8, #25000000)
- `shadow3` - BoxShadow(0, 6, 12, #30000000)

**Border Radius (BukeerBorderRadius)**
- `xs` = 4px, `sm` = 6px, `md` = 8px
- `lg` = 12px, `xl` = 16px, `xxl` = 20px
- `full` = 9999px (circular)

**Border Width (BukeerBorders)**
- `thin` = 1px, `medium` = 2px, `thick` = 3px

### Animaciones (BukeerAnimations)
**Duraciones**
- `instant` = 0ms, `fast` = 200ms, `medium` = 300ms, `slow` = 500ms

**Curvas**
- `standard` = Curves.easeInOut (más común)
- `accelerate` = Curves.easeIn (entrada)
- `decelerate` = Curves.easeOut (salida)
- `smooth` = Curves.easeInOutCubic (transiciones elegantes)

## 🧩 Componentes Reutilizables

### Tarjetas de Servicio
```dart
// Tarjeta de vuelo con toda la información
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
  onTap: () => print('Flight selected'),
)
```

### Chips de Metadata
```dart
// Chip individual
BukeerMetaChip(
  icon: Icons.date_range,
  text: '08 Jun 2025',
  isActive: true,
)

// Estilos predefinidos
BukeerMetaChipSet(
  chips: [
    BukeerMetaChipStyles.tag(text: 'ID 1-6180'),
    BukeerMetaChipStyles.person(text: '5 adultos, 2 niños'),
    BukeerMetaChipStyles.date(text: '08 Jun - 12 Jun'),
    BukeerMetaChipStyles.language(text: 'Español'),
  ],
)
```

### Contenedores de Precio
```dart
// Contenedor destacado de precio
BukeerPriceContainer(
  totalPrice: 7450100,
  pricePerPerson: 1490020,
  margin: 1179100,
  currency: 'COP',
  showMargin: true,
  orientation: Axis.vertical,
)

// Desglose de precio compacto
BukeerPriceBreakdown(
  netRate: 250000,
  markupPercent: 18,
  totalPrice: 295000,
)
```

## 📱 Sistema Responsive

```dart
// Usar breakpoints (actualizados)
if (BukeerBreakpoints.isMobile(context)) {       // < 479px
  return MobileLayout();
} else if (BukeerBreakpoints.isTablet(context)) { // 479-991px
  return TabletLayout();
} else {                                          // >= 992px
  return DesktopLayout();
}

// Layout responsive automático
ResponsiveLayout(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)
```

## 🔧 Migración Automática

Usa `MigrationHelper` para migrar archivos existentes:

```dart
import 'package:bukeer/design_system/tools/migration_helper.dart';

// Analizar un archivo
final report = await MigrationHelper.analyzeFile('path/to/widget.dart');
print(report);

// Migrar un archivo
final migratedContent = await MigrationHelper.migrateFile('path/to/widget.dart');

// Migrar directorio completo (dry run)
final results = await MigrationHelper.migrateDirectory('lib/bukeer/', dryRun: true);
```

## ✅ Componentes Implementados

### Sistema de Tokens Actualizado (v2.0)
1. **Colores** - Paleta completa con valores del diseño de itinerarios
2. **Tipografía** - Escalas ajustadas y familias Outfit/Readex Pro
3. **Espaciado** - Sistema basado en 4px
4. **Elevación** - Niveles de sombra simplificados
5. **Bordes** - Radios y anchos estandarizados
6. **Animaciones** - Duraciones y curvas consistentes
7. **Breakpoints** - Valores responsivos actualizados

### Componentes Nuevos
1. **BukeerServiceCard** - Tarjetas para vuelos, hoteles, actividades
2. **BukeerFlightCard** - Implementación específica para vuelos
3. **BukeerMetaChip** - Chips de metadata con iconos
4. **BukeerPriceContainer** - Contenedores destacados de precio
5. **BukeerPriceBreakdown** - Desglose de precios compacto

### Componentes Migrados Previamente
1. **WebNavWidget** - Navegación lateral completamente migrada
2. **ModalAddEditItineraryWidget** - Modal principal migrado
3. **SearchBoxWidget** - Componente de búsqueda migrado

### Patrones de Migración Comunes

| Antes | Después |
|-------|---------|
| `EdgeInsets.all(16.0)` | `EdgeInsets.all(BukeerSpacing.m)` |
| `EdgeInsetsDirectional.fromSTEB(0,0,0,12)` | `EdgeInsets.only(bottom: BukeerSpacing.sm)` |
| `BorderRadius.circular(8.0)` | `BorderRadius.circular(BukeerBorderRadius.md)` |
| `Color(0x33000000)` | `BukeerColors.overlay` o `BoxShadow` con opacity |
| `fontSize: 16.0` | `style: BukeerTypography.bodyLarge` |
| `Color(0xFF4B39EF)` | `BukeerColors.primary` |
| `BoxShadow(...)` | `BukeerElevation.shadow1/2/3` |
| `Duration(milliseconds: 300)` | `BukeerAnimations.medium` |

## 📊 Estado de Migración

### ✅ Completado (v2.0 - Enero 2025)
- Sistema de design tokens actualizado con valores del diseño de itinerarios
- 10 archivos de tokens (colores, tipografía, espaciado, elevación, bordes, animaciones, etc.)
- 5 nuevos componentes reutilizables (cards, chips, containers)
- Herramienta de migración automática
- Documentación completa y actualizada
- Soporte completo para modo oscuro

### 🔄 En Progreso
- Migración de componentes existentes para usar nuevos tokens
- Creación de componentes adicionales (HotelCard, ActivityCard, etc.)
- Integración con componentes FlutterFlow existentes

### 📋 Siguiente Fase
- Tests automatizados del design system
- Widgetbook/galería de componentes interactiva
- Validación con el equipo de diseño
- Guía de patrones de diseño

## 🛠️ Herramientas de Desarrollo

### Script de Migración Masiva
```bash
# Migrar todo el directorio bukeer (dry run)
dart run lib/design_system/tools/migration_helper.dart --dir lib/bukeer --dry-run

# Migrar archivos específicos
dart run lib/design_system/tools/migration_helper.dart --file lib/bukeer/componentes/web_nav/web_nav_widget.dart
```

### Validación de Tokens
```dart
// Verificar que un archivo usa design tokens
final hasDesignSystem = await MigrationHelper.analyzeFile('widget.dart');
print('Tokens missing: ${hasDesignSystem.totalIssues}');
```

## 📚 Referencias

- [Guía de Migración Detallada](MIGRATION_GUIDE.md)
- [Material Design 3](https://m3.material.io/) - Inspiración base
- [Flutter Design Tokens](https://docs.flutter.dev/ui/design) - Mejores prácticas

## 🤝 Contribuir

1. Siempre usar design tokens en componentes nuevos
2. Al editar componentes existentes, migrar valores hardcodeados
3. Documentar nuevos tokens en este README
4. Mantener consistencia con Material Design 3

---

**🎯 Objetivo**: Reemplazar 100+ archivos con valores hardcodeados por un sistema de design unificado y mantenible.

**📈 Progreso**: 
- Sistema de tokens: 100% completado (v2.0) ✅
- Componentes nuevos: 5 implementados ✅
- Componentes migrados: 3/100+ archivos
- Documentación: Actualizada con los nuevos valores del diseño ✅