-- Manual Migration Script for Staging
-- Instructions:
-- 1. Go to https://supabase.com/dashboard/project/wrgkiastpqituocblopg/sql
-- 2. Copy and paste this entire script
-- 3. Click "Run"

-- Enable necessary extensions (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create accounts table
CREATE TABLE IF NOT EXISTS accounts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create users/contacts table
CREATE TABLE IF NOT EXISTS contacts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    account_id UUID REFERENCES accounts(id),
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    is_client BOOLEAN DEFAULT false,
    is_provider BOOLEAN DEFAULT false,
    is_company BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create itineraries table
CREATE TABLE IF NOT EXISTS itineraries (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    account_id UUID REFERENCES accounts(id),
    name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    contact_id UUID REFERENCES contacts(id),
    total_amount DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create hotels table
CREATE TABLE IF NOT EXISTS hotels (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    account_id UUID REFERENCES accounts(id),
    name VARCHAR(255),
    location VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create activities table
CREATE TABLE IF NOT EXISTS activities (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    account_id UUID REFERENCES accounts(id),
    name VARCHAR(255),
    location VARCHAR(255),
    description TEXT,
    duration INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create itinerary_items table
CREATE TABLE IF NOT EXISTS itinerary_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    itinerary_id UUID REFERENCES itineraries(id),
    item_type VARCHAR(50),
    item_id UUID,
    date DATE,
    notes TEXT,
    price DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create basic indexes
CREATE INDEX idx_contacts_account_id ON contacts(account_id);
CREATE INDEX idx_itineraries_account_id ON itineraries(account_id);
CREATE INDEX idx_hotels_account_id ON hotels(account_id);
CREATE INDEX idx_activities_account_id ON activities(account_id);
CREATE INDEX idx_itinerary_items_itinerary_id ON itinerary_items(itinerary_id);

-- Insert test data
INSERT INTO accounts (id, name) VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Test Account');

INSERT INTO contacts (account_id, name, email, is_client) VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Test Client', 'test@example.com', true);

-- Success message
SELECT 'Migration completed successfully!' as message;