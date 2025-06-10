#!/bin/bash

echo "📦 Creando archivo único de importación..."
echo ""

OUTPUT="./backups/staging_import_complete.sql"
BACKUP="./backups/prod_supabase_20250609_190924.sql"

# Crear archivo con configuración inicial
cat > "$OUTPUT" << 'EOF'
-- Importación completa a Staging
-- Generado automáticamente

SET session_replication_role = replica;
SET statement_timeout = 0;
SET client_encoding = 'UTF8';

-- Desactivar triggers temporalmente
SET session_replication_role = replica;

EOF

# Extraer solo los INSERTs del schema public
echo "📝 Extrayendo datos del schema public..."
awk '
    /^INSERT INTO "public"/ { found = 1 }
    /^INSERT INTO "storage"/ { found = 0 }
    /^--/ && found { found = 0 }
    found { print }
' "$BACKUP" >> "$OUTPUT"

# Agregar al final
echo "" >> "$OUTPUT"
echo "-- Reactivar triggers" >> "$OUTPUT"
echo "SET session_replication_role = origin;" >> "$OUTPUT"

# Verificar tamaño
SIZE=$(du -h "$OUTPUT" | cut -f1)
LINES=$(wc -l < "$OUTPUT")

echo "✅ Archivo creado: $OUTPUT"
echo "📊 Tamaño: $SIZE ($LINES líneas)"
echo ""
echo "📋 Para usar este archivo:"
echo ""
echo "1. Opción A - SQL Editor (si es menor a 10MB):"
echo "   cat $OUTPUT | pbcopy"
echo "   Luego pegar en: https://supabase.com/dashboard/project/wrgkiastpqituocblopg/sql/new"
echo ""
echo "2. Opción B - Conexión directa con psql:"
echo "   psql 'postgresql://postgres:fZGE3YShagCIeTON@db.wrgkiastpqituocblopg.supabase.co:5432/postgres' -f $OUTPUT"
echo ""
echo "3. Opción C - Cliente GUI (TablePlus, DBeaver, etc):"
echo "   Host: db.wrgkiastpqituocblopg.supabase.co"
echo "   Port: 5432"
echo "   User: postgres"
echo "   Pass: fZGE3YShagCIeTON"
echo "   Database: postgres"