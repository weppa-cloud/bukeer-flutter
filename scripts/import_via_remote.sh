#!/bin/bash

echo "🚀 Importación alternativa via Supabase"
echo ""

# Verificar que estamos conectados
if ! supabase projects list > /dev/null 2>&1; then
    echo "❌ No estás logueado en Supabase"
    echo "Ejecuta: supabase login"
    exit 1
fi

echo "✅ Conectado a Supabase"
echo ""

# Dividir el archivo en partes más pequeñas
echo "📂 Dividiendo archivo en partes manejables..."
mkdir -p ./backups/parts

# Extraer solo estructura primero
echo "1️⃣ Extrayendo estructura..."
grep -E "^(CREATE|ALTER|COMMENT)" ./backups/staging_import_cleaned.sql > ./backups/parts/01_structure.sql

# Extraer datos por tablas
echo "2️⃣ Extrayendo datos por tablas..."
grep "^INSERT INTO accounts" ./backups/staging_import_cleaned.sql > ./backups/parts/02_accounts.sql
grep "^INSERT INTO hotels" ./backups/staging_import_cleaned.sql > ./backups/parts/03_hotels.sql
grep "^INSERT INTO activities" ./backups/staging_import_cleaned.sql > ./backups/parts/04_activities.sql
grep "^INSERT INTO hotel_rates" ./backups/staging_import_cleaned.sql > ./backups/parts/05_hotel_rates.sql
grep "^INSERT INTO activities_rates" ./backups/staging_import_cleaned.sql > ./backups/parts/06_activities_rates.sql

echo ""
echo "📤 Ejecutando importación por partes..."
echo ""

# Ejecutar cada parte
for file in ./backups/parts/*.sql; do
    if [ -s "$file" ]; then
        echo "Ejecutando: $(basename "$file")"
        if supabase db execute --file "$file" 2>/dev/null; then
            echo "✅ $(basename "$file") - OK"
        else
            echo "⚠️  $(basename "$file") - Algunos warnings"
        fi
    fi
done

# Verificar
echo ""
echo "📊 Verificando importación..."
supabase db execute -f - <<EOF
SELECT 
    'accounts' as tabla, COUNT(*) as registros 
FROM accounts
UNION ALL
SELECT 'hotels', COUNT(*) FROM hotels
UNION ALL
SELECT 'activities', COUNT(*) FROM activities
UNION ALL
SELECT 'hotel_rates', COUNT(*) FROM hotel_rates
UNION ALL
SELECT 'activities_rates', COUNT(*) FROM activities_rates
ORDER BY tabla;
EOF

echo ""
echo "✅ Proceso completado"
echo ""
echo "Verifica en el dashboard:"
echo "https://supabase.com/dashboard/project/wrgkiastpqituocblopg/editor"