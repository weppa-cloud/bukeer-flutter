#!/bin/bash

echo "🔄 Importando backup a staging via Supabase CLI..."
echo ""

# Usar psql directamente con la connection string
CONNECTION="postgresql://postgres:fZGE3YShagCIeTON@db.wrgkiastpqituocblopg.supabase.co:5432/postgres"

echo "📤 Ejecutando importación..."
echo "Esto puede tomar varios minutos..."

# Opción 1: Si funciona la conexión directa
if /opt/homebrew/opt/postgresql@16/bin/psql "$CONNECTION" -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ Conexión exitosa, importando..."
    /opt/homebrew/opt/postgresql@16/bin/psql "$CONNECTION" < ./backups/20250609_172947/bukeer_prod_20250609_172947.sql
else
    echo "❌ No se puede conectar directamente"
    echo ""
    echo "ALTERNATIVA: Copia y pega manualmente"
    echo ""
    echo "1. Abre el archivo:"
    echo "   open ./backups/20250609_172947/bukeer_prod_20250609_172947.sql"
    echo ""
    echo "2. Copia todo (Cmd+A, Cmd+C)"
    echo ""
    echo "3. Pega en SQL Editor:"
    echo "   https://supabase.com/dashboard/project/wrgkiastpqituocblopg/sql/new"
    echo ""
    echo "4. Click en RUN"
fi