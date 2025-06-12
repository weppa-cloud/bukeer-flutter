# Análisis del Esquema de Base de Datos - Tablas Financieras

## Resumen Ejecutivo

Este documento contiene un análisis completo de las tablas relacionadas con aspectos financieros, pagos, monedas y tarifas en la base de datos de Bukeer.

## Tablas Principales con Información Financiera

### 1. **transactions** (Tabla de Transacciones)
Tabla central para el registro de todas las transacciones financieras.

```sql
CREATE TABLE public.transactions (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id_itinerary uuid,                    -- Relación con itinerario
    date date,                            -- Fecha de la transacción
    value numeric,                        -- Valor de la transacción
    payment_method text,                  -- Método de pago
    account_id uuid,                      -- Cuenta asociada
    type text NOT NULL,                   -- Tipo: 'ingreso' o 'egreso'
    voucher_url text,                     -- URL del comprobante
    id_item_itinerary uuid,               -- Item del itinerario relacionado
    reference text,                       -- Referencia de pago
    CONSTRAINT check_value_decimal CHECK (value = round(value, 2))
);
```

**Características clave:**
- Registra ingresos y egresos
- Soporta múltiples métodos de pago
- Vincula transacciones con items específicos del itinerario
- Almacena comprobantes digitales

### 2. **accounts** (Tabla de Cuentas)
Gestiona la configuración multi-moneda y métodos de pago por cuenta.

```sql
CREATE TABLE public.accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    -- ... otros campos ...
    currency jsonb[] DEFAULT '{}'::jsonb[],        -- Configuración de monedas
    types_increase jsonb[] DEFAULT '{}'::jsonb[],  -- Tipos de incremento/markup
    payment_methods jsonb[] DEFAULT '{}'::jsonb[]  -- Métodos de pago aceptados
);
```

**Características clave:**
- Soporte multi-moneda mediante array JSONB
- Configuración de métodos de pago por cuenta
- Tipos de incremento personalizables

### 3. **itineraries** (Tabla de Itinerarios)
Contiene los totales financieros consolidados de cada itinerario.

```sql
CREATE TABLE public.itineraries (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    -- ... otros campos ...
    currency_type text,                           -- Moneda principal
    total_amount numeric DEFAULT '0'::numeric,    -- Total a cobrar
    total_markup numeric DEFAULT '0'::numeric,    -- Margen de ganancia
    total_cost numeric DEFAULT '0'::numeric,      -- Costo total
    total_provider_payment numeric DEFAULT '0'::numeric,  -- Pagos a proveedores
    paid numeric,                                 -- Monto pagado
    pending_paid numeric,                         -- Monto pendiente
    currency jsonb,                               -- Configuración de moneda
    -- Totales por tipo de servicio
    total_hotels numeric,
    total_flights numeric,
    total_activities numeric,
    total_transfer numeric
);
```

**Características clave:**
- Cálculo automático de márgenes (markup)
- Seguimiento de pagos y pendientes
- Totales segregados por tipo de servicio

### 4. **itinerary_items** (Tabla de Items del Itinerario)
Detalle financiero de cada servicio incluido en un itinerario.

```sql
CREATE TABLE public.itinerary_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    id_itinerary uuid,
    -- ... otros campos ...
    unit_cost integer,                    -- Costo unitario
    quantity integer,                     -- Cantidad
    total_cost integer,                   -- Costo total
    profit_percentage integer,            -- Porcentaje de ganancia
    profit text,                          -- Ganancia en valor
    total_price integer,                  -- Precio total
    unit_price text,                      -- Precio unitario
    paid_cost integer,                    -- Costo pagado
    pending_paid_cost integer,            -- Costo pendiente de pago
    reservation_status boolean DEFAULT FALSE
);
```

### 5. **Tablas de Tarifas (Rates)**

#### hotel_rates
```sql
CREATE TABLE public.hotel_rates (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    hotel_id uuid NOT NULL,
    name text,
    capacity integer,
    unit_cost numeric,                    -- Costo base
    profit numeric,                       -- Ganancia/margen
    price numeric,                        -- Precio final
    currency text,                        -- Moneda
    is_active boolean DEFAULT true,
    account_id uuid
);
```

#### activities_rates
```sql
CREATE TABLE public.activities_rates (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    unit_cost numeric,
    profit numeric,
    price numeric,
    id_product uuid,
    account_id uuid
);
```

#### transfer_rates
```sql
CREATE TABLE public.transfer_rates (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    unit_cost numeric,
    profit numeric,
    price numeric,
    id_transfer uuid,
    account_id uuid
);
```

## Métodos de Pago Identificados

Basado en los datos de muestra en la tabla `transactions`:
- Tarjeta de crédito
- PSE (Pagos Seguros en Línea)
- ScotiaBank Colpatria
- Transferencia bancaria (implícito)

## Monedas y Tipos de Cambio

1. **Moneda Principal**: Configurada en `itineraries.currency_type` (por defecto 'USD')
2. **Multi-moneda**: Soportada a través de `accounts.currency[]` como array JSONB
3. **Conversión**: No se encontró una tabla específica de tipos de cambio, sugiere que se maneja a nivel de aplicación

## Cálculos Financieros Automatizados

### Triggers y Funciones Identificadas:

1. **calculate_total_cost()**: Calcula el costo total basado en cantidad y noches (para hoteles)
2. **calculated_total_markup()**: Calcula el margen de ganancia considerando tipos de incremento
3. **function_calculate_item_pending_paid_cost()**: Inicializa el monto pendiente de pago

## Flujo de Datos Financieros

1. **Configuración**: Las cuentas definen monedas y métodos de pago aceptados
2. **Tarifas**: Se establecen costos, márgenes y precios para cada servicio
3. **Itinerario**: Agrupa servicios y calcula totales automáticamente
4. **Transacciones**: Registra cada pago (ingreso) o pago a proveedor (egreso)
5. **Conciliación**: Actualiza montos pagados y pendientes en items y totales

## Recomendaciones para Mejoras

1. **Tabla de Tipos de Cambio**: Crear una tabla dedicada para gestionar conversiones
2. **Auditoría**: Añadir campos de auditoría en transacciones (usuario, IP, etc.)
3. **Estados de Pago**: Implementar un enum para estados más detallados
4. **Comisiones**: Agregar campos para tracking de comisiones por canal de venta
5. **Impuestos**: Estructura dedicada para manejo de impuestos por región

## Consideraciones de Seguridad

1. Los montos financieros usan tipo `numeric` con validación de decimales
2. Las URLs de vouchers están almacenadas como texto plano
3. No se observa encriptación de datos sensibles a nivel de base de datos
4. Recomendación: Implementar auditoría de acceso a datos financieros