#!/bin/bash

echo "🚀 Importando backup directamente con psql..."
echo ""

# Connection string de staging
CONNECTION="postgresql://postgres:fZGE3YShagCIeTON@db.wrgkiastpqituocblopg.supabase.co:5432/postgres"

# Archivo a importar
BACKUP="./backups/prod_supabase_20250609_190924.sql"

echo "📋 Información:"
echo "- Archivo: $BACKUP ($(du -h "$BACKUP" | cut -f1))"
echo "- Destino: Staging (wrgkiastpqituocblopg)"
echo ""

# Intentar con psql
echo "📤 Importando..."
if /opt/homebrew/opt/postgresql@16/bin/psql "$CONNECTION" < "$BACKUP"; then
    echo "✅ Importación completada"
else
    echo "❌ Error en la importación"
    echo ""
    echo "Alternativa: Usa TablePlus"
    echo "1. Descarga: https://tableplus.com/"
    echo "2. Nueva conexión con estos datos:"
    echo "   Host: db.wrgkiastpqituocblopg.supabase.co"
    echo "   Port: 5432"
    echo "   User: postgres"
    echo "   Password: fZGE3YShagCIeTON"
    echo "   Database: postgres"
    echo "3. Importa el archivo: $BACKUP"
fi