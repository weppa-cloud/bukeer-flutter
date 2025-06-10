-- Esquema de Base de Datos Bukeer
-- Inferido del análisis del código Flutter

-- Tabla de cuentas (multi-tenant)
CREATE TABLE IF NOT EXISTS accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de ubicaciones
CREATE TABLE IF NOT EXISTS locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255),
    country VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de regiones
CREATE TABLE IF NOT EXISTS regions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de contactos
CREATE TABLE IF NOT EXISTS contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    is_company BOOLEAN DEFAULT FALSE,
    is_client BOOLEAN DEFAULT FALSE,
    is_provider BOOLEAN DEFAULT FALSE,
    account_id UUID REFERENCES accounts(id),
    location_id UUID REFERENCES locations(id),
    deleted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de roles
CREATE TABLE IF NOT EXISTS roles (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insertar roles básicos
INSERT INTO roles (id, name, description) VALUES 
(1, 'admin', 'Administrador'),
(2, 'superadmin', 'Super Administrador'),
(3, 'agent', 'Agente')
ON CONFLICT (id) DO NOTHING;

-- Tabla de información de contacto de usuarios
CREATE TABLE IF NOT EXISTS user_contact_info (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    name VARCHAR(255),
    last_name VARCHAR(255),
    phone VARCHAR(255),
    role_id INTEGER REFERENCES roles(id),
    account_id UUID REFERENCES accounts(id),
    main_image TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de roles de usuario
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    role_id INTEGER REFERENCES roles(id),
    permissions JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de itinerarios
CREATE TABLE IF NOT EXISTS itineraries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    currency VARCHAR(10) DEFAULT 'USD',
    total DECIMAL(10,2) DEFAULT 0,
    cost DECIMAL(10,2) DEFAULT 0,
    paid DECIMAL(10,2) DEFAULT 0,
    paid_provider DECIMAL(10,2) DEFAULT 0,
    profit DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'draft',
    contact_id UUID REFERENCES contacts(id),
    account_id UUID REFERENCES accounts(id),
    visibility VARCHAR(50) DEFAULT 'private',
    travel_planner UUID REFERENCES user_contact_info(id),
    message TEXT,
    deleted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de pasajeros
CREATE TABLE IF NOT EXISTS passenger (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    itinerary_id UUID REFERENCES itineraries(id),
    name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255),
    birth_date DATE,
    passport VARCHAR(100),
    nationality VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de hoteles
CREATE TABLE IF NOT EXISTS hotels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location_id UUID REFERENCES locations(id),
    region_id UUID REFERENCES regions(id),
    main_image TEXT,
    images JSONB DEFAULT '[]'::jsonb,
    payment_methods JSONB DEFAULT '[]'::jsonb,
    account_id UUID REFERENCES accounts(id),
    deleted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de tarifas de hotel
CREATE TABLE IF NOT EXISTS hotel_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID REFERENCES hotels(id),
    name VARCHAR(255) NOT NULL,
    cost DECIMAL(10,2),
    price DECIMAL(10,2),
    profit DECIMAL(10,2),
    currency VARCHAR(10) DEFAULT 'USD',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de actividades
CREATE TABLE IF NOT EXISTS activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    duration_hours INTEGER,
    schedule JSONB DEFAULT '[]'::jsonb,
    location_id UUID REFERENCES locations(id),
    region_id UUID REFERENCES regions(id),
    main_image TEXT,
    images JSONB DEFAULT '[]'::jsonb,
    payment_methods JSONB DEFAULT '[]'::jsonb,
    inclusions JSONB DEFAULT '[]'::jsonb,
    account_id UUID REFERENCES accounts(id),
    deleted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de tarifas de actividades
CREATE TABLE IF NOT EXISTS activities_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID REFERENCES activities(id),
    name VARCHAR(255) NOT NULL,
    cost DECIMAL(10,2),
    price DECIMAL(10,2),
    profit DECIMAL(10,2),
    currency VARCHAR(10) DEFAULT 'USD',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de transfers
CREATE TABLE IF NOT EXISTS transfers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50),
    capacity INTEGER,
    location_id UUID REFERENCES locations(id),
    region_id UUID REFERENCES regions(id),
    main_image TEXT,
    images JSONB DEFAULT '[]'::jsonb,
    payment_methods JSONB DEFAULT '[]'::jsonb,
    account_id UUID REFERENCES accounts(id),
    deleted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de tarifas de transfers
CREATE TABLE IF NOT EXISTS transfer_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transfer_id UUID REFERENCES transfers(id),
    name VARCHAR(255) NOT NULL,
    cost DECIMAL(10,2),
    price DECIMAL(10,2),
    profit DECIMAL(10,2),
    currency VARCHAR(10) DEFAULT 'USD',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de aerolíneas
CREATE TABLE IF NOT EXISTS airlines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de aeropuertos
CREATE TABLE IF NOT EXISTS airports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10),
    city VARCHAR(255),
    country VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de vuelos
CREATE TABLE IF NOT EXISTS flights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    flight_number VARCHAR(50),
    airline_id UUID REFERENCES airlines(id),
    departure_airport_id UUID REFERENCES airports(id),
    arrival_airport_id UUID REFERENCES airports(id),
    departure_time TIMESTAMP WITH TIME ZONE,
    arrival_time TIMESTAMP WITH TIME ZONE,
    cost DECIMAL(10,2),
    price DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de items de itinerario
CREATE TABLE IF NOT EXISTS itinerary_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    itinerary_id UUID REFERENCES itineraries(id),
    product_type VARCHAR(50), -- 'hotel', 'activity', 'transfer', 'flight'
    product_id UUID,
    product_name VARCHAR(255),
    quantity INTEGER DEFAULT 1,
    cost DECIMAL(10,2),
    price DECIMAL(10,2),
    profit DECIMAL(10,2),
    paid_amount DECIMAL(10,2) DEFAULT 0,
    paid_provider_amount DECIMAL(10,2) DEFAULT 0,
    start_date DATE,
    end_date DATE,
    details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de transacciones
CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    itinerary_id UUID REFERENCES itineraries(id),
    amount DECIMAL(10,2) NOT NULL,
    type VARCHAR(50), -- 'payment', 'refund', 'provider_payment'
    payment_method VARCHAR(50),
    reference VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de notas
CREATE TABLE IF NOT EXISTS notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT,
    itinerary_id UUID REFERENCES itineraries(id),
    user_id UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de imágenes
CREATE TABLE IF NOT EXISTS images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    url TEXT NOT NULL,
    entity_type VARCHAR(50),
    entity_id UUID,
    is_main BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de nacionalidades
CREATE TABLE IF NOT EXISTS nationalities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de puntos de interés
CREATE TABLE IF NOT EXISTS points_of_interest (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50),
    location_id UUID REFERENCES locations(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);