#!/bin/bash

echo "🚀 Restauración con Supabase CLI"
echo "================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paso 1: Login
echo -e "${YELLOW}Paso 1: Login en Supabase${NC}"
echo "Ejecuta este comando en tu terminal:"
echo -e "${BLUE}supabase login${NC}"
echo ""
echo "Se abrirá tu navegador para autenticarte."
echo -e "${GREEN}Presiona ENTER cuando hayas completado el login...${NC}"
read

# Paso 2: Link al proyecto
echo -e "${YELLOW}Paso 2: Conectar al proyecto staging${NC}"
echo "Ejecutando..."
supabase link --project-ref wrgkiastpqituocblopg --password fZGE3YShagCIeTON

# Paso 3: Restaurar
echo ""
echo -e "${YELLOW}Paso 3: Restaurar backup${NC}"
echo "Archivo: ./backups/20250609_172947/bukeer_prod_20250609_172947.sql"
echo ""

# Método 1: db push
echo -e "${BLUE}Intentando método 1: supabase db push${NC}"
if supabase db push ./backups/20250609_172947/bukeer_prod_20250609_172947.sql; then
    echo -e "${GREEN}✅ Restauración completada con éxito${NC}"
else
    echo -e "${YELLOW}⚠️  El método 1 falló, intentando método 2...${NC}"
    
    # Método 2: db execute
    echo -e "${BLUE}Intentando método 2: supabase db execute${NC}"
    if supabase db execute --file ./backups/20250609_172947/bukeer_prod_20250609_172947.sql; then
        echo -e "${GREEN}✅ Restauración completada con éxito${NC}"
    else
        echo -e "${YELLOW}⚠️  Ambos métodos fallaron${NC}"
        echo ""
        echo "Alternativa: Usa el método manual"
        echo "1. Copia el contenido del archivo SQL"
        echo "2. Pégalo en: https://supabase.com/dashboard/project/wrgkiastpqituocblopg/sql/new"
    fi
fi

# Verificar
echo ""
echo -e "${YELLOW}Verificando datos...${NC}"
supabase db execute --sql "SELECT 'hotels' as tabla, COUNT(*) as total FROM hotels UNION ALL SELECT 'activities', COUNT(*) FROM activities;"

echo ""
echo -e "${GREEN}Proceso completado${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Verifica en: https://supabase.com/dashboard/project/wrgkiastpqituocblopg/editor"
echo "2. Ejecuta el script de anonimización si es necesario"