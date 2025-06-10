#!/usr/bin/env node

// Script para extraer esquema usando la información que ya tenemos
const fs = require('fs');
const path = require('path');

// Leer el esquema analizado
const schemaPath = path.join(__dirname, '../supabase/schema/analyzed_schema.sql');
const tableAnalysisPath = path.join(__dirname, '../supabase/schema/table_analysis.json');

console.log('📋 Generando esquema completo de producción...\n');

let fullSchema = `-- Bukeer Database Schema
-- Exportado desde análisis de producción
-- Fecha: ${new Date().toISOString()}
-- NOTA: Este esquema es para crear la base en staging

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

`;

// Agregar el esquema base que ya analizamos
if (fs.existsSync(schemaPath)) {
  const analyzedSchema = fs.readFileSync(schemaPath, 'utf8');
  fullSchema += analyzedSchema;
}

// Agregar funciones RPC conocidas
fullSchema += `
-- =============================================
-- FUNCIONES RPC
-- =============================================

-- Función para obtener productos desde vistas
CREATE OR REPLACE FUNCTION function_get_products_from_views(
  p_search_query TEXT DEFAULT NULL,
  p_product_type TEXT DEFAULT NULL,
  p_account_id UUID DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  type TEXT,
  location TEXT,
  main_image TEXT
) AS $$
BEGIN
  -- Implementación pendiente de reverse engineering
  -- Por ahora retorna tabla vacía
  RETURN;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener itinerarios con nombres de contacto
CREATE OR REPLACE FUNCTION function_get_itineraries_with_contact_names(
  p_account_id UUID DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  start_date DATE,
  end_date DATE,
  contact_name TEXT,
  status TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    i.id,
    i.name,
    i.start_date,
    i.end_date,
    c.name as contact_name,
    i.status
  FROM itineraries i
  LEFT JOIN contacts c ON i.id_contact = c.id
  WHERE i.account_id = p_account_id OR p_account_id IS NULL;
END;
$$ LANGUAGE plpgsql;

-- Función de cuentas por cobrar
CREATE OR REPLACE FUNCTION function_cuentas_por_cobrar(
  account_id_param UUID DEFAULT NULL
)
RETURNS TABLE (
  itinerary_id UUID,
  itinerary_name TEXT,
  contact_name TEXT,
  total_amount NUMERIC,
  paid_amount NUMERIC,
  pending_amount NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    i.id,
    i.name,
    c.name,
    i.total_amount,
    i.paid,
    (i.total_amount - i.paid) as pending
  FROM itineraries i
  LEFT JOIN contacts c ON i.id_contact = c.id
  WHERE i.account_id = account_id_param
    AND i.total_amount > i.paid;
END;
$$ LANGUAGE plpgsql;

-- Más funciones...
`;

// Agregar vistas
fullSchema += `
-- =============================================
-- VISTAS
-- =============================================

CREATE OR REPLACE VIEW hotels_view AS
SELECT 
  h.*,
  l.name as location_name,
  l.city as location_city,
  l.country as location_country
FROM hotels h
LEFT JOIN locations l ON h.location::uuid = l.id;

CREATE OR REPLACE VIEW activities_view AS
SELECT 
  a.*,
  l.name as location_name,
  l.city as location_city,
  l.country as location_country
FROM activities a
LEFT JOIN locations l ON a.location = l.id;

-- Más vistas...
`;

// Agregar políticas RLS básicas
fullSchema += `
-- =============================================
-- ROW LEVEL SECURITY
-- =============================================

-- Habilitar RLS en tablas principales
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE itineraries ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Política básica para accounts
CREATE POLICY "Users can view their own account" ON accounts
  FOR SELECT USING (
    id IN (
      SELECT account_id 
      FROM user_contact_info 
      WHERE user_id = auth.uid()
    )
  );

-- Más políticas...
`;

// Agregar datos iniciales
fullSchema += `
-- =============================================
-- DATOS INICIALES
-- =============================================

-- Roles básicos
INSERT INTO roles (id, name, description) VALUES 
(1, 'admin', 'Administrador'),
(2, 'superadmin', 'Super Administrador'),
(3, 'agent', 'Agente')
ON CONFLICT (id) DO NOTHING;

-- Más datos iniciales...
`;

// Guardar el esquema completo
const outputPath = path.join(__dirname, '../supabase/migrations/00_initial_schema.sql');
fs.writeFileSync(outputPath, fullSchema);

console.log(`✅ Esquema exportado a: ${outputPath}`);
console.log(`📄 Total: ${fullSchema.split('\n').length} líneas`);
console.log('\nPróximo paso: supabase db push');