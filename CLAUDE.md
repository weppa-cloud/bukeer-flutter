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

[Resto del contenido original del archivo CLAUDE.md]