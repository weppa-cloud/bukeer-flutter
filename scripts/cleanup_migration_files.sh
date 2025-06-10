#!/bin/bash

echo "🧹 Limpieza de archivos de migración"
echo "===================================="
echo ""

# Crear directorio de archivo si no existe
ARCHIVE_DIR="./backups/_archive_migration_20250609"
mkdir -p "$ARCHIVE_DIR"

# Función para mover archivos con confirmación
move_file() {
    local file=$1
    local desc=$2
    if [ -f "$file" ]; then
        echo "  📄 $desc"
        mv "$file" "$ARCHIVE_DIR/"
    fi
}

# 1. Archivar backups no utilizados
echo "📦 Archivando backups antiguos..."
cd ./backups

# Mover directorios antiguos
[ -d "20250609_172909" ] && mv "20250609_172909" "$ARCHIVE_DIR/"
[ -d "20250609_172947" ] && mv "20250609_172947" "$ARCHIVE_DIR/"
[ -d "parts" ] && mv "parts" "$ARCHIVE_DIR/"
[ -d "split_import" ] && mv "split_import" "$ARCHIVE_DIR/"

# Mover archivos temporales y no utilizados
move_file "prod_supabase_20250609_184131.sql" "Backup vacío"
move_file "public_data_only.sql" "Extracción parcial"
move_file "staging_data_only.sql" "Datos parciales"
move_file "staging_import_cleaned.sql" "Import limpio (no usado)"
move_file "staging_inserts.sql" "Inserts convertidos (no usado)"
move_file "staging_schema_20250609_175436.sql" "Schema antiguo"

cd ..

# 2. Archivar scripts temporales de migración
echo ""
echo "📜 Archivando scripts temporales..."
cd ./scripts

# Scripts específicos de la migración inicial
move_file "backup_from_production_cli.sh" "Backup CLI temporal"
move_file "backup_production_api.sh" "Backup API temporal"
move_file "backup_production.sh" "Backup inicial"
move_file "clean_backup_for_import.sh" "Limpieza temporal"
move_file "convert_backup_to_inserts.py" "Conversión temporal"
move_file "extract_data_only.sh" "Extracción parcial"
move_file "extract_public_data_only.sh" "Extracción pública"
move_file "extract_tables_separately.sh" "División de tablas"
move_file "direct_import_to_staging.sh" "Import directo antiguo"
move_file "import_with_pooler.sh" "Import pooler temporal"
move_file "import_to_staging_final.sh" "Import final temporal"
move_file "import_tables_to_staging.sh" "Import por tablas"
move_file "fix_json_arrays.py" "Fix arrays temporal"
move_file "fix_postgres_arrays.py" "Fix postgres temporal"
move_file "remove_duplicates.py" "Remove duplicates temporal"
move_file "split_backup_for_import.sh" "Split backup temporal"

cd ..

# 3. Organizar archivos importantes
echo ""
echo "✅ Manteniendo archivos importantes:"
echo "  📄 backups/prod_supabase_20250609_190924.sql (Backup principal)"
echo "  📄 backups/production_schema.sql (Schema de producción)"
echo "  📄 backups/staging_schema.sql (Schema aplicado)"
echo "  📄 backups/staging_import_complete.sql (Import final)"
echo "  📄 backups/tables_import/ (Tablas separadas - referencia)"
echo "  📄 scripts/sync_prod_to_staging.sh (Script de sincronización)"
echo "  📄 scripts/create_complete_user_staging.sql (Crear usuarios)"

# 4. Limpiar documentación temporal
echo ""
echo "📚 Organizando documentación..."

# Mover documentación temporal al archivo
[ -f "DEVELOPMENT_ENVIRONMENTS_GUIDE.md" ] && mv "DEVELOPMENT_ENVIRONMENTS_GUIDE.md" "$ARCHIVE_DIR/"
[ -f "PRODUCTION_ENVIRONMENT_DOCS.md" ] && mv "PRODUCTION_ENVIRONMENT_DOCS.md" "$ARCHIVE_DIR/"
[ -f "STAGING_DATA_STRATEGY.md" ] && mv "STAGING_DATA_STRATEGY.md" "$ARCHIVE_DIR/"
[ -f "setup-staging.md" ] && mv "setup-staging.md" "$ARCHIVE_DIR/"

# 5. Crear índice de archivos archivados
echo ""
echo "📝 Creando índice de archivos archivados..."
cat > "$ARCHIVE_DIR/README.md" << 'EOF'
# Archivos de Migración Inicial a Staging

## Fecha: 9 de Junio de 2025

Este directorio contiene todos los archivos temporales utilizados durante la migración inicial de producción a staging.

### Contenido:
- Backups parciales y temporales
- Scripts de migración específicos
- Documentación temporal del proceso
- Archivos de conversión y limpieza

### Nota:
Estos archivos se conservan por referencia histórica pero no son necesarios para operaciones futuras.

Para sincronizaciones futuras, usar:
- `scripts/sync_prod_to_staging.sh`
- Ver `STAGING_MIGRATION_GUIDE.md` para detalles
EOF

# 6. Resumen final
echo ""
echo "✅ Limpieza completada"
echo ""
echo "📊 Resumen:"
echo "  - Archivos movidos a: $ARCHIVE_DIR"
echo "  - Scripts importantes conservados en: ./scripts/"
echo "  - Documentación final en: ./"
echo "  - Backups principales en: ./backups/"
echo ""
echo "📝 Documentación activa:"
echo "  - STAGING_MIGRATION_GUIDE.md"
echo "  - STAGING_SETUP_COMPLETE.md"
echo "  - .env.staging (no commiteado)"