-- Script 07: Población de datos para sistema de ubicaciones mejorado
-- Fecha: 2025-01-06
-- Descripción: Poblar las nuevas columnas con datos normalizados
-- IMPORTANTE: Ejecutar DESPUÉS de la migración 06

-- ===================================
-- BACKUP DE SEGURIDAD
-- ===================================

-- Crear backup antes de modificar datos
CREATE TABLE IF NOT EXISTS locations_backup_pre_populate AS 
SELECT * FROM locations;

-- ===================================
-- PASO 1: POBLAR COUNTRY_CODE
-- ===================================

-- Actualizar códigos de país basados en nombres conocidos
UPDATE locations SET country_code = 'PE' 
WHERE (country ILIKE '%peru%' OR country ILIKE '%perú%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'CO' 
WHERE (country ILIKE '%colombia%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'EC' 
WHERE (country ILIKE '%ecuador%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'MX' 
WHERE (country ILIKE '%mexico%' OR country ILIKE '%méxico%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'CL' 
WHERE (country ILIKE '%chile%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'AR' 
WHERE (country ILIKE '%argentina%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'BR' 
WHERE (country ILIKE '%brasil%' OR country ILIKE '%brazil%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'BO' 
WHERE (country ILIKE '%bolivia%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'UY' 
WHERE (country ILIKE '%uruguay%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'PY' 
WHERE (country ILIKE '%paraguay%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'VE' 
WHERE (country ILIKE '%venezuela%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'GY' 
WHERE (country ILIKE '%guyana%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'SR' 
WHERE (country ILIKE '%suriname%') 
  AND country_code IS NULL;

UPDATE locations SET country_code = 'GF' 
WHERE (country ILIKE '%guyana francesa%' OR country ILIKE '%french guiana%') 
  AND country_code IS NULL;

-- ===================================
-- PASO 2: POBLAR SEARCH_VECTOR
-- ===================================

-- Actualizar search_vector para todas las ubicaciones existentes
UPDATE locations SET 
    search_vector = to_tsvector('spanish', 
        COALESCE(name, '') || ' ' || 
        COALESCE(city, '') || ' ' || 
        COALESCE(country, '') || ' ' ||
        COALESCE(aliases::text, '')
    )
WHERE search_vector IS NULL;

-- ===================================
-- PASO 3: POBLAR TIPO DE UBICACIÓN
-- ===================================

-- Clasificar tipos de ubicación basados en patrones comunes
UPDATE locations SET type = 'resort'
WHERE type = 'city' 
  AND (
    name ILIKE '%resort%' OR 
    name ILIKE '%lodge%' OR
    name ILIKE '%machu picchu%' OR
    name ILIKE '%sanctuary%' OR
    name ILIKE '%santuario%'
  );

UPDATE locations SET type = 'airport'
WHERE type = 'city' 
  AND (
    name ILIKE '%airport%' OR 
    name ILIKE '%aeropuerto%' OR
    name ILIKE '%terminal%'
  );

UPDATE locations SET type = 'region'
WHERE type = 'city' 
  AND (
    name ILIKE '%region%' OR 
    name ILIKE '%valle%' OR
    name ILIKE '%valley%' OR
    name ILIKE '%provincia%' OR
    name ILIKE '%department%'
  );

-- ===================================
-- PASO 4: POBLAR COORDENADAS (EJEMPLOS)
-- ===================================

-- Coordenadas para ubicaciones principales de Perú
UPDATE locations SET latitude = -12.0464, longitude = -77.0428
WHERE name ILIKE '%lima%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -13.5319, longitude = -71.9675
WHERE name ILIKE '%cusco%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -13.1631, longitude = -72.5450
WHERE name ILIKE '%machu picchu%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -15.8402, longitude = -70.0219
WHERE name ILIKE '%puno%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -9.1900, longitude = -75.0152
WHERE name ILIKE '%huancayo%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -8.1116, longitude = -79.0287
WHERE name ILIKE '%trujillo%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -6.7014, longitude = -79.9097
WHERE name ILIKE '%chiclayo%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -5.1945, longitude = -80.6328
WHERE name ILIKE '%piura%' AND country_code = 'PE' AND latitude IS NULL;

UPDATE locations SET latitude = -3.7437, longitude = -73.2516
WHERE name ILIKE '%iquitos%' AND country_code = 'PE' AND latitude IS NULL;

-- Coordenadas para ubicaciones principales de Colombia
UPDATE locations SET latitude = 4.7110, longitude = -74.0721
WHERE name ILIKE '%bogota%' AND country_code = 'CO' AND latitude IS NULL;

UPDATE locations SET latitude = 10.3932, longitude = -75.4794
WHERE name ILIKE '%cartagena%' AND country_code = 'CO' AND latitude IS NULL;

UPDATE locations SET latitude = 6.2486, longitude = -75.5636
WHERE name ILIKE '%medellin%' AND country_code = 'CO' AND latitude IS NULL;

UPDATE locations SET latitude = 3.4516, longitude = -76.5320
WHERE name ILIKE '%cali%' AND country_code = 'CO' AND latitude IS NULL;

-- ===================================
-- PASO 5: POBLAR ALIASES CON NOMBRES ALTERNATIVOS
-- ===================================

-- Agregar aliases para ubicaciones con nombres alternativos conocidos
UPDATE locations SET aliases = '["Lima", "Ciudad de Lima", "Lima Metropolitana"]'::jsonb
WHERE name ILIKE '%lima%' AND country_code = 'PE' AND aliases = '[]'::jsonb;

UPDATE locations SET aliases = '["Cusco", "Cuzco", "Qosqo"]'::jsonb
WHERE name ILIKE '%cusco%' AND country_code = 'PE' AND aliases = '[]'::jsonb;

UPDATE locations SET aliases = '["Machu Picchu", "Machupicchu", "Santuario"]'::jsonb
WHERE name ILIKE '%machu picchu%' AND country_code = 'PE' AND aliases = '[]'::jsonb;

UPDATE locations SET aliases = '["Bogotá", "Bogota", "Santafé de Bogotá"]'::jsonb
WHERE name ILIKE '%bogota%' AND country_code = 'CO' AND aliases = '[]'::jsonb;

UPDATE locations SET aliases = '["Cartagena", "Cartagena de Indias", "La Heroica"]'::jsonb
WHERE name ILIKE '%cartagena%' AND country_code = 'CO' AND aliases = '[]'::jsonb;

-- ===================================
-- PASO 6: POBLAR METADATA
-- ===================================

-- Agregar metadata básica para ubicaciones principales
UPDATE locations SET metadata = jsonb_build_object(
    'timezone', 'America/Lima',
    'currency', 'PEN',
    'language', 'es'
) WHERE country_code = 'PE' AND metadata = '{}'::jsonb;

UPDATE locations SET metadata = jsonb_build_object(
    'timezone', 'America/Bogota',
    'currency', 'COP',
    'language', 'es'
) WHERE country_code = 'CO' AND metadata = '{}'::jsonb;

UPDATE locations SET metadata = jsonb_build_object(
    'timezone', 'America/Guayaquil',
    'currency', 'USD',
    'language', 'es'
) WHERE country_code = 'EC' AND metadata = '{}'::jsonb;

-- ===================================
-- PASO 7: ACTUALIZAR SEARCH_VECTOR CON NUEVOS DATOS
-- ===================================

-- Re-generar search_vector después de agregar aliases
UPDATE locations SET 
    search_vector = to_tsvector('spanish', 
        COALESCE(name, '') || ' ' || 
        COALESCE(city, '') || ' ' || 
        COALESCE(country, '') || ' ' ||
        COALESCE(aliases::text, '')
    );

-- ===================================
-- PASO 8: CREAR ÍNDICES PARA PERFORMANCE
-- ===================================

-- Crear índices de forma concurrente para no bloquear la tabla
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_locations_country_code 
ON locations(country_code);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_locations_type 
ON locations(type);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_locations_city 
ON locations(city);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_locations_search_vector 
ON locations USING GIN(search_vector);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_locations_coordinates 
ON locations(latitude, longitude) 
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- ===================================
-- PASO 9: ESTADÍSTICAS Y VERIFICACIÓN
-- ===================================

-- Ver estadísticas de la población de datos
SELECT 
    'Ubicaciones totales' as metric,
    COUNT(*) as value
FROM locations
UNION ALL
SELECT 
    'Con country_code',
    COUNT(*) 
FROM locations WHERE country_code IS NOT NULL
UNION ALL
SELECT 
    'Con coordenadas',
    COUNT(*) 
FROM locations WHERE latitude IS NOT NULL AND longitude IS NOT NULL
UNION ALL
SELECT 
    'Con search_vector',
    COUNT(*) 
FROM locations WHERE search_vector IS NOT NULL
UNION ALL
SELECT 
    'Con aliases',
    COUNT(*) 
FROM locations WHERE aliases != '[]'::jsonb
ORDER BY metric;

-- Ver distribución por país
SELECT 
    country_code,
    country,
    COUNT(*) as locations_count
FROM locations 
WHERE country_code IS NOT NULL
GROUP BY country_code, country
ORDER BY locations_count DESC;

-- ===================================
-- COMENTARIOS FINALES
-- ===================================

-- Este script:
-- 1. Crea backup automático
-- 2. Pobla datos de forma inteligente
-- 3. Crea índices para performance
-- 4. Proporciona estadísticas
-- 5. Es seguro para ejecutar múltiples veces

-- Para verificar resultados:
-- SELECT * FROM locations WHERE country_code = 'PE' LIMIT 5;
-- SELECT name, full_name, product_count FROM function_search_locations_improved('lima', 'hotels', 'PE');

COMMENT ON TABLE locations IS 'Tabla de ubicaciones mejorada con búsqueda full-text y datos geográficos - Actualizada 2025-01-06';