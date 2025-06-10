#!/bin/bash

echo "📚 Limpieza y Organización de Documentación"
echo "=========================================="
echo ""

# Crear estructura de directorios
echo "📁 Creando estructura de documentación..."
mkdir -p docs/setup
mkdir -p docs/guides
mkdir -p docs/reference
mkdir -p docs/archive
mkdir -p docs/development

# Función para mover con mensaje
move_doc() {
    local file=$1
    local dest=$2
    local desc=$3
    if [ -f "$file" ]; then
        echo "  → $desc"
        mv "$file" "$dest/"
    fi
}

echo ""
echo "📋 Organizando documentación..."

# 1. STAGING - Fusionar y organizar
echo ""
echo "1️⃣ Documentación de Staging..."
# Crear documento consolidado de staging
cat > docs/setup/STAGING_COMPLETE_GUIDE.md << 'EOF'
# 🚀 Guía Completa de Staging

## Contenido
1. [Configuración](#configuración)
2. [Credenciales](#credenciales)
3. [Uso Diario](#uso-diario)
4. [Sincronización](#sincronización)
5. [Troubleshooting](#troubleshooting)

## Configuración

### Credenciales de Staging
- **Project ID**: wrgkiastpqituocblopg
- **URL**: https://wrgkiastpqituocblopg.supabase.co
- **Anon Key**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyZ2tpYXN0cHFpdHVvY2Jsb3BnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3OTE0NjIsImV4cCI6MjA0OTM2NzQ2Mn0.J7fLWMhMQiRvRr8mPQ0h-YZ7JTQMUVwNkROOSTU8MZU
- **Database**: postgresql://postgres.wrgkiastpqituocblopg:[PASSWORD]@aws-0-us-east-2.pooler.supabase.com:6543/postgres
- **Dashboard**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg

### Usuario de Prueba
- **Email**: admin@staging.com
- **Password**: password123

## Uso Diario

### Ejecutar en Staging
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

### Sincronizar Datos
```bash
./scripts/sync_prod_to_staging.sh
```

## Sincronización

El script `sync_prod_to_staging.sh`:
1. Hace backup de staging actual
2. Extrae datos de producción
3. Limpia staging
4. Importa datos frescos
5. Recrea usuario admin

### Frecuencia Recomendada
- **Semanal**: Para desarrollo normal
- **Diaria**: Durante desarrollo intensivo
- **Bajo demanda**: Para pruebas específicas

## Troubleshooting

### Usuario no puede login
```bash
psql $STAGING_DB -f scripts/create_complete_user_staging.sql
```

### Datos desactualizados
```bash
./scripts/sync_prod_to_staging.sh
```

### Verificar conexión
```bash
psql "postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -c "SELECT 1;"
```

---
*Última actualización: $(date)*
EOF

# Mover archivos de staging a archivo
move_doc "STAGING_MIGRATION_GUIDE.md" "docs/archive" "Guía de migración (archivado)"
move_doc "STAGING_SETUP_COMPLETE.md" "docs/archive" "Setup completo (archivado)"
move_doc "staging_restore_via_sql.md" "docs/archive" "Restore SQL (archivado)"

# 2. DESARROLLO - Consolidar workflows
echo ""
echo "2️⃣ Guías de Desarrollo..."
# Mantener el más reciente y completo
move_doc "DEVELOPMENT_WORKFLOW_STAGING.md" "docs/development" "Workflow con staging"
move_doc "DEVELOPMENT_WORKFLOW.md" "docs/archive" "Workflow antiguo"
move_doc "LOCAL_DATABASE_SETUP.md" "docs/development" "Setup BD local"

# 3. SUPABASE - Consolidar documentación
echo ""
echo "3️⃣ Documentación de Supabase..."
cat > docs/reference/SUPABASE_GUIDE.md << 'EOF'
# 📘 Guía de Referencia Supabase

## Proyectos

### Producción
- **ID**: wzlxbpicdcdvxvdcvgas
- **URL**: https://wzlxbpicdcdvxvdcvgas.supabase.co
- **Dashboard**: https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas

### Staging  
- **ID**: wrgkiastpqituocblopg
- **URL**: https://wrgkiastpqituocblopg.supabase.co
- **Dashboard**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg

## Edge Functions

### En Producción
1. generate-itinerary-pdf
2. create-activity-social-image
3. create-hotel-social-image
4. activity-description-generator
5. hotel-description-generator

### Estado
- ✅ Todas desplegadas en producción
- ⚠️ No desplegadas en staging (no necesarias para desarrollo)

## Prioridades de Implementación

### Fase 1: Estabilización (Completado ✅)
- Configuración de staging
- Migración de datos
- Scripts de sincronización

### Fase 2: Optimización
- Crear índices para queries lentas
- Optimizar vistas materializadas

### Fase 3: Funcionalidades
- Implementar RPC functions faltantes
- Mejorar Edge Functions

---
*Ver archivos en docs/archive para documentación histórica*
EOF

# Mover archivos de Supabase
move_doc "SUPABASE_CONTEXT.md" "docs/archive" "Contexto Supabase"
move_doc "SUPABASE_EDGE_FUNCTIONS.md" "docs/archive" "Edge Functions"
move_doc "SUPABASE_PRIORITY_PLAN.md" "docs/archive" "Plan de prioridades"
move_doc "SUPABASE_REFERENCE.md" "docs/archive" "Referencia Supabase"

# 4. OTROS ARCHIVOS
echo ""
echo "4️⃣ Otros archivos..."
move_doc "PLAYWRIGHT_SETUP.md" "docs/guides" "Setup Playwright"
move_doc "PLAYWRIGHT_QUICK_START.md" "docs/guides" "Playwright Quick Start"
move_doc "TESTING_GUIDE.md" "docs/archive" "Testing guide (hay uno en docs/)"
move_doc "CONNECTION_STRING_GUIDE.md" "docs/archive" "Connection strings"
move_doc "ENVIRONMENT_CREDENTIALS.md" "docs/archive" "Credenciales (sensible)"
move_doc "ENVIRONMENT_QUICK_REFERENCE.md" "docs/archive" "Quick reference"
move_doc "PRODUCTION_FREEZE_NOTICE.md" "docs/archive" "Freeze notice"
move_doc "TEAM_ACCESS_MATRIX.md" "docs/archive" "Access matrix"
move_doc "CLEANUP_SUMMARY.md" "docs/archive" "Cleanup summary"

# 5. Crear índice principal
echo ""
echo "5️⃣ Creando índice principal..."
cat > docs/README.md << 'EOF'
# 📚 Documentación Bukeer

## 🚀 Inicio Rápido

### Desarrollo con Staging
```bash
# Ejecutar app
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# Login
admin@staging.com / password123

# Sincronizar datos
./scripts/sync_prod_to_staging.sh
```

## 📁 Estructura de Documentación

### `/setup`
- `STAGING_COMPLETE_GUIDE.md` - Guía completa de staging

### `/development`
- `DEVELOPMENT_WORKFLOW_STAGING.md` - Flujo de desarrollo
- `LOCAL_DATABASE_SETUP.md` - Configurar BD local (opcional)

### `/guides`
- `PLAYWRIGHT_SETUP.md` - Testing E2E
- `PLAYWRIGHT_QUICK_START.md` - Quick start testing

### `/reference`
- `SUPABASE_GUIDE.md` - Referencia de Supabase

### `/historical`
- Documentación del proceso de migración inicial

### `/archive`
- Documentos obsoletos o reemplazados

## 🔗 Enlaces Rápidos

- [Staging Dashboard](https://supabase.com/dashboard/project/wrgkiastpqituocblopg)
- [Production Dashboard](https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas)

## 📋 Scripts Importantes

```bash
# Sincronizar staging con producción
./scripts/sync_prod_to_staging.sh

# Crear usuario en staging
psql $STAGING_DB -f scripts/create_complete_user_staging.sql
```

---
*Última actualización: $(date)*
EOF

# 6. Actualizar README principal
echo ""
echo "6️⃣ Actualizando README principal..."
cat > README.md << 'EOF'
# 🎯 Bukeer - Travel Management Platform

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run in staging mode (recommended for development)
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# Login credentials
# Email: admin@staging.com
# Password: password123
```

## 📁 Project Structure

```
bukeer-flutter/
├── lib/                    # Flutter application code
│   ├── bukeer/            # Feature modules
│   ├── backend/           # API and database
│   ├── config/            # App configuration
│   └── main.dart          # Entry point
├── docs/                  # Documentation
├── scripts/               # Utility scripts
├── test/                  # Tests
└── web/                   # Web assets
```

## 🔧 Development

### Environments
- **Staging** (default for development): Connected to staging database with production data copy
- **Production**: Live environment (never use for development)

### Key Commands
```bash
# Sync staging with production data
./scripts/sync_prod_to_staging.sh

# Run tests
flutter test

# Build for production
flutter build web --release
```

## 📚 Documentation

See [`/docs`](./docs) for detailed documentation:
- [Development Workflow](./docs/development/DEVELOPMENT_WORKFLOW_STAGING.md)
- [Staging Setup](./docs/setup/STAGING_COMPLETE_GUIDE.md)
- [Architecture](./docs/ARCHITECTURE.md)

## 🛠️ Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Hosting**: Firebase Hosting
- **Edge Functions**: Deno Deploy

## 🤝 Contributing

1. Create feature branch from `main`
2. Develop and test in staging
3. Submit PR with description
4. Deploy after review

---

**Questions?** Check [documentation](./docs) or create an issue.
EOF

echo ""
echo "✅ Limpieza completada!"
echo ""
echo "📊 Resumen:"
echo "  - Documentación reorganizada en /docs"
echo "  - Archivos duplicados consolidados"
echo "  - README principal actualizado"
echo "  - Archivos sensibles movidos a /archive"
echo ""
echo "🗑️  Archivos para eliminar manualmente:"
echo "  - .env.staging (si está commiteado)"
echo "  - Cualquier archivo .env*"
echo "  - docs/archive/* (después de revisar)"