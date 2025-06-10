#!/bin/bash

# Script para ejecutar la app en modo staging

echo "🚀 Ejecutando Bukeer en modo STAGING"
echo "📍 URL: https://wrgkiastpqituocblopg.supabase.co"
echo ""

flutter run -d chrome --dart-define=ENVIRONMENT=staging --web-port 5001