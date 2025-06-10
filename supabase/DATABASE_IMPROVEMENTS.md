# Recomendaciones para Mejoras en la Base de Datos de Producción

## 🚨 Mejoras Críticas (Alta Prioridad)

### 1. **Índices Faltantes**
```sql
-- Búsquedas frecuentes por account_id (multi-tenancy)
CREATE INDEX idx_itineraries_account_id ON itineraries(account_id);
CREATE INDEX idx_contacts_account_id ON contacts(account_id);
CREATE INDEX idx_itinerary_items_account_id ON itinerary_items(account_id);
CREATE INDEX idx_hotels_account_id ON hotels(account_id);
CREATE INDEX idx_activities_account_id ON activities(account_id);

-- Búsquedas por estado y fechas
CREATE INDEX idx_itineraries_status ON itineraries(status);
CREATE INDEX idx_itineraries_dates ON itineraries(start_date, end_date);

-- Relaciones frecuentes
CREATE INDEX idx_itinerary_items_itinerary_id ON itinerary_items(itinerary_id);
CREATE INDEX idx_passenger_itinerary_id ON passenger(itinerary_id);
CREATE INDEX idx_hotel_rates_hotel_id ON hotel_rates(hotel_id);
```

### 2. **Funciones RPC Faltantes**
Muchas funciones esperadas por el código no existen. Crear o renombrar:
```sql
-- Renombrar funciones existentes para coincidir con el código
ALTER FUNCTION filter_contacts RENAME TO function_get_contacts_search;
ALTER FUNCTION get_data_by_id_products RENAME TO function_get_product_rates;
```

### 3. **Campos Calculados como Columnas Generadas**
```sql
-- En lugar de calcular en cada query
ALTER TABLE itineraries 
ADD COLUMN pending_amount NUMERIC GENERATED ALWAYS AS (total_amount - paid) STORED;

ALTER TABLE itinerary_items
ADD COLUMN profit_amount NUMERIC GENERATED ALWAYS AS (total_price - total_cost) STORED;
```

## ⚡ Optimizaciones de Performance

### 1. **Particionamiento de Tablas Grandes**
```sql
-- Particionar itinerary_items por año (7,813 registros y creciendo)
CREATE TABLE itinerary_items_2024 PARTITION OF itinerary_items
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE itinerary_items_2025 PARTITION OF itinerary_items
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
```

### 2. **Vistas Materializadas para Reportes**
```sql
-- Para los dashboards que son pesados
CREATE MATERIALIZED VIEW mv_sales_summary AS
SELECT 
  DATE_TRUNC('month', created_at) as month,
  account_id,
  COUNT(*) as total_itineraries,
  SUM(total_amount) as revenue,
  SUM(paid) as collected
FROM itineraries
WHERE status != 'cancelled'
GROUP BY 1, 2;

-- Refrescar cada hora
CREATE OR REPLACE FUNCTION refresh_materialized_views()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_sales_summary;
END;
$$ LANGUAGE plpgsql;
```

### 3. **Optimización de Queries JSON**
```sql
-- Índices GIN para búsquedas en JSONB
CREATE INDEX idx_hotels_payment_methods ON hotels USING GIN (payment_methods);
CREATE INDEX idx_activities_schedule ON activities USING GIN (schedule);
CREATE INDEX idx_accounts_currency ON accounts USING GIN (currency);
```

## 🛡️ Mejoras de Integridad de Datos

### 1. **Constraints Faltantes**
```sql
-- Validaciones de negocio
ALTER TABLE itineraries 
ADD CONSTRAINT chk_dates CHECK (end_date >= start_date);

ALTER TABLE itinerary_items
ADD CONSTRAINT chk_amounts CHECK (
  total_cost >= 0 AND 
  total_price >= total_cost
);

-- Evitar duplicados
CREATE UNIQUE INDEX idx_unique_passenger 
ON passenger(itinerary_id, passport) 
WHERE passport IS NOT NULL;
```

