#!/bin/bash

# Script para descargar Edge Functions una por una

FUNCTIONS=(
  "process-flight-extraction"
  "create-hotel-pdf"
  "generate-itinerary-pdf"
  "create-hotel-social-image"
  "create-activity-social-image"
  "hotel-description-generator"
  "activity-description-generator"
  "generate-activity-social-image-gotenberg"
  "generate-hotel-social-image-gotenberg"
  "create-hotel-pdf-image"
  "generate_activity_embeddings"
)

echo "📥 Descargando Edge Functions..."
echo ""

for func in "${FUNCTIONS[@]}"; do
  echo "Descargando: $func"
  
  # Cambiar al directorio de funciones
  cd supabase/functions 2>/dev/null || exit 1
  
  # Descargar con timeout más largo
  timeout 300 supabase functions download "$func"
  
  if [ $? -eq 124 ]; then
    echo "  ⏱️  Timeout al descargar $func"
  elif [ $? -eq 0 ]; then
    echo "  ✅ $func descargada"
  else
    echo "  ❌ Error al descargar $func"
  fi
  
  # Volver al directorio principal
  cd ../.. 2>/dev/null
  
  # Verificar si se descargó algo
  if [ -f "supabase/functions/$func/index.ts" ]; then
    echo "  📄 Archivo index.ts encontrado"
  fi
  
  echo ""
done

echo "📋 Resumen de funciones descargadas:"
find supabase/functions -name "index.ts" -type f | while read file; do
  echo "  ✓ $(dirname "$file" | xargs basename)"
done