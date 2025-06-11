# Extracción de Tokens de Diseño - Itinerary Details

## 🎨 Tokens de Color

### Colores Base
```dart
// Backgrounds
primaryBackground: Color(0xFFF1F4F8)      // Fondo principal (claro)
secondaryBackground: Color(0xFFFFFFFF)    // Fondo de tarjetas
alternate: Color(0xFFE0E3E7)              // Bordes y divisores

// Texto
primaryText: Color(0xFF14181B)            // Texto principal
secondaryText: Color(0xFF57636C)          // Texto secundario

// Accent Colors
primary: Color(0xFF4B39EF)                // Color principal (morado)
secondary: Color(0xFF39D2C0)              // Color secundario (turquesa)
tertiary: Color(0xFFEE8B60)               // Color terciario (naranja)
error: Color(0xFFFF5963)                  // Color de error

// Estado específicos
success: Color(0xFF04A24C)                // Verde éxito
warning: Color(0xFFF9CF58)                // Amarillo advertencia
info: Color(0xFF4B39EF)                   // Azul información
```

### Modo Oscuro
```dart
// Backgrounds Dark
primaryBackground: Color(0xFF1A1F24)      // Fondo principal oscuro
secondaryBackground: Color(0xFF2B2F33)    // Fondo de tarjetas oscuro
alternate: Color(0xFF404449)              // Bordes oscuros

// Texto Dark
primaryText: Color(0xFFFFFFFF)            // Texto principal oscuro
secondaryText: Color(0xFF95A1AC)          // Texto secundario oscuro
```

## 📏 Tokens de Tipografía

### Escala Tipográfica
```dart
// Headings
headlineLarge: 32px, weight: 700
headlineMedium: 24px, weight: 700
headlineSmall: 20px, weight: 700

// Titles
titleLarge: 22px, weight: 600
titleMedium: 18px, weight: 600
titleSmall: 16px, weight: 500

// Body
bodyLarge: 16px, weight: 400
bodyMedium: 14px, weight: 400
bodySmall: 13px, weight: 400

// Labels
labelLarge: 14px, weight: 500
labelMedium: 12px, weight: 500
labelSmall: 11px, weight: 400
```

### Familias Tipográficas
```dart
primary: 'Outfit'      // Para headings y títulos
secondary: 'Readex Pro' // Para body y texto general
```

## 📐 Tokens de Espaciado

### Sistema de Espaciado (Base 4px)
```dart
spacing-xs: 4px
spacing-sm: 8px
spacing-md: 12px
spacing-lg: 16px
spacing-xl: 20px
spacing-2xl: 24px
spacing-3xl: 32px
spacing-4xl: 48px
spacing-5xl: 64px
```

### Padding de Componentes
```dart
// Containers
container-padding: 20px
section-padding: 24px
page-padding: 32px

// Buttons
button-padding-horizontal: 16px
button-padding-vertical: 8px - 10px

// Cards
card-padding: 16px

// Chips
chip-padding-horizontal: 10px
chip-padding-vertical: 4px
```

## 🎭 Tokens de Elevación/Sombras

### Niveles de Elevación
```dart
elevation-0: none
elevation-1: BoxShadow(
  color: Color(0x1A000000),
  blurRadius: 6,
  offset: Offset(0, 2),
)
elevation-2: BoxShadow(
  color: Color(0x25000000),
  blurRadius: 8,
  offset: Offset(0, 4),
)
elevation-3: BoxShadow(
  color: Color(0x30000000),
  blurRadius: 12,
  offset: Offset(0, 6),
)
```

## 🔲 Tokens de Bordes

### Border Radius
```dart
radius-xs: 4px
radius-sm: 6px
radius-md: 8px
radius-lg: 12px
radius-xl: 16px
radius-2xl: 20px
radius-full: 9999px (circular)
```

### Border Width
```dart
border-thin: 1px
border-medium: 2px
border-thick: 3px
```

## ⚡ Tokens de Animación

