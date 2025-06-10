-- Bukeer Database Schema
-- Exportado desde análisis de producción
-- Fecha: 2025-06-09T16:33:56.879Z
-- NOTA: Este esquema es para crear la base en staging

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Bukeer Database Schema
-- Generated from Supabase API Analysis
-- Date: 2025-06-09T15:50:57.175Z
-- NOTE: This is inferred from data samples, actual types may vary

-- Table: accounts (14 rows)
CREATE TABLE IF NOT EXISTS accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name TEXT,
    status TEXT,
    id_fm INTEGER,
    logo_image TEXT,
    type_id TEXT,
    number_id TEXT,
    phone TEXT,
    phone2 TEXT,
    mail TEXT,
    location TEXT,
    website TEXT,
    cancellation_policy TEXT,
    privacy_policy TEXT,
    terms_conditions TEXT,
    currency JSONB DEFAULT '[]'::jsonb,
    types_increase JSONB DEFAULT '[]'::jsonb,
    payment_methods JSONB DEFAULT '[]'::jsonb
);

-- Table: contacts (758 rows)
CREATE TABLE IF NOT EXISTS contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    managed_by_user_id TEXT,
    additional_info TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    nationality TEXT,
    type_id TEXT,
    number_id TEXT,
    id_itinerary TEXT,
    birth_date DATE,
    id_fm TEXT,
    user_id TEXT,
    user_rol TEXT,
    website TEXT,
    id_related_contact TEXT,
    is_company BOOLEAN DEFAULT FALSE,
    is_provider BOOLEAN DEFAULT FALSE,
    phone2 TEXT,
    user_image TEXT,
    is_client BOOLEAN,
    account_id UUID,
    location UUID,
    position TEXT,
    notify TEXT
);

-- Table: itineraries (887 rows)
CREATE TABLE IF NOT EXISTS itineraries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_created_by UUID,
    name TEXT,
    start_date DATE,
    end_date DATE,
    status TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    id_contact UUID,
    passenger_count INTEGER,
    currency_type TEXT,
    valid_until DATE,
    request_type TEXT,
    total_amount INTEGER,
    total_markup INTEGER,
    total_cost INTEGER,
    agent TEXT,
    total_provider_payment INTEGER,
    id_fm TEXT,
    language TEXT,
    account_id UUID,
    total_hotels INTEGER,
    total_flights INTEGER,
    total_activities INTEGER,
    total_transfer INTEGER,
    paid INTEGER,
    pending_paid INTEGER,
    currency JSONB,
    itinerary_visibility BOOLEAN,
    rates_visibility BOOLEAN DEFAULT FALSE,
    types_increase TEXT,
    total_amount_rate INTEGER,
    personalized_message TEXT,
    main_image TEXT,
    confirmation_date TEXT
);

-- Table: itinerary_items (7813 rows)
CREATE TABLE IF NOT EXISTS itinerary_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_itinerary UUID,
    start_time TEXT,
    end_time TEXT,
    day_number TEXT,
    order TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    unit_cost INTEGER,
    quantity INTEGER,
    total_cost INTEGER,
    date DATE,
    destination TEXT,
    product_name TEXT,
    rate_name TEXT,
    product_type TEXT,
    hotel_nights TEXT,
    profit_percentage INTEGER,
    profit TEXT,
    total_price INTEGER,
    flight_departure TEXT,
    flight_arrival TEXT,
    departure_time TEXT,
    arrival_time TEXT,
    flight_number TEXT,
    airline TEXT,
    unit_price TEXT,
    id_product UUID,
    account_id UUID,
    paid_cost INTEGER,
    pending_paid_cost INTEGER,
    reservation_status BOOLEAN DEFAULT FALSE,
    personalized_message TEXT,
    reservation_messages TEXT
);

-- Table: hotels (321 rows)
CREATE TABLE IF NOT EXISTS hotels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    star_rating TEXT,
    description TEXT,
    check_in_time TEXT,
    check_out_time TEXT,
    region_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    provider_id TEXT,
    type TEXT,
    booking_type TEXT,
    metadata TEXT,
    description_short TEXT,
    inclutions TEXT,
    exclutions TEXT,
    recomendations TEXT,
    instructions TEXT,
    id_contact UUID,
    main_image TEXT,
    account_id UUID,
    location TEXT,
    social_image TEXT,
    pdf_image TEXT
);

-- Table: hotel_rates (569 rows)
CREATE TABLE IF NOT EXISTS hotel_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID,
    name TEXT,
    capacity TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    unit_cost INTEGER,
    profit INTEGER,
    price INTEGER,
    currency TEXT,
    description TEXT,
    is_active BOOLEAN,
    account_id UUID
);

