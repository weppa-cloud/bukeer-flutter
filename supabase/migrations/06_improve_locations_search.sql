-- Migración 06: Mejoras al sistema de ubicaciones (PRODUCCIÓN SEGURA)
-- Fecha: 2025-01-06
-- Descripción: Agregar capacidades de búsqueda mejorada sin romper funcionalidad existente

-- ===================================
-- FASE 1: AGREGAR COLUMNAS SEGURAS
-- ===================================

-- Agregar columnas opcionales (NO rompe nada existente)
ALTER TABLE locations ADD COLUMN IF NOT EXISTS country_code CHAR(2);
ALTER TABLE locations ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 8);
ALTER TABLE locations ADD COLUMN IF NOT EXISTS longitude DECIMAL(11, 8);
ALTER TABLE locations ADD COLUMN IF NOT EXISTS type VARCHAR(50) DEFAULT 'city';
ALTER TABLE locations ADD COLUMN IF NOT EXISTS aliases JSONB DEFAULT '[]'::jsonb;
ALTER TABLE locations ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE locations ADD COLUMN IF NOT EXISTS search_vector tsvector;

-- ===================================
-- FASE 2: FUNCIONES DE NORMALIZACIÓN
-- ===================================

-- Función para normalizar texto de búsqueda
CREATE OR REPLACE FUNCTION normalize_search_text(input_text TEXT)
RETURNS TEXT AS $$
BEGIN
    IF input_text IS NULL THEN
        RETURN '';
    END IF;
    
    RETURN TRIM(
        LOWER(
            -- Reemplazar caracteres especiales con espacios
            REGEXP_REPLACE(
                -- Reemplazar acentos
                TRANSLATE(input_text, 
                    'áéíóúàèìòùâêîôûäëïöüñçÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÄËÏÖÜÑÇ',
                    'aeiouaeiouaeiouaeiounceeiouaeiouaeiouaeiounce'
                ),
                '[^a-z0-9\s]', ' ', 'g'
            )
        )
    );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Función para actualizar search_vector automáticamente
