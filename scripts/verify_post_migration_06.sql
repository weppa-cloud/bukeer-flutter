-- Script de verificación POST-migración 06
-- Ejecutar DESPUÉS de aplicar migración 06

\echo '=== VERIFICACIÓN POST-MIGRACIÓN 06 ==='
\echo 'Fecha y hora:' `date`
\echo ''

-- 1. Verificar nuevas columnas agregadas
\echo '1. Verificar nuevas columnas en locations:'
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'locations'
  AND column_name IN (
    'country_code', 'latitude', 'longitude', 
    'type', 'aliases', 'metadata', 'search_vector'
  )
ORDER BY column_name;

-- 2. Verificar que datos existentes no se perdieron
\echo ''
\echo '2. Verificar integridad de datos existentes:'
SELECT 
    'Total ubicaciones' as metric,
    COUNT(*) as value
FROM locations
UNION ALL
SELECT 
    'Con nombre',
    COUNT(*) 
FROM locations WHERE name IS NOT NULL
UNION ALL
SELECT 
    'Con ciudad',
    COUNT(*) 
FROM locations WHERE city IS NOT NULL
UNION ALL
SELECT 
    'Con país',
    COUNT(*) 
FROM locations WHERE country IS NOT NULL;

-- 3. Verificar nuevas funciones RPC
\echo ''
\echo '3. Verificar nuevas funciones creadas:'
SELECT 
    routine_name,
    routine_type
FROM information_schema.routines 
WHERE routine_name IN (
    'normalize_search_text',
    'update_location_search_vector',
    'function_search_locations_improved',
    'function_get_cities_by_country'
)
ORDER BY routine_name;

-- 4. Verificar que productos siguen funcionando
\echo ''
\echo '4. Verificar relaciones con productos:'
SELECT 
    'Hotels enlazados' as metric,
    COUNT(*) as count
FROM hotels h
JOIN locations l ON h.location_id = l.id
UNION ALL
SELECT 
    'Activities enlazadas',
    COUNT(*)
FROM activities a
JOIN locations l ON a.location_id = l.id
UNION ALL
SELECT 
    'Transfers enlazados',
    COUNT(*)
FROM transfers t
JOIN locations l ON t.location_id = l.id;

-- 5. Test básico de nueva función
\echo ''
\echo '5. Test básico de función de búsqueda:'
SELECT 
    'Test función búsqueda' as test,
    CASE 
        WHEN EXISTS(
            SELECT 1 FROM function_search_locations_improved('', '', NULL, 5)
        ) THEN 'OK - Función responde'
        ELSE 'ERROR - Función no responde'
    END as resultado;

-- 6. Verificar índices (los que no son CONCURRENTLY)
\echo ''
\echo '6. Verificar índices básicos:'
SELECT 
    indexname,
    tablename
FROM pg_indexes 
WHERE tablename = 'locations'
  AND indexname LIKE '%locations%'
ORDER BY indexname;

\echo ''
\echo '=== MIGRACIÓN 06 VERIFICADA ==='
\echo 'Si todo está OK, proceder con migración 07'