-- Table: activities (594 rows)
CREATE TABLE IF NOT EXISTS activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    type TEXT,
    booking_type TEXT,
    duration_minutes TEXT,
    metadata TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    description_short TEXT,
    inclutions TEXT,
    exclutions TEXT,
    recomendations TEXT,
    instructions TEXT,
    id_contact UUID,
    experience_type TEXT,
    main_image TEXT,
    account_id UUID,
    location UUID,
    schedule_data TEXT,
    social_image TEXT
);

-- Table: activities_rates (1680 rows)
CREATE TABLE IF NOT EXISTS activities_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    unit_cost INTEGER,
    profit INTEGER,
    price INTEGER,
    id_product UUID,
    account_id UUID
);

-- Table: transfers (101 rows)
CREATE TABLE IF NOT EXISTS transfers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type TEXT,
    from_location TEXT,
    to_location TEXT,
    departure_time TEXT,
    arrival_time TEXT,
    estimated_price TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    provider_id TEXT,
    name TEXT,
    description TEXT,
    booking_type TEXT,
    duration_minutes TEXT,
    metadata TEXT,
    description_short TEXT,
    inclutions TEXT,
    exclutions TEXT,
    recomendations TEXT,
    instructions TEXT,
    id_contact UUID,
    experience_type TEXT,
    main_image TEXT,
    account_id UUID,
    location UUID
);

-- Table: transfer_rates (548 rows)
CREATE TABLE IF NOT EXISTS transfer_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    unit_cost INTEGER,
    profit INTEGER,
    price INTEGER,
    id_transfer UUID,
    account_id UUID
);

-- Table: flights (0 rows)
CREATE TABLE IF NOT EXISTS flights (

);

-- Table: airlines (45 rows)
CREATE TABLE IF NOT EXISTS airlines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    duffel_id TEXT,
    name TEXT,
    iata_code TEXT,
    conditions_of_carriage_url TEXT,
    logo_symbol_url TEXT,
    logo_lockup_url TEXT,
    updated_at TIMESTAMP WITH TIME ZONE,
    account_id UUID,
    feature TEXT,
    logo_png TEXT
);

-- Table: airports (9026 rows)
CREATE TABLE IF NOT EXISTS airports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    duffel_id TEXT,
    name TEXT,
    icao_code TEXT,
    iata_code TEXT,
    iata_country_code TEXT,
    iata_city_code TEXT,
    city_name TEXT,
    longitude NUMERIC(10,2),
    latitude NUMERIC(10,2),
    time_zone TEXT,
    updated_at TIMESTAMP WITH TIME ZONE
);

-- Table: passenger (474 rows)
CREATE TABLE IF NOT EXISTS passenger (
    id INTEGER,
    name TEXT,
    last_name TEXT,
    type_id TEXT,
    number_id TEXT,
    nationality TEXT,
    birth_date DATE,
    itinerary_id UUID,
    account_id UUID
);

-- Table: transactions (542 rows)
CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    id_itinerary UUID,
    date DATE,
    value INTEGER,
    payment_method TEXT,
    account_id UUID,
    type TEXT,
    voucher_url TEXT,
    id_item_itinerary UUID,
    reference TEXT
);

-- Table: notes (0 rows)
CREATE TABLE IF NOT EXISTS notes (

);

-- Table: images (3279 rows)
CREATE TABLE IF NOT EXISTS images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID,
    url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    account_id UUID
);

-- Table: user_contact_info (0 rows)
CREATE TABLE IF NOT EXISTS user_contact_info (

);

-- Table: user_roles (40 rows)
CREATE TABLE IF NOT EXISTS user_roles (
    id INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID,
    role_id INTEGER,
    account_id UUID
);

-- Table: roles (4 rows)
CREATE TABLE IF NOT EXISTS roles (
    id INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    role_name TEXT
);

-- Table: locations (1479 rows)
CREATE TABLE IF NOT EXISTS locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    latlng TEXT,
    name TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    country TEXT,
    zip_code TEXT,
    account_id UUID,
    type_entity TEXT
);

-- Table: regions (0 rows)
CREATE TABLE IF NOT EXISTS regions (

);

-- Table: nationalities (180 rows)
CREATE TABLE IF NOT EXISTS nationalities (
    id INTEGER,
    name TEXT
);

-- Table: points_of_interest (0 rows)
CREATE TABLE IF NOT EXISTS points_of_interest (

);


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
