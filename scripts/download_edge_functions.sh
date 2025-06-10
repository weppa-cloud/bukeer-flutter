#!/bin/bash

# Script para descargar todas las Edge Functions de Bukeer
# Ejecutar después de hacer: supabase login

PROJECT_ID="wzlxbpicdcdvxvdcvgas"
FUNCTIONS_DIR="supabase/functions"

# Lista de Edge Functions
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

echo "🚀 Descarga de Edge Functions para Bukeer"
echo "========================================="
echo ""

# Verificar si está logueado
if ! supabase projects list &> /dev/null; then
  echo "❌ No estás logueado en Supabase"
  echo ""
  echo "Por favor ejecuta primero:"
  echo "  supabase login"
  echo ""
  exit 1
fi

echo "✅ Autenticación confirmada"
echo ""

# Conectar al proyecto
echo "🔗 Conectando al proyecto ${PROJECT_ID}..."
supabase link --project-ref $PROJECT_ID

if [ $? -ne 0 ]; then
  echo "❌ Error al conectar con el proyecto"
  exit 1
fi

echo ""
echo "📥 Descargando Edge Functions..."
echo ""

# Crear directorio si no existe
mkdir -p $FUNCTIONS_DIR

# Descargar cada función
for func in "${FUNCTIONS[@]}"; do
  echo "📦 Descargando: $func"
  
  # Cambiar al directorio de funciones
  cd $FUNCTIONS_DIR 2>/dev/null || { echo "Error: No se puede acceder al directorio $FUNCTIONS_DIR"; exit 1; }
  
  # Descargar la función
  supabase functions download $func
  
  if [ $? -eq 0 ]; then
    echo "  ✅ $func descargada exitosamente"
  else
    echo "  ❌ Error al descargar $func"
  fi
  
  # Volver al directorio principal
  cd - > /dev/null
  echo ""
done

echo "✨ Proceso completado"
echo ""
echo "📁 Las funciones se descargaron en: $FUNCTIONS_DIR/"
echo ""

# Listar lo que se descargó
echo "📋 Funciones descargadas:"
ls -la $FUNCTIONS_DIR/*/index.ts 2>/dev/null | awk '{print "  - " $9}'