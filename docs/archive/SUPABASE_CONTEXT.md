# Contexto de Supabase para Bukeer

## 📊 Resumen de la Base de Datos

### Estadísticas Generales
- **Total de tablas**: 33 tablas principales
- **Total de vistas**: 6 vistas denormalizadas  
- **Total de funciones RPC**: 67 funciones
- **Edge Functions**: 0 (No hay Edge Functions desplegadas)
- **Registros principales**:
  - 887 itinerarios
  - 758 contactos
  - 7,813 items de itinerario
  - 321 hoteles
  - 594 actividades
  - 14 cuentas (multi-tenant)

### Tablas Principales

#### 🏢 Sistema Multi-tenant
- **accounts** (14 registros) - Cuentas/empresas del sistema
- **user_contact_info** - Información de usuarios por cuenta
- **user_roles** - Roles y permisos de usuarios

#### 👥 Gestión de Contactos
- **contacts** (758 registros) - Clientes y proveedores
  - Soporta personas y empresas (is_company)
  - Clasificación: is_client, is_provider
  - Vinculado a cuentas (account_id)

#### 📋 Gestión de Itinerarios
- **itineraries** (887 registros) - Itinerarios principales
  - Estados: draft, confirmed, cancelled
  - Totales calculados: total_amount, total_cost, paid
  - Visibilidad configurable
  
- **itinerary_items** (7,813 registros) - Líneas de itinerario
  - Tipos: hotel, activity, transfer, flight
  - Control de pagos: paid_cost, pending_paid_cost
  - Estados de reserva: reservation_status

- **passenger** - Pasajeros por itinerario

#### 🏨 Productos Turísticos

**Hotels**
- **hotels** (321 registros) - Catálogo de hoteles
- **hotel_rates** (569 registros) - Tarifas por tipo de habitación

**Activities**  
- **activities** (594 registros) - Catálogo de actividades
- **activities_rates** - Tarifas de actividades

**Transfers**
- **transfers** - Servicios de transporte
- **transfer_rates** - Tarifas de transfers

**Flights**
- **flights** - Información de vuelos
- **airlines** - Catálogo de aerolíneas
- **airports** - Catálogo de aeropuertos

#### 💰 Finanzas
- **transactions** - Registro de pagos y transacciones

#### 📍 Datos de Referencia
- **locations** - Ubicaciones/destinos
- **regions** - Regiones geográficas
- **nationalities** - Nacionalidades
- **points_of_interest** - Puntos de interés

### Vistas Denormalizadas
- **hotels_view** - Vista optimizada de hoteles
- **activities_view** - Vista optimizada de actividades
- **transfers_view** - Vista optimizada de transfers
- **airports_view** - Vista mejorada de aeropuertos
- **user_roles_view** - Vista de roles de usuario

### Funciones RPC (Database Functions)

#### ✅ Funciones Activas (Confirmadas)
1. **function_get_products_from_views** - Búsqueda de productos desde vistas
2. **function_get_itineraries_with_contact_names** - Lista itinerarios con info de contacto
3. **function_cuentas_por_cobrar** - Reporte de cuentas por cobrar
4. **function_cuentas_por_pagar** - Reporte de cuentas por pagar
5. **function_reporte_ventas** - Reporte de ventas
6. **function_get_agenda** - Obtener agenda/calendario
7. **function_get_user_roles_for_authenticated_user** - Roles del usuario actual

#### 🔍 Funciones RPC Existentes (Lista completa)
Las siguientes funciones existen como RPC en la base de datos:

**Gestión de Productos:**
- `function_get_products_from_views` ✅
- `function_get_products_by_type_location_search`
- `function_get_products_by_type_search`
- `function_search_products`
- `function_get_products_paginated`
- `function_test_products`
- `get_products_paginated_test`
- `get_hotels_paginated`
- `get_data_by_id_products`

**Gestión de Itinerarios:**
- `function_create_itinerary`
- `function_get_itinerary_details`
- `function_get_itineraries_with_contact_names` ✅
- `function_get_itineraries_with_contact_names_search`
- `function_copy_itinerary_item`
- `function_all_items_itinerary`
- `function_get_passengers_itinerary`
- `function_client_itinerary`

**Gestión de Contactos:**
- `function_get_contacts_search`
- `function_get_contacts_related`
- `function_validate_delete_contact`
- `function_get_contact_with_location`
- `filter_contacts`

**Reportes Financieros:**
- `function_cuentas_por_cobrar` ✅
- `function_cuentas_por_pagar` ✅
- `function_reporte_ventas` ✅
- `function_get_provider_payments`

**Integraciones:**
- `request_openai_extraction_edge` - Integración con OpenAI
- `sync_duffel_airlines` - Sincronización con Duffel (aerolíneas)
- `sync_duffel_airports` - Sincronización con Duffel (aeropuertos)
- `get_bukeer_data_for_wp_sync` - Sincronización con WordPress
- `hotel_pdf_generation` - Generación de PDFs

**Otras Funciones:**
- `function_get_agenda` ✅
- `function_get_user_roles_for_authenticated_user` ✅
- `function_get_agent_data`
- `function_get_user_by_email`
- `normalize_phone_colombia_only`
- `update_account_currency`

### Edge Functions

**No hay Edge Functions desplegadas**. Todas las funciones que parecían ser Edge Functions (por el sufijo "_edge") son en realidad funciones RPC en la base de datos.

### Características Importantes

1. **IDs como UUID**: Todas las tablas usan UUID como primary key
2. **Multi-tenancy**: Casi todas las tablas tienen `account_id`
3. **Soft Delete**: Algunas entidades usan borrado lógico
4. **Timestamps**: created_at y updated_at en la mayoría de tablas
5. **JSONB**: Uso extensivo para metadata, currency, payment_methods

### Seguridad y Acceso

- **Autenticación**: Integrada con Supabase Auth
- **RLS**: Políticas Row Level Security probablemente activas
- **Roles**: Sistema de roles (admin=1, superadmin=2)

## 🧪 Implicaciones para Testing

1. **Mocks de Supabase**: Necesitan coincidir con estructura UUID
2. **Multi-tenancy**: Tests deben incluir account_id
3. **Funciones RPC**: Las funciones están en la BD, no como Edge Functions
4. **Datos relacionales**: Muchas foreign keys entre tablas
5. **Nombres de funciones**: Muchas funciones esperadas no coinciden con las existentes

## 📝 Notas Importantes

- Esta es una base de datos en **PRODUCCIÓN** - solo lectura
- El esquema fue inferido de muestras de datos
- Los tipos de datos exactos pueden variar
- Algunas tablas están vacías (flights, notes, user_contact_info)
- **NO hay Edge Functions** - todas las funciones son RPC en PostgreSQL