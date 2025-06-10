#!/bin/bash
# sync_prod_to_staging.sh
# Script para sincronizar datos de producción a staging

echo "🔄 Sincronización Producción → Staging"
echo "======================================"
echo ""
echo "⚠️  ADVERTENCIA: Esto sobrescribirá todos los datos en staging"
echo "¿Continuar? (s/n)"
read -r response

if [[ ! "$response" =~ ^[Ss]$ ]]; then
    echo "Cancelado por el usuario"
    exit 1
fi

# Configuración
PROD_PASSWORD="aqe9KRCreA4D0X6n"
STAGING_PASSWORD="fZGE3YShagCIeTON"
PROD_DB="postgresql://postgres.wzlxbpicdcdvxvdcvgas:${PROD_PASSWORD}@aws-0-us-west-1.pooler.supabase.com:6543/postgres"
STAGING_DB="postgresql://postgres.wrgkiastpqituocblopg:${STAGING_PASSWORD}@aws-0-us-east-2.pooler.supabase.com:6543/postgres"
BACKUP_DIR="./backups/sync_$(date +%Y%m%d_%H%M%S)"
PSQL="/opt/homebrew/opt/postgresql@16/bin/psql"
PG_DUMP="/opt/homebrew/opt/postgresql@16/bin/pg_dump"

# Verificar herramientas
if [ ! -f "$PSQL" ]; then
    echo "❌ Error: psql no encontrado. Instalar con: brew install postgresql@16"
    exit 1
fi

# Crear directorio para backup
mkdir -p $BACKUP_DIR

# 1. Verificar conexiones
echo "🔌 Verificando conexiones..."
if ! $PSQL "$PROD_DB" -c "SELECT 1" > /dev/null 2>&1; then
    echo "❌ No se puede conectar a producción"
    exit 1
fi

if ! $PSQL "$STAGING_DB" -c "SELECT 1" > /dev/null 2>&1; then
    echo "❌ No se puede conectar a staging"
    exit 1
fi
echo "✅ Conexiones verificadas"

# 2. Backup de staging actual (por seguridad)
echo "💾 Creando backup de staging actual..."
$PG_DUMP "$STAGING_DB" --data-only --exclude-schema=auth --exclude-schema=storage \
    -f "$BACKUP_DIR/staging_backup_before_sync.sql"

# 3. Backup de producción
echo "📦 Extrayendo datos de producción..."
$PG_DUMP "$PROD_DB" --data-only --exclude-schema=auth --exclude-schema=storage \
    -f "$BACKUP_DIR/prod_data.sql"

# Verificar tamaño
SIZE=$(du -h "$BACKUP_DIR/prod_data.sql" | cut -f1)
echo "   Tamaño del backup: $SIZE"

# 4. Limpiar staging
echo "🧹 Limpiando datos en staging..."
$PSQL "$STAGING_DB" << 'EOF'
-- Desactivar triggers
SET session_replication_role = replica;

-- Limpiar tablas en orden inverso de dependencias
DO $$ 
BEGIN
    -- Transacciones y detalles
    TRUNCATE TABLE public.transactions CASCADE;
    TRUNCATE TABLE public.passenger CASCADE;
    TRUNCATE TABLE public.itinerary_items CASCADE;
    TRUNCATE TABLE public.notes CASCADE;
    
    -- Itinerarios
    TRUNCATE TABLE public.itineraries CASCADE;
    
    -- Productos
    TRUNCATE TABLE public.transfer_rates CASCADE;
    TRUNCATE TABLE public.transfers CASCADE;
    TRUNCATE TABLE public.activities_rates CASCADE;
    TRUNCATE TABLE public.activities CASCADE;
    TRUNCATE TABLE public.hotel_rates CASCADE;
    TRUNCATE TABLE public.hotels CASCADE;
    
    -- Datos maestros
    TRUNCATE TABLE public.images CASCADE;
    TRUNCATE TABLE public.user_roles CASCADE;
    TRUNCATE TABLE public.contacts CASCADE;
    TRUNCATE TABLE public.locations CASCADE;
    TRUNCATE TABLE public.accounts CASCADE;
    
    RAISE NOTICE 'Tablas limpiadas exitosamente';
