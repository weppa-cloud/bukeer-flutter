# Typography Implementation

## Overview
The Bukeer design system now implements a dual-font typography system:

### Primary Font: Outfit (SemiBold)
- Used for: Headlines, titles, buttons, metrics, card headers, and emphasis text
- Default weight: 600 (SemiBold)
- Purpose: Creates strong visual hierarchy and brand identity

### Secondary Font: Plus Jakarta Sans
- Used for: Body text, form fields, navigation items, sidebar items, table cells
- Default weight: 400 (Regular)
- Purpose: Provides excellent readability for content and UI elements

## Implementation Details

### Font Families
```dart
static const String _primaryFont = 'Outfit'; // Primary font: Outfit SemiBold
static const String _secondaryFont = 'Plus Jakarta Sans'; // Secondary font
static const String _fallbackFont = 'Inter'; // Fallback font
```

### Usage Examples

#### Headlines and Titles (Outfit SemiBold)
```dart
Text('Welcome to Bukeer', style: BukeerTypography.headlineLarge)
Text('Dashboard', style: BukeerTypography.titleLarge)
```

#### Body Text (Plus Jakarta Sans)
```dart
Text('This is body text', style: BukeerTypography.bodyMedium)
Text('Form input text', style: BukeerTypography.formField)
```

#### Custom Font Usage
```dart
// Outfit with custom settings
Text('Custom Outfit', style: BukeerTypography.outfit(
  fontSize: 20,
  fontWeight: FontWeight.w700,
))

// Plus Jakarta Sans with custom settings
Text('Custom Jakarta', style: BukeerTypography.plusJakartaSans(
  fontSize: 16,
  fontWeight: FontWeight.w500,
))
```

## Font Loading
Both fonts are loaded through the Google Fonts package, which handles:
- Automatic font downloading and caching
- Fallback to system fonts if needed
- Cross-platform compatibility

## Typography Tokens Updated

### Primary Font (Outfit) Used In:
- `displayLarge`, `displayMedium`, `displaySmall`
- `headlineLarge`, `headlineMedium`, `headlineSmall`
- `titleLarge`, `titleMedium`, `titleSmall`
- `labelLarge`, `labelMedium`, `labelSmall`
- `buttonPrimary`, `buttonSecondary`, `buttonText`
- `cardHeader`, `metricLarge`, `metricMedium`, `metricSmall`
- `tableHeader`

### Secondary Font (Plus Jakarta Sans) Used In:
- `bodyLarge`, `bodyMedium`, `bodySmall`
- `formField`, `formFieldHint`, `formFieldLabel`
- `navItem`, `sidebarItem`
- `tableCell`

## Migration Notes
- The previous Inter font is now the fallback font
- All Outfit font weights have been adjusted to use SemiBold (600) by default
- Body text and UI elements now use Plus Jakarta Sans for improved readability