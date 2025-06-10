#!/bin/bash

echo "🚀 Importación Final a Staging"
echo "=============================="
echo ""

# Verificar conexión
echo "📡 Verificando conexión a staging..."
if supabase projects list | grep -q "wrgkiastpqituocblopg"; then
    echo "✅ Conectado al proyecto staging"
else
    echo "❌ No conectado. Ejecuta: supabase link --project-ref wrgkiastpqituocblopg"
    exit 1
fi

# Opciones disponibles
echo ""
echo "📋 Métodos disponibles:"
echo ""
echo "1. Ejecutar el backup limpio con db push:"
echo "   supabase db push ./backups/staging_import_cleaned.sql"
echo ""
echo "2. Resetear la base de datos y aplicar migraciones:"
echo "   supabase db reset"
echo ""
echo "3. Copiar y pegar en SQL Editor (más confiable):"
echo "   - Abre: https://supabase.com/dashboard/project/wrgkiastpqituocblopg/sql/new"
echo "   - Ejecuta: cat ./backups/staging_import_cleaned.sql | pbcopy"
echo "   - Pega en el editor y ejecuta"
echo ""
echo "4. Usar una herramienta visual como TablePlus:"
echo "   - Host: db.wrgkiastpqituocblopg.supabase.co"
echo "   - Port: 5432"
echo "   - User: postgres"
echo "   - Pass: fZGE3YShagCIeTON"
echo ""

# Intentar método más simple
echo "🔄 Intentando importación..."
echo ""

# Crear archivo SQL simple de prueba
cat > test_import.sql << 'EOF'
-- Test import
SELECT 'Testing connection' as status;

-- Create test table
CREATE TABLE IF NOT EXISTS test_import (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert test data
INSERT INTO test_import DEFAULT VALUES;

-- Verify
SELECT COUNT(*) as test_records FROM test_import;
EOF

echo "Probando con archivo de test..."
if supabase db push test_import.sql; then
    echo "✅ Conexión funciona!"
    echo ""
    echo "Ahora intenta con el backup completo:"
    echo "supabase db push ./backups/staging_import_cleaned.sql"
else
    echo "⚠️  El db push no funciona correctamente"
    echo ""
    echo "USA EL SQL EDITOR:"
    echo "1. cat ./backups/staging_import_cleaned.sql | pbcopy"
    echo "2. Pega en: https://supabase.com/dashboard/project/wrgkiastpqituocblopg/sql/new"
fi

# Limpiar
rm test_import.sql 2>/dev/null

echo ""
echo "🎯 RECOMENDACIÓN: Usa el SQL Editor del dashboard"
echo "Es la forma más confiable de importar datos grandes."