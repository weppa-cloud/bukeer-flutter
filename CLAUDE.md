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
- **Estado Global**: Provider

## Arquitectura del Proyecto

### Estructura de Directorios Principales

```
bukeer/
├── lib/
│   ├── app_state.dart              # Estado global de la aplicación
│   ├── main.dart                   # Punto de entrada
│   ├── index.dart                  # Exportaciones centralizadas
│   │
│   ├── auth/                       # Autenticación
│   │   └── supabase_auth/         # Implementación con Supabase
│   │
│   ├── backend/                    # Lógica de backend
│   │   ├── api_requests/          # Llamadas API
│   │   ├── schema/                # Estructuras de datos
│   │   └── supabase/              # Integración Supabase
│   │       ├── database/          # Modelos de tablas
│   │       └── storage/           # Gestión de archivos
│   │
│   ├── flutter_flow/              # Framework FlutterFlow
│   │   ├── nav/                   # Navegación y rutas
│   │   └── flutter_flow_*.dart    # Utilidades del framework
│   │
│   ├── custom_code/               # Código personalizado
│   │   ├── actions/               # Acciones custom
│   │   └── widgets/               # Widgets personalizados
│   │
│   └── bukeer/                    # Módulos principales
│       ├── dashboard/             # Panel principal
│       ├── itinerarios/           # Gestión de itinerarios
│       ├── productos/             # Gestión de productos
│       ├── contactos/             # Gestión de contactos
│       ├── users/                 # Gestión de usuarios
│       └── componentes/           # Componentes reutilizables
```

## Módulos Principales

### 1. Dashboard
- **Ubicación**: `lib/bukeer/dashboard/`
- **Funciones**:
  - Vista general del negocio
  - Reporte de ventas
  - Cuentas por cobrar
  - Cuentas por pagar

### 2. Gestión de Itinerarios
- **Ubicación**: `lib/bukeer/itinerarios/`
- **Funciones**:
  - Crear/editar itinerarios personalizados
  - Agregar servicios (vuelos, hoteles, actividades, traslados)
  - Gestionar pasajeros
  - Control de pagos (cliente y proveedores)
  - Generar PDFs y vouchers
  - URLs compartibles para clientes

### 3. Gestión de Productos
- **Ubicación**: `lib/bukeer/productos/`
- **Productos gestionados**:
  - **Hoteles**: Con tarifas por tipo de habitación
  - **Actividades**: Tours y experiencias
  - **Vuelos**: Información de vuelos
  - **Traslados**: Servicios de transporte
- **Características**:
  - Sistema de tarifas con costo, ganancia y precio final
  - Múltiples imágenes por producto
  - Inclusiones/exclusiones
  - Políticas de cancelación

### 4. Gestión de Contactos
- **Ubicación**: `lib/bukeer/contactos/`
- **Tipos de contacto**:
  - Clientes
  - Proveedores
  - Usuarios del sistema
- **Información gestionada**:
  - Datos personales/empresariales
  - Información de contacto
  - Documentos de identidad
  - Roles y permisos

### 5. Sistema de Usuarios
- **Ubicación**: `lib/bukeer/users/`
- **Funcionalidades**:
  - Autenticación (login/registro)
  - Recuperación de contraseña
  - Perfiles de usuario
  - Gestión de roles (admin, superadmin, agente)

## Base de Datos - Tablas Principales

### Tablas de Negocio
1. **itineraries**: Itinerarios de viaje
2. **itinerary_items**: Servicios dentro de cada itinerario
3. **activities**: Actividades turísticas
4. **hotels**: Hoteles disponibles
5. **flights**: Información de vuelos
6. **transfers**: Servicios de traslado
7. **contacts**: Clientes, proveedores y usuarios
8. **accounts**: Cuentas/empresas (multi-tenancy)
9. **transactions**: Registro de pagos
10. **passenger**: Pasajeros de itinerarios

### Tablas de Configuración
1. **activities_rates**: Tarifas de actividades
2. **hotel_rates**: Tarifas de hoteles
3. **transfer_rates**: Tarifas de traslados
4. **airlines**: Catálogo de aerolíneas
5. **airports**: Catálogo de aeropuertos
6. **regions**: Regiones geográficas
7. **nationalities**: Nacionalidades
8. **roles**: Roles del sistema
9. **user_roles**: Asignación de roles

### Vistas
1. **activities_view**: Actividades con info del proveedor
2. **hotels_view**: Hoteles con información completa
3. **transfers_view**: Traslados con detalles
4. **airports_view**: Aeropuertos con información extendida

