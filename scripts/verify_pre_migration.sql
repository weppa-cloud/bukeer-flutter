-- Script de verificación PRE-migración
-- Ejecutar ANTES de aplicar las migraciones

\echo '=== VERIFICACIÓN PRE-MIGRACIÓN ==='
\echo 'Fecha y hora:' `date`
\echo ''

-- 1. Verificar estructura actual de locations
\echo '1. Estructura actual de tabla locations:'
\d locations

-- 2. Verificar datos existentes
\echo ''
\echo '2. Estadísticas actuales:'
SELECT 
    'Total ubicaciones' as metric,
    COUNT(*) as value
FROM locations
UNION ALL
SELECT 
    'Con ciudad',
    COUNT(*) 
FROM locations WHERE city IS NOT NULL
UNION ALL
SELECT 
    'Con país',
    COUNT(*) 
FROM locations WHERE country IS NOT NULL
ORDER BY metric;

-- 3. Verificar si ya existen nuevas columnas
\echo ''
\echo '3. Verificar columnas existentes:'
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'locations'
ORDER BY ordinal_position;

-- 4. Verificar uso en productos
\echo ''
\echo '4. Uso de location_id en productos:'
SELECT 
    'Hotels con location_id' as table_name,
    COUNT(*) as count
FROM hotels WHERE location_id IS NOT NULL
UNION ALL
SELECT 
    'Activities con location_id',
    COUNT(*) 
FROM activities WHERE location_id IS NOT NULL
UNION ALL
SELECT 
    'Transfers con location_id',
    COUNT(*) 
FROM transfers WHERE location_id IS NOT NULL;

-- 5. Verificar posibles duplicados
\echo ''
\echo '5. Posibles ubicaciones duplicadas:'
SELECT 
    LOWER(TRIM(name)) as normalized_name,
    LOWER(TRIM(COALESCE(city, ''))) as normalized_city,
    LOWER(TRIM(COALESCE(country, ''))) as normalized_country,
    COUNT(*) as duplicates,
    string_agg(name, ', ') as original_names
FROM locations 
GROUP BY 
    LOWER(TRIM(name)),
    LOWER(TRIM(COALESCE(city, ''))),
    LOWER(TRIM(COALESCE(country, '')))
HAVING COUNT(*) > 1
ORDER BY duplicates DESC
LIMIT 10;

-- 6. Verificar funciones RPC existentes
\echo ''
\echo '6. Funciones RPC actuales relacionadas con locations:'
SELECT 
    routine_name,
    routine_type
FROM information_schema.routines 
WHERE routine_name LIKE '%location%' 
   OR routine_name LIKE '%search%'
ORDER BY routine_name;

\echo ''
\echo '=== VERIFICACIÓN COMPLETADA ==='
\echo 'Si todo se ve correcto, proceder con migración 06'