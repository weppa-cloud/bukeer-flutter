# 🎨 Bukeer Design System

Un sistema de diseño unificado para la aplicación Bukeer que reemplaza valores hardcodeados con tokens consistentes y mantenibles.

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
│   │   └── bukeer_fab.dart      # Floating Action Button
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
│   ├── breakpoints.dart         # Puntos de quiebre responsive
│   ├── colors.dart              # Paleta de colores
│   ├── elevation.dart           # Niveles de elevación
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
  margin: EdgeInsets.fromLTRB(BukeerSpacing.s, BukeerSpacing.s, BukeerSpacing.s, 0),
  decoration: BoxDecoration(
    color: BukeerColors.surfacePrimary,
    borderRadius: BorderRadius.circular(BukeerSpacing.s),
    boxShadow: BukeerElevation.small,
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
- `BukeerSpacing.xs` = 4.0px - Extra pequeño
- `BukeerSpacing.s` = 8.0px - Pequeño  
- `BukeerSpacing.m` = 16.0px - Mediano
- `BukeerSpacing.l` = 24.0px - Grande
- `BukeerSpacing.xl` = 32.0px - Extra grande

### Colores (BukeerColors)
- **Primarios**: `primaryMain`, `primaryLight`, `primaryDark`
- **Superficie**: `surfacePrimary`, `surfaceSecondary`, `surfaceTertiary`
- **Texto**: `textPrimary`, `textSecondary`, `textTertiary`
- **Estados**: `successMain`, `warningMain`, `errorMain`, `infoMain`
- **Utilidad**: `overlay`, `borderLight`, `borderMedium`

### Tipografía (BukeerTypography)
- **Display**: `displayLarge`, `displayMedium`, `displaySmall`
- **Headline**: `headlineLarge`, `headlineMedium`, `headlineSmall`  
- **Body**: `bodyLarge`, `bodyMedium`, `bodySmall`
- **Label**: `labelLarge`, `labelMedium`, `labelSmall`
- **Caption**: `caption`

### Elevación (BukeerElevation)
- `BukeerElevation.none` - Sin sombra
- `BukeerElevation.small` - Sombra pequeña
- `BukeerElevation.medium` - Sombra mediana
- `BukeerElevation.large` - Sombra grande

## 📱 Sistema Responsive

```dart
// Usar breakpoints
if (BukeerBreakpoints.isMobile(context)) {
  return MobileLayout();
} else if (BukeerBreakpoints.isTablet(context)) {
  return TabletLayout();
} else {
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

## ✅ Componentes Migrados

### Ejemplos Completados
1. **WebNavWidget** - Navegación lateral completamente migrada
2. **ModalAddEditItineraryWidget** - Modal principal migrado
3. **SearchBoxWidget** - Componente de búsqueda migrado

### Patrones de Migración Comunes

| Antes | Después |
|-------|---------|
| `EdgeInsets.all(16.0)` | `EdgeInsets.all(BukeerSpacing.m)` |
| `EdgeInsetsDirectional.fromSTEB(0,0,0,12)` | `EdgeInsets.only(bottom: BukeerSpacing.s)` |
| `BorderRadius.circular(8.0)` | `BorderRadius.circular(BukeerSpacing.s)` |
| `Color(0x33000000)` | `BukeerColors.overlay` |
| `fontSize: 16.0` | `fontSize: BukeerTypography.bodyMediumSize` |

## 📊 Estado de Migración

### ✅ Completado
- Sistema de design tokens base
- Herramienta de migración automática
- 3 componentes principales migrados
- Documentación completa
- Ejemplos de uso

### 🔄 En Progreso
- Migración masiva de 100+ archivos restantes
- Integración con componentes FlutterFlow existentes

### 📋 Siguiente Fase
- Tests automatizados del design system
- Storybook/galería de componentes
- Plugin VSCode para autocompletado
- Documentación interactiva

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

**📈 Progreso**: 3/100+ componentes migrados, sistema base completado ✅