## Configuración de Supabase

- **URL**: https://wzlxbpicdcdvxvdcvgas.supabase.co
- **Archivo de configuración**: `lib/backend/supabase/supabase.dart`
- **Autenticación**: FlutterFlow auth con Supabase

## Rutas Principales (Navegación)

### Rutas Públicas
- `/authLogin` - Página de login
- `/authCreate` - Registro de usuarios
- `/forgotPassword` - Recuperar contraseña
- `/previewItineraryURL` - Vista pública de itinerarios

### Rutas Protegidas (Requieren autenticación)
- `/mainHome` - Dashboard principal
- `/mainProfilePage` - Perfil de usuario
- `/main_contacts` - Gestión de contactos
- `/mainProducts` - Gestión de productos
- `/main_itineraries` - Gestión de itinerarios
- `/itineraryDetails` - Detalles de itinerario
- `/mainUsers` - Gestión de usuarios (admin)

## Funcionalidades Especiales

### 1. Generación de PDFs
- **Ubicación**: `lib/custom_code/actions/create_p_d_f.dart`
- Genera PDFs de itinerarios con diseño personalizado
- Incluye logo, detalles del viaje, servicios y costos

### 2. Sistema de Multi-moneda
- Soporte para múltiples monedas en cotizaciones
- Conversión automática según configuración

### 3. Cálculo Automático de Precios
- Sistema de márgenes de ganancia
- Cálculo automático de totales
- Separación costo/precio/ganancia

### 4. URLs Compartibles
- Generación de URLs públicas para itinerarios
- Vista especial para clientes sin autenticación

### 5. Control de Pagos
- Registro de pagos de clientes
- Control de pagos a proveedores
- Estados de reserva

## Comandos Útiles

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en Chrome
flutter run -d chrome

# Ejecutar en iOS
flutter run -d iPhone

# Ejecutar en Android
flutter run -d android

# Ver dispositivos disponibles
flutter devices

# Limpiar y reconstruir
flutter clean && flutter pub get

# Construir para web
flutter build web

# Analizar código
flutter analyze
```

## Consideraciones Importantes

1. **FlutterFlow**: El proyecto fue generado con FlutterFlow. Una vez editado manualmente, no se puede reimportar a FlutterFlow.

2. **Multi-tenancy**: El sistema soporta múltiples cuentas/empresas mediante el campo `accountId` en las tablas.

3. **Roles y Permisos**: Sistema de roles para controlar acceso a funcionalidades.

4. **Estado Global**: Usa Provider para manejo de estado global (app_state.dart).

5. **Imágenes**: Las imágenes se almacenan en Supabase Storage y se referencian por URL.

6. **Sincronización WordPress**: Existe funcionalidad para sincronizar productos con WordPress.

## Patrones de Código

### Estructura Widget + Model
Cada página sigue el patrón:
```dart
// widget.dart - UI
class MyPageWidget extends StatefulWidget {...}

// model.dart - Lógica
class MyPageModel extends FlutterFlowModel<MyPageWidget> {...}
```

### Acceso a Supabase
```dart
// Lectura
final response = await SupaFlow.client
    .from('table_name')
    .select()
    .eq('field', value);

// Escritura
await SupaFlow.client
    .from('table_name')
    .insert({'field': value});

// Actualización
await SupaFlow.client
    .from('table_name')
    .update({'field': newValue})
    .eq('id', id);
