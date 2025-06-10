#!/bin/bash

# Funciones restantes por descargar
FUNCTIONS=(
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

cd supabase/functions || exit 1

echo "📥 Descargando funciones restantes..."
echo ""

for func in "${FUNCTIONS[@]}"; do
  if [ -f "$func/index.ts" ]; then
    echo "✓ $func ya existe, saltando..."
  else
    echo "📦 Descargando: $func"
    supabase functions download "$func"
    
    if [ -f "$func/index.ts" ]; then
      echo "  ✅ Descargada exitosamente"
    else
      echo "  ❌ Error al descargar"
    fi
  fi
  echo ""
done

echo "📋 Resumen final:"
echo ""
find . -name "index.ts" -type f | while read file; do
  func_name=$(dirname "$file" | sed 's|./||')
  lines=$(wc -l < "$file")
  echo "✓ $func_name ($lines líneas)"
done