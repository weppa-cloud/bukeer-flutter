#!/bin/bash

echo "📋 Extrayendo esquema de la base de datos..."
echo ""

# Usar el esquema que ya tenemos en el proyecto
SCHEMA_FILE="./supabase/schema/tables.sql"
OUTPUT="./backups/staging_schema.sql"

if [ -f "$SCHEMA_FILE" ]; then
    echo "✅ Usando esquema existente del proyecto"
    cp "$SCHEMA_FILE" "$OUTPUT"
else
    echo "❌ No se encontró el archivo de esquema"
    echo "📋 Generando desde el respaldo..."
    
    # Si no existe, intentar extraer del backup de pg_dump
    # pg_dump normalmente no incluye CREATE TABLE en backups con --data-only
    echo "El backup fue creado con --data-only, no contiene DDL"
    exit 1
fi

echo ""
echo "📋 Para crear las tablas en staging:"
echo "1. psql 'postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres' -f $OUTPUT"
echo ""
echo "2. O copiar y pegar en SQL Editor:"
echo "   cat $OUTPUT | pbcopy"