```

### Custom Actions
Las acciones personalizadas se encuentran en `lib/custom_code/actions/` y siguen el patrón:
```dart
Future<ReturnType> actionName(parameters) async {
  // Lógica de la acción
}
```

## Plan de Mejora del Proyecto

### Arquitectura y Código
1. **Servicio Centralizado de Estado**
   - Extender UserService para manejar más estado global
   - Implementar patrón Repository para acceso a datos
   - Crear servicios específicos por módulo (ItineraryService, ProductService, etc.)

2. **Manejo de Errores y Loading**
   - Crear componentes reutilizables de loading
   - Implementar manejo consistente de errores
   - Agregar retry logic para operaciones de red

3. **Optimización de Performance**
   - Implementar lazy loading en listas largas
   - Agregar paginación donde sea necesario
   - Optimizar consultas a Supabase

### Testing y Calidad
1. **Tests Unitarios**: Para lógica de negocio crítica
2. **Tests de Integración**: Para flujos principales
3. **Linting**: Configurar reglas estrictas de código

### UX/UI
1. **Feedback Visual**: Mejorar indicadores de carga y éxito
2. **Validación**: Agregar validación en tiempo real
3. **Responsividad**: Mejorar diseño móvil

### Funcionalidades Futuras
1. **PWA**: Optimizar para Progressive Web App
2. **Offline Support**: Sincronización cuando hay conexión
3. **Notificaciones**: Push notifications para eventos importantes
4. **Dashboard Analytics**: Gráficos y métricas avanzadas

## Guía de Desarrollo

### Mejores Prácticas
1. **Autenticación**: Siempre verificar antes de operaciones sensibles
2. **Transacciones**: Usar para operaciones múltiples relacionadas
3. **Errores**: Mantener consistencia en el manejo
4. **Patrones**: Seguir los existentes de FlutterFlow
5. **Documentación**: Actualizar este archivo con cambios importantes

### Convenciones de Código
1. **Naming**: 
   - Clases: PascalCase
   - Archivos: snake_case
   - Variables: camelCase
   
2. **Estructura**:
   - Un widget por archivo
   - Modelos separados de widgets
   - Custom code en carpetas específicas

3. **Estado**:
   - Usar FFAppState para estado global
   - FlutterFlowModel para estado de página
   - Evitar setState directo, usar safeSetState

### Comandos de Desarrollo
```bash
# Limpiar y reconstruir cuando hay problemas
flutter clean && flutter pub get

# Analizar código antes de commits
flutter analyze

# Ver logs en tiempo real
flutter logs

# Hot reload (r) y hot restart (R) durante desarrollo
```

### Debugging Tips
1. **Null Safety**: Usar ?. y ?? para acceso seguro
2. **Logs**: Usar debugPrint en lugar de print
3. **Network**: Verificar respuestas de Supabase en Network tab
4. **State**: Usar Flutter Inspector para ver estado

## Mejoras Implementadas

### 1. Gestión de Estado de Usuario (UserService)
- **Archivo**: `lib/services/user_service.dart`
- **Propósito**: Solucionar el problema de datos null del usuario al cargar la app
- **Características**:
  - Carga única y centralizada de datos del usuario
  - Prevención de cargas múltiples
  - Métodos seguros para acceder a datos del usuario
  - Manejo robusto de errores
  - Verificación de roles (isAdmin, isSuperAdmin)

### 2. Componente UserDataWrapper
- **Archivo**: `lib/components/user_data_wrapper.dart`
- **Propósito**: Widget wrapper que garantiza que los datos estén cargados
- **Uso**: Envolver páginas que requieren datos del usuario

### 3. WebNav Mejorado
- **Archivo**: `lib/bukeer/componentes/web_nav/web_nav_widget_improved.dart`
- **Mejoras**:
  - Carga automática de datos si no están disponibles
  - Manejo de estados de carga y error
  - Acceso seguro a datos del usuario (sin null)
  - UI más robusta con fallbacks

### Uso del UserService:
```dart
// Obtener instancia
final userService = UserService();

// Verificar si los datos están cargados
if (!userService.hasLoadedData) {
  await userService.initializeUserData();
}

// Acceder a datos de forma segura
final userName = userService.getAgentInfo(r'$[:].name');
final isAdmin = userService.isAdmin;

