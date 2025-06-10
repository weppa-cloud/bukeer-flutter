#!/bin/bash

echo "🚀 Backup rápido de producción con Supabase CLI"
echo "=============================================="
echo ""

# 1. Cambiar a producción
echo "1️⃣ Cambiando a proyecto de producción..."
supabase link --project-ref wzlxbpicdcdvxvdcvgas --password aqe9KRCreA4D0X6n

# 2. Hacer el dump
echo ""
echo "2️⃣ Generando backup..."
BACKUP_FILE="./backups/prod_supabase_$(date +%Y%m%d_%H%M%S).sql"

# Usar db dump con opciones para mejor compatibilidad
supabase db dump \
  --data-only \
  -f "$BACKUP_FILE"

echo ""
echo "✅ Backup creado: $BACKUP_FILE"
echo "📏 Tamaño: $(du -h "$BACKUP_FILE" | cut -f1)"

# 3. Volver a staging
echo ""
echo "3️⃣ Volviendo a proyecto staging..."
supabase link --project-ref wrgkiastpqituocblopg --password fZGE3YShagCIeTON

echo ""
echo "📋 Para importar en staging:"
echo "   supabase db push $BACKUP_FILE"
echo ""
echo "O usa el SQL Editor con el archivo generado"