END $$;

-- Reactivar triggers
SET session_replication_role = origin;
EOF

# 5. Importar datos a staging
echo "📥 Importando datos a staging..."
if $PSQL "$STAGING_DB" -f "$BACKUP_DIR/prod_data.sql" > "$BACKUP_DIR/import.log" 2>&1; then
    echo "✅ Datos importados exitosamente"
else
    echo "❌ Error durante la importación. Ver: $BACKUP_DIR/import.log"
    exit 1
fi

# 6. Recrear usuario admin de staging
echo "👤 Recreando usuario admin de staging..."
$PSQL "$STAGING_DB" << 'EOF'
-- Asegurar que existe el usuario admin
DO $$
BEGIN
    -- Verificar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'admin@staging.com') THEN
        INSERT INTO auth.users (
            id,
            instance_id,
            email,
            encrypted_password,
            email_confirmed_at,
            created_at,
            updated_at,
            raw_app_meta_data,
            raw_user_meta_data,
            aud,
            role
        ) VALUES (
            'a08ae0ff-24c0-4895-b552-96a4bead229e',
            '00000000-0000-0000-0000-000000000000',
            'admin@staging.com',
            crypt('password123', gen_salt('bf')),
            now(),
            now(),
            now(),
            jsonb_build_object('provider', 'email', 'providers', array['email']),
            jsonb_build_object(),
            'authenticated',
            'authenticated'
        );
        
        -- Crear identidad
        INSERT INTO auth.identities (
            provider_id,
            user_id,
            provider,
            identity_data,
            created_at,
            updated_at
        ) VALUES (
            'admin@staging.com',
            'a08ae0ff-24c0-4895-b552-96a4bead229e',
            'email',
            jsonb_build_object(
                'email', 'admin@staging.com',
                'email_verified', true,
                'sub', 'a08ae0ff-24c0-4895-b552-96a4bead229e'
            ),
            now(),
            now()
        );
    END IF;
    
    -- Asegurar contacto y rol
    INSERT INTO public.contacts (
        id,
        name,
        last_name,
        email,
        user_id,
        created_at,
        updated_at,
        account_id
    ) VALUES (
        gen_random_uuid(),
        'Admin',
        'Staging',
        'admin@staging.com',
        'a08ae0ff-24c0-4895-b552-96a4bead229e',
        now(),
        now(),
        '9fc24733-b127-4184-aa22-12f03b98927a'
    ) ON CONFLICT (user_id) DO UPDATE
      SET updated_at = now();
    
    -- Asegurar rol super_admin
    INSERT INTO public.user_roles (
        user_id,
        role_id,
        created_at,
        account_id
    ) VALUES (
        'a08ae0ff-24c0-4895-b552-96a4bead229e',
        1,
        now(),
        '9fc24733-b127-4184-aa22-12f03b98927a'
    ) ON CONFLICT DO NOTHING;
END $$;
EOF

# 7. Verificar sincronización
echo ""
echo "📊 Verificando sincronización..."
$PSQL "$STAGING_DB" -t << 'EOF'
SELECT 
    'Cuentas: ' || COUNT(*) FROM public.accounts
UNION ALL
SELECT 'Contactos: ' || COUNT(*) FROM public.contacts
UNION ALL
SELECT 'Hoteles: ' || COUNT(*) FROM public.hotels
UNION ALL
SELECT 'Actividades: ' || COUNT(*) FROM public.activities
UNION ALL
SELECT 'Itinerarios: ' || COUNT(*) FROM public.itineraries
UNION ALL
SELECT 'Items de itinerario: ' || COUNT(*) FROM public.itinerary_items
UNION ALL
SELECT 'Transacciones: ' || COUNT(*) FROM public.transactions;
EOF

echo ""
echo "✅ Sincronización completada"
echo ""
echo "📁 Backups guardados en: $BACKUP_DIR"
echo "👤 Usuario admin: admin@staging.com / password123"
echo ""
echo "🚀 Para ejecutar la app en staging:"
echo "   flutter run -d chrome --dart-define=ENVIRONMENT=staging"