// Refrescar datos
await userService.refreshUserData();
```

### 4. Servicios Centralizados de Estado ✅ COMPLETADO
- **Archivos creados**:
  - `lib/services/base_service.dart` - Clase base para todos los servicios
  - `lib/services/app_services.dart` - Manager central de servicios
  - `lib/services/itinerary_service.dart` - Servicio para itinerarios
  - `lib/services/product_service.dart` - Servicio para productos
  - `lib/services/contact_service.dart` - Servicio para contactos
  - `lib/components/service_builder.dart` - Widget helper para usar servicios

- **Características**:
  - ✅ Patrón singleton para cada servicio
  - ✅ Cache automático con duración configurable
  - ✅ Manejo centralizado de errores y loading
  - ✅ Notificación automática de cambios (ChangeNotifier)
  - ✅ Inicialización coordinada al login
  - ✅ Reset automático al logout
  - ✅ Operaciones batch para mejor performance
  - ✅ Búsqueda con cache de resultados

- **Uso de los servicios**:
  ```dart
  import '/services/app_services.dart';
  
  // Acceder a servicios
  final itineraries = appServices.itinerary.itineraries;
  final isLoading = appServices.itinerary.isLoading;
  
  // Crear itinerario
  final id = await appServices.itinerary.createItinerary(
    name: 'Trip to Paris',
    startDate: '2024-01-01',
    endDate: '2024-01-07',
  );
  
  // Buscar productos
  final results = await appServices.product.searchAllProducts('beach');
  
  // Usar ServiceBuilder en widgets
  ServiceBuilder<ItineraryService>(
    service: appServices.itinerary,
    loadingWidget: CircularProgressIndicator(),
    errorBuilder: (error) => Text('Error: $error'),
    builder: (context, service) {
      return ListView.builder(
        itemCount: service.itineraries.length,
        itemBuilder: (context, index) {
          final itinerary = service.itineraries[index];
          return ListTile(title: Text(itinerary['name']));
        },
      );
    },
  )
  ```

### 5. Refactorización Arquitectural Completa ✅ COMPLETADO

#### 5.1 API Keys Seguras
- **Archivos creados**:
  - `lib/config/app_config.dart` - Configuración centralizada
  - `.env.example` - Plantilla de variables de entorno

- **Características**:
  - ✅ API keys movidas a variables de entorno
  - ✅ Configuración centralizada y validada
  - ✅ Logging de configuración en debug
  - ✅ URLs base configurables

#### 5.2 FFAppState Refactorizado
- **Archivos creados**:
  - `lib/app_state_clean.dart` - FFAppState limpio (8 variables vs 40+)
  - `lib/services/ui_state_service.dart` - Estado temporal de UI
  - `lib/providers/app_providers.dart` - Providers centralizados
  - `MIGRATION_PLAN.md` - Plan de migración detallado

- **Variables movidas del FFAppState original**:
  - ❌ `searchStringState` → ✅ `UiStateService.searchQuery`
  - ❌ `idProductSelected` → ✅ `UiStateService.selectedProductId`
  - ❌ `typeProduct` → ✅ `UiStateService.selectedProductType`
  - ❌ `imageMain` → ✅ `UiStateService.selectedImageUrl`
  - ❌ `latlngLocation` → ✅ `UiStateService.selectedLocationLatLng`
  - ❌ Variables de cálculo de tarifas → ✅ `UiStateService`

#### 5.3 ItineraryDetails Modularizado
- **Archivos creados**:
  - `lib/bukeer/itinerarios/itinerary_details/sections/` (4 componentes)
  - `itinerary_header_section.dart` - Encabezado y acciones
  - `itinerary_services_section.dart` - Servicios con tabs
  - `itinerary_passengers_section.dart` - Gestión de pasajeros
  - `itinerary_payments_section.dart` - Resumen financiero
  - `itinerary_details_widget_refactored.dart` - Widget principal limpio

- **Mejoras logradas**:
  - 🔥 De 8,483 líneas → 4 componentes modulares (~500 líneas c/u)
  - 🚀 Mejor performance (componentes independientes)
  - 🧹 Código mantenible y testeable
  - 🎨 UI mejorada con diseño consistente

#### 5.4 Manejo Global de Errores
- **Archivos creados**:
  - `lib/services/error_service.dart` - Servicio centralizado de errores
  - `lib/components/error_handler_widget.dart` - Widget de manejo de errores

- **Características**:
  - ✅ Categorización automática de errores (API, Network, Auth, etc.)
  - ✅ Severidad automática (Low, Medium, High)
  - ✅ Mensajes user-friendly
  - ✅ Acciones sugeridas por tipo de error
  - ✅ Logging estructurado
  - ✅ Overlay visual no intrusivo
  - ✅ Historial de errores
  - ✅ Auto-clear para errores menores

#### 5.5 Sistema de Autorización Robusto ✅ COMPLETADO
- **Archivos creados**:
  - `lib/services/authorization_service.dart` - Servicio centralizado de autorización
  - `lib/components/authorization_widget.dart` - Widgets para UI autorizada
  - `lib/custom_code/actions/user_admin_supeardmin_validate_improved.dart` - Actions mejoradas
  - `lib/examples/authorization_examples.dart` - Ejemplos de uso

- **Características del Sistema**:
  - ✅ **Roles granulares**: SuperAdmin, Admin, Agent, Guest
  - ✅ **Permisos específicos**: 20+ permisos categorizados por recurso:acción
  - ✅ **Acceso basado en propiedad**: El dueño siempre tiene acceso
  - ✅ **Cache inteligente**: Roles cacheados por 5 minutos
  - ✅ **Validación robusta**: Múltiples niveles de validación

- **Widgets de Autorización**:
  - `AuthorizedWidget` - Mostrar/ocultar contenido por permisos
  - `AuthorizedButton` - Botones que se deshabilitan sin permisos
  - `AdminOnlyWidget` - Contenido solo para admins
  - `ResourceAccessWidget` - UI diferente según nivel de acceso
  - `UserRoleBadge` - Badge visual del rol del usuario

- **Permisos por Rol**:
  ```
  SuperAdmin: TODO (*)
  Admin: create/read/update/delete en itineraries, contacts, products
  Agent: create/read/update en itineraries, contacts | read-only products
  Guest: Sin permisos especiales
  ```

- **Ejemplo de Uso**:
  ```dart
  // Widget condicional
  AuthorizedWidget(
    requiredPermissions: ['itinerary:delete'],
    child: DeleteButton(),
    fallback: Text('Sin permisos'),
  )
  
  // Botón autorizado
  AuthorizedButton(
    onPressed: () => deleteItinerary(),
    requiredRoles: [RoleType.admin],
    child: Text('Eliminar'),
  )
  
  // Verificación programática
  final canEdit = await appServices.authorization.authorize(
    userId: currentUserUid,
    resourceType: 'itinerary',
    action: 'update',
    ownerId: itineraryOwnerId,
  );
  ```

### 6. Funcionalidad: Cambiar Travel Planner en Itinerarios ✅ COMPLETADO
- **Archivos creados**:
  - `lib/bukeer/itinerarios/dropdown_travel_planner/` - Dropdown de usuarios
  - `lib/bukeer/itinerarios/travel_planner_section/` - Sección completa con edición
  - `lib/custom_code/actions/update_travel_planner.dart` - Acción para actualizar

- **Archivos modificados**:
  - `lib/bukeer/modal_add_edit_itinerary/modal_add_edit_itinerary_widget.dart` - Integración del dropdown
  - `lib/bukeer/modal_add_edit_itinerary/modal_add_edit_itinerary_model.dart` - Modelo actualizado

- **Características**:
  - ✅ Dropdown funcional para seleccionar Travel Planner en modal crear/editar
  - ✅ Solo admins y super admins pueden cambiar el travel planner
  - ✅ Dropdown con usuarios del sistema (usando GetUsersCall - corrige "no usuarios disponibles")
  - ✅ Muestra foto de perfil circular, nombre y apellido en cada opción del dropdown
  - ✅ Muestra foto del travel planner seleccionado cuando el dropdown está cerrado
  - ✅ Hint visual con icono cuando no hay selección
  - ✅ Función de edición en detalles deshabilitada (solo lectura)
  - ✅ Integración completa con CreateItinerary y UpdateItinerary APIs
  - ✅ Carga correcta de usuarios disponibles (mismo método que main_users)
  - ✅ Dropdown personalizado con avatares, fallbacks e indicadores de carga
  - ✅ Manejo robusto de errores de imagen y tamaños fijos
  - ✅ selectedItemBuilder personalizado para mostrar usuario seleccionado
  - ✅ Proyecto limpio y optimizado (flutter clean + pub get)
  - ✅ Feedback visual del cambio
  - ✅ Manejo de estados de carga y error

- **Flujo completado**:
  1. ✅ Usuario abre modal crear/editar itinerario
  2. ✅ Dropdown carga usuarios del sistema usando GetUsersCall
  3. ✅ Usuario selecciona travel planner
  4. ✅ Al crear: se asigna el travel planner seleccionado
  5. ✅ Al editar: se actualiza el travel planner si cambió
  6. ✅ Valor por defecto es el usuario actual o el agente asignado

- **Uso en itinerary_details_widget.dart** (opcional para edición inline):
  Reemplazar la sección estática del Travel Planner (líneas ~1180-1280) con:
  ```dart
  wrapWithModel(
    model: _model.travelPlannerSectionModel,
    updateCallback: () => safeSetState(() {}),
    child: TravelPlannerSectionWidget(
      itineraryId: widget.id!,
      currentAgentId: getJsonField(
        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
        r'$[:].agent',
      )?.toString(),
      travelPlannerName: getJsonField(
        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
        r'$[:].travel_planner_name',
      )?.toString(),
      travelPlannerLastName: getJsonField(
        itineraryDetailsGetitIneraryDetailsResponse.jsonBody,
        r'$[:].travel_planner_last_name',
      )?.toString(),
      onUpdated: () async {
        // Recargar datos del itinerario
        await _model.getItineraryDetails();
      },
    ),
  )
  ```