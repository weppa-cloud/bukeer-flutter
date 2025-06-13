# Migración al Sistema de Diseño Bukeer

## ⚠️ IMPORTANTE: No usar FlutterFlowTheme

**SIEMPRE** usar el sistema de diseño de Bukeer basado en tokens de diseño. 

### ❌ NO HACER:
```dart
// NO usar FlutterFlowTheme
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
FlutterFlowTheme.of(context).primaryText
```

### ✅ HACER:
```dart
// Usar el sistema de diseño de Bukeer
import 'package:bukeer/design_system/index.dart';

// Colores
BukeerColors.primary
BukeerColors.textPrimary
BukeerColors.backgroundPrimary

// Tipografía
BukeerTypography.headlineLarge
BukeerTypography.bodyMedium

// Espaciado
BukeerSpacing.s
BukeerSpacing.m

// Bordes
BukeerBorders.radiusMedium
BukeerBorders.widthThin
```

## Componentes del Sistema de Diseño

### 1. Tokens de Diseño (`/lib/design_system/tokens/`)
- `colors.dart` - Colores con soporte para dark mode
- `typography.dart` - Sistema tipográfico
- `spacing.dart` - Sistema de espaciado
- `borders.dart` - Radios y anchos de borde
- `shadows.dart` - Sombras
- `animations.dart` - Duraciones y curvas

### 2. Componentes (`/lib/design_system/components/`)
- `BukeerButton` - Botones
- `BukeerIconButton` - Botones de icono
- `BukeerTextField` - Campos de texto
- `BukeerCard` - Tarjetas
- `BukeerSwitch` - Switches
- `BukeerCheckbox` - Checkboxes
- `BukeerRadio` - Radio buttons

### 3. Navegación
- `SidebarNavigationWidget` - Barra lateral de navegación
- `SidebarDrawer` - Drawer para móvil

## Cambio de Tema (Dark/Light Mode)

Para cambiar el tema, usar el método `setThemeMode` directamente en `MyApp`:

```dart
// Cambiar a modo oscuro
MyApp.of(context).setThemeMode(ThemeMode.dark);

// Cambiar a modo claro
MyApp.of(context).setThemeMode(ThemeMode.light);

// Usar el tema del sistema
MyApp.of(context).setThemeMode(ThemeMode.system);
```

## Persistencia del Tema

La persistencia del tema se maneja con `shared_preferences`:

```dart
import 'package:shared_preferences/shared_preferences.dart';

// Guardar preferencia
final prefs = await SharedPreferences.getInstance();
await prefs.setString('themeMode', mode.name);

// Cargar preferencia
final savedMode = prefs.getString('themeMode');
final themeMode = ThemeMode.values.firstWhere(
  (e) => e.name == savedMode,
  orElse: () => ThemeMode.system,
);
```

## Migración de Componentes Existentes

Al migrar componentes existentes:

1. Reemplazar todos los imports de FlutterFlowTheme
2. Usar tokens de diseño de Bukeer
3. Verificar soporte para dark mode
4. Testear en ambos temas

## Ejemplos de Uso

### Obtener colores según el tema:
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final backgroundColor = isDark 
  ? BukeerColors.backgroundDark 
  : BukeerColors.backgroundPrimary;
```

### Usar componentes:
```dart
BukeerButton(
  text: 'Guardar',
  onPressed: () {},
  variant: BukeerButtonVariant.primary,
  size: BukeerButtonSize.medium,
)
```

### Aplicar espaciado:
```dart
Padding(
  padding: EdgeInsets.all(BukeerSpacing.m),
  child: Container(
    margin: EdgeInsets.only(bottom: BukeerSpacing.s),
  ),
)
```