### 2. **Triggers para Consistencia**
```sql
-- Actualizar totales automáticamente
CREATE OR REPLACE FUNCTION update_itinerary_totals()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE itineraries
  SET 
    total_cost = COALESCE((
      SELECT SUM(total_cost) 
      FROM itinerary_items 
      WHERE itinerary_id = COALESCE(NEW.itinerary_id, OLD.itinerary_id)
    ), 0),
    total_amount = COALESCE((
      SELECT SUM(total_price) 
      FROM itinerary_items 
      WHERE itinerary_id = COALESCE(NEW.itinerary_id, OLD.itinerary_id)
    ), 0),
    updated_at = NOW()
  WHERE id = COALESCE(NEW.itinerary_id, OLD.itinerary_id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_itinerary_totals
AFTER INSERT OR UPDATE OR DELETE ON itinerary_items
FOR EACH ROW EXECUTE FUNCTION update_itinerary_totals();
```

## 📊 Mejoras de Estructura

### 1. **Normalización de Datos**
```sql
-- Crear tabla de currencies en lugar de JSON
CREATE TABLE currencies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(3) UNIQUE NOT NULL,
  name VARCHAR(100),
  symbol VARCHAR(10),
  exchange_rate NUMERIC(10,4)
);

-- Migrar de JSON a relación
ALTER TABLE itineraries ADD COLUMN currency_id UUID REFERENCES currencies(id);
```

### 2. **Auditoría y Logs**
```sql
-- Tabla de auditoría
CREATE TABLE audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name TEXT NOT NULL,
  record_id UUID NOT NULL,
  action TEXT NOT NULL, -- INSERT, UPDATE, DELETE
  changed_by UUID REFERENCES auth.users(id),
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  old_values JSONB,
  new_values JSONB
);

-- Trigger genérico de auditoría
CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (table_name, record_id, action, changed_by, old_values, new_values)
  VALUES (
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    TG_OP,
    auth.uid(),
    to_jsonb(OLD),
    to_jsonb(NEW)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

## 🔒 Seguridad y RLS

### 1. **Políticas RLS Mejoradas**
```sql
-- Asegurar multi-tenancy estricto
CREATE POLICY "Users can only see their account data" ON itineraries
FOR ALL USING (
  account_id IN (
    SELECT account_id 
    FROM user_contact_info 
    WHERE user_id = auth.uid()
  )
);

-- Aplicar a todas las tablas relevantes
ALTER TABLE itineraries ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE itinerary_items ENABLE ROW LEVEL SECURITY;
```

### 2. **Encriptación de Datos Sensibles**
```sql
-- Usar pgcrypto para datos sensibles
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Encriptar números de pasaporte
ALTER TABLE passenger 
ADD COLUMN passport_encrypted BYTEA;

UPDATE passenger 
SET passport_encrypted = pgp_sym_encrypt(passport, current_setting('app.encryption_key'))
WHERE passport IS NOT NULL;
```

## 🚀 Plan de Implementación

### Fase 1 (Inmediato - Sin downtime)
1. Crear índices faltantes
2. Agregar constraints CHECK
3. Crear vistas materializadas

### Fase 2 (Próxima ventana de mantenimiento)
1. Implementar triggers de consistencia
2. Crear tablas de auditoría
3. Activar RLS donde falte

### Fase 3 (Migración planificada)
1. Normalizar estructuras JSON
2. Particionar tablas grandes
3. Migrar a columnas generadas

## 📈 Monitoreo

### Queries para monitorear mejoras:
```sql
-- Ver queries lentas
SELECT 
  query,
  calls,
  total_time,
  mean_time,
  max_time
FROM pg_stat_statements
WHERE mean_time > 100
ORDER BY mean_time DESC
LIMIT 20;

-- Ver índices no utilizados
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
AND indexname NOT LIKE 'pg_%';

-- Ver tamaño de tablas
SELECT 
  tablename,
  pg_size_pretty(pg_total_relation_size(tablename::regclass)) as size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(tablename::regclass) DESC;
```

## ⚠️ Precauciones

1. **Siempre hacer backup** antes de cambios estructurales
2. **Probar en staging** primero
3. **Monitorear performance** después de cada cambio
4. **Documentar todos los cambios** en migraciones
5. **Comunicar a los usuarios** sobre ventanas de mantenimiento

## 🎯 Beneficios Esperados

- **50-70% mejora** en queries de búsqueda con índices
- **Reducción de errores** con constraints
- **Mejor consistencia** con triggers
- **Auditoría completa** para compliance
- **Escalabilidad** con particionamiento