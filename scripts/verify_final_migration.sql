-- Script de verificación FINAL
-- Ejecutar DESPUÉS de aplicar migración 07

\echo '=== VERIFICACIÓN FINAL - MIGRACIÓN COMPLETA ==='
\echo 'Fecha y hora:' `date`
\echo ''

-- 1. Estadísticas de población de datos
\echo '1. Estadísticas de datos poblados:'
SELECT 
    'Total ubicaciones' as metric,
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
UNION ALL
SELECT 
    'Con metadata',
    COUNT(*) 
FROM locations WHERE metadata != '{}'::jsonb
ORDER BY metric;

-- 2. Distribución por país
\echo ''
\echo '2. Distribución por país:'
SELECT 
    country_code,
    country,
    COUNT(*) as locations_count
FROM locations 
WHERE country_code IS NOT NULL
GROUP BY country_code, country
ORDER BY locations_count DESC
LIMIT 10;

-- 3. Test de función de búsqueda con datos reales
\echo ''
\echo '3. Test de búsqueda por "lima":'
SELECT 
    name,
    full_name,
    product_count,
    relevance
FROM function_search_locations_improved('lima', 'hotels', 'PE', 5)
LIMIT 5;

-- 4. Test de función de ciudades por país
\echo ''
\echo '4. Test de ciudades en Perú:'
SELECT 
    city,
    location_count,
    product_count
FROM function_get_cities_by_country('PE', 'hotels')
LIMIT 5;

-- 5. Verificar índices creados
\echo ''
\echo '5. Índices en tabla locations:'
SELECT 
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename = 'locations'
ORDER BY indexname;

-- 6. Test de performance básico
\echo ''
\echo '6. Test de performance (debe ser < 100ms):'
\timing on
SELECT COUNT(*) FROM function_search_locations_improved('', 'hotels', NULL, 20);
\timing off

-- 7. Verificar backup creado
\echo ''
\echo '7. Verificar que backup fue creado:'
SELECT 
    table_name
FROM information_schema.tables 
WHERE table_name LIKE 'locations_backup%'
ORDER BY table_name;

-- 8. Integridad final de datos
\echo ''
\echo '8. Verificación final de integridad:'
SELECT 
    'Ubicaciones únicas' as check_name,
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT id) THEN 'OK'
        ELSE 'ERROR - IDs duplicados'
    END as status
FROM locations
UNION ALL
SELECT 
    'Search vector poblado',
    CASE 
        WHEN COUNT(*) = COUNT(search_vector) THEN 'OK'
        ELSE 'WARNING - Algunos sin search_vector'
    END
FROM locations
UNION ALL
SELECT 
    'Productos enlazados',
    CASE 
        WHEN NOT EXISTS(
            SELECT 1 FROM hotels WHERE location_id NOT IN (SELECT id FROM locations)
        ) THEN 'OK'
        ELSE 'ERROR - Referencias rotas'
    END;

\echo ''
\echo '=== MIGRACIÓN COMPLETADA EXITOSAMENTE ==='
\echo 'El sistema de ubicaciones mejorado está listo para usar'
\echo ''
\echo 'Próximos pasos:'
\echo '1. Actualizar frontend para usar nuevas APIs'
\echo '2. Testing en staging'
\echo '3. Rollout gradual de nuevos widgets'