CREATE OR REPLACE FUNCTION update_location_search_vector()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector := to_tsvector('spanish', 
        COALESCE(NEW.name, '') || ' ' || 
        COALESCE(NEW.city, '') || ' ' || 
        COALESCE(NEW.country, '') || ' ' ||
        COALESCE(NEW.aliases::text, '')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===================================
-- FASE 3: FUNCIÓN DE BÚSQUEDA MEJORADA
-- ===================================

-- Nueva función de búsqueda (NO reemplaza las existentes)
CREATE OR REPLACE FUNCTION function_search_locations_improved(
    p_search_term TEXT DEFAULT '',
    p_product_type TEXT DEFAULT '',
    p_country_code CHAR(2) DEFAULT NULL,
    p_limit INTEGER DEFAULT 20
)
RETURNS TABLE (
    id UUID,
    name VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    country_code CHAR(2),
    location_type VARCHAR(50),
    full_name TEXT,
    product_count BIGINT,
    relevance FLOAT
) AS $$
DECLARE
    search_query tsquery;
BEGIN
    -- Preparar query de búsqueda
    IF p_search_term IS NOT NULL AND p_search_term != '' THEN
        search_query := plainto_tsquery('spanish', p_search_term);
    END IF;
    
    RETURN QUERY
    WITH location_products AS (
        -- Contar productos por ubicación según el tipo
        SELECT 
            l.id as location_id,
            CASE 
                WHEN p_product_type = 'hotels' THEN 
                    (SELECT COUNT(*) FROM hotels h WHERE h.location_id = l.id)
                WHEN p_product_type = 'activities' THEN 
                    (SELECT COUNT(*) FROM activities a WHERE a.location_id = l.id)
                WHEN p_product_type = 'transfers' THEN 
                    (SELECT COUNT(*) FROM transfers t WHERE t.location_id = l.id)
                ELSE 
                    (SELECT COUNT(*) FROM hotels h WHERE h.location_id = l.id) +
                    (SELECT COUNT(*) FROM activities a WHERE a.location_id = l.id) +
                    (SELECT COUNT(*) FROM transfers t WHERE t.location_id = l.id)
            END as product_count
        FROM locations l
    )
    SELECT 
        l.id,
        l.name,
        l.city,
        l.country,
        l.country_code,
        l.type,
        CONCAT(
            l.name, 
            CASE WHEN l.city IS NOT NULL AND l.city != l.name 
                 THEN ', ' || l.city ELSE '' END,
            CASE WHEN l.country IS NOT NULL 
                 THEN ', ' || l.country ELSE '' END
        ) as full_name,
        COALESCE(lp.product_count, 0) as product_count,
        CASE 
            WHEN search_query IS NOT NULL AND l.search_vector IS NOT NULL THEN
                ts_rank(l.search_vector, search_query)
            WHEN p_search_term IS NOT NULL AND p_search_term != '' THEN
                CASE 
                    WHEN l.name ILIKE '%' || p_search_term || '%' THEN 0.9
                    WHEN l.city ILIKE '%' || p_search_term || '%' THEN 0.7
                    WHEN l.country ILIKE '%' || p_search_term || '%' THEN 0.5
                    ELSE 0.1
                END
            ELSE 1.0
        END as relevance
    FROM locations l
    LEFT JOIN location_products lp ON l.id = lp.location_id
    WHERE 
        -- Filtro por país si se especifica
        (p_country_code IS NULL OR l.country_code = p_country_code)
        AND
        -- Filtro por término de búsqueda
        (
            p_search_term IS NULL OR p_search_term = '' OR
            (search_query IS NOT NULL AND l.search_vector @@ search_query) OR
            l.name ILIKE '%' || p_search_term || '%' OR
            l.city ILIKE '%' || p_search_term || '%' OR
            l.country ILIKE '%' || p_search_term || '%'
        )
        AND
        -- Solo ubicaciones con productos (opcional)
        (p_product_type = '' OR lp.product_count > 0)
    ORDER BY 
        relevance DESC,
        product_count DESC,
        l.name ASC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- ===================================
-- FASE 4: FUNCIÓN PARA OBTENER CIUDADES
-- ===================================

-- Función para obtener ciudades disponibles por país
CREATE OR REPLACE FUNCTION function_get_cities_by_country(
    p_country_code CHAR(2) DEFAULT NULL,
    p_product_type TEXT DEFAULT 'hotels'
)
RETURNS TABLE (
    city VARCHAR(255),
    country VARCHAR(255),
    country_code CHAR(2),
    location_count BIGINT,
    product_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    WITH city_stats AS (
        SELECT 
            l.city,
            l.country,
            l.country_code,
            COUNT(DISTINCT l.id) as location_count,
            CASE 
                WHEN p_product_type = 'hotels' THEN 
                    COUNT(DISTINCT h.id)
                WHEN p_product_type = 'activities' THEN 
                    COUNT(DISTINCT a.id)
                WHEN p_product_type = 'transfers' THEN 
                    COUNT(DISTINCT t.id)
                ELSE 
                    COUNT(DISTINCT h.id) + COUNT(DISTINCT a.id) + COUNT(DISTINCT t.id)
            END as product_count
        FROM locations l
        LEFT JOIN hotels h ON l.id = h.location_id
        LEFT JOIN activities a ON l.id = a.location_id
        LEFT JOIN transfers t ON l.id = t.location_id
        WHERE 
            l.city IS NOT NULL 
            AND l.city != ''
            AND (p_country_code IS NULL OR l.country_code = p_country_code)
        GROUP BY l.city, l.country, l.country_code
    )
    SELECT 
        cs.city,
        cs.country,
        cs.country_code,
        cs.location_count,
        cs.product_count
    FROM city_stats cs
    WHERE cs.product_count > 0
    ORDER BY cs.product_count DESC, cs.city ASC;
END;
$$ LANGUAGE plpgsql;

-- ===================================
-- FASE 5: TRIGGERS (OPCIONAL - COMENTADO PARA SEGURIDAD)
-- ===================================

-- Trigger para actualizar search_vector automáticamente
-- (Comentado por seguridad en producción - se puede activar después)
/*
CREATE TRIGGER trigger_location_search_vector
    BEFORE INSERT OR UPDATE ON locations
    FOR EACH ROW EXECUTE FUNCTION update_location_search_vector();
*/

-- ===================================
-- COMENTARIOS FINALES
-- ===================================

-- Esta migración es SEGURA para producción porque:
-- 1. Solo AGREGA columnas opcionales
-- 2. NO modifica datos existentes
-- 3. NO elimina nada
-- 4. Las nuevas funciones son independientes
-- 5. NO activa triggers automáticamente

-- Para activar completamente:
-- 1. Ejecutar script de población de datos
-- 2. Crear índices con CONCURRENTLY
-- 3. Activar triggers si se desea
-- 4. Actualizar APIs para usar nuevas funciones