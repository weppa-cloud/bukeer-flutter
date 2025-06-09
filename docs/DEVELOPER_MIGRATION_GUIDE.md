# 🚀 Guía de Migración para Desarrolladores - Proyecto Bukeer

## 📋 Resumen de la Nueva Arquitectura

El proyecto Bukeer ha completado una migración masiva hacia una arquitectura más modular y mantenible. Este documento guía a los desarrolladores sobre cómo trabajar con la nueva estructura.

## 🏗️ Nueva Estructura del Proyecto

```
lib/
├── bukeer/
│   ├── core/                     # 🆕 Componentes y utilidades centralizados
│   │   ├── widgets/              # Todos los componentes reutilizables
│   │   │   ├── navigation/       # Componentes de navegación
│   │   │   ├── buttons/          # Botones
│   │   │   ├── forms/            # Formularios y campos
│   │   │   ├── containers/       # Contenedores
│   │   │   ├── modals/           # Modales
│   │   │   └── payments/         # Componentes de pago
│   │   ├── utils/                # 🆕 Utilidades
│   │   │   ├── date/             # Utilidades de fecha
│   │   │   ├── currency/         # Conversión y cálculos
│   │   │   ├── validation/       # Validaciones
│   │   │   └── pdf/              # Generación de PDFs
│   │   └── constants/            # 🆕 Constantes
│   │       ├── routes.dart       # Rutas de navegación
│   │       ├── api_endpoints.dart # Endpoints API
│   │       └── config.dart       # Configuración
│   ├── users/
│   │   ├── auth/                 # 🆕 Autenticación reorganizada
│   │   └── profile/              # 🆕 Perfil reorganizado
│   └── [otros módulos...]
└── services/                     # Servicios (NO FFAppState)
```

## 🔄 Cambios Principales

### 1. **Adiós FFAppState, Hola Servicios**
```dart
// ❌ ANTIGUO - NO USAR
FFAppState().searchStringState = 'query';
FFAppState().idProductSelected = 'id';

// ✅ NUEVO - USAR SERVICIOS
final appServices = AppServices();
appServices.ui.searchQuery = 'query';
appServices.product.selectedId = 'id';
```

### 2. **Imports de Componentes**
```dart
// ❌ ANTIGUO
import 'package:bukeer/bukeer/componentes/web_nav/web_nav_widget.dart';
import 'package:bukeer/bukeer/contactos/modal_add_edit_contact/modal_add_edit_contact_widget.dart';

// ✅ NUEVO
import 'package:bukeer/bukeer/core/widgets/navigation/web_nav/web_nav_widget.dart';
import 'package:bukeer/bukeer/core/widgets/modals/contact/add_edit/modal_add_edit_contact_widget.dart';

// O usar imports agrupados
import 'package:bukeer/bukeer/core/widgets/navigation/index.dart';
import 'package:bukeer/bukeer/core/widgets/modals/index.dart';
```

### 3. **Utilidades y Funciones**
```dart
// ❌ ANTIGUO
import 'package:bukeer/flutter_flow/custom_functions.dart' as functions;
final nights = functions.calculateNights(checkIn, checkOut);

// ✅ NUEVO
import 'package:bukeer/bukeer/core/utils/date/date_calculations.dart';
final nights = calculateNights(checkIn, checkOut);
```

### 4. **Constantes**
```dart
// ❌ ANTIGUO
const double maxWidth = 1200.0;
const Duration animationDuration = Duration(milliseconds: 300);
const String apiUrl = '/api/contacts';

// ✅ NUEVO
import 'package:bukeer/bukeer/core/constants/index.dart';
// Usar: UiConstants.maxContentWidth
// Usar: UiConstants.animationDuration
// Usar: ApiEndpoints.contacts
```

## 📝 Guía Rápida de Migración

### Para Nuevos Componentes:
1. **Ubicación**: Crear en `/core/widgets/[categoría]/`
2. **Nomenclatura**: Seguir patrón `[category]_[name]_widget.dart`
3. **Exports**: Agregar a `index.dart` de la categoría

### Para Migrar Código Existente:
1. **Ejecutar Script**: `dart scripts/migrate_imports.dart`
2. **Buscar FFAppState**: Reemplazar con servicios apropiados
3. **Actualizar Imports**: Usar nuevas rutas de componentes
4. **Reemplazar Constantes**: Usar valores de `/core/constants/`

## 🛠️ Herramientas Disponibles

### Script de Migración Automática
```bash
# Actualiza automáticamente los imports
dart scripts/migrate_imports.dart
```

### Servicios Disponibles
```dart
final appServices = AppServices();

// Servicios disponibles:
appServices.ui           // Estado temporal de UI
appServices.user         // Datos del usuario
appServices.itinerary    // Gestión de itinerarios
appServices.product      // Gestión de productos
appServices.contact      // Gestión de contactos
appServices.authorization // Control de acceso
appServices.error        // Manejo de errores
```

## 📁 Dónde Encontrar las Cosas

| Tipo | Ubicación Anterior | Nueva Ubicación |
|------|-------------------|-----------------|
| Navegación | `/bukeer/componentes/` | `/bukeer/core/widgets/navigation/` |
| Modales | Dispersos por módulos | `/bukeer/core/widgets/modals/` |
| Formularios | `/bukeer/componentes/` | `/bukeer/core/widgets/forms/` |
| Utilidades | `/flutter_flow/custom_functions.dart` | `/bukeer/core/utils/` |
| Constantes | Hardcodeadas | `/bukeer/core/constants/` |
| Auth | `/bukeer/users/auth_*` | `/bukeer/users/auth/` |
| Perfil | `/bukeer/users/*profile*` | `/bukeer/users/profile/` |

## 🚨 Errores Comunes y Soluciones

### Error: "FFAppState not found"
**Solución**: Importar y usar `AppServices`:
```dart
import 'package:bukeer/services/app_services.dart';
final appServices = AppServices();
```

### Error: "Import not found" después de migración
**Solución**: 
1. Verificar nueva ubicación en `/core/widgets/`
2. Ejecutar script de migración
3. Actualizar import manualmente si es necesario

### Error: "calculateNights not found"
**Solución**: Importar utilidades específicas:
```dart
import 'package:bukeer/bukeer/core/utils/date/index.dart';
```

## 📚 Documentación Adicional

- **Arquitectura**: Ver `/lib/bukeer/core/ARCHITECTURE.md`
- **Nomenclatura**: Ver `/lib/bukeer/core/NAMING_CONVENTIONS.md`
- **Servicios**: Ver `/lib/services/README.md`
- **Design System**: Ver `/lib/design_system/README.md`

## 🎯 Mejores Prácticas

1. **Siempre** usar servicios en lugar de FFAppState
2. **Preferir** imports agrupados (`index.dart`) sobre imports individuales
3. **Evitar** hardcodear valores - usar constantes
4. **Seguir** convenciones de nomenclatura establecidas
5. **Reutilizar** componentes de `/core/widgets/`
6. **Documentar** nuevos componentes con ejemplos

## 🆘 Soporte

Si encuentras problemas durante la migración:
1. Revisa esta guía
2. Consulta la documentación específica del componente
3. Revisa los ejemplos en `/test/` y `/examples/`
4. Contacta al equipo de arquitectura

---

**Última actualización**: Enero 2025
**Versión**: 2.0