### Duraciones
```dart
duration-instant: 0ms
duration-fast: 200ms
duration-medium: 300ms
duration-slow: 500ms
```

### Curvas de Animación
```dart
easing-standard: Curves.easeInOut
easing-accelerate: Curves.easeIn
easing-decelerate: Curves.easeOut
```

## 📱 Breakpoints Responsivos

```dart
mobile: < 479px
tablet: 768px - 991px
desktop: >= 992px
widescreen: >= 1280px
```

## 🧩 Componentes Específicos

### Buttons
```dart
// Primary Button
height: 44px
padding: 24px horizontal
border-radius: 8px
font-size: 16px
font-weight: 500

// Icon Button
size: 40px
padding: 8px
border-radius: 8px
icon-size: 20px

// Chip Button
height: auto
padding: 16px horizontal, 8px vertical
border-radius: 20px
font-size: 13px
font-weight: 500
```

### Cards
```dart
// Service Card
border-radius: 8px
border: 1px solid alternate
padding: 16px
background: secondaryBackground

// Info Container
border-radius: 12px
padding: 20px
shadow: elevation-1
```

### Tabs
```dart
indicator-color: primary
indicator-weight: 3px
label-size: 15px
label-weight: 600 (selected), 500 (unselected)
icon-size: 20px
```

### Meta Items (Pills)
```dart
padding: 10px horizontal, 4px vertical
border-radius: 16px
background: alternate with 0.2 opacity
font-size: 13px
icon-size: 16px
```

## 🎨 Patrones de Diseño Identificados

### 1. **Contenedores con Información**
- Fondo: `secondaryBackground`
- Borde redondeado: `radius-lg` (12px)
- Sombra: `elevation-1`
- Padding: `20px`

### 2. **Secciones de Precio**
- Fondo: `primary` con 0.1 opacidad
- Texto: `primary` color
- Border radius: `radius-md` (8px)
- Padding: `20px horizontal, 16px vertical`

### 3. **Estados de Botones**
- Activo: Fondo `primary`, texto blanco
- Inactivo: Fondo `secondaryBackground` o `alternate` con opacidad
- Border: `primary` cuando activo, `alternate` cuando inactivo

### 4. **Tarjetas de Servicio (Vuelos)**
- Estructura de dos partes:
  - Superior: `secondaryBackground` con bordes
  - Inferior: `primaryBackground` con información de precio
- Border radius solo en esquinas exteriores

### 5. **Información Jerárquica**
- Título principal: `headlineMedium` (24px, weight 700)
- Subtítulos: `titleMedium` (18px, weight 600)
- Valores importantes: `titleSmall` (16px, weight 700) en color `primary`
- Metadata: `bodySmall` (13px) en `secondaryText`

## 🔧 Implementación Sugerida

Para implementar estos tokens en tu sistema de diseño:

1. **Actualizar `/lib/design_system/tokens/colors.dart`** con los colores extraídos
2. **Actualizar `/lib/design_system/tokens/typography.dart`** con la escala tipográfica
3. **Actualizar `/lib/design_system/tokens/spacing.dart`** con el sistema de espaciado
4. **Crear nuevos tokens para:**
   - Elevaciones específicas de Bukeer
   - Radios de borde estándar
   - Padding de componentes

5. **Crear componentes reutilizables:**
   - `BukeerServiceCard`
   - `BukeerMetaChip`
   - `BukeerPriceContainer`
   - `BukeerTabBar`

## 📋 Checklist para el Diseñador

Pide al diseñador que valide o ajuste:

- [ ] Paleta de colores completa (incluyendo estados hover/active)
- [ ] Escala tipográfica y pesos exactos
- [ ] Sistema de espaciado coherente
- [ ] Valores de sombra para cada nivel
- [ ] Comportamiento responsive de componentes
- [ ] Estados de interacción (hover, pressed, disabled)
- [ ] Iconografía y tamaños estándar
- [ ] Animaciones y transiciones